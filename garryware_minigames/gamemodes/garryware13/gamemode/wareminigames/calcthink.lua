WARE = {}
WARE.Author = "Hurricaaane (Ha3)"
WARE.Room = "none"

WARE.CorrectColor = Color(0,0,0,255)
WARE.ChatCorrect  = Color(0,192,0,0)
WARE.ChatWrong    = Color(192,0,0,0)
WARE.ChatBleh     = Color(192,192,0,0)
WARE.ChatRegular  = Color(255,255,255,0)

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_IQ_WIN )
	GAMEMODE:SetFailAwards( AWARD_IQ_FAIL )
	
	GAMEMODE:OverrideAnnouncer( 2 )
	
	GAMEMODE:SetWareWindupAndLength( 2 , 8 )

	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Приготовьтесь писать в чат..." )
	
end

function WARE:StartAction()

	local init = math.random(2,19)
	local mul = math.random(2,2)
	local negative = math.random(0,1)
	local add = math.random(1,9)
	local ismul = math.random(1,7) == 7
	
	if negative == 1 then
		add = -add
	end
	
	local one, two, three
	if ismul then
		one = init
		two = one * mul
		three = two * mul
		self.WareSolution = three * mul
	else
		one = init + negative * (-add * 10)
		two = one + add
		three = two + add
		self.WareSolution = three + add
	end
	
	self.Beginning = one.." , "..two.." , "..three

	GAMEMODE:DrawInstructions("Думай : ".. self.Beginning .." , ?")
	GAMEMODE:PrintInfoMessage("Думай", " : ", self.Beginning .." , ?")
	
end

function WARE:EndAction()
	GAMEMODE:DrawInstructions( "Ответ был "..self.WareSolution.."!" , self.CorrectColor)
	GAMEMODE:PrintInfoMessage( "Ответ", " был ", self.WareSolution.."!" )
end

function WARE:PlayerSay(ply, text, say)
	if !ply:IsWarePlayer() then
		if (text == tostring(self.WareSolution)) or string.find(text, tostring(self.WareSolution)) then
			return false
		end
		return
	end

	if text == tostring(self.WareSolution) then
		local initialLocked = ply:GetLocked()
	
		ply:ApplyWin( )
		if ( ply:GetLocked() and !(ply:GetAchieved()) ) then
			chat.AddText( self.ChatBleh, ply:GetName(), self.ChatRegular, " думал, ", self.ChatWrong, "что у него будет несколько попыток." )
		elseif initialLocked and ply:GetAchieved() then
			chat.AddText( self.ChatBleh, ply:GetName(), self.ChatRegular, " нашёл ", self.ChatBleh, "правильный ответ... но не было необходимости писать его дважды." )
			
		else
			chat.AddText( self.ChatBleh, ply:GetName(), self.ChatRegular, " нашёл ", self.ChatCorrect, "правильный ответ!" )
		end
		return false
		
	else
		ply:ApplyLose( )
		
		if string.find(text, tostring(self.WareSolution)) then
			local txtReplace = string.Replace(text, tostring(self.WareSolution), "<answer>")
			chat.AddText( self.ChatBleh, ply:GetName(), self.ChatRegular, " сказал \"" .. txtReplace .. "\" ... ", self.ChatWrong, "не совсем верно!" )

			return false
		end
	end
end
