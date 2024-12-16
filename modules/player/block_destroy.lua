local const = require "constants"
local tools = require "player/tools"
local events_ = require "penrose:events/events"

-- not_survival необходимо изменить под себя.
local PACK_ID = PACK_ID or "penrose";
local function resource(name) return PACK_ID .. ":" .. name end;

local function is_survival(pid)
  return true
end

---@author MihailRis
---@copyright MIT
---Modified a bit for resource(name) compatibility.

-- from base_survival:scripts/world.lua

local breaking_blocks = {};

local function get_durability(id, pid)
  local durabilities = const.session.blocks_durability
  local materials = const.session.materials_available
  local inv, slot = player.get_inventory(pid)
  local item_in_slot = inventory.get(inv, slot)
  local str_id = block.name(id)
  local str_id_item = str_id .. ".item"

  local block_durability = durabilities[str_id]
  local material = str_id

  if not block_durability then
      for m, i in pairs(materials) do
          if table.has(i, str_id_item) then
              block_durability = durabilities[m]
              material = m
              break
          end
      end
  end

  local durability = block_durability or block.properties[id]["base:durability"]
  if block.properties[id]["breakable"] == false then
      return 2^64
  end

  local n_durability = tools.get_durability(material, durability, item.name(item_in_slot))
  durability = n_durability or durability

  if durability then
      return durability
  elseif block.get_model(id) == "X" then
      return 0.0
  end

  return 2.0
end


local function stop_breaking(pid, target)
  events.emit(resource("stop_destroy"), pid, target)
  target.breaking = false
end

events_.player.reg(function(pid, tps)
  if not is_survival(pid) then return end;

  local target = breaking_blocks[pid]
  if not target then
    target = { breaking = false }
    breaking_blocks[pid] = target
  end

  if input.is_active("player.destroy") then
    local x, y, z = player.get_selected_block(pid)
    if target.breaking then
      if block.get(x, y, z) ~= target.id or
          x ~= target.x or y ~= target.y or z ~= target.z then
        return stop_breaking(pid, target)
      end
      local speed = 1.0 / math.max(get_durability(target.id, pid), 0.00001)
      target.progress = target.progress + (1.0 / tps) * speed
      target.tick = target.tick + 1
      if target.progress >= 1.0 then
        block.destruct(x, y, z, pid)
        return stop_breaking(pid, target)
      end

      events.emit(resource("progress_destroy"), pid, target)
    elseif x ~= nil then
      target.breaking = true
      target.id = block.get(x, y, z)
      target.x = x
      target.y = y
      target.z = z
      target.tick = 0
      target.progress = 0.0
      events.emit(resource("start_destroy"), pid, target)
    end
  elseif target.wrapper then
    stop_breaking(pid, target)
  end
end, {}, true)

-- from base_survival:scripts/hud.lua

events.on(resource("start_destroy"), function(playerid, target)
  target.wrapper = gfx.blockwraps.wrap(
    { target.x, target.y, target.z }, "cracks/cracks_0"
  )
end)

events.on(resource("progress_destroy"), function(playerid, target)
  local x = target.x
  local y = target.y
  local z = target.z
  gfx.blockwraps.set_texture(target.wrapper, string.format(
    "cracks/cracks_%s", math.floor(target.progress * 11)
  ))
  if target.tick % 12 == 0 then
    if block.materials[block.material(target.id)] then
      audio.play_sound(block.materials[block.material(target.id)].stepsSound,
        x + 0.5, y + 0.5, z + 0.5, 1.0, 1.0, "regular"
      )
    end
    local camera = cameras.get("core:first-person")
    local ray = block.raycast(camera:get_pos(), camera:get_front(), 64.0)
    gfx.particles.emit(ray.endpoint, 4, {
      lifetime = 1.0,
      spawn_interval = 0.0001,
      explosion = { 3, 3, 3 },
      velocity = vec3.add(vec3.mul(camera:get_front(), -1.0), { 0, 0.5, 0 }),
      texture = "blocks:" .. block.get_textures(target.id)[1],
      random_sub_uv = 0.1,
      size = { 0.1, 0.1, 0.1 },
      size_spread = 0.2,
      spawn_shape = "box",
      collision = true
    })
  end
end)

events.on(resource("stop_destroy"), function(playerid, target)
  gfx.blockwraps.unwrap(target.wrapper)
end)
