liandan={}
liandan["ok"]=nil
liandan["fail"]=nil
liandan.items={}
liandan.items["包裹"]={min=1,max=1}
liandan.sells={}
liandan.sells["火麒丹"]={name="火麒丹",id="huoqi dan"}
liandan.sells["归元丹"]={name="归元丹",id="guiyuan dan"}
liandan.sells["小还丹"]={name="小还丹",id="xiaohuan dan"}
liandan.sells["大还丹"]={name="大还丹",id="dahuan dan"}
liandan.sells["大补丹"]={name="大补丹",id="dabu dan"}
liandan.sells["雪参丹"]={name="雪参丹",id="xueshen dan"}
liandan.sells["十全大还丹"]={name="十全大还丹",id="shiquan dan"}
liandan.sells["大云丹"]={name="大云丹",id="dayun dan"}
liandan.sells["养精丹"]={name="养精丹",id="yangjing dan"}
liandan.sells["锁泉丹"]={name="锁泉丹",id="suoquan dan"}
liandan.sells["小金丹"]={name="小金丹",id="gold dan"}
liandan.sells["小云丹"]={name="小云丹",id="xiaoyun dan"}
liandan.sells["蓄精丹"]={name="蓄精丹",id="xujing dan"}
liandan.sells["碧泉丹"]={name="碧泉丹",id="biquan dan"}
--liandan.sells["幻灵丹"]={name="幻灵丹",id="huanling dan"}
liandan.pack={}
liandan.pack["Guiling dan"]="guiling dan"
liandan.pack["血麒丹"]="xueqi dan"
liandan.pack["映月丹"]="yingyue dan"
liandan.pack["修罗无常丹"]="xiuluo dan"
liandan.pack["回阳无极丹"]="huiyang dan"
liandan.pack["补精丹"]="bujing dan"
liandan.pack["还魂丹"]="huanhun dan"
liandan.pack["龙涎丹"]="longxian dan"
liandan.pack["邀月丹"]="yaoyue dan"
liandan.pack["子午龙甲丹"]="longjia dan"
liandan.pack["幻灵丹"]="huanling dan"
liandan.pack["Luosha dan"]="luosha dan"
liandan.pack["轩辕补心丹"]="xuanyuan dan"
liandan.pack["Baihu dan"]="baihu dan"
liandan.pack["Qinglong dan"]="qinglong dan"
liandan.pack["Xuanwu dan"]="xuanwu dan"
liandan.pack["Zhuque dan"]="zhuque dan"
liandan.pack["Wanshou dan"]="wanshou dan"
liandan.pack["Yinyang dan"]="yinyang dan"
liandan.pack["Change dan"]="change dan"
liandan.pack["Longwang dan"]="longwang dan"
liandan.dropgift={}
liandan.eat={}
liandan.yaoanswer=0
liandan.tonganswer=0
liandan.loc={1397,1398,1399,1400,1401}
liandan.recon=function()
end
do_liandan=function(liandan_ok,liandan_fail)
	liandan["ok"]=liandan_ok
	liandan["fail"]=liandan_fail
	EnableTriggerGroup("liandan",true)
	busytest(liandan.main)
end
liandan.loop=function()
	busytest(liandan.loopcmd)
end
liandan.loopcmd=function()
	do_liandan(liandan.loop,liandan.loop)
end
liandan.main=function()
	if quest.stop then
		liandan["end"]()
		return
	end
	getstatus(liandan["check"])
end

liandan.check=function()
	if do_check(liandan["main"]) then
	elseif checkitems(liandan.items,liandan["main"],liandan["main"]) then
	elseif checkgiftdrop(liandan.dropgift,liandan["main"],liandan.packluosha) then
	elseif checksell(liandan.sells,liandan["main"],liandan["main"],1291) then
	elseif checkpack(liandan.pack,"baoguo",liandan["main"],liandan["main"],1291) then
	elseif check_eatdan(liandan.eat,liandan["main"]) then
	elseif checkstudy(liandan["main"]) then
	elseif checkfangqi(liandan["main"],liandan["main"]) then
	elseif itemsnum("cao yao")>0 then
		busytest(liandan.caiyaogive)
	else
		busytest(liandan.askyao)
	end
