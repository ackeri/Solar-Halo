-- thermostat/control.lua
--
-- The thermostat is deprecated: heat pipes can read their own temperature onto
-- the circuit network natively, so the thermostat is redundant. This converts
-- placed thermostats, and "halo-thermostat" item stacks, into plain heat pipes.
-- It runs from migrations/1.2.0.lua and again on every configuration change,
-- which is safe to repeat (it finds thermostats by name) and catches saves
-- where the migration already ran before there were any left to convert.
--
-- This is a best-effort sweep, not an exhaustive one: it covers entities on
-- every surface with the most common inventory-bearing types (chests,
-- vehicles, cargo pods, characters, ...) and item-on-ground, plus every
-- player's inventories and cursor. It does not reach into other mods' custom
-- storage, or into blueprint/blueprint-book contents (those reference the item
-- by name, which stays defined, just hidden and uncraftable, so they won't
-- error, they just can no longer be built).

local M = {}

local function capture_wires(entity)
	local captured = {}
	for _, id in pairs(defines.wire_connector_id) do
		local wc = entity.get_wire_connector(id, false)
		if wc then
			for _, connection in pairs(wc.connections) do
				table.insert(captured, {id = id, target = connection.target})
			end
		end
	end
	return captured
end

local function apply_wires(entity, captured)
	for _, c in pairs(captured) do
		local wc = entity.get_wire_connector(c.id, true)
		if wc then
			wc.connect_to(c.target)
		end
	end
end

local function replace_thermostat(entity, surface)
	local position, direction, force = entity.position, entity.direction, entity.force
	local temperature = entity.temperature
	local health_ratio = entity.get_health_ratio()
	local wires = capture_wires(entity)
	local old_cb = entity.get_control_behavior()
	local read_temperature, temperature_signal
	if old_cb then
		read_temperature = old_cb.read_temperature
		temperature_signal = old_cb.temperature_signal
	end

	entity.destroy()

	local pipe = surface.create_entity{
		name = "heat-pipe",
		position = position,
		direction = direction,
		force = force,
	}
	if not pipe then return end

	pipe.temperature = temperature
	if health_ratio then
		pipe.health = pipe.max_health * health_ratio
	end
	apply_wires(pipe, wires)
	if read_temperature ~= nil then
		local cb = pipe.get_or_create_control_behavior()
		if cb then
			cb.read_temperature = read_temperature
			cb.temperature_signal = temperature_signal
		end
	end
end

local function convert_stack(stack)
	if stack and stack.valid_for_read and stack.name == "halo-thermostat" then
		local count, quality = stack.count, stack.quality
		stack.set_stack{name = "heat-pipe", count = count, quality = quality}
	end
end

local function convert_inventory(inventory)
	if not inventory then return end
	for i = 1, #inventory do
		convert_stack(inventory[i])
	end
end

-- Tries every inventory slot type Factorio knows about on this entity; most
-- will simply not apply and get_inventory returns nil for those.
local function convert_all_inventories(entity)
	if not entity or not entity.valid then return end
	for _, inv_id in pairs(defines.inventory) do
		local ok, inventory = pcall(entity.get_inventory, inv_id)
		if ok and inventory then
			convert_inventory(inventory)
		end
	end
end

local inventory_bearing_types = {
	"container", "logistic-container", "cargo-wagon", "car", "spider-vehicle",
	"cargo-pod", "character", "rocket-silo", "artillery-wagon",
	"cargo-landing-pad", "space-platform-hub",
}

function M.convert_all()
	for _, surface in pairs(game.surfaces) do
		for _, entity in pairs(surface.find_entities_filtered{name = "halo-thermostat"}) do
			replace_thermostat(entity, surface)
		end

		for _, entity in pairs(surface.find_entities_filtered{type = inventory_bearing_types}) do
			convert_all_inventories(entity)
		end

		for _, ground_item in pairs(surface.find_entities_filtered{name = "item-on-ground"}) do
			convert_stack(ground_item.stack)
		end
	end

	for _, player in pairs(game.players) do
		convert_inventory(player.get_main_inventory())
		convert_stack(player.cursor_stack)
		if player.character then
			convert_all_inventories(player.character)
		end
	end
end

return M
