local stru = require "noname:utils/string"

local const = {

}

local items_available = {}
local blocks_available = {}
local crafts_available = {table = {}, furnace = {}}
local fuels_available = {}
local food_available = {}
local materials_available = {}

local function init()
    for i=0, item.defs_count()-1 do
        items_available[item.name(i)] = i
    end

    for i=0, block.defs_count()-1 do
        blocks_available[block.name(i)] = i
    end

    local crafts = file.list("noname:data/crafts/table")
    local materials = file.list("noname:data/crafts/materials")
    local fuel = file.read("noname:data/fuels.json")
    local food = file.read("noname:data/food.json")

    for i, path in ipairs(crafts) do
        if stru.path.parse_file_extension(path) then
            local craft = {}
            craft[1] = stru.path.parse_filename(path)
            craft[1] = stru.path.filename_repair(craft[1])
            craft[2] = json.parse(file.read(path))
            table.insert(crafts_available.table, craft)
        end
    end

    crafts = file.list("noname:data/crafts/furnace")

    for i, path in ipairs(crafts) do
        if stru.path.parse_file_extension(path) then
            local craft = {}
            craft[1] = stru.path.parse_filename(path)
            craft[1] = stru.path.filename_repair(craft[1])
            craft[2] = json.parse(file.read(path))
            table.insert(crafts_available.furnace, craft)
        end
    end

    for i, path in ipairs(materials) do
        local data = file.read(path)
        materials_available['!' .. stru.path.parse_filename(path)] = string.split(data, ' ')
    end

    for i, v in pairs(json.parse(fuel)) do
        fuels_available[i] = v
    end

    for i, v in pairs(json.parse(food)) do
        food_available[i] = v
    end
end

local session_const = {
    items_available = items_available,
    blocks_available = blocks_available,
    materials_available = materials_available,
    crafts_available = crafts_available,
    fuels_available = fuels_available,
    food_available = food_available
}
return {init = init, const = const, session = session_const}