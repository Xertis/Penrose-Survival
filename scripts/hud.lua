local events = require "events/events"
local gamemode = require "player/gamemode"
local player_events = require "events/player"

function on_hud_open(pid)
    hud.open_permanent("penrose:bars")
    hud.open_permanent("penrose:madness")
    gamemode.init(pid)
    events.player.reg(player_events.base, {}, true)

    input.add_callback("penrose.craft", function ()
        local x, y, z = player.get_selected_block(pid)
        local px, py, pz = player.get_pos(pid)

        px, py, pz = math.floor(px), math.floor(py), math.floor(pz)

        if block.get(x, y, z) ~= block.index("base:sand") or block.get(px, py-1, pz) ~= block.index("base:sand") then
            return
        end

        if not hud.is_paused() then
            local inv = hud.open("penrose:sand_craft", false)
        end
    end)

    --input.add_callback("penrose.guide", function ()
        --if not hud.is_paused() then
            --local inv = hud.show_overlay("penrose:guide_main", true)
        --end
    --end)
end