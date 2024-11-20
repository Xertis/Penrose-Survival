local furnaces = require "noname:utils/furnaces"

function on_broken(x, y, z)
    furnaces.unreg(x, y, z)
end

function on_interact(x, y, z)
    furnaces.reg(x, y, z)
    hud.open_block(x, y, z)
end