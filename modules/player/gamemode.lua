local stru = require "utils/string"
local module = {}

local players = {}
local gamemodes = {}

for _, mode in ipairs(file.list("penrose:data/gamemodes")) do
    local name = stru.path.parse_filename(mode)
    gamemodes[name] = json.parse(file.read(mode))
end

function module.set_mode(mode, pid)
    local _rules = gamemodes[mode]

    if _rules then
        players[pid] = mode
        for id, v in pairs(_rules) do
            rules.set(id, v)
        end
        return true
    end

    return false
end

function module.get_mode(pid)
    return players[pid]
end

return module