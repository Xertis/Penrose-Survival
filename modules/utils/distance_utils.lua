local module = {}

local sqrt = math.sqrt
local abs  = math.abs

function module.chebyshev(x1, y1, z1, x2, y2, z2)
	return abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2)
end

function module.euclidean(x1, y1, z1, x2, y2, z2)
    local dx, dy, dz = x1 - x2, y1 - y2, z1 - z2
	return sqrt(dx*dx + dy*dy + dz*dz)
end

return module
