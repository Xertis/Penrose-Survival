
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

function math.gen_seed()
    local time = time.uptime()
    local random_part = math.random(10000, 99999)
    return time + random_part
end

function math.in_range(num, min, max)
    if num < min then
        num = max
    elseif num > max then
        num = min
    end

    return num
end