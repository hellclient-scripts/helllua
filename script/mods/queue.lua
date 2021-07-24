queue={
    queue={},
    tick=2100,
    timestamp=0,
    sent={},
}

queue.exec=function(cmds,grouped)
    queue.append(cmds)
    queue.send()
end
queue.limit=function()
    return cmd_limit
end
queue.discard=function()
    queue.queue={}
end
queue.append=function(cmds,grouped)
    if grouped then
        table.insert(queue.queue,cmds)
    else
        for k,v in pairs(cmds) do
            table.insert(queue.queue,{v})
        end
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
queue.clean=function()
    local ts=Milliseconds()
    table.sort(queue.sent,queue.sort)
    local newsent={}
    for k,v in pairs(queue.sent) do
        if ts-v<=queue.tick then
            table.insert(newsent,v)
        end
    end
    queue.sent=newsent
end
queue.send=function()
    queue.clean()
    while #queue.queue~=0 and #queue.sent<queue.limit() do
        local cmds=queue.queue[1]
        if queue.limit()-#queue.sent<#cmds then
            queue.full()
            return   
        end
        table.remove(queue.queue,1)
        for k,v in pairs(cmds) do
            local ts=Milliseconds()
            table.insert(queue.sent,ts)
            SendNoEcho(v)
            if walkecho==true then Note(v) end
        end
    end
end

do_send_queue=function()
    queue.exec({})
end
queue.full()


