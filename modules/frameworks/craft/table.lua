local c = require "penrose:constants"
local module = {}

function module.equals(craft1, craft2, MATERIALS)
    if #craft1 ~= #craft2 or #craft1[1] ~= #craft2[1] then
        return false
    end

    MATERIALS = MATERIALS or c.session.materials_available

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

return module