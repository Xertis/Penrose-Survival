local events = require "noname:events/events"
local player_events = require "noname:events/player"

function on_hud_open(pid)
    hud.open_permanent("noname:bars")
    events.world.reg(player_events.falling, {pid}, true)

    input.add_callback("noname.craft", function ()
        local x, y, z = player.get_selected_block(pid)
        if block.get(x, y, z) ~= block.index("base:sand") then
            return
        end

        if not hud.is_paused() then
            --hud.show_overlay("noname:craft_inv", true)
        end
    end)
end