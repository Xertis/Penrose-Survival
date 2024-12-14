local solace = require "penrose:utils/solace_blocks"

function on_broken(x, y, z)
    solace.unreg(x, y, z)
end

function on_placed(x, y, z)
    solace.reg(x, y, z)
    return true
end