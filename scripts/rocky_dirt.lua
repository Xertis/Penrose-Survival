function on_random_update(x, y, z)
    local water_id = block.index("base:water")
    local wet_dirt_id = block.index("noname:wet_dirt")

    if block.get(x, y, z-1) == water_id then
        block.set(x, y, z, wet_dirt_id)

    elseif block.get(x, y, z+1) == water_id then
        block.set(x, y, z, wet_dirt_id)

    elseif block.get(x-1, y, z) == water_id then
        block.set(x, y, z, wet_dirt_id)

    elseif block.get(x+1, y, z) == water_id then
        block.set(x, y, z, wet_dirt_id)

    elseif block.get(x, y-1, z) == water_id then
        block.set(x, y, z, wet_dirt_id)
    end
end