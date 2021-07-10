kill={}
kill["ok"]=nil
kill["fail"]=nil
kill.npc=""
getpfm=function()
	local pfm=""
	if me.special["小周天运转"] then pfm="yun recover" end
	pfm_skill=GetVariable("pfm")
	if pfm_skill=="" or pfm ==nil then return pfm end
	if pfm_skill=="shot" then
		if quest.name~="mq" or masterquest.die~=true then
			pfm=pfm..";"..("shot "..kill.npc.." with arrow")
		end
	else
		pfm=pfm..";"..pfm_skill
	end
	if kill.npc~=nil and dragongiftcmd~=nil then
		if dragongiftcmd[kill.npc]~=nil then
			pfm=pfm..";"..(dragongiftcmd[kill.npc])
		end
	end
	return pfm
end
pfm=function()
	run(getpfm())
end
getfightpreper=function()
	cmd=""
	if GetVariable("pfm")=="shot" then
		cmd=cmd..";hand bow"
	end
	if me.special["天神降世"] then cmd=cmd..";special power" end
	if me.special["如鬼似魅"] then cmd=cmd..";special agile" end
	if me.special["杀气"] then cmd=cmd..";special hatred" end
	if preperskill~="" and preperskill~=nil then
	cmd=cmd..";"..preperskillcmd
	end
	if GetVariable("fight_preper")~=nil then
	cmd=cmd..";"..GetVariable("fight_preper")
	end
	if mudvar.powerup==nopowerup.powerup or mudvar.powerup==nil then
		cmd=cmd..";yun powerup"
	end
	cmd=cmd..";yun recover;yun shield"
	weapon2id=GetVariable("weapon2")
	weapon1id=GetVariable("weapon")
	if weapon2id~="" and weapon2id~=nil then
			cmd=cmd..";unwield "..weapon2id..";remove"..weapon2id
	end
	if weapon1id~="" and weapon1id~=nil then
		cmd=cmd..";wield "..weapon1id..";remove"..weapon1id
	end
	return cmd
end
fightpreper=function()
	run(getfightpreper())
end

do_kill=function(npc,kill_ok,kill_fail)
	kill["ok"]=kill_ok
	kill["fail"]=kill_fail
	kill.npc=npc
	hook(hooks.fight,pfm)
	hook(hooks.hurt,pfm)
	kill.cmd()
end

kill["end"]=function(s)
	hook(hooks.fight,nil)
	hook(hooks.hurt,nil)
	if ((s~="")and(s~=nil)) then
		call(kill[s])
	end
	kill["ok"]=nil
	kill["fail"]=nil
end

kill_end_ok=function()
	kill["end"]("ok")
end

kill_end_fail=function()
	kill["end"]("fail")
end
kill.cmd=function()
	run("yun recover;yun regenerate")
	if (me.score.xingge=="心狠手辣")or(me.score.xingge=="光明磊落")and(tonumber(GetVariable("nuqimin"))>2000) then run("burning") end
	cmd=GetVariable("fightcuff")
	prewield()
	if cmd~=nil and cmd~="" then
		npchere(kill.npc,"kill "..kill.npc)
		fightcuff()
		pfm()
	else
			npchere(kill.npc,getfightpreper()..";kill "..kill.npc..';'..getpfm())
	end
	
	busytest(kill.test)
end

kill.test=function()
	if npc.nobody==1 then
		kill_end_fail()
	else
		busytest(kill_end_ok)
	end
end

fightcuff=function()
	if mudvar.powerup==nopowerup.drunk or (cmd~=nil and cmd~="") then
			weapon(0)
		if mudvar.powerup==nopowerup.drunk then
			run("wield mu gun;yong club.zuida;unwield mu gun")
		end
		cmd=GetVariable("fightcuff")
		if cmd~=nil and cmd~="" then
			run(cmd)
		end
		weapon(1)
	end
end


prewield=function()
	if (cmd==nil or cmd=="")and mudvar.powerup~=nopowerup.drunk then
		weapon(1)
	end
end


-------------------------

killnpc={}
killnpc["ok"]=nil
killnpc["fail"]=nil
killnpc["id"]=""
killnpc["loc"]=nil

do_killnpc=function(npcid,loc,killnpc_ok,killnpc_fail)
	killnpc["ok"]=killnpc_ok
	killnpc["fail"]=killnpc_fail
	killnpc["id"]=npcid
	killnpc["loc"]=loc
	killnpc.resume()
end

killnpc.resume=function()
	if killnpc["loc"]==nil then
		busytest(killnpc.cmd)
	else
		go(killnpc["loc"],killnpc.cmd,killnpc.cmd)
	end
end

killnpc.cmd=function()
	fightpreper()
	do_kill(killnpc["id"],killnpc_end_ok,killnpc_end_ok)
end

killnpc["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(killnpc[s])
	end
	killnpc["ok"]=nil
	killnpc["fail"]=nil
end

killnpc_end_ok=function()
	killnpc["end"]("ok")
end

killnpc_end_fail=function()
	killnpc["end"]("fail")
end

