local inv = require "utils/inventory"

function on_use_on_block(x, y, z, p)

    if block.get(x, y+1, z) ~= 0 then
        return
    end

    inv.del_item(p)

    entities.spawn("penrose:boat", {x, y+1, z})

end