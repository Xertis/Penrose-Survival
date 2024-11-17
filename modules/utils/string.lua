local module = {
    path = {}
}

function module.path.parse_file_extension(path)
    return str:match("%.(%w+)$")
end

function module.path.parse_file_name(path)
    str = str:match("([^/]+)$")
    return str:match("([^%.]+)")
end

function module.path.filename_repair(str)
    --Заменяет первый % строке на :
    return str:gsub("^(%%)", ":")
end

function module.replace(str, a, b)
    return str:gsub(a, b)
end

return module