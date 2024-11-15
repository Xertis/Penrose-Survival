require("noname:player/blocked")
local dropu = require "noname:utils/drop"
local invu = require "noname:utils/inventory"


function on_world_tick( ... )
    BlockedFunc.update()
end

function on_block_broken(id, x, y, z)
    x, y, z = math.floor(x), math.floor(y), math.floor(z)
    local drop = dropu.get_drops_ids(block.name(id))
    for _, v in ipairs(drop) do
        local count = v[2]
        for i=1, count do
            entities.spawn("base:drop", {x+0.5, y+0.5, z+0.5}, {base__drop={
                id=item.index(v[1] .. '.item'),
                count=1
            }})
        end
    end
end

function on_block_placed(id, x, y, z, pid)
    x, y, z = math.floor(x), math.floor(y), math.floor(z)
    invu.del_item(id .. ".item", pid)
end