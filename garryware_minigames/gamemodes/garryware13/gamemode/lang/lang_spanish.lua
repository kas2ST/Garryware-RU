LANG.Name = "spanish"
LANG.ColorTranslation = {
	"Negro",
	"Gris" ,
	"Blanco",
	"Rojo"  ,
	"Verde",
	"Azul" ,
	"Rosa"
}
LANG.ShapeTranslation = {
	"Giro"		,
	"Equis" 	,
	"Triangulo"	,
	"Cuadrado"  	,
	"Circulo"	,
	"Estrella" 		,
	"Flore"
}

LANG.TranslationTable = {}
LANG.TT = LANG.TranslationTable

do --Editor collapse
LANG.TT["__BASE"] = {}
LANG.TT["__BASE"][1] = "BIEN!"
LANG.TT["__BASE"][2] = "MAL!"
LANG.TT["__BASE"][3] = "TODO EL MUNDO GANA!"
LANG.TT["__BASE"][4] = "TODO EL MUNDO PERDIO!"

LANG.TT["_intro"] = {}
LANG.TT["_intro"][1] = "Una nueva partida ha empezado!"
LANG.TT["_intro"][2] = "Las reglas son simples : Hacer lo que yo diga!"
LANG.TT["_intro"][3] = "La partida comienza! disfruta!"
end

do -- alarmcrates > buildtothetop
LANG.TT["alarmcrates"] = {}
LANG.TT["alarmcrates"][1] = "Escucha..."
LANG.TT["alarmcrates"][2] = "Shut it down!"

LANG.TT["avoidball"] = {}
LANG.TT["avoidball"][1] = "Esquiva!"

LANG.TT["avoidcircles"] = {}
LANG.TT["avoidcircles"][1] = "Evade los circulos!"

LANG.TT["battery"] = {}
LANG.TT["battery"][1] = "Encuentra la batería y enchufala!"

LANG.TT["bigcrate"] = {}
LANG.TT["bigcrate"][1] = "Dispara a la caja más grande!"

LANG.TT["breakallcrates"] = {}
LANG.TT["breakallcrates"][1] = "Se util!"
LANG.TT["breakallcrates"][2] = "Rompe todas las cajas!"

LANG.TT["buildtothetop"] = {}
LANG.TT["buildtothetop"][1] = "Crea una escalera de sierras..."
LANG.TT["buildtothetop"][2] = "Subete ahí!"
end

do -- bullseye > calcthink
-- Make use of a function for eventual complex grammar, if not English
LANG.TT["bullseye"] = {}
LANG.TT["bullseye"][1] = function(times) return "Dispara a la diana exactamente".. times .." veces!" end

LANG.TT["calc"] = {}
LANG.TT["calc"][1] = "Preparate para escrivir en el chat..."
LANG.TT["calc"][2] = function(op)   return "Calcula : " .. op .. " = ?" end
LANG.TT["calc"][3] = function(op)   return { "Calcula", " : " , op .. "= ?" } end
LANG.TT["calc"][4] = function(sol)  return "La respuesta es " .. sol .. " !" end
LANG.TT["calc"][5] = function(op)   return { "La respuesta", " es " , op .. " !" } end
LANG.TT["calc"][6] = function(name) return { name, " ha encontrado " , "la respuesta correcta!" } end
LANG.TT["calc"][7] = function(name) return { name, " ha encontrado " , "la respuesta correcta ... pero no hace falta decirlo dos veces." } end
LANG.TT["calc"][8] = function(name, partial) return { name, " dijo \"" .. partial .. "\" ... " , "no del todo bien!" } end

LANG.TT["calcthink"] = table.Copy(LANG.TT["calc"])
LANG.TT["calcthink"][2] = function(op)   return "Piensa : " .. op .. " = ?" end
LANG.TT["calcthink"][3] = function(op)   return { "Piensa", " : " , op .. "= ?" } end
end

do -- catchball > flee_hexa
LANG.TT["catchball"] = {}
LANG.TT["catchball"][1] = "Atrapa!"

LANG.TT["chair"] = {}
LANG.TT["chair"][1] = "Rompe la silla!"

LANG.TT["climb"] = {}
LANG.TT["climb"][1] = "Subete a una caja!"

LANG.TT["dontmove"] = {}
LANG.TT["dontmove"][1] = "No te muevas!"

LANG.TT["fewestplayers"] = {}
LANG.TT["fewestplayers"][1] = "Vete al circulo con menos personas!"

LANG.TT["findthemissing"] = {}
LANG.TT["findthemissing"][1] = "Mira los props..."
LANG.TT["findthemissing"][2] = "Ponte en el prop que falta!"

LANG.TT["flee_hexa"] = {}
LANG.TT["flee_hexa"][1] = "Escapa!"
end

