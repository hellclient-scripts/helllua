--assert  (package.loadlib (luapath.."mapper.dll","luaopen_mapper")) ()
mapper={}
mapper.loadLine=function(line)
end

split2=function(v,sep)
	s=SplitN(v,sep,2)
	return s[1],s[2]
end
mapper.parsepath=function(fr,str)
	local tag
	local tags
	local ex
	local etags
	local p=Mapper:newpath()
	p.from=fr
	str,delay=split2(str,"%")
	if delay then
		p.delay=delay-0
	end
	str,to=split2(str,":")
	if to then
		p.to=to
	end
	tag,str=split2(str,">")
	tags={}
	while (str) do
		table.insert(tags,tag)
		tag,str=split2(str,">")
	end
	p.tags=tags
	str=tag
	etags={}
	ex,str=split2(str,"<")
	while (str) do
		table.insert(etags,ex)
		ex,str=split2(str,"<")
	end
	p.excludetags=etags
	str=ex
	p.command=str
	Mapper:addpath(fr,p)
end
mapper.loadline=function(line)
	local id,line=split2(line,"=")
	Mapper:clearroom(id)
	local name,v=split2(line,"|")
	Mapper:setroomname(id,name)
	local exitlist=SplitN(v,",",-1)
	for k, v in pairs(exitlist) do
		mapper.parsepath(id,v)
	end

end
mapper.open=function(fname)
	local t=ReadLines(fname)
	for k, v in pairs(t) do
		mapper.loadline(v)
	end
    
end
mapper.getpaths=function(r,t,f)
	return Mapper:getpath(r,f,t)
end
mapper.getpath=function(r,t,f)
	local p,delay=mapper.getpaths(r,t,f)
	local result={}
	local delay=0
	if p then 
		for k, v in pairs(p) do
			table.insert(result,v.command)
			if v.delay>0 then
				delay=delay+v.delay
			else
				delay=delay+1
			end
		end
	end
	path=table.concat(result,";")
	return path,delay
end
mapper.getroomid=function(r)
	--return Mapper:getroomid(r)
	local t=Mapper:getroomid(r)
	local result={}
	if t~=nil then
		for k,v  in pairs(t) do
				if v~="" then
					table.insert(result,v-0)
				end
		end
	end
	return result
end

mapper.getexits=function(r)
	return Mapper:getexits(r)
end
mapper.settags=function(t)
	Mapper:flashtags()
	return Mapper:settags(t)
end
mapper.setflylist=function(f)
	return false
	--return mushmapper.setflylist(f)
end

mapper.getroomname=function(r)
	return Mapper:getroomname(r)
end

mapper.addpath=function(r,p)
	Mapper:addpath(r,p)
end

mapper.newarea=function(i)
	return Mapper:newarea(i)
end
mapper.clearroom=function(i)
	return Mapper:clearroom(i)
end
mapper.readroom=function(r,s)
	return false
	--mushmapper.readroom(r,s)
end

getexitroom=function (room,dir)

	local exits={}
	local i=0
	local tdir=""
	local texit=""
	if room==nil then room= -1 end
	if room-0<0 then return -1 end
	if dir==nil then return room end
	exits=Mapper:getexits(room)
	while (i<#exits) do
		i=i+1
		tdir=dir
		texit=exits[i]["command"]
		if #tdir > #texit then
			texit=texit.."*"
		elseif #tdir < #texit then
			tdir=tdir.."*"
		end
		if (tdir==texit) then
			return exits[i]["to"]
		end
	end
	return -1
end

defdisableroomlist={}
getroomexits=function (room,enterable,disableroomlist)
	local exits={}
	local i=0
	local exitcount=0
	local roomexits={}
	if disableroomlist==nil then
		disableroomlist=defdisableroomlist
	end
	if room-0<0 then return nil end
	exits=Mapper:getexits(room)
	while (i<#exits) do
		i=i+1
		if enterable==true then
			if exits[i]["to"]==-1 then
				break
			elseif exitback[exits[i]["command"]]==nil then
				break
			elseif getexitroom(exits[i]["to"],exitback[exits[i]["command"]])~=room then
				break
			end
		end
		if disableroomlist[exits[i]["to"]]==true then break end
		exitcount=exitcount+1
		roomexits[exitcount]=exits[i]["command"]
	end
	return roomexits
end
