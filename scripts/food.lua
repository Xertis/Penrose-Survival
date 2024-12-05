local const = require "noname:constants"
local player_bars = require "noname:player/bars_manager"
local pop_up = require "noname:frontend/pop_up"

function on_use(pid)
    local inv, slot = player.get_inventory(pid)
    local item_id, item_count = inventory.get(inv, slot)

    local saturation = const.session.food_available[item.name(item_id)]
    if saturation and player_bars.get_food() < 100 then
        if item_count <= 0 then item_id = 0 item_count = 1 end
        inventory.set(inv, slot, item_id, item_count-1)
        player_bars.set_hunger(-saturation)
    else
        pop_up.open("You're not hungry")
    end
end