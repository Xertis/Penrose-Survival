local matrixu = require "noname:utils/matrix"
local stru = require "noname:utils/string"
local module = {}

local CRAFTS = {}
local crafts = file.list("noname:data/crafts")

for i, path in ipairs(crafts) do
    local craft = {}
    craft[1] = stru.path.parse_filename(path)
    craft[1] = stru.path.filename_repair(craft[1])
    craft[2] = json.parse(file.read(path))
    table.insert(CRAFTS, craft)
end

function module.find_craft(slots)
    slots = matrixu.crop2D(slots)
    print(json.tostring({slots = slots}))
    for _, craft in ipairs(CRAFTS) do
        if matrixu.equals(craft[2]["craft"], slots) then
            return craft
        end
    end
end

return module