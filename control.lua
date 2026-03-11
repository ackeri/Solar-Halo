--control.lua

local function ensure_storage_tables()
	storage["computer"] = storage["computer"] or {}
	storage["solar-surface"] = storage["solar-surface"] or {}
	storage["solar-forces"] = storage["solar-forces"] or {}
end

local function ensure_rocket_silo_recipe(entity)
	if not (entity and entity.valid and entity.type == "rocket-silo") then
		return
	end

	if entity.get_recipe() == nil then
		entity.set_recipe("rocket-part")
	end
	entity.recipe_locked = false
end

local function ensure_all_rocket_silo_recipes()
	for _, surface in pairs(game.surfaces) do
		for _, silo in pairs(surface.find_entities_filtered{type = "rocket-silo"}) do
			ensure_rocket_silo_recipe(silo)
		end
	end
end

script.on_init(function()
	ensure_storage_tables()
	ensure_all_rocket_silo_recipes()
end)

function getOffset(direction)
	if direction == defines.direction.north then
		return 0, -0.5
	elseif direction == defines.direction.east then
		return 0.5, 0
	elseif direction == defines.direction.south then
		return 0, 0.5
	elseif direction == defines.direction.west then
		return -0.5, 0
	end
end

script.on_configuration_changed(function()
	ensure_storage_tables()
	ensure_all_rocket_silo_recipes()
end)

----------building created---------
script.on_event({
	defines.events.on_built_entity,
	defines.events.on_robot_built_entity,
	defines.events.script_raised_built,
	defines.events.script_raised_revive,
	defines.events.on_space_platform_built_entity,
	defines.events.on_biter_base_built},
function(event)
	local entity = event.created_entity or event.entity or event.destination
	if not entity.valid then return end
	ensure_rocket_silo_recipe(entity)

	if entity.name == "halo-computer" then 
		local heat = entity.surface.create_entity {
			name = "halo-computer-heat",
			position = entity.position,
			force = entity.force_index,
			direction = entity.direction,
			quality = entity.quality,
			create_build_effect_smoke = false,
		}
		heat.destructible = false
		heat.minable_flag = false
		storage["computer"][entity.unit_number] = {c = entity, h = heat, p = 0}
	elseif entity.name == "halo-terminal" then
		local turbine = entity.surface.create_entity {
			name = "halo-terminal-turbine",
			position = entity.position,
			force = entity.force_index,
			direction = entity.direction,
		}
		turbine.destructible = false
		turbine.minable_flag = false
		entity.fluidbox.add_linked_connection(1,turbine,1)
	elseif event.consumed_items ~= nil and event.consumed_items.valid and #event.consumed_items > 0 and event.consumed_items[1].name == "halo-superheated-pipe" then
		entity.temperature = 800
	elseif entity.name == "halo-heatpump" then
		local receiver = entity.surface.create_entity {
			name = "halo-heatpump-receiver",
			position = entity.position,
			force = entity.force_index,
			direction = entity.direction,
		}
		receiver.destructible = false
		receiver.minable_flag = false
		
		local x,y = getOffset(entity.direction)
		local pos = {x = entity.position.x + x, y = entity.position.y + y}
		local reactor = entity.surface.create_entity {
			name = "halo-heatpump-reactor",
			position = pos,
			force = entity.force_index,
			direction = entity.direction,
		}
		reactor.destructible = false
		reactor.minable_flag = false

		entity.fluidbox.add_linked_connection(1,receiver,1)
		entity.fluidbox.add_linked_connection(2,reactor,1)
	elseif entity.name == "halo-heatsink" then
		local receiverlow = entity.surface.create_entity {
			name = "halo-heatsinklowreceiver",
			position = entity.position,
			force = entity.force_index,
			direction = entity.direction,
		}
		receiverlow.destructible = false
		receiverlow.minable_flag = false
		local receiverhigh = entity.surface.create_entity {
			name = "halo-heatsinkhighreceiver",
			position = entity.position,
			force = entity.force_index,
			direction = entity.direction,
			destructible = false,
		}
		receiverhigh.destructible = false
		receiverhigh.minable_flag = false
		
		entity.fluidbox.add_linked_connection(1,receiverlow,1)
		entity.fluidbox.add_linked_connection(2,receiverhigh,1)
	end
end)

