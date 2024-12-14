local module = {}
local strength = 0

function module.init()
end

function module.tick()
    local coff = 1.2 / 10 / 60 / 20

    strength = math.clamp(strength + coff, 0, 1.2)

    return strength
end

return module