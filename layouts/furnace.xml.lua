local furnaces = require "penrose:utils/furnaces"

function on_open(invid, x, y, z)
    furnaces.on_open(invid, x, y, z)
end

function check(invid, slot)
end