local stru = require "utils/string"

local module = {}

local TOOLS = {}
local levels_power = {0.75, 0.5, 0.25}

for _, ttype in ipairs(file.list("noname:data/tools")) do
    local name = stru.path.parse_filename(ttype)
    local data = json.parse(file.read(ttype))
    TOOLS[name] = data
end

local function find_tool(material, item)
    for _, t in pairs(TOOLS) do
        local i = table.index(t.levels, item)
        if table.has(t.blocks_cracks, material) and i ~= -1 then
            return t
        end
    end
end

function module.is_tool(item)
    for _, t in pairs(TOOLS) do
        local i = table.index(t.levels, item)
        if i ~= -1 then
            return i
        end
    end
end

function module.get_tools()
    return TOOLS
end

function module.get_durability(material, durability, item)
    local tool = find_tool(material, item)
    local level = nil

    if tool then
        level = table.index(tool.levels, item)
    end

    if tool and level then
        level = levels_power[level]
        return durability * level
    end
    return durability
end

return module