local craftu = require "penrose:utils/craft"
local matrixu = require "penrose:utils/matrix"
local ctable = require "penrose:frameworks/craft/table"
local const = nil
local CRAFT = nil

local ITEMS_AVAILABLE = nil

function on_open()
    const = require "penrose:constants"
end

function check(invid, slot)
    print(invid)
    if not ITEMS_AVAILABLE then
        ITEMS_AVAILABLE = const.session.items_available
    end
    local slots = {}
    local raw = {}
    for j = 1, 4 do
        local i = 4 - j

        local id, count = inventory.get(invid, i)
        if item.name(id) == "core:empty" then
            table.insert(raw, 0)
        else
            id = item.name(id)
            table.insert(raw, {id, count})
        end

        if i % 2 == 0 then
            table.insert(slots, raw)
            raw = {}
        end
    end
    print(json.tostring({d = slots}))
    local craft, bounds = craftu.table.find_craft(slots)
    if craft then
        local id = nil
        if ITEMS_AVAILABLE[craft[1]] then id = craft[1] else id = craft[1] .. ".item" end
        inventory.set(invid, 4, ITEMS_AVAILABLE[id], craft[2]["count"])
        CRAFT = {craft, bounds, slots}
    elseif slot then
        inventory.set(invid, 4, item.index("core:empty"), 0)
        CRAFT = nil
    end
end

function clear(invid)
    if CRAFT then
        local enlarged_craft = matrixu.uncrop2D(CRAFT[1][2]["craft"], CRAFT[2])

        if ctable.equals(enlarged_craft, CRAFT[3]) then
            local slots = ctable.sub(CRAFT[3], enlarged_craft)
            local count_row = #slots
            local count_col = #slots[1]

            for i = 1, count_row do
                for j = 1, count_col do
                    if type(slots[i][j]) == "table" then
                        local count_need = slots[i][j][2]
                        local slot_id = 3 - ((i-1) * count_row + (j-1))
                        local item_id, _ = inventory.get(invid, slot_id)

                        if count_need > 0 then
                            inventory.set(invid, slot_id, item_id, count_need)
                        else
                            inventory.set(invid, slot_id, item.index("core:empty"), 0)
                        end
                    end
                end
            end
        end
    end
    check(invid)
end

function all(invid)
    if CRAFT then
        local enlarged_craft = matrixu.uncrop2D(CRAFT[1][2]["craft"], CRAFT[2])
        local res = 0
        if ctable.equals(enlarged_craft, CRAFT[3]) then
            local slots = CRAFT[3]
            local temp = nil
            while ctable.equals(enlarged_craft, slots) do
                temp = slots
                res = res + 1
                slots = ctable.sub(slots, enlarged_craft)
            end
            local id = nil
            if ITEMS_AVAILABLE[CRAFT[1][1]] then id = CRAFT[1][1] else id = CRAFT[1][1] .. ".item" end
            inventory.set(invid, 4, item.index(id), res * CRAFT[1][2]['count'])
            slots, temp = temp, nil
            local count_row = #slots
            local count_col = #slots[1]

            for i = 1, count_row do
                for j = 1, count_col do
                    if type(slots[i][j]) == "table" then
                        local count_need = slots[i][j][2]
                        local slot_id = 3 - ((i-1) * count_row + (j-1))
                        local item_id, _ = inventory.get(invid, slot_id)
                        if count_need > 0 then
                            inventory.set(invid, slot_id, item_id, count_need)
                        else
                            inventory.set(invid, slot_id, item.index("core:empty"), 0)
                        end
                    end
                end
            end
        end
    end
end