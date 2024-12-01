local events = require "noname:events/events"
local player_events = require "noname:events/player"

function on_hud_open(pid)
    hud.open_permanent("noname:bars")
    player.set_infinite_items(pid, false)
    player.set_instant_destruction(pid, false)
    events.world.reg(player_events.base, {pid}, true)

    input.add_callback("noname.craft", function ()
        local x, y, z = player.get_selected_block(pid)
        if block.get(x, y, z) ~= block.index("base:sand") then
            return
        end

        if not hud.is_paused() then
            hud.open(player.get_inventory(pid), "noname:sand_craft")
        end
    end)
end