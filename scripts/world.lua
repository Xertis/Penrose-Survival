require("noname:player/blocked")



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