local craftu = require "noname:utils/craft"
local const = require "noname:constants"
local FUELS = {}
local events = require "noname:events/events"
local metadata = require "noname:files/metadata"
local module = {}

local FURNACES = {}

--Тики до того, как закончится топливо
--Тики до того, как сготовится предмет

function module.reg(x, y, z)
    table.insert(FURNACES, {x, y, z, 0, 0})
end

function module.unreg(x, y, z)
    for i, b in ipairs(FURNACES) do
        if b[1] == x and b[2] == y and b[3] == z then
            table.remove(FURNACES, i)
        end
    end
end

function module.get(x, y, z)
    for i, b in ipairs(FURNACES) do
        if b[1] == x and b[2] == y and b[3] == z then
            return b[4], b[5], i
        end
    end
end

function module.tick()
    for i, b in ipairs(FURNACES) do
        if b[5] > 0 then
           b[5] = b[5] - 0.05
        end

        if b[4] > 0 then
            b[4] = b[4] - 0.05
        end
        module.check(inventory.get_block(b[1], b[2], b[3]), 0, b[1], b[2], b[3])
    end
end

function module.quit()
    metadata.world.set("furnaces", FURNACES)
end

function module.load()
    FURNACES = metadata.world.get("furnaces") or {}
end

function module.on_open(invid, x, y, z, doc)
    FUELS = const.session.fuels_available
end

function module.check(invid, slot, x, y, z)
    local furnace = {module.get(x, y, z)}
    print(json.tostring({d=furnace}))
    local id, count = inventory.get(invid, slot)
    local slots = {
        craft = {item.name(id), count}
    }

    local craft = craftu.furnace.find_craft(slots)

    if craft and furnace[1] > 0 and furnace[2] <= 0 then
        if const.session.items_available[craft[1]] == nil then craft[1] = craft[1] .. '.item' end
        local in_slot_id, in_slot_count = inventory.get(invid, 2)
        if in_slot_id == item.index(craft[1]) or in_slot_id == 0 then
            if in_slot_id == 0 then in_slot_count = 0 end
            inventory.set(invid, 2, item.index(craft[1]), craft[2].count + in_slot_count)

            count = slots.craft[2] - craft[2].craft[2]
            in_slot_id, in_slot_count = inventory.get(invid, 0)
            if count <= 0 then
                inventory.set(invid, 0)
            elseif in_slot_id == id then
                inventory.set(invid, 0, id, count)
            end

        end
    end
    if furnace[1] <= 0 and inventory.get(invid, 0) ~= 0 then
        id, count = inventory.get(invid, 1)
        local energy = FUELS[item.name(id)]
        if energy then
            FURNACES[furnace[3]][4] = energy
            inventory.set(invid, 1, id, count-1)
        end
    end
    if furnace[2] <= 0 and furnace[3] > 0 and inventory.get(invid, 0) ~= 0 then
        FURNACES[furnace[3]][5] = 10
    end
end

events.world.reg(module.tick, {}, "Done")
events.world.quit.reg(module.quit, {})

return module