local manager = require 'noname:frameworks/entities_manager'
local other_uid = nil
local sept = 0
local OPTIONS = {
    hp = 5,
    damage = 0,
    velocity = 10,
    fraction = math.random(0, 1000),
    pattern = "walker",
    behaviour = "agressive"
}

local pattern = manager.reg(entity:get_uid(), OPTIONS)

function on_render()
    if other_uid == nil or sept < 20 then
        sept = sept + 1
        return
    end
    sept = 0
    pattern.on_sensor(entity:get_uid(), OPTIONS, other_uid)
end

function on_sensor_enter(index, e)
    other_uid = e
end

function on_sensor_exit(index, e)
    other_uid = nil
end

function on_attacked()
    
end