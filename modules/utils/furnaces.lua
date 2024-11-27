local craftu = require "noname:utils/craft"
local const = require "noname:constants"
local FUELS = {}
local events = require "noname:events/events"
local metadata = require "noname:files/metadata"
local module = {}

local FURNACES = {}

--Тики до того, как закончится топливо
--Тики до того, как сготовится предмет
--Тики до того, 

function module.reg(x, y, z)
    if module.get(x, y, z) ~= nil then
        return
    end
    table.insert(FURNACES, {x, y, z, 0, 0, false})
end

function module.unreg(x, y, z)
    for i, b in ipairs(FURNACES) do
        if b[1] == x and b[2] == y and b[3] == z then
            table.remove(FURNACES, i)
            return
        end
    end
end

function module.get(x, y, z)
    for i, b in ipairs(FURNACES) do
        if b[1] == x and b[2] == y and b[3] == z then
            return b[4], b[5], b[6], i
        end
    end
end

function module.tick()
    for i, b in ipairs(FURNACES) do
        module.check(inventory.get_block(b[1], b[2], b[3]), 0, b[1], b[2], b[3])
        if b[5] > 0 then
           b[5] = b[5] - 0.05
        end

        if b[4] > 0 then
            b[4] = b[4] - 0.05
        end
    end
end

function module.quit()
    metadata.world.set("furnaces", FURNACES)
end

function module.load()
    FURNACES = metadata.world.get("furnaces") or {}
end

function module.on_open(invid, x, y, z, doc)
    FUELS = const.session.fuels_available
end

function module.find_fuel(fuel)
    local materials = const.session.materials_available
    for i, m in pairs(materials) do
        if table.has(m, fuel) then
            print(FUELS[i])
            return FUELS[i]
        end
    end
end

function module.check(invid, slot, x, y, z)
    if invid == 0 then
        return
    end

    local function get_craft()
        local id, count = inventory.get(invid, 0)
        local slots = {
            craft = {item.name(id), count}
        }

        local craft = craftu.furnace.find_craft(slots)
        if craft then
            if const.session.items_available[craft[1]] == nil then craft[1] = craft[1] .. '.item' end
            return craft
        end
    end

    local furnace = {module.get(x, y, z)}

    --print(json.tostring({d = furnace}))

    local INPUT_SLOT = 0
    local FUEL_SLOT = 1
    local OUTPU_SLOT = 2

    local fuel_lvl = furnace[1]
    local cooking_lvl = furnace[2]
    local is_not_start = furnace[3]
    local reg_id = furnace[4]

    if fuel_lvl <= 0 then
        local fuel_id, fuel_count = inventory.get(invid, FUEL_SLOT)

        if fuel_id ~= 0 and fuel_count > 0 then
            local in_input_id, in_input_count = inventory.get(invid, INPUT_SLOT)
            local energy = module.find_fuel(item.name(fuel_id))
            if in_input_id ~= 0 and energy then
                inventory.set(invid, FUEL_SLOT, fuel_id, fuel_count-1)
                FURNACES[reg_id][4] = energy
                --print(cooking_lvl, "кук левеле")
            end
        else
            FURNACES[reg_id][4] = 0.05
            FURNACES[reg_id][5] = 0.05
            return
        end
    end

    fuel_lvl = FURNACES[reg_id][4]

    if fuel_lvl > 0 and cooking_lvl < 0 and is_not_start then
        local craft = get_craft()
        FURNACES[reg_id][6] = false
        if craft then
            --Уменьшаем кол-во предметов в печке
            local in_input_id, in_input_count = inventory.get(invid, INPUT_SLOT)
            if in_input_count-craft[2].craft[2] > 0 then
                inventory.set(invid, INPUT_SLOT, in_input_id, in_input_count-craft[2].craft[2])
            else
                inventory.set(invid, INPUT_SLOT, 0, 0)
            end

            --Увеличиваем кол-во предметов на выходе
            local in_output_id, in_output_count = inventory.get(invid, OUTPU_SLOT)
            local craft_id, craft_count = craft[1], craft[2].count
            if item.name(in_output_id) == craft_id then
                inventory.set(invid, OUTPU_SLOT, in_output_id, in_output_count+craft_count)
            else
                inventory.set(invid, OUTPU_SLOT, item.index(craft_id), craft_count)
            end

        end
    end
    if fuel_lvl > 0 and cooking_lvl <= 0 and inventory.get(invid, INPUT_SLOT) ~= 0 then
        FURNACES[reg_id][5] = 10
        FURNACES[reg_id][6] = true
    end
end

events.world.reg(module.tick, {}, "Done")
events.world.quit.reg(module.quit, {})

return module