---------building removed---------
script.on_event({
	defines.events.on_player_mined_entity,
	defines.events.on_robot_mined_entity,
	defines.events.on_entity_died,
	defines.events.script_raised_destroy,
	defines.events.on_space_platform_mined_entity},
function(event)
    local entity = event.entity
    if not entity.valid then return end
    if entity.name == "halo-computer" then
		local tuple = storage["computer"][entity.unit_number]
		storage["computer"][entity.unit_number] = nil
		if tuple.h ~= nil then
			tuple.h.destroy()
		end
	elseif entity.name == "halo-terminal" then
		local turbine, _ = entity.fluidbox.get_linked_connection(1)
		if turbine ~= nil then
			turbine.destroy()
		end
	elseif entity.name == "halo-heatpump" then 
		local receiver, _ = entity.fluidbox.get_linked_connection(1)
		if receiver ~= nil then
			receiver.destroy()
		end
		
		local reactor, _ = entity.fluidbox.get_linked_connection(2)
		if reactor ~= nil then
			reactor.destroy()
		end
	elseif entity.name == "halo-heatsink" then
		local receiver, _ = entity.fluidbox.get_linked_connection(1)
		if receiver ~= nil then
			receiver.destroy()
		end
		
		receiver, _ = entity.fluidbox.get_linked_connection(2)
		if receiver ~= nil then
			receiver.destroy()
		end
	end
end)

---------building rotated---------
script.on_event(defines.events.on_player_rotated_entity,
function(event)
    local entity = event.entity
    if not entity.valid then return end
    if entity.name == "halo-computer" then	
		local tuple = storage["computer"][entity.unit_number]
		tuple.h.direction = tuple.c.direction
	elseif entity.name == "halo-terminal" then
		local turbine, _ = entity.fluidbox.get_linked_connection(1)
		turbine.direction = entity.direction
	elseif entity.name == "halo-heatpump" then
		local receiver, _ = entity.fluidbox.get_linked_connection(1)
		receiver.direction = entity.direction
		
		local reactor, _ = entity.fluidbox.get_linked_connection(2)
		reactor.destroy()
		local x,y = getOffset(entity.direction)
		local pos = {x = entity.position.x + x, y = entity.position.y + y}
		reactor = entity.surface.create_entity {
			name = "halo-heatpump-reactor",
			position = pos,
			force = entity.force_index,
			direction = entity.direction,
		}
		reactor.destructible = false
		reactor.minable_flag = false
		entity.fluidbox.add_linked_connection(2,reactor,1)
	end
end)


script.on_event(defines.events.on_tick,
function(event)
	if event.tick % 20 ~= 0 then return end
	
	for _,t in pairs(storage["computer"]) do
		local newp = t.c.products_finished
		local dur = (newp - t.p)/t.c.crafting_speed
		local mult = 1000*0.5*(t.c.consumption_bonus + 1)
		t.h.temperature = t.h.temperature + dur*mult/200
		t.p = newp
		
		t.c.disabled_by_script = (t.h.temperature >= 200)
	end
end)


----------Navigation Computer----------
script.on_event(defines.events.on_script_trigger_effect,
function(event)
	if event.effect_id ~= "navcomp" then
		return
	end

	local e = event.target_entity
	if e ~= nil and e.valid and e.type == "asteroid" then
		e.destroy()
	end
end)

----------Solar Productivity----------
function updateSolar()
	local m = 0
	for _,lvl in pairs(storage["solar-forces"]) do
		game.print("force level " .. lvl)
		if lvl > m then m = lvl end
	end

	for _,s in pairs(game.surfaces) do
		if storage["solar-surface"] == nil then
			storage["solar-surface"] = {}
		end
		if storage["solar-surface"][s.name] == nil then
			storage["solar-surface"][s.name] = s.solar_power_multiplier
		end
		local solar = storage["solar-surface"][s.name]
		local bonus = solar * 0.1 * m
		s.solar_power_multiplier = solar + bonus
	end
end

script.on_event(defines.events.on_research_finished,
function(event)
	if event.research.name == "halo-solar" then
		if storage["solar-forces"] == nil then
			storage["solar-forces"] = {}
		end

		storage["solar-forces"][event.research.force.name] = event.research.level - 1

		updateSolar()
	end
end)

script.on_event(defines.events.on_research_reversed,
function(event)
	if event.research.name == "halo-solar" then
		if storage["solar-forces"] == nil then
			storage["solar-forces"] = {}
		end
		storage["solar-forces"][event.research.force.name] = 0
		updateSolar()
	end
end)
