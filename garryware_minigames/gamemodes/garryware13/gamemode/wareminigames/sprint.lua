WARE.Author = "Frostyfrog"
WARE.MaxSpeed = 320

function WARE:Initialize()
	GAMEMODE:SetWinAwards( AWARD_MOVES )
	GAMEMODE:SetWareWindupAndLength(2.5,5)
	
	GAMEMODE:SetPlayersInitialStatus( true )
	GAMEMODE:DrawInstructions( "Не останавливайся!" )
end

function WARE:StartAction()
	
end

function WARE:EndAction()

end

function WARE:Think( )
	for k,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		if !ply:GetLocked() and ( ply:GetVelocity():Length() < (self.MaxSpeed * 0.8) ) then
			ply:ApplyLose( )
			ply:SimulateDeath()
			
		end
	end
end
