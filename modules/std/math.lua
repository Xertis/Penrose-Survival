
function math.chance(chance)
    if type(chance) ~= "table" then
        return math.random() <= chance
    end
    local rand = math.random()

    local sumchance = 0
    local result = {}

    for i, c in ipairs(chance) do
        if c ~= 1 then
            sumchance = sumchance + c
            if rand <= sumchance then
                table.insert(result, i)
            end
        else
            table.insert(result, i)
        end
    end

    return result
end