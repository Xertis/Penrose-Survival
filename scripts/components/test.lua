local manager = require 'noname:frameworks/entities_manager'
local pathfinder = require 'starpath:pathfinder'
local other_uid = nil
local sept = 0

local AStar, BFS, DFS = pathfinder.AStar, pathfinder.BFS, pathfinder.DFS

local PATHFINDER_OPTIONS_WALKER = {
    radius = 20,
    pathPieceRadius = 4,
    algorithm = AStar,
    pathPiece = true,
}

local OPTIONS = {
    hp = 5,
    damage = 0,
    velocity = 10,
    fraction = "Players2",
    behaviour = "friendlyfire",
    pathOptions = PATHFINDER_OPTIONS_WALKER
}

local PLAYER = {
    hp = 5,
    damage = 0,
    velocity = 10,
    fraction = "Players",
    behaviour = "agressive"
}


manager.reg(player.get_entity(0), PLAYER)

local body = entity.rigidbody
body:set_body_type('static')

local pattern = manager.reg(entity:get_uid(), OPTIONS)

function on_render()
    if other_uid == nil or sept < 10 then
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