local player_bars = require "penrose:player/bars_manager"
local _events = require "penrose:events/events"
local metadata = require "penrose:files/metadata"
local pop_up = require "penrose:frontend/pop_up"
local faults = require "generation/faults"

local PLAYERS = {}
local module = {}

function module.base(pid, tps)

    if PLAYERS[tostring(pid)] == nil then
        local player_data = metadata.player.get(player.get_name(pid))
        if player_data and player_data["player-stats-minor"] then
            PLAYERS[tostring(pid)] = player_data["player-stats-minor"]
        else
            PLAYERS[tostring(pid)] = {
                fall_velocity = 0,
                saturation = 3*tps*60,
                madness = {lunacy = 0, madness_lvl = 0},
                shield = 0
            }
            --fall_speed, saturation, madness, shield
        end
    end

    module.saturation(pid, tps)

    if not PLAYERS[tostring(pid)].shield then PLAYERS[tostring(pid)].shield = 0 end

    if PLAYERS[tostring(pid)].shield == 0 then
        module.madness(pid, tps)
        module.falling(pid, tps)
        module.death(pid, tps)
        module.oxygen(pid, tps)
    else
        PLAYERS[tostring(pid)].shield = PLAYERS[tostring(pid)].shield - 1
    end
end

function module.quit()
    for pid, data in pairs(PLAYERS) do
        metadata.player.set(player.get_name(pid), "player-stats-minor", data)
    end
end

function module.oxygen(pid, tps)
    local x, y, z = player.get_pos(pid)
    x, y, z = math.floor(x), math.floor(y+1), math.floor(z)

    if block.get(x, y, z) == block.index("base:water") then
        player_bars.set_suffocation(0.08)
    else
        player_bars.set_suffocation(-0.08)
    end

    if player_bars.get_oxygen() < 1 then
        player_bars.set_damage(0.2)
    end
end

function module.madness(pid, tps)
    local x, y, z = player.get_pos(pid)
    x, y, z = math.floor(x), math.floor(y), math.floor(z)

    if not PLAYERS[tostring(pid)].madness then
        PLAYERS[tostring(pid)].madness = {lunacy = 0, madness_lvl = 0}
    end
    player_bars.set_madness(PLAYERS[tostring(pid)].madness.madness_lvl)

    local fault_lvl = faults.at(x, z)

    if fault_lvl > 0.4 then
        PLAYERS[tostring(pid)].madness.lunacy = math.clamp(PLAYERS[tostring(pid)].madness.lunacy + fault_lvl, -1, 1)
    else
        PLAYERS[tostring(pid)].madness.lunacy = math.clamp(PLAYERS[tostring(pid)].madness.lunacy - fault_lvl, -1, 1)
    end

    if PLAYERS[tostring(pid)].madness.lunacy == 1 or PLAYERS[tostring(pid)].madness.lunacy == -1 then
        player_bars.set_solace(PLAYERS[tostring(pid)].madness.lunacy)
        PLAYERS[tostring(pid)].madness.lunacy = 0
    end

    PLAYERS[tostring(pid)].madness.madness_lvl = player_bars.get_madness()

    player_bars.set_damage(player_bars.get_madness() / 100)
end

function module.solace(pid, power)
    PLAYERS[tostring(pid)].madness.lunacy = math.clamp(PLAYERS[tostring(pid)].madness.lunacy - power, -1, 1)
    PLAYERS[tostring(pid)].madness.madness_lvl = player_bars.get_madness() - power
end

function module.falling(pid, tps)
    local e = entities.get(player.get_entity(pid))
    local body = e.rigidbody
    local fall_velocity = body:get_vel()[2]

    if fall_velocity <= -15 then
        PLAYERS[tostring(pid)].fall_velocity = fall_velocity
    end

    if PLAYERS[tostring(pid)] ~= 0 and body:is_grounded() then
        player_bars.set_damage(math.abs(PLAYERS[tostring(pid)].fall_velocity))
        PLAYERS[tostring(pid)].fall_velocity = 0
    end
end

function module.saturation(pid, tps)

    local velocity = {player.get_vel(pid)}
    local move_velocity = math.abs(velocity[1]) + math.abs(velocity[3])

    local saturation = PLAYERS[tostring(pid)].saturation
    if saturation > 0 then
        PLAYERS[tostring(pid)].saturation = saturation - 1

        if move_velocity > 5.45 then
            PLAYERS[tostring(pid)].saturation = PLAYERS[tostring(pid)].saturation - 1
        end
    else
        player_bars.set_hunger(5)
        PLAYERS[tostring(pid)].saturation = 3*tps*60
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
        events.emit("penrose:player_death", pid)
        local inv = player.get_inventory(pid)
        local size = inventory.size(inv)
        local x, y, z = player.get_pos(pid)
        x, y, z = math.floor(x), math.floor(y), math.floor(z)

        for slot=0, size-1 do
            local id, count = inventory.get(inv, slot)
            if id ~= 0 then
                entities.spawn("base:drop", {x+0.5, y+0.5, z+0.5}, {base__drop={
                    id=id,
                    count=count
                }})
            end
            inventory.set(inv, slot, 0, 0)
        end
        player.set_pos(pid, unpack({player.get_spawnpoint(pid)}))

        x, y, z = player.get_spawnpoint(pid)
        x, y, z = math.floor(x), math.floor(y), math.floor(z)

        player_bars.set_hp(100)
        player_bars.set_food(100)
        player_bars.set_oxygen(100)
        player_bars.set_madness(0)

        PLAYERS[tostring(pid)].shield = tps * 3

        if faults.at(x, z) > 0.4 then
            PLAYERS[tostring(pid)].shield = tps * 10
        end

        PLAYERS[tostring(pid)].madness = {lunacy = 0, madness_lvl = 0}

        pop_up.open("You died.")
    end
end

_events.world.quit.reg(module.quit, {})

return module