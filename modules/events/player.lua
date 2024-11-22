local player_bars = require "noname:player/bars_manager"
local PLAYERS = {}
local module = {}

function module.base(pid)
    module.falling(pid)
    module.death(pid)
end

function module.falling(pid)
    local e = entities.get(player.get_entity(pid))
    local body = e.rigidbody
    local fall_velocity = body:get_vel()[2]

    if fall_velocity <= -15 then
        PLAYERS[tostring(pid)] = fall_velocity
    end

    if PLAYERS[tostring(pid)] and PLAYERS[tostring(pid)] ~= 0 and body:is_grounded() then
        player_bars.set_damage(math.abs(PLAYERS[tostring(pid)]))
        PLAYERS[tostring(pid)] = 0
    end
end

function module.death(pid)
    if player_bars.get_hp() < 1 then
        player.set_pos(pid, unpack({player.get_spawnpoint(pid)}))
        player_bars.set_hp(100)
    end
end

return module