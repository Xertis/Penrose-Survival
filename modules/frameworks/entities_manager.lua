local table_u = require 'penrose:utils/table_utils'
local patterns = require 'penrose:frameworks/entities_manager_patterns'

local framework = {}
local defaults_options = {}
REGISTERED_ENTITIES = {}

local options_example = {
    hp = 5,
    damage = 0,
    velocity = 10,
    fraction = "Duraki",
    behaviour = "agressive",
    allies = {"NeDuraci", "Otlichniki"},
    pathOptions = {},
    wanderRadius = 3,
    panicRadius = 6
}

defaults_options.players = {
    hp = 100,
    damage = 1,
    fraction = "Players",
    behaviour = "peaceful"
}

defaults_options.monsters = {
    hp = 100,
    damage = 1,
    fraction = "Monsters",
    behaviour = "agressive"
}

defaults_options.ambient = {
    hp = 100,
    damage = 1,
    fraction = "Ambient",
    behaviour = "peaceful"
}

--behaviour: peaceful, agressive, friendlyfire

function framework.get_default_options()
    return table.copy(defaults_options)
end

function framework.reg(uid, options)
    table.insert(REGISTERED_ENTITIES, {uid, options})
    return patterns.get(options)
end

function framework.unreg(uid)
    for i=1, #REGISTERED_ENTITIES do
        if REGISTERED_ENTITIES[i][1] == uid then
            table.remove(REGISTERED_ENTITIES, i)
            break
        end
    end
end

function framework.get_options(uid)
    for i=1, #REGISTERED_ENTITIES do
        if REGISTERED_ENTITIES[i][1] == uid then
            return REGISTERED_ENTITIES[i][2]
        end
    end
end

return framework