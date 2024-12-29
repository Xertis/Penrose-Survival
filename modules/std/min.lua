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

entities.utils = {}

time.utils = {}

function time.utils.normalize(cof)
    local wtime = world.get_total_time()
    local time = wtime / cof

    return time % 1
end

function entities.utils.move_in_dir(dir, vel)

    local n = vec3.normalize(dir)
    local m = vec3.length(vel)

    return vec3.mul(n, m)
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

function math.normalize(num, conf)
    conf = conf or 10

    local normalized_num = num / conf

    return normalized_num % 1
end

function math.randomize(pos, seed, min, max)
    local x, y, z = unpack(pos)
    math.randomseed(math.floor((x * 1000 + y * 100 + z * 10) * seed))

    return math.random(min, max)
end

function math.gen_seed()
    local time = time.uptime()
    local random_part = math.random(10000, 99999)
    return time + random_part
end

function math.round(num, places)
    local mult = 10 ^ (places or 0)
    return math.floor(num * mult + 0.5) / mult
end

function math.in_range(num, min, max)
    if num < min then
        num = max
    elseif num > max then
        num = min
    end

    return num
end

if not table.deep_copy then
    table.deep_copy = function (t)
        local copied = {}

        for k, v in pairs(t) do
            if type(v) == "table" then
                copied[k] = table.deep_copy(v)
            else
                copied[k] = v
            end
        end

        return copied
    end
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

function table.shuffle(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end

    return t
end

function table.keys(t)
    local keys = {}

    for key, _ in pairs(t) do
        table.insert(keys, key)
    end

    return keys
end

function table.gen_matrix(rows, cols, e)
    e = e or 0
    local matrix = {}

    for i = 1, rows do
        matrix[i] = {}
        for j = 1, cols do
            matrix[i][j] = e
        end
    end

    return matrix
end

function table.equals(tbl1, tbl2)
    return table.easy_concat(tbl1) == table.easy_concat(tbl2)
end