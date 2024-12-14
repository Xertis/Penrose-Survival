local events = require "penrose:events/events"

local module = {}
local WORLD_EVENTS = {}

local function interlayer(func, current_time, ticks)
    func()
end

local function set_event(func)
    local minutes = math.random(0, 15)
    events.world.reg(interlayer, {func, time.uptime(), 15*minutes*60*20}, true)
end

function module.load()
    for _, e in ipairs(file.list("penrose:world_events")) do
        table.insert(WORLD_EVENTS, load_script(e))
    end
end

return module