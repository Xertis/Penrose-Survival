local module = {
    pop_up_text = ""
}

function module.open(text)
    module.pop_up_text = text
    hud.open_permanent("noname:pop_up")
end

return module