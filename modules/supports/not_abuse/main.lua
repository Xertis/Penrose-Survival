local gamemode = require "supports/not_abuse/gamemode"
local drop = require "supports/not_abuse/drop"

local const = require "constants"

local module = {}


function module.not_off()
    const.session.penrose_mode = "not_abuse"
    for i, pid in ipairs(const.session.players_online) do
        gamemode.init(pid)
    end

    drop.init()
end
events.on("penrose:first_tick", module.not_off)


return module