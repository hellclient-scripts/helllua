-- queue={
--     queue={},
--     tick=1100,
--     timestamp=0,
--     sent={},
-- }

-- queue.exec=function(cmds,grouped)
--     queue.append(cmds,grouped)
--     queue.send()
-- end
-- queue.limit=function()
--     return cmd_limit
-- end
-- queue.discard=function()
--     queue.queue={}
-- end
-- queue.append=function(rawcmds,grouped)
--     local cmds={}
--     for k,v in pairs(rawcmds) do
--         local splited=SplitN(v,"\n",-1)
--         for k,c in pairs(splited) do
--             table.insert(cmds,c)
--         end
--     end
--     if grouped then
--         table.insert(queue.queue,cmds)
--     else
--         for k,v in pairs(cmds) do
--                 table.insert(queue.queue,{v})
--         end
--     end
-- end
-- queue.full=function()
--     local ts=Milliseconds()
--     while #queue.sent<queue.limit() do
--         table.insert(queue.sent,ts)
--     end
-- end
-- queue.fulltick=function()
--     queue.sent={}
--     queue.full()
-- end
-- queue.clean=function()
--     local ts=Milliseconds()
--     local newsent={}
--     for k,v in pairs(queue.sent) do
--         if ts-v<=queue.tick then
--             table.insert(newsent,v)
--         end
--     end
--     queue.sent=newsent
-- end
-- queue.send=function()
--     queue.clean()
--     while #queue.queue~=0 and #queue.sent<queue.limit() do
--         local cmds=queue.queue[1]
--         if queue.limit()-#queue.sent<#cmds then
--             queue.fulltick()
--             return   
--         end
--         table.remove(queue.queue,1)
--         for k,v in pairs(cmds) do
--             local ts=Milliseconds()
--             table.insert(queue.sent,ts)
--             SendNoEcho(v)
--             if walkecho==true then Note(v) end
--         end
--     end
-- end

-- do_send_queue=function()
--     queue.exec({})
-- end
-- queue.full()
Metronome:settick(1100)
Metronome:setinterval(50)

queue={}
queue.discard=function()
    Metronome:discard()
end
queue.exec=function(cmds,grouped)
    Metronome:setbeats(cmd_limit)
    Metronome:push(cmds,grouped,walkecho)
end
