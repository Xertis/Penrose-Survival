local module = {
    path = {}
}

function module.path.parse_file_extension(path)
    return path:match("%.(%w+)$")
end

function module.path.parse_filename(path)
    path = path:match("([^/]+)$")
    return path:match("([^%.]+)")
end

function module.path.filename_repair(str)
    --Заменяет первый % строке на :
    return str:gsub("%%", ":", 1)
end

function module.replace(str, a, b)
    return str:gsub(a, b)
end

return module