local const = require "constants"
local events = require "events/events"
local module = {}

function module.del_item(pid)
    local inv, slot = player.get_inventory(pid)

    local item_id, item_count = inventory.get(inv, slot)
    if item_count > 0 then
        inventory.set(inv, slot, item_id, item_count - 1)
    end
end

function module.get_item(pid)
    if pid == -1 then
        return 0, 0
    end

    local inv, slot = player.get_inventory(pid)

    local item_id, item_count = inventory.get(inv, slot)
    return item_id, item_count
end

local function check_slot_data(pid, tps)
    local data = const.session.players_slot_data[pid]
    local inv, slot = player.get_inventory(pid)

    if data.slot ~= slot then
        const.session.players_slot_data[pid] = nil
    end
end

function module.set_slot_data(pid, slot, data)
    const.session.players_slot_data[pid] = {slot = slot, data = data}
end

function module.get_slot_data(pid)
    return const.session.players_slot_data[pid]
end

--events.player.reg(check_slot_data, {}, true)

return module