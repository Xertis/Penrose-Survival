local faults = require "generation/faults"
local pop_up = require "penrose:frontend/pop_up"

function on_use(pid)
    local t = 'L'
    local x, y, z = player.get_pos(pid)
    x, y, z = math.floor(x), math.floor(y), math.floor(z)

    local fault_lvl = faults.at(x, z)

    if fault_lvl > 0.3 then
        t = 'M'
    end

    if fault_lvl > 0.35 then
        t = 'H'
    end
    pop_up.open(string.format("FAULT LVL: %.5f (%s)", fault_lvl, t))
end