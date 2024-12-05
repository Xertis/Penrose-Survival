local metadata = require "penrose:files/metadata"
local events = require "penrose:events/events"
local doc = Document.new("penrose:bars")
local SIZE = 257
local module = {}

function module.load()
    local player_data = metadata.world.get("player-data") or {hp = 100, food = 100}

    module.set_hp(player_data.hp)
    module.set_food(player_data.food)
end

function module.quit()
    local player_data = {
        hp = module.get_hp(),
        food = module.get_food()
    }

    metadata.world.set("player-data", player_data)
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

function module.set_food(food)
    doc.food.size = {SIZE * (math.clamp(food,0,100) / 100), doc.food.size[2]}
end

function module.get_hp()
    return (doc.hp.size[1] / SIZE) * 100
end

function module.get_food()
    return (doc.food.size[1] / SIZE) * 100
end

events.world.quit.reg(module.quit, {})

return module