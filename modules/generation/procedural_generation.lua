local m = require "penrose:generation/maze"
local struct = {}

function struct.load(directory)
    struct.struct = json.parse(file.read("penrose:" .. directory.."/procedural_generation.json"))
end

function struct.place(placements, x, z, w, d, seed, hmap, chunk_height) 
    local BLOCKS_PER_CHUNK = w * d * chunk_height
    local maze = m.gen_maze(16, 16, 10)
    local maze_width = #maze
    local maze_height = #maze[1]

    for _, st in pairs(struct.struct) do
        local part = st.structures[1]
        for i = 1, maze_width do
            for j = 1, maze_height do
                if maze[i][j] == 1 then
                    local max_depth = st["max-depth"] or 255

                    local sx = (i - 1) * (w / maze_width) + math.random() * (w / maze_width)
                    local sz = (j - 1) * (d / maze_height) + math.random() * (d / maze_height)
                    local sy = math.clamp(math.random() * (chunk_height * 0.5), 0, max_depth)

                    if sy < hmap:at(sx, sz) * chunk_height - 6 then 
                        table.insert(placements, {part, {sx, sy, sz}, math.random() * 4, -1})
                    end
                end
            end
        end
    end
end


return struct
