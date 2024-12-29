local ns_drop = require "not_survival:drop/loot_tables"
local const = require "constants"

local module = {}

local s = json.parse('{"pools": [{"items": ["not_survival:sapling"],"chance":0.1,"rolls":1}]}')
function module.init()
    local drops = const.session.drops_available

    for bname, drop in pairs(drops) do
        print(bname)
        ns_drop.blocks.set_drop(bname, s.pools)
    end
end

return module