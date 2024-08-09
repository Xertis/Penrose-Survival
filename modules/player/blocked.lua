BlockedFunc = {}

--- Temp func
function get_player()
    local pid = entities.get(player.get_entity(0))
    return pid
end


function BlockedFunc.update()

    local is_grounded = get_player().rigidbody:is_grounded()
    local is_flight = player.is_flight()
    local is_noclip = player.is_noclip()

    if not is_grounded then
        if is_flight then
            player.set_flight(false)
        end
    end

    if is_noclip then
        player.set_noclip(false)
    end

    -- if input.is_pressed("key:r") then
    --     player.set_vel(get_player(), 1, 1, 1)
    -- end
end