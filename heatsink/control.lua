-- heatsink/control.lua

local M = {}

-- Shared by on_built and migrations/1.2.0.lua: builds the low/high receiver
-- pair for a heatsink at `position`. Both receivers sit exactly on the
-- heatsink (so they stay inside its hitbox); their one internal heat
-- connection pairs up because the two ports are on adjacent tiles, not
-- because the entities are offset (see heatsink/data.lua).
function M.create_receivers(surface, position, force, direction)
	local receiverlow = surface.create_entity {
		name = "halo-heatsinklowreceiver",
		position = position,
		force = force,
		direction = direction,
	}
	receiverlow.destructible = false
	receiverlow.minable_flag = false

	local receiverhigh = surface.create_entity {
		name = "halo-heatsinkhighreceiver",
		position = position,
		force = force,
		direction = direction,
	}
	receiverhigh.destructible = false
	receiverhigh.minable_flag = false

	return receiverlow, receiverhigh
end

-- Inserters take whichever entity at their target spot was made last, and the
-- receivers are made after the heatsink and sit exactly on it, so an inserter
-- reaching for a heatsink got a receiver, which has no use for any item: the
-- heatsink could be neither loaded nor unloaded. Teleporting the heatsink to
-- where it already is makes it the newest again, and changes nothing else about
-- it (its recipe, its fluids and the links to its receivers all stay). Inserters
-- already reaching for it keep the target they had worked out, so those are
-- pointed at the heatsink too. Also used by migrations/1.2.4.lua for the
-- heatsinks already placed.
local RECEIVERS = {["halo-heatsinklowreceiver"] = true, ["halo-heatsinkhighreceiver"] = true}

function M.bring_to_front(heatsink)
	heatsink.teleport(heatsink.position)
	for _, inserter in pairs(heatsink.surface.find_entities_filtered{
			type = "inserter", position = heatsink.position, radius = 4}) do
		local target = inserter.drop_target
		if target and RECEIVERS[target.name] then inserter.drop_target = heatsink end
		target = inserter.pickup_target
		if target and RECEIVERS[target.name] then inserter.pickup_target = heatsink end
	end
end

function M.on_built(entity)
	local receiverlow, receiverhigh = M.create_receivers(
		entity.surface, entity.position, entity.force_index, entity.direction)

	entity.add_fluid_box_linked_connection(1, receiverlow, 1)
	entity.add_fluid_box_linked_connection(2, receiverhigh, 1)
	M.bring_to_front(entity)
end

function M.on_removed(entity)
	local receiver, _ = entity.get_fluid_box_linked_connection(1)
	if receiver ~= nil then
		receiver.destroy()
	end

	receiver, _ = entity.get_fluid_box_linked_connection(2)
	if receiver ~= nil then
		receiver.destroy()
	end
end

-- The superheated pipe is a distinct entity from the plain heat pipe
-- specifically so it can't be confused with it during ghost/robot item
-- resolution (see heatsink/data.lua); it starts at ambient temperature like
-- any other entity, so it's set hot here on build instead.
function M.on_superheated_pipe_built(entity)
	entity.temperature = 800
end

return M
