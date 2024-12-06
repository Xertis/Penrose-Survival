local module = {
    block = {},
    world = {},
    player = {}
}

local WORLD_META = {}
local PLAYERS_META = {}

function module.open()
    module.world.load()
    module.player.load()
end

function module.close()
    module.world.save()
    module.player.save()
end

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

function module.player.set(pid, key, val)
    if PLAYERS_META[pid] == nil then
        PLAYERS_META[pid] = {}
    end
    PLAYERS_META[pid][key] = val
end

function module.player.get(pid)
    return PLAYERS_META[pid]
end

function module.player.save()
    local path = pack.data_file("penrose", "players_metadata.bjson")
    file.write_bytes(path, bjson.tobytes(PLAYERS_META, true))
 end

function module.player.load()
    local path = pack.data_file("penrose", "players_metadata.bjson")
    if file.exists(path) then
        local bytes = file.read_bytes(path)
        PLAYERS_META = bjson.frombytes(bytes)
    end
 end


return module