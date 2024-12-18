local m = require "penrose:generation/maze"
local struct = {}

function struct.load(directory)
    struct.struct = json.parse(file.read("penrose:" .. directory.."/procedural_generation.json"))
end

local function in_range(num, min, max)
    if num < min then
        num = max
    elseif num > max then
        num = min
    end

    return num
end

function struct.place(placements, x, z, w, d, seed, hmap, chunk_height)
    local BLOCKS_PER_CHUNK = w * d * chunk_height
    local maze = m.gen_maze(16, 16, 10)
    local maze_width = #maze
    local maze_height = #maze[1]

    local chunk_size_x = w / maze_width
    local chunk_size_z = d / maze_height

    for _, st in pairs(struct.struct) do
        local part = st.structures[1]
        local max_depth = st["max-depth"] or 255

        for i = 1, maze_width do
            for j = 1, maze_height do
                if maze[i][j] == 1 then

                    local chunk_x = x + (i - 1) * chunk_size_x
                    local chunk_z = z + (j - 1) * chunk_size_z

                    local sx = chunk_x + math.random() * chunk_size_x
                    local sz = chunk_z + math.random() * chunk_size_z
                    local sy = math.clamp(math.random() * (chunk_height * 0.5), 0, 255)

                    if sy < hmap:at({sx, sz}) * chunk_height - 6 then
                        sy = 180
                        sx, sz = x, z
                        print(x, z, sx, sy, sz)
                        table.insert(placements, {part, {sx, sy, sz}, math.random() * 4, 1})
                    end
                end
            end
        end
    end
end



return struct
