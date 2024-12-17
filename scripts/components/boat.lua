
local function resource(name) return  "penrose:" .. name end

local PID = SAVED_DATA.pid
local tsf = entity.transform
local body = entity.rigidbody
local last_vel = 2

local function swim()
    local water = block.index("base:water")

    local epos = tsf:get_pos()

    local x, y, z = math.floor(epos[1]), math.floor(epos[2]), math.floor(epos[3])
    if block.get(x, y, z) == water then
        local vel = body:get_vel()
        vel[2] = math.abs(vel[2]) + 0.1
        body:set_gravity_scale(0)
        body:set_vel(vel)

    elseif block.get(x, y-1, z) == water and block.get(x, y+1, z) ~= water then
        if tsf:get_pos()[2]-y ~= 0 then
            local pos = tsf:get_pos()
            pos[2] = pos[2]-(pos[2]-y)+0.369
            tsf:set_pos(pos)
        end
        local vel = body:get_vel()
        vel[2] = 0
        body:set_gravity_scale(0)
        body:set_vel(vel)
    end

    if block.get(x, y, z) == 0 and block.get(x, y-1, z) == 0 then
        body:set_gravity_scale(1)
    end
end

local function rot()

    local rx = player.get_rot(PID)

    local mat = mat4.idt()
    mat4.rotate(mat, { 0, 1, 0 }, rx, mat)

    tsf:set_rot(mat)
end

local function get_speed()
    local epos = tsf:get_pos()
    local x, y, z = math.floor(epos[1]), math.floor(epos[2]), math.floor(epos[3])

    local water = block.index("base:water")
    local ice = {block.index("penrose:ice"), block.index("base:ice")}

    local in_cord = block.get(x, y-1, z)

    if in_cord == water then
        last_vel = 10
        return 10
    end

    if table.index(ice, in_cord) ~= -1 then
        last_vel = 20
        return 20
    end

    if in_cord == 0 then
        return last_vel
    end

    last_vel = 2
    return 2
end

local function navigate()
    local speed = get_speed()
    if input.is_pressed("key:w") then
        local vel = body:get_vel()
        local vely = vel[2]
        vel = {speed, 0, 0}

        vel = entities.utils.move_in_dir(player.get_dir(PID),
                                        vel
                                        )
        vel[2] = vely
        body:set_vel(vel)
    end
end

function on_used(pid)
    PID = pid
end

function on_attacked(_, pid)
    if PID and PID == pid then
        PID = nil
        return
    elseif PID then
        return
    end

    local epos = tsf:get_pos()
    local x, y, z = math.floor(epos[1]), math.floor(epos[2]), math.floor(epos[3])

    entities.spawn("base:drop", {x+0.5, y+0.5, z+0.5}, {base__drop={
        id=item.index("penrose:boat.item"),
        count=1
    }})

    entity:despawn()
end

function tp_player()
    player.set_vel(PID, 0, 0, 0)
    local epos = tsf:get_pos()

    player.set_pos(PID, epos[1], epos[2]+0.2, epos[3])
end

function on_render()
    body:set_linear_damping(0.9)
    swim()
    if PID and (player.get_name(PID) == SAVED_DATA.pname or not SAVED_DATA.pname) then
        navigate()
        tp_player()
        rot()
    elseif player.get_name(PID) and player.get_name(PID) ~= SAVED_DATA.pname then
        PID = nil
        SAVED_DATA.pname = nil
    end
end

local function player_die(pid)
    if PID == pid then
        PID = nil
    end
end

function on_save()
    SAVED_DATA.pname = player.get_name(PID)
    SAVED_DATA.pid = PID
end

events.on(resource("player_death"), player_die)