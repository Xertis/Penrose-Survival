local module = {
    block = {},
    world = {}
}

local WORLD_META = {}

function module.block.set(x, y, z, key, val)
    block.set_field(x, y, z, key, val)
end

function module.block.get(x, y, z, key, val)
    block.get_field(x, y, z, key, val)
end

function module.world.set(key, val)
    WORLD_META[key] = val
end

function module.world.get(key)
    return WORLD_META[key]
end

function module.world.save()
   local path = pack.data_file("penrose", "world_metadata.bjson")
   file.write_bytes(path, bjson.tobytes(WORLD_META, true))
end

function module.world.load()
    local path = pack.data_file("penrose", "world_metadata.bjson")
    if file.exists(path) then
        local bytes = file.read_bytes(path)
        WORLD_META = bjson.frombytes(bytes)
    end
end

return module