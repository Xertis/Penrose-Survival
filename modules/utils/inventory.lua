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

return module