do -- get21 >
LANG.TT["get21"] = {}
LANG.TT["get21"][1] = "consigue 21!"


LANG.TT["getoncolor"] = {}
LANG.TT["getoncolor"][1] = function(colorID)
	if lang.GetColorblindMode() then
		return "Subete a la " .. LANG:TranslateShapes(colorID) .. " forma!"
	else
		return "subete al " .. LANG:TranslateColors(colorID) .. " uno!"
	end
end

LANG.TT["hitasmuch"] = {}
LANG.TT["hitasmuch"][1] = "Acierta la mayoría de las veces!"
LANG.TT["hitasmuch"][2] = function(times) return "Fue golpeado " .. times .. " veces!" end
LANG.TT["hitasmuch"][3] = "Nadie golpeó lo suficiente!"


LANG.TT["hlss"] = {}
LANG.TT["hlss"][1] = "No utilices el HLSS!"

LANG.TT["jumpbox"] = {}
LANG.TT["jumpbox"][1] = "Salta de una caja a otra!"

LANG.TT["keepbumping"] = {}
LANG.TT["keepbumping"][1] = "Quedate rebotando!"

LANG.TT["meloncrates"] = {}
LANG.TT["meloncrates"][1] = "Mira la caja..."
LANG.TT["meloncrates"][2] = "Rompe el melon!"

LANG.TT["memorycrates"] = {}
LANG.TT["memorycrates"][1] = "Mira cuidadosamente!"
LANG.TT["memorycrates"][2] = "Repite!"

LANG.TT["memorytriangle"] = {}
LANG.TT["memorytriangle"][1] = "Memoriza!"
LANG.TT["memorytriangle"][2] = function(colorID)
	if lang.GetColorblindMode() then
		return "Dispara la " .. LANG:TranslateShapes(colorID) .. " forma!"
	else
		return "Dispara al " .. LANG:TranslateColors(colorID) .. " uno!"
	end
end
LANG.TT["memorytriangle"][3] = function(number) return "Dispara el " .. number .. "!" end

end

do

LANG.TT["musicalchairs"] = {}
LANG.TT["musicalchairs"][1] = "Alejate del pod!"
LANG.TT["musicalchairs"][2] = "Subete al pod!"

LANG.TT["pickupthatcan"] = {}
LANG.TT["pickupthatcan"][1] = "Recoje esa lata!"
LANG.TT["pickupthatcan"][2] = "Ahora mete la lata!"

LANG.TT["propbullseye"] = {}
LANG.TT["propbullseye"][1] = "Dispara a la diana!"


LANG.TT["rightorder"] = {}
LANG.TT["rightorder"][1] = "Dispara en el orden!"
LANG.TT["rightorder"][2] = "De menor a mayor ! (1 , 2 , 3...)"
LANG.TT["rightorder"][3] = "De mayor a menor ! (3 , 2 , 1...)"
LANG.TT["rightorder"][4] = function() return { "El orden", " es ", "ascendente (1 , 2 , 3...)!" } end
LANG.TT["rightorder"][5] = function() return { "El orden ", " es ", "descendiente (3 , 2 , 1...)!" } end
LANG.TT["rightorder"][6] = function(sequence) return  "el orden es ".. message .."!" end
LANG.TT["rightorder"][7] = function(sequence) return { "el orden", " es ", message .."!" } end

LANG.TT["rocketjump"] = {}
LANG.TT["rocketjump"][1] = "Rocketjump a la plataforma!"

LANG.TT["rollingcolor"] = {}
LANG.TT["rollingcolor"][1] = function(colorID)
	if lang.GetColorblindMode() then
		return "Espera y dispara a " .. LANG:TranslateShapes(colorID) .. " la forma!"
	else
		return "Espera y dispara al " .. LANG:TranslateColors(colorID) .. " uno!"
	end
end

LANG.TT["shootcolor"] = {}
LANG.TT["shootcolor"][1] = function(colorID)
	if lang.GetColorblindMode() then
		return "Dispara la " .. LANG:TranslateShapes(colorID) .. " forma!"
	else
		return "Dispara al " .. LANG:TranslateColors(colorID) .. " uno!"
	end
end

LANG.TT["sprint"] = {}
LANG.TT["sprint"][1] = "No pares de correr!"


LANG.TT["touchsky"] = {}
LANG.TT["touchsky"][1] = "Quedate en el piso!"
LANG.TT["touchsky"][2] = "No toques el cielo!"


LANG.TT["tryclimb"] = {}
LANG.TT["tryclimb"][1] = "Intenta escalar la caja!"

end



function LANG:TranslateColors( colorID )
	return self.ColorTranslation[colorID] or "ERROR"
end

function LANG:TranslateShapes( colorID )
	return self.ShapeTranslation[colorID] or "ERROR"
end


