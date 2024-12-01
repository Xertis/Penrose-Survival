local pathfinder = require 'starpath:pathfinder'
local distance = require 'noname:utils/distance_utils'
local tblu_u = require 'noname:utils/table_utils'

local agressive = {}
local peaceful = {}
local friendlyfire = {}

function vec3.floor(a)
    local x, y, z = unpack(a)
    return {math.floor(x), math.floor(y), math.floor(z)}
end

local AStar, BFS, DFS = pathfinder.AStar, pathfinder.BFS, pathfinder.DFS
local PATHFINDER_OPTIONS_DEFAULT = {
    radius = 20,
    pathPieceRadius = 4,
    algorithm = AStar,
    pathPiece = true,
    maxAscent = 1,
    maxDescent = 2
}

local function get_options(uid)
    for i=1, #REGISTERED_ENTITIES do
        if REGISTERED_ENTITIES[i][1] == uid then
            return REGISTERED_ENTITIES[i][2]
        end
    end
end

local function get_random_postion(pos, radius, if_array)
    local rX = pos[1] + math.random(-radius, radius)
    local rY = pos[2] + math.random(-radius, radius)
    local rZ = pos[3] + math.random(-radius, radius)
    if if_array == true then return {rX, rY, rZ} else return {x = rX, y = rY, z = rZ} end
end

local function base_attack(uid, options, other_uid)
    local other = entities.get(other_uid)
    local other_tsf = other.transform
    local other_pos = vec3.floor(other_tsf:get_pos())

    local it = entities.get(uid)
    local it_tsf = it.transform
    local it_pos = vec3.floor(it_tsf:get_pos())

    local path_options = nil
    if options.pathOptions == nil then path_options = PATHFINDER_OPTIONS_DEFAULT else path_options = options.pathOptions end
    local path = pathfinder.find_path(it_pos[1], it_pos[2], it_pos[3], other_pos[1], other_pos[2], other_pos[3], path_options)
    if path ~= nil and #path > 1 then
        return path
    end
end

local function wander(uid, options)
    local it = entities.get(uid)
    local it_tsf = it.transform
    local it_pos = vec3.floor(it_tsf:get_pos())
    local random_pos = nil
    if options.wanderRadius == nil then random_pos = get_random_postion(it_pos, 4, true) else random_pos = get_random_postion(it_pos, options.wanderRadius, true) end

    local path_options = nil
    if options.pathOptions == nil then path_options = PATHFINDER_OPTIONS_DEFAULT else path_options = options.pathOptions end

    local path = pathfinder.find_path(it_pos[1], it_pos[2], it_pos[3], random_pos[1], random_pos[2], random_pos[3], path_options)

    if path ~= nil and #path > 1 then
        return path
    end
end

local function panic(uid, options, other_uid)
    local other = entities.get(other_uid)
    local other_tsf = other.transform
    local other_pos = vec3.floor(other_tsf:get_pos())

    local it = entities.get(uid)
    local it_tsf = it.transform
    local it_pos = vec3.floor(it_tsf:get_pos())

    local panic_direction = vec3.sub(it_pos, other_pos)
    local normalized_direction = vec3.normalize(panic_direction)
    if tblu_u.equals(panic_direction, {0, 0, 0}) then
        normalized_direction = {0, 0, 0}
    end

    local panic_distance = nil
    if options.panicRadius == nil then panic_distance = 6 else panic_distance = options.panicRadius end

    local target_pos = {
        it_pos[1] + normalized_direction[1] * panic_distance,
        it_pos[2] + normalized_direction[2] * panic_distance,
        it_pos[3] + normalized_direction[3] * panic_distance
    }

    local path_options = nil
    if options.pathOptions == nil then path_options = PATHFINDER_OPTIONS_DEFAULT else path_options = options.pathOptions end

    local path = pathfinder.find_path(it_pos[1], it_pos[2], it_pos[3], target_pos[1], target_pos[2], target_pos[3], path_options)

    if path ~= nil and #path > 1 then
        return path
    end
end

function agressive.attack(uid, options, other_uid)
    local other_options = get_options(other_uid)
    if other_options == nil or (other_options.fraction == options.fraction or table.has(options.allies, other_options.fraction)) then
        return
    end

    return base_attack(uid, options, other_uid)

end

function friendlyfire.attack(uid, options, other_uid)
    local other_options = get_options(other_uid)
    if other_options == nil or (other_options.fraction ~= options.fraction and not table.has(options.allies, other_options.fraction)) then
        return
    end

    return base_attack(uid, options, other_uid)
end

friendlyfire.wander = wander
agressive.wander = wander
peaceful.wander = wander

friendlyfire.panic = panic
agressive.panic = panic
peaceful.panic = panic

local patterns = {}

function patterns.get(options)
    if options then
        options.allies = options.aliies or {}
        if options.behaviour == 'agressive' then
            return agressive
        elseif options.behaviour == 'peaceful' then
            return peaceful
        elseif options.behaviour == 'friendlyfire' then
            return friendlyfire
        end
    end
end

return patterns