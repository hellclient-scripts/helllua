
loadconfigfile=function(str)
	include("configs/"..str)
end


loadconfig=function()
	if GetVariable("configfile")==nil or GetVariable("configfile")=="" then
		include("config.ini")
	else
		include(GetVariable("configfile"))
	end
	include("config.ini")
	loadconfigfile("locs.ini")
	loadconfigfile("npcs.ini")
	loadconfigfile("items.ini")
	loadconfigfile("paths.ini")
	loadconfigfile("family.ini")
	loadconfigfile("info.ini")
	include("house.ini")
	if rooms_all==nil then rooms_all="rooms_all.h" end
	walk["open"]=mapper.open(rooms_all)
	--loadconfigfile("newpath.lua")
	if (walk[open]==0) then
		print "地图打开失败"
	else
		for i,v in pairs(houses) do
			house.add(i)
		end
	end
end
loadconfig()
