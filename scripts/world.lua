require("noname:player/blocked")
local invu = require "noname:utils/inventory"


function on_world_tick( ... )
    BlockedFunc.update()
end

function on_block_broken(id, x, y, z)
    x, y, z = math.floor(x), math.floor(y), math.floor(z)
    entities.spawn("base:drop", {x+0.5, y+0.5, z+0.5}, {base__drop={
        id=id,
        count=1
    }})
end

function on_block_placed(id, x, y, z, pid)
    x, y, z = math.floor(x), math.floor(y), math.floor(z)
    invu.del_item(id .. ".item", pid)
end