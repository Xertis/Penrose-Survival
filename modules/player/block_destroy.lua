--[[ Для начала в world.lua пропишите следующее:
function on_player_tick(player_id, tps)
  events.emit(PACK_ID..":player_tick", player_id, tps)
end
]]

-- not_survival необходимо изменить под себя.
local PACK_ID = PACK_ID or "noname";
local function resource(name) return PACK_ID .. ":" .. name end;

local function is_survival(pid)
  return true
end

---@author MihailRis
---@copyright MIT
---Modified a bit for resource(name) compatibility.

-- from base_survival:scripts/world.lua

local breaking_blocks = {};

local function get_durability(id)
  local durability = block.properties[id]["base:durability"]
  if durability ~= nil then
    return durability
  end
  if block.get_model(id) == "X" then
    return 0.0
  end
  return 2.0
end

local function stop_breaking(pid, target)
  events.emit(resource("stop_destroy"), pid, target)
  target.breaking = false
end

events.on(resource("player_tick"), function(pid, tps)
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
      local speed = 1.0 / math.max(get_durability(target.id), 0.00001)
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
end)

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
    audio.play_sound(block.materials[block.material(target.id)].stepsSound,
      x + 0.5, y + 0.5, z + 0.5, 1.0, 1.0, "regular"
    )
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