

list.Set( "PlayerColours", "красный", 		Color( 255, 0, 0 ) )
list.Set( "PlayerColours", "жёлтый", 	Color( 255, 255, 0 ) )
list.Set( "PlayerColours", "зелёный", 	Color( 43, 235, 79 ) )
list.Set( "PlayerColours", "синий", 		Color( 43, 158, 255 ) )
list.Set( "PlayerColours", "оранжевый", 	Color( 255, 148, 39 ) )
list.Set( "PlayerColours", "розовый", 		Color( 255, 148, 255 ) )
list.Set( "PlayerColours", "сиреневый", 	Color( 120, 133, 255 ) )
list.Set( "PlayerColours", "армейский", 		Color( 120, 158, 18 ) )
list.Set( "PlayerColours", "серый", 		Color( 200, 200, 200 ) )

if ( CLIENT ) then
	CreateClientConVar( "cl_playercolor", "", true, true )
end

