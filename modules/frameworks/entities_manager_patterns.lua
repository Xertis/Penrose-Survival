local pathfinder = require 'starpath:pathfinder'
local distance = require 'noname:utils/distance_utils'

local AStar, BFS, DFS = pathfinder.AStar, pathfinder.BFS, pathfinder.DFS

local agressive = {}
local peaceful = {}

local function get_options(uid)
    for i=1, #registered_entities do
        if registered_entities[i][1] == uid then
            return registered_entities[i][2]
        end
    end
end

local PATHFINDER_OPTIONS_BIRD = {
    radius = 20,
    pathPieceRadius = 4,
    algorithm = AStar,
    pathPiece = true
}

local PATHFINDER_OPTIONS_WALKER = {
    radius = 20,
    pathPieceRadius = 4,
    algorithm = AStar,
    pathPiece = true,
    maxAscent = 1,
    maxDescent = 2
}

function agressive.on_sensor(uid, options, other_uid)
    local other_options = get_options(other_uid)
    if other_options == nil or other_options.fraction == nil or other_options.fraction == options.fraction then
        return
    end

    local other = entities.get(other_uid)
    local other_tsf = other.transform
    local other_pos = vec3.round(other_tsf:get_pos())

    local it = entities.get(uid)
    local it_tsf = it.transform
    local it_pos = vec3.round(it_tsf:get_pos())

    local path_options = nil
    if options.pattern == 'bird' then path_options = PATHFINDER_OPTIONS_BIRD else path_options = PATHFINDER_OPTIONS_WALKER end

    local path = pathfinder.find_path(it_pos[1], it_pos[2], it_pos[3], other_pos[1], other_pos[2], other_pos[3], path_options)

    if path ~= nil and #path > 1 then
        path = path[2]
        it_tsf:set_pos({path.x, path.y, path.z})

        if distance.chebyshev(path.x, path.y, path.z, other_pos[1], other_pos[2], other_pos[3]) < 2 then
            local id = entities.def_name(entities.get_def(uid))
            local entity = entities.get(uid)
            entity:get_component(id).on_attacked()
            --print('ATTACK')
        end
    end
end

function peaceful.on_render(uid, options, other_uid)
end

local patterns = {}

function patterns.get(options)
    if options then
        if options.behaviour == 'agressive' then
            return agressive
        elseif options.behaviour == 'peaceful' then
            return peaceful
        end
    end
end

return patterns