end
liandan.packluosha=function()
	send("keep dan")
	do_pack("dan","baoguo",liandan["main"],liandan["main"])
end
liandan.askyao=function()
	go(liandanyaoloc,liandan.askyaocmd,liandan_end_fail)
end

liandan.askyaocmd=function()
	liandan.yaoanswer=0
	npchere("yao chun","yun regenerate;ask yao chun about liandan")
	infoend(liandan.askyaook)
end
liandan_yaook=function()
	liandan.yaoanswer=1
end

liandan.askyaook=function()
	if npc.nobody>0 then
		liandan_end_fail()
	elseif 	liandan.yaoanswer==1 then
		busytest(liandan.askyaocmd)
	else
		busytest(liandan.asktong)
	end
end

liandan.asktong=function()
	go(liandanxiaoerloc,liandan.asktongcmd,liandan_end_fail)
end
liandan.asktongcmd=function()
	liandan.tonganswer=0
	npchere("xiao tong","yun regenerate;ask xiao tong about 药材")
	infoend(liandan.asktongok)
end

liandan.asktongok=function()
	if npc.nobody>0 then
		liandan_end_fail()
	elseif 	liandan.tonganswer==1 then
		busytest(liandan.caiyao)
	elseif 	liandan.tonganswer==2 then
		busytest(liandan.liandan)
	else
		busytest(liandan.askyao)
	end
end

liandan_tongcai=function()
	liandan.tonganswer=1
end

liandan_tonglian=function()
	liandan.tonganswer=2
end

liandan.caiyao=function()
	if GetVariable("pfm")~=nil and GetVariable("pfm")~="" then
		hook(hooks.fight,pfm)
	end
	local loc=liandan.loc[math.random(1,#liandan.loc)]
	weapon(1)
	go(loc,liandan.caiyaocmd,liandan_end_fail)
end

liandan.caiyaocmd=function()
	run("cai yao")
	if hashook(hooks.fight) then run("kill du langzhong;kill du she") end
	busytest(liandan.caiyaook)
end

liandan.caiyaook=function()
	run("i")
	infoend(liandan.caiyaotest)
end
liandan.caiyaotest=function()
	if itemsnum("cao yao")>0 then
		killcmd()
		busytest(liandan.caiyaogive)
	else
		busytest(liandan.caiyaocmd)
	end
end
liandan.caiyaogive=function()
	go(liandanxiaoerloc,liandan.caiyaogivecmd,liandan_end_fail)
end

liandan.caiyaogivecmd=function()
	run("give cao yao to xiao tong")
	busytest(liandan.liandan)
end
liandan.liandan=function()
	go(liandanloc,liandan.liandancmd,liandan_end_fail)
end

liandan.liandancmd=function()
	run("liandan")
	busytest(liandan_end_ok)
end

liandan["end"]=function(s)
	if ((s~="")and(s~=nil)) then
		call(liandan[s])
	end
	hook(hooks.fight,nil)
	EnableTriggerGroup("liandan",false)
	liandan["ok"]=nil
	liandan["fail"]=nil
end

liandan_end_afterbusy=function()
	liandan["end"]("ok")
end
liandan_end_ok=function()
	DoAfterSpecial(2,"liandan_end_afterbusy()",12)
end

liandan_end_fail=function()
	liandan["end"]("fail")
end

check_eatdan=function(eatdan_list,eatdan_ok,eatdan_fail)
	for i,v in pairs(eatdan_list) do
		if itemsnum(i)>0 then
			run("eat "..v)
			busytest(eatdan_ok)
			return true
		end
	end
	return false
end
