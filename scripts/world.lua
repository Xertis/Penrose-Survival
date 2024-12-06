--require("penrose:player/blocked")
local dropu = require "penrose:utils/drop"
local invu = require "penrose:utils/inventory"
local block_destroy = require "player/block_destroy"
local events_ = require "penrose:events/events"
local constants = require "penrose:constants"
local metadata = require "penrose:files/metadata"
require "penrose:utils/craft"
require "penrose:std/math"
require "penrose:std/table"

function on_world_open()
    metadata.open()
    constants.init()
    local rules_tbl = json.parse(file.read(PACK_ID .. ":data/rules.json"))
    for id, v in pairs(rules_tbl) do
        rules.set(id, v)
    end
    require "penrose:std/on_open"
end

function on_world_quit()
    events_.quit()
    metadata.close()
end

function on_block_broken(id, x, y, z, pid)
    x, y, z = math.floor(x), math.floor(y), math.floor(z)
    local drop = dropu.get_drops_ids(block.name(id), pid)
    for _, v in ipairs(drop) do
        local count = v[2]
        entities.spawn("base:drop", {x+0.5, y+0.5, z+0.5}, {base__drop={
            id=item.index(v[1]),
            count=count
        }})
    end
end

function on_world_tick(tps)
    events_.world.tick()
end

function on_player_tick(pid, tps)
    events_.player.tick(pid)
    events.emit(PACK_ID..":player_tick", pid, tps)
end