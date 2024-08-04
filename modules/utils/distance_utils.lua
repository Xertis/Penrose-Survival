local module = {}

function module.chebyshev(x1, y1, z1, x2, y2, z2)
	local x, y, z = x1 - x2, y1 - y2, z1 - z2

	if x < 0 then x = -x end
	if y < 0 then y = -y end
	if z < 0 then z = -z end

	return x + y + z
end

function module.euclidean(x1, y1, z1, x2, y2, z2)
    return ((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2) ^ 0.5
end

function module.manhattan(x1, y1, z1, x2, y2, z2)
    local x, y, z = math.abs(x1 - x2), math.abs(y1 - y2), math.abs(z1 - z2)
    return x+y+z
end

return module