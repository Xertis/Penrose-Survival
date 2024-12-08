function set_page(page)
    document.crafts.enabled = true
    document.mechanics.enabled = true
    document.commands.enabled = true
    document[page].enabled = false
    document.menu.page = page
end

function on_open()
    document.mechanics.enabled = false
    document.crafts.enabled = true
    document.commands.enabled = true

    document.menu.page = "mechanics"
end