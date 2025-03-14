WARE.Author = "Kilburn"
WARE.Room = "empty"

function WARE:IsPlayable()
        //// Temporaily disable
        return false
        //// ////
        /*
        local doit = false
        if #team.GetPlayers(TEAM_HUMANS) <= 12 then
                doit = true
        end
        return doit*/
end


-----------------------------------------------------------------------------------------------
-- Minigame local variables and functions

local Colors = {
        {0,0,255},
        {0,255,0},
        {255,0,0},
        {0,0,100},
        {100,0,0},
        {0,100,100},
        {100,100,0},
        {20,20,20},
}

-- Spawn a fancy little flag on a crate
local function Flag(p)
        local pole = ents.Create("prop_dynamic")
        pole:SetModel("models/props_junk/harpoon002a.mdl")
        pole:SetAngles(Angle(90,0,0))
        pole:SetPos(p:GetPos()+Vector(0,0,30))
        pole:Spawn()
       
        pole:SetParent(p)
       
        local flag = ents.Create("prop_dynamic")
        flag:SetModel("models/props_c17/streetsign005b.mdl")
        flag:SetAngles(Angle(90,0,0))
        flag:SetPos(p:GetPos()+Vector(11,0,70))
        flag:Spawn()
       
        flag:SetMaterial("models/debug/debugwhite")
        flag:SetColor(200,0,0,255)
       
        flag:SetParent(p)
       
        GAMEMODE:MakeLandmarkEffect(p:GetPos()+Vector(0,0,18))
end

-- Spawn a mine on a crate
local function Mine(p)
        local mine = ents.Create("prop_dynamic")
        mine:SetModel("models/props_combine/combine_mine01.mdl")
        mine:SetPos(p:GetPos()+Vector(0,0,20))
        mine:Spawn()
       
        mine:SetParent(p)
       
        GAMEMODE:MakeAppearEffect(p:GetPos()+Vector(0,0,18))
end

-- Spawn a number showing how many mines there are around this crate
local function Uncover(p)
        if not p:IsValid() then return end
       
        local num = p.Neighbours
       
        if num>0 then
                local textent = ents.Create("ware_text")
                textent:SetPos(p:GetPos()+Vector(0, 0, 18))
                textent:Spawn()
               
                GAMEMODE:AppendEntToBin(textent)
                GAMEMODE:MakeAppearEffect(p:GetPos())
               
                textent:SetEntityText(tostring(num))
               
                local c = Colors[num] or Colors[8]
               
                timer.Simple(0.1, function(t)
                        umsg.Start("EntityTextChangeColor")
                                umsg.Entity(t)
                                umsg.Long(c[1])
                                umsg.Long(c[2])
                                umsg.Long(c[3])
                                umsg.Long(255)
                        umsg.End()
                end, textent)
        end
end

-- Floodfill algorithm for uncovering all safe crates found around this one
local function Floodfill(grid, x, y)
        local Q = {}
        table.insert(Q, {x,y})
        while Q[1] do
                local n = table.remove(Q, 1)
               
                for i=n[1]-1,n[1]+1 do
                        for j=n[2]-1,n[2]+1 do
                                if i~=n[1] or j~=n[2] then
                                        local q = grid:Get(i, j)
                                        if q:IsValid() then
                                                if q.Neighbours==0 then
                                                        table.insert(Q, {i,j})
                                                else
                                                        Uncover(q)
                                                end
                                                q.Neighbours = nil
                                                q:Remove()
                                                grid:RemoveItem(i, j)
                                        end
                                end
                        end
                end
        end
end

-----------------------------------------------------------------------------------------------
-- Minigame hooks start here

function WARE:Initialize()
        GAMEMODE:SetWareWindupAndLength(2,25)
        GAMEMODE:DrawPlayersTextAndInitialStatus("Приготовьтесь к минному тралению!",0)
       
        local entlist = GAMEMODE:GetEnts({"light_ground","dark_ground"})
        local maxcount = table.Count(entlist)
       
        -- We want a strict maximum of 1/3 mines, so the game isn't too hard with many players
        local nummines = math.ceil(math.Clamp(team.NumPlayers(TEAM_HUMANS)*1.25,1,maxcount*0.3))
       
        self.Losers = {}
        self.Grid = entity_map.Create()
        self.NumMines = 0
       
        -- Spawn the crates and map them into self.Grid
        for k,v in pairs(entlist) do
                local pos = v:GetPos()
                pos = pos + Vector(0,0,-16)
               
                local prop = ents.Create("prop_physics")
                prop:SetModel("models/props_junk/wood_crate001a.mdl")
                prop:PhysicsInit(SOLID_VPHYSICS)
                prop:SetSolid(SOLID_VPHYSICS)
                prop:SetPos(pos)
                prop:Spawn()
               
                prop:SetMoveType(MOVETYPE_NONE)
                prop:SetCollisionGroup(COLLISION_GROUP_NONE)
               
                prop.Neighbours = 0
               
                GAMEMODE:AppendEntToBin(prop)
                GAMEMODE:MakeAppearEffect(pos)
               
                self.Grid:Insert(prop)
        end
       
        -- ware_debug 2 will additionally make mines visible
        local dbg = (GetConVarNumber("ware_debug")==2)
       
        -- Place those mines!
        for i=1,nummines do
                local x,y = math.random(1,self.Grid:Width()), math.random(1,self.Grid:Height())
                local p = self.Grid:Get(x, y)
               
                if p:IsValid() and not p.Mine then
                        p.Mine = true
                        if dbg then
                                p:SetColor(255,200,200,255)
                        end
                        p:SetHealth(100000)
                        self.NumMines = self.NumMines + 1
                       
                        -- Update mines count for every nearby crate
                        for i=x-1,x+1 do
                                for j=y-1,y+1 do
                                        local q = self.Grid:Get(i, j)
                                        if q:IsValid() then
                                                q.Neighbours = q.Neighbours + 1
                                        end
                                end
                        end
                end
        end
