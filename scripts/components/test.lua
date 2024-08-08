local manager = require 'noname:frameworks/entities_manager'
local pathfinder = require 'starpath:pathfinder'
local other_uid = nil
local sept = 0
local path = nil
local AStar, BFS, DFS = pathfinder.AStar, pathfinder.BFS, pathfinder.DFS

local PATHFINDER_OPTIONS_WALKER = {
    radius = 20,
    pathPieceRadius = 4,
    algorithm = AStar,
    pathPiece = true,
    maxAscent = 1,
    maxDescent = 2
}

local OPTIONS = {
    hp = 5,
    damage = 0,
    velocity = 10,
    fraction = "Players",
    behaviour = "friendlyfire",
    wanderRadius = 15,
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
local max_sept = 4
function on_render()
    if other_uid == nil or sept < max_sept then
        sept = sept + 1
        return
    end
    sept = 0
    if path == nil or #path == 0 then
        path = pattern.panic(entity:get_uid(), OPTIONS, other_uid)
    else
        entity.transform:set_pos({path[1].x, path[1].y, path[1].z})
        table.remove(path, 1)
    end
end

function on_sensor_enter(index, e)
    other_uid = e
end