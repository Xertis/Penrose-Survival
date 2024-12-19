require "penrose:utils/craft"
require "penrose:std/min"
require "player/block_destroy"

local dropu = require "penrose:utils/drop"
local events_ = require "penrose:events/events"
local constants = require "penrose:constants"
local metadata = require "penrose:files/metadata"
local player_events = require "events/player"

function on_world_open()
    metadata.open()
    constants.init()

    require "penrose:std/on_open"

    events_.player.reg(player_events.base, {}, true)
end

function on_world_quit()
    events_.quit()
    metadata.close()
end

function on_block_broken(id, x, y, z, pid)
    if id ~= 0 then
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
end

function on_world_tick(tps)
    events_.world.tick()
end

function on_player_tick(pid, tps)
    events_.player.tick(pid, tps)
end