
local module = {
    world = {
        quit = {},
        open = {}
    },

    player = {
    }
}

local WORLD_EVENTS = {
    quit = {}
}

local PLAYER_EVENTS = {

}

function module.quit()
    module.world.world_quit()
end

function module.world.tick()
    for i, event in ipairs(WORLD_EVENTS) do
        if event[5] == 0 then
            local args = event[2]
            local x = event[1](unpack(args))
            if x == event[3] then
                table.remove(WORLD_EVENTS, i)
            end
            event[5] = event[4]
        else
            event[5] = event[5] - 1
        end
    end
end

function module.player.tick(pid, tps)
    for i, event in ipairs(PLAYER_EVENTS) do
        if event[5] == 0 then
            local args = event[2]
            local x = event[1](pid, tps, unpack(args))
            if x == event[3] then
                table.remove(PLAYER_EVENTS, i)
            end
            event[5] = event[4]
        else
            event[5] = event[5] - 1
        end
    end
end

function module.world.reg(event, args, die_value, sleep)
    sleep = sleep or 0
    table.insert(WORLD_EVENTS, {event, args, die_value, sleep, 0})
end

function module.player.reg(event, args, die_value, sleep)
    sleep = sleep or 0
    table.insert(PLAYER_EVENTS, {event, args, die_value, sleep, 0})
end

function module.world.world_quit()
    for i, event in ipairs(WORLD_EVENTS.quit) do
        event[1](unpack(event[2]))
    end
end

function module.world.quit.reg(event, args)
    table.insert(WORLD_EVENTS.quit, {event, args})
end

return module