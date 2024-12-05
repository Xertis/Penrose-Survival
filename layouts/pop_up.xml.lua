local pop_up = require "penrose:frontend/pop_up"
local w_tick = require "penrose:events/events"

function close_label(t, seconds)
    if time.uptime() > t+seconds then
        hud.close("penrose:pop_up")
        return "Done"
    end
end

function on_open()
    document.label.text = pop_up.pop_up_text
    local text = document.label.text

    if #text <= 0 then
        return
    end

    w_tick.world.reg(close_label, {time.uptime(), 3}, "Done")
end