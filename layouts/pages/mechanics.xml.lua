local builder = require "penrose:utils/layout_builder"
local stru = require "penrose:utils/string"

local function parse_mechanics(data)
    local result = {}
    local pattern = "(.-)(<img%s+(.-)%s*>)(.*)"

    while true do
        local text, tag, src, rest = data:match(pattern)
        if not text then
            table.insert(result, data)
            break
        end

        if text ~= "" then
            table.insert(result, text)
        end

        table.insert(result, { "IMG", src = src })

        data = rest
    end

    return result
end

local function generate()
    local page = document.mechanics

    for i, path in ipairs(file.list("penrose:data/guide/mechanics")) do
        local data = file.read(path)
        local mechanic = parse_mechanics(data)

        local l_tbl = {
            value = '[' .. stru.path.parse_filename(path):upper() .. ']'
        }

        builder.create_label(page, path, l_tbl)

        for j, elem in ipairs(mechanic) do
            if type(elem) == "table" and elem[1] == "IMG" then
                local tbl = {
                    value = elem.src,
                    size = "100,100"
                }

                builder.create_image(page, j, tbl)
            else
                local tbl = {
                    value = elem,
                }

                builder.create_label(page, j, tbl)
            end
        end
        builder.create_label(page, "sept_" .. i, {value = ''})
    end
end

function on_open()
    generate()
end