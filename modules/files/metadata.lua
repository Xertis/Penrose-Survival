local module = {
    block = {},
    world = {},
    player = {},
    own = {}
}

local WORLD_META = {}
local PLAYERS_META = {}
local OWN_META = {}

function module.open()
    module.load()
end

function module.close()
    module.save()
end

function module.own.set(name, key, val)
    if OWN_META[name] == nil then
        OWN_META[name] = {}
    end

    OWN_META[name][key] = val
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

function module.player.set(pname, key, val)
    if PLAYERS_META[pname] == nil then
        PLAYERS_META[pname] = {}
    end
    PLAYERS_META[pname][key] = val
end

function module.player.get(pname)
    return PLAYERS_META[pname]
end

function module.player.get_names()
    local names = {}

    for name, _ in pairs(PLAYERS_META) do
        table.insert(names, name)
    end

    return names
end

function module.save()
    local path = pack.data_file("penrose", "world_metadata.bjson")
    file.write_bytes(path, bjson.tobytes(WORLD_META, true))

    path = pack.data_file("penrose", "players_metadata.bjson")
    file.write_bytes(path, bjson.tobytes(PLAYERS_META, true))

    path = pack.data_file("penrose", "own_metadata.bjson")
    file.write_bytes(path, bjson.tobytes(OWN_META, true))
end

function module.load()
    local path = pack.data_file("penrose", "world_metadata.bjson")
    if file.exists(path) then
        local bytes = file.read_bytes(path)
        WORLD_META = bjson.frombytes(bytes)
    end

    path = pack.data_file("penrose", "players_metadata.bjson")
    if file.exists(path) then
        local bytes = file.read_bytes(path)
        PLAYERS_META = bjson.frombytes(bytes)
    end

    path = pack.data_file("penrose", "own_metadata.bjson")
    if file.exists(path) then
        local bytes = file.read_bytes(path)
        OWN_META = bjson.frombytes(bytes)
    end
end

function module.player.load()
    local path = pack.data_file("penrose", "players_metadata.bjson")
    if file.exists(path) then
        local bytes = file.read_bytes(path)
        PLAYERS_META = bjson.frombytes(bytes)
    end
 end


return module