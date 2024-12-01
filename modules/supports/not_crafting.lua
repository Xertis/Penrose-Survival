local const = require "constants"
local module = {}

function module.scan()
    local crafts = {}

    local installed = pack.get_installed()

    for _, id in ipairs(installed) do
        local path = id .. ":resources/data"
        if file.exists(path) then
            for _, pack in ipairs(file.list(path)) do
                for _, craft in ipairs(file.list(pack .. "/recipe")) do
                    table.insert(crafts, craft)
                end
            end
        end
    end

    return crafts
end

function module.parse(craft)
    local keys = craft.key
    local pattern = craft.pattern
    local result = {craft={}, count=0}

    for _, p in ipairs(pattern) do
        local items = {}
        for char in p:gmatch(".") do
            if char == " " then
                table.insert(items, 0)
            else
                local item = keys[char].item
                if not const.session.items_available[item] then
                    table.insert(items, {item .. '.item', 1})
                else
                    table.insert(items, {item, 1})
                end
            end
        end
        table.insert(result.craft, items)
    end

    result.count = craft.result.count

    return result
end


function module.load()
    local function find(arr, val)
        for _, sub_array in ipairs(arr) do
            if sub_array[1] == val then
                return true
            end
        end
        return false
    end
    local crafts = module.scan()
    local crafts_available = const.session.crafts_available

    for _, path in ipairs(crafts) do
        local craft = json.parse(file.read(path))
        local craft_type = craft.type

        if not find(crafts_available, craft.result.id) and craft_type == "minecraft:crafting_shaped" then
            table.insert(crafts_available.table, {craft.result.id, module.parse(craft)})
        end
    end
end

return module