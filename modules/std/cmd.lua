local gamemode = require "player/gamemode"
local const = require "constants"

local function send(class, message)
    return string.format("[SYS.%s] %s", class:upper(), message)
end


console.add_command(
    "p.gamemode mode:str",
    "Change game mode",
    function (args)
        local x = gamemode.set_mode(args[1], hud.get_player())
        if x then
            return send("game", "The game mode has been changed to " .. args[1])
        end

        return send("game", string.format("The %s game mode was not found", args[1]))
    end
)

console.add_command(
    "p.seed",
    "Display seed",
    function ()
        return send("world", string.format("Seed: %s", world.get_seed()))
    end
)