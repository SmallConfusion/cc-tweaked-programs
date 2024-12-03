local w = {}


w.storageSystemId = 0


function w.init()
    rednet.open("back")
    w.storageSystemId = rednet.lookup("storage", "storageHost")
end

function w.list()
    rednet.send(w.storageSystemId, "l")
    local id, message = rednet.receive()
    return message
end

function w.retrieveItems(getName, count)
    rednet.send(w.storageSystemId, "g " .. getName .. " " .. count)
end

return w
