
local module = {
    world = {
        quit = {},
        open = {}
    }
}

local WORLD_EVENTS = {
    quit = {},
    open = {}
}

function module.tick()
    module.world.tick()
end

function module.quit()
    module.world.world_quit()
end

function module.world.tick()
    for i, event in ipairs(WORLD_EVENTS) do
        local args = event[2]
        local x = event[1](unpack(args))
        if x == event[3] then
            table.remove(WORLD_EVENTS, i)
        end
    end
end

function module.world.reg(event, args, die_value)
    table.insert(WORLD_EVENTS, {event, args, die_value})
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