local events = require "events/events"
local gamemode = require "player/gamemode"
local player_events = require "events/player"

function on_hud_open(pid)
    hud.open_permanent("penrose:bars")
    gamemode.init(pid)
    events.player.reg(player_events.base, {}, true)

    input.add_callback("penrose.craft", function ()
        local x, y, z = player.get_selected_block(pid)
        if block.get(x, y, z) ~= block.index("base:sand") then
            return
        end

        if not hud.is_paused() then
            local inv = hud.open("penrose:sand_craft", false)
        end
    end)
end