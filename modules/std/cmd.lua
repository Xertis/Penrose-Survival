local stru = require "utils/string"
local gamemodes = {}

for _, mode in ipairs(file.list("noname:data/gamemodes")) do
    local name = stru.path.parse_filename(mode)
    gamemodes[name] = json.parse(file.read(mode))
end

console.add_command(
    "gamemode mode:str",
    "Change game mode",
    function (args)
        local mode = gamemodes[args[1]]
        if mode then
            for id, v in pairs(mode) do
                rules.set(id, v)
            end
        end
    end
)