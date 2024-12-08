local module = {}

local tbl_example = {
    name = "name",
    value = 1,
    tooltip = '',
    size = "200,200"
}

function module.create_checkbox(page, id, tbl)

    local tooltip, name, value = tbl.tooltip, tbl.name, tbl.value
    tooltip = tooltip or ''

    page:add(string.format(
        "<checkbox id='%s' consumer='function(x) set_value(\"%s\", x) end' checked='%s' tooltip='%s'>%s</checkbox>",
        id, id, value, tooltip, name
    ))
end

function module.create_textbox(page, id, tbl)

    local tooltip, name, text = tbl.tooltip, tbl.name, tbl.value
    tooltip = tooltip or ''

    page:add(string.format(
        "<textbox id='%s' consumer='function(x) set_value(\"%s\", x) end' placeholder='%s' tooltip='%s'>%s</textbox>",
        id, id, name, tooltip, text
    ))
end

function module.create_trackbar(page, id, tbl)
    local tooltip, name, value = tbl.tooltip, tbl.name, tbl.value
    tooltip = tooltip or ''

    page:add(string.format(
        "<label id='%s' tooltip='%s'>%s</label>",
        id .. "_label", tooltip, name .. ' (' .. value .. ')'
    ))
    page:add(string.format(
        "<trackbar id='%s' consumer='function(x) set_value(\"%s\", x) end' value='%s' tooltip='%s' min='100' max='1000' step='10'>%s</trackbar>",
        id, id, value, tooltip, name
    ))
end

function module.create_label(page, id, tbl)
    local value = tbl.value
    for part in string.gmatch(value, "([^\n]+)") do
        page:add(string.format(
            "<label multiline='true'>%s</label>",
            part
        ))
    end
end

function module.create_image(page, id, tbl)
    local value, size = tbl.value, tbl.size
    page:add(string.format(
        "<image id='%s' src='%s' size='%s'/>",
        id, value, size
    ))
end

return module