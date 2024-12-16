local _events = require "events/events"
local gamemode = require "player/gamemode"
local player_events = require "events/player"
local const = require "penrose:constants"
local metadata = require "penrose:files/metadata"

function on_hud_open(pid)
    if player.get_name(pid) == '' then
        local name = "player_"
        local index = 0

        while metadata.player.get(name .. index) ~= nil do
            index = index + 1
            print(name .. index)
        end

        player.set_name(pid, name .. index)
    end

    table.insert(const.session.players_online, pid)
    gamemode.init(pid)
    events.emit(PACK_ID..":player_join", pid)
    _events.player.reg(player_events.base, {}, true)

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

function on_hud_close(pid)
    local index = table.index(const.session.players_online, pid)

    if index ~= -1 then
        table.remove(const.session.players_online, index)
    end

    events.emit(PACK_ID..":player_leave", pid)
end