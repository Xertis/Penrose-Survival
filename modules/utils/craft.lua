local matrixu = require "noname:utils/matrix"
local module = {}

local CRAFTS = {}
local crafts = file.list("noname:data/crafts")

for i, path in ipairs(crafts) do
    local craft = json.parse(file.read(path))
    table.insert(CRAFTS, craft)
end

function module.find_craft(slots)
    slots = matrixu.crop2D(slots)

    for _, craft in ipairs(CRAFTS) do
        if matrixu.equals(craft, slots) then
            return craft
        end
    end
end

return module