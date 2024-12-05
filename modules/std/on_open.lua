local furnaces = require "utils/furnaces"
local player_bars = require "player/bars_manager"
local player_events = require "events/player"
local not_crafting = require "supports/not_crafting"
require "std/cmd"

furnaces.load()
player_bars.load()
player_events.open()
not_crafting.load()

local paths = file.list("penrose:generators/world.files/fragments")

--for _, path in ipairs(paths) do
    --local data = bjson.frombytes(file.read_bytes(path))
    --local names = data['block-names']

    --for i, str in ipairs(names) do
    --    data["block-names"][i] = str:gsub("penrose", "penrose")
    --end
    --file.write_bytes(path, bjson.tobytes(data))
--end