end

function WARE:StartAction()
        GAMEMODE:DrawPlayersTextAndInitialStatus("Разбейте все безопасные ящики, не взорвитесь!",0)
       
        for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do
                v:Give("weapon_crowbar")
        end
       
        timer.Simple(0.1, function()
                for _,v in pairs(ents.FindByClass("prop_physics")) do
                        v:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
                end
        end)
end


function WARE:EndAction()
        local remaining = 0
        for _,v in pairs(ents.FindByClass("prop_physics")) do
                if v.Neighbours then remaining = remaining + 1 end
        end
       
        if self.NumMines==remaining then
                for _,p in pairs(ents.FindByClass("prop_physics")) do
                        if p.Mine then
                                GAMEMODE:MakeLandmarkEffect(p:GetPos()+Vector(0,0,18))
                        end
                end
               
                for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do
                        v:WareApplyLose()
                end
        end
end

function WARE:Think()
        -- Because using the crowbar is just impractical
        -- Stand on a crate, it breaks (or blows you up if it's a mine)
        if self.GameOver then return end
       
        for _,v in pairs(ents.FindByClass("player")) do
                if not self.Losers[v] then
                        local ent = v:GetGroundEntity()
                        if ent and ent:IsValid() and ent.Neighbours then
                                ent:TakeDamage(50, v, v)
                        end
                end
        end
end

function WARE:EntityTakeDamage(ent,inf,att,amount,info)
        -- Losers shouldn't be able to trigger mines again
        if not att:IsPlayer() or amount<10 or self.Losers[att] then return end
       
        if ent.Mine then
                self.Losers[att] = true
               
                --[[ent:EmitSound("ambient/levels/labs/electric_explosion1.wav")
               
                local effectdata = EffectData( )
                        effectdata:SetOrigin(ent:GetPos())
                        effectdata:SetNormal(Vector(0,0,1))
                util.Effect("waveexplo", effectdata, true, true)]]
               
                -- ka bewm
                local effectdata = EffectData()
                        effectdata:SetOrigin(ent:GetPos()+Vector(0,0,18))
                util.Effect("Explosion", effectdata, true, true)
               
                -- Turn the crate red for 3 seconds, so it gives a hint to other players
                ent:SetColor(255,0,0,255)
                timer.Simple(3,function(e) if e:IsValid() and e.Mine then e:SetColor(255,255,255,255) end end,ent)
               
                att:WareApplyLose( )
                att:StripWeapons()
               
                -- Everyone has failed, show the mines and end the game
                local fail = true
                for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do
                        if not self.Losers[v] then
                                fail = false
                                break
                        end
                end
               
                if fail then
                        self.GameOver = true
                        for _,p in pairs(ents.FindByClass("prop_physics")) do
                                if p.Mine then
                                        p.Mine = false
                                        p:SetColor(255,0,0,255)
                                        Mine(p)
                                end
                        end
                       
                        if GAMEMODE.NextgameEnd>CurTime()+3 then
                                GAMEMODE:SetNextGameEnd(CurTime()+3)
                        end
                end
        end
end


function WARE:PropBreak(killer, prop)
        local pos = self.Grid:GetPositionInGrid(prop)
        if not pos then return end
       
        -- Contribute by breaking at least one safe crate
        if killer:IsPlayer() then
                killer:SetAchievedNoLock(true)
        end
       
        local num = prop.Neighbours
       
        self.Grid:RemoveItem(pos.x, pos.y)
       
        if num==0 then
                Floodfill(self.Grid, pos.x, pos.y)
        else
                Uncover(prop)
        end
       
        prop.Neighbours = nil
       
        local remaining = 0
        for _,v in pairs(ents.FindByClass("prop_physics")) do
                if v.Neighbours then remaining = remaining + 1 end
        end
       
        -- Everyone has won, yay, defuse the mines and add a flag
        if self.NumMines>=remaining then
                self.GameOver = true
                for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do
                        v:ApplyLock()
                end
               
                for _,p in pairs(ents.FindByClass("prop_physics")) do
                        if p.Mine then
                                p.Mine = false
                                p:SetColor(0,255,0,255)
                                Flag(p)
                        end
                end
               
                if GAMEMODE.NextgameEnd>CurTime()+3 then
                        GAMEMODE:SetNextGameEnd(CurTime()+3)
                end
        end
end
