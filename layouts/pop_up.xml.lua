local pop_up = require "noname:frontend/pop_up"
local w_tick = require "noname:events/events"

function close_label(t, seconds)
    if time.uptime() > t+seconds then
        local x = Document.new("noname:pop_up")
        x.root.pos = {0,1000}
        return "Done"
    end
end

function on_open()
    document.label.text = pop_up.pop_up_text
    local text = document.label.text

    if #text <= 0 then
        document.root.pos = {0,1000}
        return
    end

    document.root.pos = {540, 600}
    w_tick.world.reg(close_label, {time.uptime(), 3}, "Done")
end