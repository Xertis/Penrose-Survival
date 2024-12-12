local dist = require "penrose:utils/distance_utils".euclidean
local player_events = require "events/player"
local metadata = require "penrose:files/metadata"
local events = require "penrose:events/events"

local module = {}

local solace_blocks = {}
local REG_BLOCKS = {}

local function parse()
    local path = file.read("penrose:data/solace.json")
    solace_blocks = json.parse(path)
end

parse()

function module.quit()
    metadata.world.set("solace-blocks", REG_BLOCKS)
end

function module.load()
    REG_BLOCKS = metadata.world.get("solace-blocks") or {}
end

function module.reg(x, y, z)
    if module.get(x, y, z) ~= nil then
        return
    end
    table.insert(REG_BLOCKS, {x, y, z, solace_blocks[block.name(block.get(x, y, z))]})
end

function module.unreg(x, y, z)
    for i, b in ipairs(REG_BLOCKS) do
        if b[1] == x and b[2] == y and b[3] == z then
            table.remove(REG_BLOCKS, i)
            return
        end
    end
end

function module.get(x, y, z)
    for i, b in ipairs(REG_BLOCKS) do
        if b[1] == x and b[2] == y and b[3] == z then
            return b[4], b[5], b[6], i
        end
    end
end

function module.tick(pid)
    for _, b in ipairs(REG_BLOCKS) do
        local bx, by, bz = b[1], b[2], b[3]
        local power = b[4] or 1

        if block.get(bx, by, bz) ~= -1 then
            local px, py, pz = player.get_pos()
            local distance = dist(bx, by, bz, px, py, pz)
            --print(distance, power)
            if distance <= power then
                player_events.solace(pid, power - distance)
            end
        end
    end
end

events.player.reg(module.tick, {}, true)
events.world.quit.reg(module.quit, {})

return module