local tsf = entity.transform
local body = entity.rigidbody

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
            pos[2] = pos[2]-(pos[2]-y)
            tsf:set_pos(pos)
        end
        local vel = body:get_vel()
        vel = {0, 0, 0}
        body:set_gravity_scale(0)
        body:set_vel(vel)
    end

    if block.get(x, y, z) == 0 and block.get(x, y-1, z) == 0 then
        body:set_gravity_scale(1)
    end
end

function catch()
    entity:despawn()

    local epos = tsf:get_pos()
    local x, y, z = math.floor(epos[1]), math.floor(epos[2]), math.floor(epos[3])

    entities.spawn("base:drop", {x+0.5, y+0.5, z+0.5}, {base__drop={
        id=item.index("penrose:apple"),
        count=1
    }})
end

function on_render()
    local time = time.utils.normalize(10)
    local uid = entity:get_uid()

    local configs = {uid, uid, uid}
    local rand = math.randomize(configs, math.abs(time - 0.1), 1, 5)

    print(time, rand)
    
    if rand == 1 and time+0.0004 >= 1 then
        print(rand, time, uid)
        catch()
        return
    end
    body:set_linear_damping(0.9)
    swim()
end