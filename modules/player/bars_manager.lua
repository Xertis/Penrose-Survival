local function resource(name) return  "penrose:" .. name end

local metadata = require "penrose:files/metadata"
local _events = require "penrose:events/events"

local doc = Document.new("penrose:bars")
local madness = Document.new("penrose:madness")

local SIZE = 257
local module = {}
local PLAYERS = {}

function module.load(pid)
    local player_data = metadata.player.get(tostring(pid))

    hud.open_permanent("penrose:bars")
    hud.open_permanent("penrose:madness")

    PLAYERS[tostring(pid)] = 1

    if player_data and player_data["player-stats-major"] then
        player_data = player_data["player-stats-major"]
    else
        player_data = {hp = 100, food = 100}
    end

    module.set_hp(player_data.hp)
    module.set_food(player_data.food)
end

function module.quit()
    for pid, _player_data in pairs(PLAYERS) do
        local player_data = {
            hp = module.get_hp(),
            food = module.get_food()
        }
        metadata.player.set(pid, "player-stats-major", player_data)
    end
end


function module.set_damage(damage)
    module.set_hp(module.get_hp() - damage)
end

function module.set_hunger(hunger)
    module.set_food(module.get_food() - hunger)
end

function module.set_hp(hp)
    doc.hp.size = {SIZE * (math.clamp(hp,0,100) / 100), doc.hp.size[2]}
end

function module.set_solace(solace)
    module.set_madness(module.get_madness() + solace)
end

function module.set_madness(_madness)
    local color = madness.root.color
    color[4] = 255 * (math.clamp(_madness,0,100) / 100)
    madness.root.color = color
end

function module.get_madness()
    local color = madness.root.color
    return (color[4] / 255) * 100
end

function module.set_food(food)
    doc.food.size = {SIZE * (math.clamp(food,0,100) / 100), doc.food.size[2]}
end

function module.get_hp()
    return (doc.hp.size[1] / SIZE) * 100
end

function module.get_food()
    return (doc.food.size[1] / SIZE) * 100
end

events.on(resource("player_join"), module.load)
_events.world.quit.reg(module.quit, {})

return module