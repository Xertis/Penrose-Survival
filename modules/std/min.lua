load_script = function (path)
    local prefix = ''
    local extension = ''

    if not string.find(path, ':') then
        prefix, _ = parse_path(debug.getinfo(2).source)
        prefix = prefix .. ':'
    end

    if not string.find(path, '.') then
        extension = '.lua'
    end

    return __load_script(prefix .. path .. extension)
end

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

function table.easy_concat(tbl)
    local output = ""
    for i, value in pairs(tbl) do
        output = output .. tostring(value)
        if i ~= #tbl then
            output = output .. ", "
        end
    end
    return output
end

function table.equals(tbl1, tbl2)
    return table.easy_concat(tbl1) == table.easy_concat(tbl2)
end