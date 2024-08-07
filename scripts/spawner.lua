-- local vec3 = require("core:vector3")
-- local v1 = vec3(1,2,2)
-- print(v1)
local vecn = require("core:vector")


-- local v2 = {1,2,2}


-- print(vec3.tostring(v2))


function on_block_break_by(x, y, z, p)
    local v1 = vecn(1,3)
    print(v1)
    -- entities.spawn("noname:test", {x, y+3, z})
end
