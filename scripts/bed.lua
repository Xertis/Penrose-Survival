local pop_up = require "noname:frontend/pop_up"

function on_interact(x, y, z, pid)
    local time = world.get_day_time()
    if time < 0.25 or time > 0.7 then
        world.set_day_time(0.25)
    else
        pop_up.open("You can't sleep")
    end
    return true
end