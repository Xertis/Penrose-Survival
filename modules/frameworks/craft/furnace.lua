local c = require "noname:constants"
local module = {}

local craft_example = {
    craft = {"qwadas", 1},
    fuel = "!fuel",
    count = 4
}

function module.equals(craft1, craft2, MATERIALS)
    MATERIALS = MATERIALS or c.session.materials_available
    local material = MATERIALS[craft1[2].craft[1]] or {}
    if (craft1[2].craft[1] == craft2.craft[1] or table.has(material, craft2.craft[1])) and craft1[2].craft[2] <= craft2.craft[2] then
        return true
    end
    return false
end

function module.sub(craft1, craft2)
    craft1[2].craft[2] = craft1[2].craft[2] - craft2.craft[2]
    return craft1
end

return module