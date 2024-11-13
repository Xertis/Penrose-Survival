local module = {}

function module.del_item(id, pid)
    local inv, slot = player.get_inventory(pid)

    local item_id, item_count = inventory.get(inv, slot)
    if item_count > 0 then
        inventory.set(inv, slot, item_id, item_count - 1)
    end
end

return module