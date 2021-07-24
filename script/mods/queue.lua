queue={
    queue={},
    tick=2100,
    timestamp=0,
    sent={},
    sep={},
}

queue.exec=function(cmds)
    queue.append(cmds)
    queue.send()
end
queue.limit=function()
    return cmd_limit
end
queue.discard=function()
    queue.queue={}
end
queue.append=function(cmds)
    for k,v in pairs(cmds) do
        table.insert(queue.queue,v)
    end
end
queue.sort=function(fisrt,second)
    return fisrt<second
end
queue.full=function()
    local ts=Milliseconds()
    while #queue.sent<queue.limit() do
        table.insert(queue.sent,ts)
    end
end
queue.send=function()
    local ts=Milliseconds()
    table.sort(queue.sent,queue.sort)
    local newsent={}
    for k,v in pairs(queue.sent) do
        if ts-v<=queue.tick then
            table.insert(newsent,v)
        end
    end
    queue.sent=newsent
    while #queue.queue~=0 and #queue.sent<queue.limit() do
        local cmd=table.remove(queue.queue,1)
        local ts=Milliseconds()
        table.insert(queue.sent,ts)
        SendNoEcho(cmd)
        if queue.sep[cmd] then
            queue.full()
            return
        end
    end
end

do_send_queue=function()
    queue.exec({})
end
queue.full()


