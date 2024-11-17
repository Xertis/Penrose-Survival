local craftu = require "noname:utils/craft"

function check(invid, s)
    local slots = {}
    local raw = {}
    for j = 1, 9 do
        local i = 9 - j

        local id, count = inventory.get(invid, i)
        if item.name(id) == "core:empty" then
            table.insert(raw, 0)
        else
            id = item.name(id)
            table.insert(raw, {id, count})
        end

        if i % 3 == 0 then
            table.insert(slots, raw)
            raw = {}
        end
    end

    local craft = craftu.find_craft(slots)
    if craft then
        inventory.set(invid, 9, item.index(craft[1] .. ".item"), craft[2]["count"])
    else
        inventory.set(invid, 9, item.index("core:empty"), 0)
    end
end

function clear(invid, slot)
    for i = 0, 9 do
        inventory.set(invid, i, item.index("core:empty"), 0)
    end
end