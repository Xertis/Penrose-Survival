local toolsu = require "player/tools"
local invu = require "utils/inventory"
local const = require "constants"
local module = {}
local drops = nil

local function parse_drop()
    if not drops then
        drops = json.parse(file.read("penrose:data/drops.json"))
        local tags = json.parse(file.read("penrose:data/drops_tags.json"))

        for i, tag in pairs(drops) do
            drops[i] = tags[tag]
        end
    end
end

local function repair_chances(chances, def_drop)
    local add = 0
    if #chances < def_drop then
        add = def_drop - #chances
    end

    for i=1, add do
        table.insert(chances, 1)
    end
    return chances
end

local function check_self(drop, id)
    local d = table.deep_copy(drop)

    for o, i in ipairs(d) do
        if i[1] == "!self" then
            d[o][1] = id
        end
    end

    return d
end

local function get_material_drop(block_id)
    for i, m in pairs(const.session.materials_available) do
        if table.has(m, block_id) then
            return i
        end
    end
end

function module.get_drops_ids(id, pid)
    if not drops then
        parse_drop()
    end

    local drop_info = drops[id]
    local t_id = nil

    if not drop_info then
        t_id = get_material_drop(id .. ".item")
        drop_info = drops[t_id]
    end

    if not drop_info then return {{id .. ".item", 1}} end
    local temp_drop = check_self(drop_info["drop"], id .. ".item")
    local chances = drop_info["chances"] or {}
    local placeholder = drop_info["placeholder"] or {}
    local start_level = drop_info["start-level"] or 0

    local item_id = invu.get_item(pid)
    local level = toolsu.is_tool(item.name(item_id)) or 0

    local tool_by_item = toolsu.find_tool_by_item(item.name(item_id))
    local tool_by_material = toolsu.find_tool(id, nil)

    if (level and level < start_level) or (tool_by_item ~= tool_by_material)  then
        return {}
    end

    chances = repair_chances(chances, #temp_drop)
    local chance_ids = math.chance(chances)
    local drop = {}
    if #chance_ids > 0 then
        for i, d in ipairs(chance_ids) do
            table.insert(drop, temp_drop[d])
        end
    else
        drop = placeholder
    end

    return drop
end

return module