local gamemode = require "player/gamemode"

console.add_command(
    "gamemode mode:str",
    "Change game mode",
    function (args)
        local x = gamemode.set_mode(args[1], hud.get_player())
        if x then
            return "[SYS.GAME] The game mode has been changed to " .. args[1]
        end
        return string.format("[SYS.GAME] The %s game mode was not found", args[1])
    end
)