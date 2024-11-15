local module = {}
local drops = json.parse(file.read("noname:data/drops.json"))

function module.get_drops_ids(id)
    local drop = drops[id]

    if not drop then return {{id, 1}} end
    return drop
end

return module