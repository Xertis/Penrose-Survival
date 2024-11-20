--require("noname:player/blocked")
local dropu = require "noname:utils/drop"
local invu = require "noname:utils/inventory"
local events = require "noname:events/events"
local constants = require "noname:constants"
local metadata = require "noname:files/metadata"
local furnaces = require "noname:utils/furnaces"
require "noname:utils/craft"
require "noname:std/math"
require "noname:std/table"

function on_world_open()
    metadata.world.load()
    constants.init()
    local rules_tbl = json.parse(file.read(PACK_ID .. ":data/rules.json"))
    for id, v in pairs(rules_tbl) do
        rules.set(id, v)
    end
    furnaces.load()
end

function on_world_quit()
    events.quit()
    metadata.world.save()
end

function on_block_broken(id, x, y, z)
    x, y, z = math.floor(x), math.floor(y), math.floor(z)
    local drop = dropu.get_drops_ids(block.name(id))
    for _, v in ipairs(drop) do
        local count = v[2]
        entities.spawn("base:drop", {x+0.5, y+0.5, z+0.5}, {base__drop={
            id=item.index(v[1]),
            count=count
        }})
    end
end

function on_world_tick(tps)
    events.tick(tps)
end

function on_block_placed(id, x, y, z, pid)
    x, y, z = math.floor(x), math.floor(y), math.floor(z)
    invu.del_item(id .. ".item", pid)
end