local pop_up = require "noname:frontend/pop_up"
local dist = require "noname:utils/distance_utils".euclidean

function on_interact(x, y, z, pid)
    local pX, pY, pZ = player.get_pos(pid)
    if dist(x, y, z, pX, pY, pZ) <= 2 then
        local time = world.get_day_time()
        player.set_spawnpoint(pid, pX, pY, pZ)
        print(pX, pY, pZ)
        if time < 0.25 or time > 0.7 then
            world.set_day_time(0.25)
        else
            pop_up.open("You can't sleep at the day")
        end
    end
    return true
end