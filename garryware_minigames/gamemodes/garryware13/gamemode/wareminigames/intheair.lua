WARE.Author = "Hurricaaane (Ha3)"
WARE.Room = "empty"

function WARE:Initialize()

	self.IsTrap = (math.random(0,10) <= 3)
	if !self.IsTrap then
		GAMEMODE:SetWareWindupAndLength(2, math.Rand(1.3, 5.0))
		GAMEMODE:SetWinAwards( AWARD_REFLEX )
		
	else
		GAMEMODE:SetWareWindupAndLength(2, math.Rand(1.3, 2.5))
		GAMEMODE:SetFailAwards( AWARD_VICTIM )
		
	end
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Когда часы пробьют ноль..." )
	
	self.zcap = GAMEMODE:GetRandomLocations(1, "dark_ground")[1]:GetPos().z + 96

	return
end

function WARE:StartAction()
	if !self.IsTrap then
		GAMEMODE:DrawInstructions( "Будь высоко в небе!" )
		
	else
		GAMEMODE:DrawInstructions( "Стой на земле!" )
		
	end
	
	for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do
		v:Give( "sware_rocketjump_limited" )
	end
	
	return
end

function WARE:EndAction()

end


function WARE:Think( )
	for _,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do
		if !self.IsTrap then
			ply:SetAchievedNoLock( ply:GetPos().z > self.zcap )
		
		else
			ply:SetAchievedNoLock( ply:GetPos().z < self.zcap )
			
		end
		
	end
end
