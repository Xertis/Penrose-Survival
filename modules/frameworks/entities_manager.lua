local table_u = require 'noname:utils/table_utils'
local patterns = require 'noname:frameworks/entities_manager_patterns'

local framework = {}
registered_entities = {}

local options_example = {
    hp = 5,
    damage = 0,
    velocity = 10,
    fraction = "birds",
    pattern = "bird",
    behaviour = "peaceful"
}

--behaviour: peaceful, neutral, agressive
--patterns: bird, walker


function framework.reg(uid, options)
    table.insert(registered_entities, {uid, options})
    return patterns.get(options)
end

function framework.unreg(uid)
    for i=1, #registered_entities do
        if registered_entities[i][1] == uid then
            table.remove(registered_entities, i)
            break
        end
    end
end

function framework.get_options(uid)
    for i=1, #registered_entities do
        if registered_entities[i][1] == uid then
            return registered_entities[i][2]
        end
    end
end

return framework