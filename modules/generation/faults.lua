local events = require "penrose:events/events"
local metadata = require "penrose:files/metadata"

local module = {}
local faultmap = nil
local strength = 0.1
local max_strength = 1.0
local seed_conf = 2222

function module.gen_fault(x, y, w, h, new_seed_conf)
    new_seed_conf = new_seed_conf or 0

    seed_conf = math.in_range(seed_conf, 1111, 30000)
    local SEED = world.get_seed() - seed_conf - new_seed_conf

    SEED = math.in_range(SEED, 11111111111111, 99999999999999)

    local umap = Heightmap(w, h)
    local vmap = Heightmap(w, h)
    umap.noiseSeed = SEED
    vmap.noiseSeed = SEED
    vmap:noise({x + 521, y + 70}, 0.1, 3, 25.8)
    vmap:noise({x + 95, y + 246}, 0.15, 3, 25.8)

    local map = Heightmap(w, h)
    map.noiseSeed = SEED
    map:noise({x, y}, 0.8, 4, 0.02)
    map:cellnoise({x, y}, 0.1, 3, 0.3, umap, vmap)
    map:add(0.7)

    return map
end

function module.load()
    local data = metadata.world.get("fault-seed-data") or {}
    seed_conf = data[1] or 2222
    strength = data[2] or 0.1
end

function module.alteration()
    if not faultmap then
        faultmap = module.gen_fault(1, 1, 16, 16)
    else
        local new_map = module.gen_fault(1, 1, 16, 16, 1111)

        faultmap:mixin(new_map, strength)

        strength = strength + (0.0025)
        if strength >= max_strength then
            faultmap = new_map
            seed_conf = seed_conf + 1111
            strength = 0.01
        end
    end
end

function module.at(x, z)
    faultmap = module.gen_fault(x, z, 16, 16)
    local new_map = module.gen_fault(x, z, 16, 16, 1111)

    faultmap:mixin(new_map, strength)

    return faultmap:at({x, z})
end

events.world.reg(module.alteration, {}, true, 20*60*6)
events.world.quit.reg(
    function ()
        metadata.world.set("fault-seed-data", {seed_conf, strength})
    end
, {})

return module
