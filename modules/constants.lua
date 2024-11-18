local const = {

}

local items_available = {}
local blocks_available = {}

for i=0, item.defs_count()-1 do
    items_available[item.name(i)] = i
end

for i=0, block.defs_count()-1 do
    blocks_available[block.name(i)] = i
end

local session_const = {
    items_available = items_available,
    blocks_available = blocks_available
}

return {const = const, session_const = session_const}