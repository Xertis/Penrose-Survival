local faults = require "generation/faults"

function on_random_update(x, y, z)
    local iron_ore = block.index("penrose:iron_ore")
    local fault_lvl = faults.at(x, z)

    if fault_lvl <= 0.35 then
        block.set(x, y, z, iron_ore, 0, true)
    end
end