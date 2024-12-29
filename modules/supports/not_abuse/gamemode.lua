local ns = require "not_survival:api"

local module = {}

local function redefinition(mode)
    if mode == nil then return end
    mode = {ns.gamemode.get_gamemode(mode)}

    if mode[2].name ~= "penrose" then
        gamemode.set_player_mode(hud.get_player(), "penrose")
    end
end

local function reg_gamemode()
    ns.gamemode.register(
        "penrose",
        function (pid)
            redefinition()
        end
      )
end

reg_gamemode()

function module.init(pid)
    ns.gamemode.set_player_mode(pid, "penrose")
end

events.on("not_survival:change_gamemode", redefinition)

return module