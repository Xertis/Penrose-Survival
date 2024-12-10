local module = {}
local faultmap = nil

function module.gen_fault(x, y, w, h)
    local SEED = world.get_seed() - 2222
    local s = x*w

    local umap = Heightmap(w, h)
    local vmap = Heightmap(w, h)
    umap.noiseSeed = SEED
    vmap.noiseSeed = SEED
    vmap:noise({x+521, y+70}, 0.1, 3, 25.8)
    vmap:noise({x+95, y+246}, 0.15, 3, 25.8)

    local map = Heightmap(w, h)
    map.noiseSeed = SEED
    map:noise({x, y}, 0.8, 4, 0.02)
    map:cellnoise({x, y}, 0.1, 3, 0.3, umap, vmap)
    map:add(0.7)

    return map
end

function module.at(x, z)
    faultmap = module.gen_fault(x, z, 16, 16)
    return faultmap:at({x, z})
end

return module