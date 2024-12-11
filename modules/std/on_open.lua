local furnaces = require "utils/furnaces"
local solace_blocks = require "utils/solace_blocks"
local player_bars = require "player/bars_manager"
local player_events = require "events/player"
local not_crafting = require "supports/not_crafting"
local faults = require "generation/faults"
require "std/cmd"

furnaces.load()
player_bars.load()
player_events.open()
not_crafting.load()
faults.load()
solace_blocks.load()

--local paths = file.list("penrose:s")

--for _, path in ipairs(paths) do
    --local data = bjson.frombytes(file.read_bytes(path))
    --local names = data['block-names']

    --for i, str in ipairs(names) do
        --data["block-names"][i] = str:gsub("penrose", "penrose")
    --end

    --for i, b in ipairs(data['voxels']) do
        --if i % 2 == 0 then
            --if b == 2 or b == 0 then
                --data['voxels'][i] = 1
                --print("conv")
            --elseif b == 3 or b == 1 then
                --data['voxels'][i] = 2
                --print("conv")
            --end
        --end
    --end
    --file.write_bytes(path, bjson.tobytes(data))
--end