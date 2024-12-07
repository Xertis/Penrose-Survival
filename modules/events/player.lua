local player_bars = require "penrose:player/bars_manager"
local events = require "penrose:events/events"
local metadata = require "penrose:files/metadata"
local pop_up = require "penrose:frontend/pop_up"
local PLAYERS = {}
local module = {}

function module.base(pid, tps)
    if PLAYERS[tostring(pid)] == nil then
        PLAYERS[tostring(pid)] = {0, 3*tps*60, 0}
        --fall_speed, saturation
    end
    module.falling(pid, tps)
    module.death(pid, tps)
    module.saturation(pid, tps)
end

function module.quit()
    metadata.world.set("players_stats", PLAYERS)
end

function module.open()
   PLAYERS = metadata.world.get("players_stats") or {}
end

function module.falling(pid, tps)
    local e = entities.get(player.get_entity(pid))
    local body = e.rigidbody
    local fall_velocity = body:get_vel()[2]

    if fall_velocity <= -15 then
        PLAYERS[tostring(pid)][1] = fall_velocity
    end

    if PLAYERS[tostring(pid)] ~= 0 and body:is_grounded() then
        player_bars.set_damage(math.abs(PLAYERS[tostring(pid)][1]))
        PLAYERS[tostring(pid)][1] = 0
    end
end

function module.saturation(pid, tps)
    local saturation = PLAYERS[tostring(pid)][2]
    if saturation > 0 then
        PLAYERS[tostring(pid)][2] = saturation - 1
    else
        player_bars.set_hunger(5)
        PLAYERS[tostring(pid)][2] = 3*tps*60
    end

    if player_bars.get_food() < 1 then
        player_bars.set_damage(0.2)
    end

    if player_bars.get_food() >= 100 then
        player_bars.set_damage(-0.02)
    end
end

function module.death(pid, tps)
    if player_bars.get_hp() < 1 then
        local inv = player.get_inventory(pid)
        local size = inventory.size(inv)

        for slot=0, size-1 do
            local id, count = inventory.get(inv, slot)
            local x, y, z = player.get_pos(pid)
            x, y, z = math.floor(x), math.floor(y), math.floor(z)
            entities.spawn("base:drop", {x+0.5, y+0.5, z+0.5}, {base__drop={
                id=id,
                count=count
            }})
            inventory.set(inv, slot, 0, 0)
        end
        player.set_pos(pid, unpack({player.get_spawnpoint(pid)}))
        player_bars.set_hp(100)
        player_bars.set_food(100)
        pop_up.open("You died.")
    end
end

events.world.quit.reg(module.quit, {})

return module