local stru = require "utils/string"
local events = require "events/events"
local metadata = require "files/metadata"
local const = require "constants"
local module = {}

local GAMEMODES_PATH = "penrose:data/gamemodes"

local players = {}
local gamemodes = {}

for _, mode in ipairs(file.list(GAMEMODES_PATH)) do
    local name = stru.path.parse_filename(mode)
    gamemodes[name] = json.parse(file.read(mode))
end

local function on_close()
    for pid, mode in pairs(players) do
        metadata.player.set(player.get_name(pid), "gamemode", mode)
    end
end

function module.init(pid)
    local mode = metadata.player.get(player.get_name(pid))
    if mode then mode = mode["gamemode"] end

    if not mode then
        mode = "survival"
    end

    module.set_mode(mode, pid)
end

function module.set_mode(mode, pid)
    local _rules = gamemodes[mode]

    if _rules then
        players[pid] = mode
        for id, v in pairs(_rules) do

            if id:sub(1, 1) == "@" then
                const.const.gamemode_tags[id](pid, v)
            else
                rules.set(id, v)
            end
        end
        return true
    end

    return false
end

function module.get_mode(pid)
    return players[pid]
end

events.world.quit.reg(on_close, {})

return module