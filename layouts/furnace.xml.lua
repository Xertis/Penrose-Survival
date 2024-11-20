local furnaces = require "noname:utils/furnaces"

local furnace = nil

function on_open(invid, x, y, z)
    furnace = {x, y, z}
    furnaces.on_open(invid, x, y, z)
end

function check(invid, slot)
    furnaces.check(invid, slot, furnace[1], furnace[2], furnace[3])
end