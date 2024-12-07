local trees = {}
local trees_placed = {}

function trees.load(directory)
    trees.trees = file.read_combined_list(directory.."/trees.json")
end

function trees.place(placements, x, z, w, d, seed, hmap, chunk_height)
    local BLOCKS_PER_CHUNK = w * d * chunk_height
    for _, tree in ipairs(trees.trees) do
        local count = BLOCKS_PER_CHUNK / tree.rarity

        -- average count is less than 1
        local addchance = math.fmod(count, 1.0)

        if math.random() < addchance then
            count = count + 1
        end

        for i=1,count do

            local sx = math.random() * w
            local sz = math.random() * d
            local sy = 254
            while block.get(sx, sy, sz) == 0 or block.get(sx, sy, sz) == -1 do
                sy = sy - 1
                if sy <= 0 then
                    break
                end
            end

            sy = 50

            if sy < hmap:at(sx, sz) * chunk_height - 6 then
                table.insert(trees_placed, {tree.struct, {sx, sy, sz}})
                table.insert(placements, {tree.struct, {sx, sy, sz}, math.random()*4, -1})
            end
        end
    end
end

return trees
