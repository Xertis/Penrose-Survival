function on_interact(x, y, z)
    hud.open_block(x, y, z)

    return true
end

function on_broken(x, y, z)
    local inv = inventory.get_block(x, y, z)

    if inv ~= 0 then
        local size = inventory.size(inv)
        for slot=0, size-1 do
            local id, count = inventory.get(inv, slot)
            x, y, z = math.floor(x), math.floor(y), math.floor(z)
            entities.spawn("base:drop", {x+0.5, y+0.5, z+0.5}, {base__drop={
                id=id,
                count=count
            }})
        end
    end
end
