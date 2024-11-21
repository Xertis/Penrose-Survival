local matrixu = require "noname:utils/matrix"
local ctable = require "noname:frameworks/craft/table"
local cfurnace = require "noname:frameworks/craft/furnace"
local const = require "noname:constants"
local module = {table = {}, furnace = {}}

function module.table.find_craft(slots)
    local bounds = nil
    slots, bounds = matrixu.crop2D(slots)
    --print(json.tostring(slots))
    for _, craft in ipairs(const.session.crafts_available.table) do
        if ctable.equals(craft[2]["craft"], slots, const.session.materials_available) then
            return craft, bounds
        end
    end
end

function module.furnace.find_craft(slots)
    for _, craft in ipairs(const.session.crafts_available.furnace) do
        if cfurnace.equals(craft, slots, const.session.materials_available) then
            return craft
        end
    end
end

return module