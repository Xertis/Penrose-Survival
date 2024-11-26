local function broken(x, y, z)
    if block.get(x, y-1, z) == 0 then
        local block_id = block.index("noname:bamboo")
        local item_id = block.get_picking_item(block_id)
        while block.get(x, y, z) == block_id and block.get_rotation(x, y, z) == 4 do
            block.set(x, y, z, 0, 0)
            entities.spawn("base:drop", {x+0.5, y+0.5, z+0.5}, {base__drop={
                id=item_id,
                count=1
            }})
            y = y + 1
        end
    end
end

local function get_height(x, y, z)
    y = y + 1
    local block_id = block.index("noname:bamboo")
    local height = 0
    local start_y = y

    while block.get(x, y, z) == block_id and block.get_rotation(x, y, z) == 4 do
        height = height + 1
        y = y + 1
    end

    y = start_y - 1

    while block.get(x, y, z) == block_id and block.get_rotation(x, y, z) == 4 do
        height = height + 1
        y = y - 1
    end

    return height
end

local function growth(x, y, z)
    local block_id = block.index("noname:bamboo")
    local height = get_height(x, y, z)
    if height < 20 then
        while block.get(x, y, z) == block_id and block.get_rotation(x, y, z) == 4 do
            y = y + 1
        end
        if block.get(x, y, z) == 0 then
            block.set(x, y, z, block_id, 4)
        end
    end
end

function on_broken(x, y, z)
    broken(x, y, z)
end

function on_update(x, y, z)
    broken(x, y, z)
end

function on_random_update(x, y, z)
    if block.get_rotation(x, y, z) == 4 then
        growth(x, y, z)
    end
end