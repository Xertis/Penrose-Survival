local table_u = require 'noname:utils/table_utils'
local patterns = require 'noname:frameworks/entities_manager_patterns'

local framework = {}
REGISTERED_ENTITIES = {}

local options_example = {
    hp = 5,
    damage = 0,
    velocity = 10,
    fraction = "birds",
    behaviour = "peaceful",
    pathOptions = {}
}

--behaviour: peaceful, neutral, agressive
--patterns: bird, walker


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