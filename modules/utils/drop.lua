local module = {}
local drops = nil

local function parse_drop()
    if not drops then
        drops = json.parse(file.read("noname:data/drops.json"))
        local tags = json.parse(file.read("noname:data/drops_tags.json"))

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

function module.get_drops_ids(id)
    if not drops then
        parse_drop()
    end

    local drop_info = drops[id]

    if not drop_info then return {{id .. ".item", 1}} end

    local temp_drop = drop_info["drop"]
    local chances = drop_info["chances"] or {}
    local placeholder = drop_info["placeholder"] or {}

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