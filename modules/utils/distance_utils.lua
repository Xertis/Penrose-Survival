local module = {}

-- local sqrt = math.sqrt
local abs  = math.abs
local vec3_add = vec3.add
local vec3_len = vec3.length

function module.chebyshev(x1, y1, z1, x2, y2, z2)
	return abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2)
end

function module.euclidean(x1, y1, z1, x2, y2, z2)
    return vec3_len(vec3_add({x1,y1,z1},{x2,y2,z2}))
end

return module
