local furnaces = require "utils/furnaces"
local player_bars = require "player/bars_manager"
local player_events = require "events/player"
local not_crafting = require "supports/not_crafting"
require "std/cmd"

furnaces.load()
player_bars.load()
player_events.open()
not_crafting.load()