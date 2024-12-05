local matrixu = require "penrose:utils/matrix"
local ctable = require "penrose:frameworks/craft/table"
local cfurnace = require "penrose:frameworks/craft/furnace"
local const = require "penrose:constants"
local module = {table = {}, furnace = {}}

function module.table.find_craft(slots)
    local bounds = nil
    slots, bounds = matrixu.crop2D(slots)
    --print(json.tostring(slots))
    for _, craft in ipairs(const.session.crafts_available.table) do
        if craft[2]["craft"] and ctable.equals(craft[2]["craft"], slots, const.session.materials_available) then
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