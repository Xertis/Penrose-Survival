local module = {
    pop_up_text = ""
}

local POPUP_SIZE = 28

function module.open(text)
    module.pop_up_text = text
    local strip = POPUP_SIZE - string.len(text)

    if strip > 0 then
        local left_strip = math.floor(strip / 2)
        local right_strip = strip - left_strip
        module.pop_up_text = string.rep(" ", left_strip) .. text .. string.rep(" ", right_strip)
    end

    hud.open_permanent("penrose:pop_up")
end

return module
