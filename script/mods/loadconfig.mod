
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
	include("house.ini")
	loadconfigfile("paths.ini")
	loadconfigfile("family.ini")
	loadconfigfile("info.ini")
	if rooms_all==nil then rooms_all="rooms_all.h" end
	walk["open"]=mapper.open(rooms_all)
	if (walk[open]==0) then
		print "锟斤拷图锟侥硷拷未锟揭碉拷锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷"
	else
		for i,v in pairs(houses) do
			house.add(i)
		end
	end
end
loadconfig()
