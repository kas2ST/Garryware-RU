WARE.Author = "Hurricaaane (Ha3)"

WARE.EndingColor = Color(0,0,0,255)
WARE.HitAmount = math.random(8, 12)

function WARE:IsPlayable()
	if team.NumPlayers(TEAM_HUMANS) >= 2 then
		return true
	end
	
	return false
end

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_FRENZY )
	GAMEMODE:SetWareWindupAndLength(1.5, 8)
	
	self.MostTimesHit = 0
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Попади в цель "..self.HitAmount.." раз или больше!" )
	
	for k,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		ply:Give( "sware_pistol" )
		ply:GiveAmmo( 12, "Pistol", true )	
		ply.BULLSEYE_Hit = 0
	end
	
end

function WARE:StartAction()
	local ratio = 0.3
	local minimum = 1
	local num = math.Clamp(math.ceil(team.NumPlayers(TEAM_HUMANS) * ratio), minimum, 64)
	local entposcopy = GAMEMODE:GetRandomPositions(num, ENTS_INAIR)
	
	for k,pos in pairs(entposcopy) do
		local ent = ents.Create("ware_bullseye")
		ent:SetPos(pos)
		ent:Spawn()
		
		local phys = ent:GetPhysicsObject()
		phys:ApplyForceCenter(VectorRand() * 16)
		
		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
	end
	
end

function WARE:EndAction()
	if (self.MostTimesHit >= self.HitAmount) then
		GAMEMODE:DrawInstructions( "В цель попали ".. self.MostTimesHit .." раз!", self.EndingColor )
		
	elseif (self.MostTimesHit == 2) then
		GAMEMODE:DrawInstructions( "В цель попали всего 2 раза!", self.EndingColor )
		
	elseif (self.MostTimesHit == 1) then
		GAMEMODE:DrawInstructions( "В цель попали лишь единожды!", self.EndingColor )
		
	elseif (self.MostTimesHit == 0) then
		GAMEMODE:DrawInstructions( "Никто не попал в цель!", self.EndingColor )
		
	else
		GAMEMODE:DrawInstructions( "В цель попали только ".. self.MostTimesHit .." раз!", self.EndingColor )
		
	end
end

function WARE:Think( )
	for k,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		ply.BULLSEYE_Hit = ply.BULLSEYE_Hit or 0
		
		if !ply:IsOnHold() and (ply.BULLSEYE_Hit > self.MostTimesHit) then
			self.MostTimesHit = ply.BULLSEYE_Hit
		end
		
		if ply.BULLSEYE_Hit >= self.HitAmount then
			if GAMEMODE:IsFirstWinAwardEnabled( ) then
				ply:ApplyWin()
			end
			ply:SetAchievedNoLock( true )
		end
		
	end

	--[[for k,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		local timesHit = ply.BULLSEYE_Hit
		
		if (self.MostTimesHit > 2) and (timesHit == self.MostTimesHit) then
			ply:SetAchievedNoLock( true )
			
		else
			ply:SetAchievedNoLock( false )
		end
	end]]--
	
end
