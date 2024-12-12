local faults = require "generation/faults"

function on_random_update(x, y, z)
    local oppositional_ore = block.index("penrose:oppositional_iron_ore")
    local fault_lvl = faults.at(x, z)

    if fault_lvl > 0.4 then
        block.set(x, y, z, oppositional_ore)
    elseif fault_lvl > 0.35 and math.random(0, 3) == 2 then
        block.set(x, y, z, oppositional_ore)
    end
end