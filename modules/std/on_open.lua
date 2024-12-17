local furnaces = require "utils/furnaces"
local solace_blocks = require "utils/solace_blocks"
local not_crafting = require "supports/not_crafting"
local faults = require "generation/faults"
require "std/cmd"

furnaces.load()
not_crafting.load()
faults.load()
solace_blocks.load()