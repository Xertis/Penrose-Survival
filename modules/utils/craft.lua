local matrixu = require "noname:utils/matrix"
local stru = require "noname:utils/string"
local module = {}

local CRAFTS = {}
local MATERIALS = {}
local crafts = file.list("noname:data/crafts")
local materials = file.list("noname:data/crafts/materials")

for i, path in ipairs(crafts) do
    if stru.path.parse_file_extension(path)  then
        local craft = {}
        craft[1] = stru.path.parse_filename(path)
        craft[1] = stru.path.filename_repair(craft[1])
        craft[2] = json.parse(file.read(path))
        table.insert(CRAFTS, craft)
    end
end

for i, path in ipairs(materials) do
    local data = file.read(path)
    MATERIALS['!' .. stru.path.parse_filename(path)] = string.split(data, ' ')
end

function module.equals(craft1, craft2)
    if #craft1 ~= #craft2 or #craft1[1] ~= #craft2[1] then
        return false
    end

    for i=1, #craft1 do
        for j=1, #craft1[1] do

            local e1 = craft1[i][j]
            local e2 = craft2[i][j]

            local c1 = 0
            local c2 = 0

            if type(e1) == "table" then c1 = e1[2] e1 = e1[1] end
            if type(e2) == "table" then c2 = e2[2] e2 = e2[1] end

            local material = MATERIALS[e1] or {}
            if (e1 ~= e2 and not table.has(material, e2)) or c2 < c1 then
                return false
            end
        end
    end
    return true
end

function module.sub(craft1, craft2)
    for i=1, #craft1 do
        for j=1, #craft1[1] do
            if type(craft1[i][j]) == "table" then
                craft1[i][j][2] = craft1[i][j][2] - craft2[i][j][2]
            end
        end
    end
    return craft1
end

function module.find_craft(slots)
    local bounds = nil
    print(json.tostring({slots = slots}))
    slots, bounds = matrixu.crop2D(slots)

    for _, craft in ipairs(CRAFTS) do
        if module.equals(craft[2]["craft"], slots) then
            return craft, bounds
        end
    end
end

return module