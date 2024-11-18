function on_hud_open(pid)
    --hud.open_permanent("noname:hp")
    --hud.open_permanent("noname:water")
    --hud.open_permanent("noname:food")
    --hud.open_permanent("noname:mind")
    --hud.open_permanent("noname:armor")
    --hud.open_permanent("noname:mana")

    input.add_callback("noname.craft", function ()
        local x, y, z = player.get_selected_block(pid)
        if block.get(x, y, z) ~= block.index("base:sand") then
            return
        end

        if not hud.is_paused() then
            --hud.show_overlay("noname:craft_inv", true)
        end
    end)
end