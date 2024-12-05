local module = {}
local Hp = {}

local hp_bar = Document.new("penrose:hp")
local mana_bar = Document.new("penrose:mana")
local food_bar =  Document.new("penrose:food")
local water_bar = Document.new("penrose:water")
local armor_bar = Document.new("penrose:armor")
local mind_bar = Document.new("penrose:mind")

Hp.__index = Hp

function Hp:new(pid, val)
    local obj = {
        pid = pid,
        value = val
    }
    setmetatable(obj, self)
    return obj
end

function Hp:get()
    return self.value
end

function Hp:set(val)
    self.value = val
    hp_bar.hp.size = {505 * (val / 100), 20}
end

function Hp:get_player()
    return self.pid
end

-- Food class
local Food = setmetatable({}, { __index = Hp })
Food.__index = Food

function Food:new(pid, nutrition)
    local obj = Hp.new(self, pid, nutrition)
    return obj
end

function Food:set(val)
    self.value = val
    food_bar.food.size = {505 * (val / 100), 20}
end

-- Water class
local Water = setmetatable({}, { __index = Hp })
Water.__index = Water

function Water:new(pid, hydration)
    local obj = Hp.new(self, pid, hydration)
    return obj
end 

function Water:set(val)
    self.value = val
    water_bar.water.size = {505 * (val / 100), 20}
end

-- Mind class
local Mind = setmetatable({}, { __index = Hp })
Mind.__index = Mind

function Mind:new(pid, mind)
    local obj = Hp.new(self, pid, mind)
    return obj
end

function Mind:set(val)
    self.value = val
    mind_bar.mind.size = {505 * (val / 100), 20}
end

-- Armor class
local Armor = setmetatable({}, { __index = Hp })
Armor.__index = Armor

function Armor:new(pid, defense)
    local obj = Hp.new(self, pid, defense)
    return obj
end

function Armor:set(val)
    self.value = val
    armor_bar.armor.size = {505 * (val / 100), 20}
end

-- Mana class
local Mana = setmetatable({}, { __index = Hp })
Mana.__index = Mana

function Mana:new(pid, mana)
    local obj = Hp.new(self, pid, mana)
    return obj
end

function Mana:set(val)
    self.value = val
    mana_bar.mana.size = {505 * (val / 100), 20}
end


module.hp = Hp
module.food = Food
module.water = Water
module.mind = Mind
module.armor = Armor
module.mana = Mana

return module