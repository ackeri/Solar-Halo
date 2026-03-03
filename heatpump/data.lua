local util = require("util")

local cb = {{-0.4, -1}, {0.4, 1}}
local sb = {{-0.5, -1}, {0.5, 1}}

data:extend{{
	type = "assembling-machine",
	icon = "__Solar-Halo__/heatpump/icon.png",
	icon_size = 64,
	fixed_recipe = "halo-heatpump-activity",
	quality_affects_energy_usage = true,
	energy_usage = "32MW",
	crafting_speed = 1,
	crafting_categories = {"halo-heatpump"},
	energy_source = {
		type = "electric",
		usage_priority = "secondary-input",
		drain = "150kW"
	},
	fluid_boxes = {
		{
			volume = 10,
			pipe_connections = {{
				connection_type = "linked",
				linked_connection_id = 1
			}},
			production_type = "input"
		},
		{
			volume = 10,
			pipe_connections = {{
				connection_type = "linked",
				linked_connection_id = 2
			}},
			production_type = "output"
		}
	},
	module_slots = 2,
	allowed_effects = {"speed", "consumption"},
	allow_module_categories = {"speed", "efficiency"},
	max_health = 300,
	circuit_wire_max_distance = 12,
	collision_box = cb,
	selection_box = sb,
	flags = {"hide-alt-info", "player-creation"},
	allow_copy_paste = true,
	minable = {
		mining_time = 0.5,
		result = "halo-heatpump",
	},
	
    corpse = "pump-remnants",
    dying_explosion = "pump-explosion",

	placeable_by = {item = "halo-heatpump", count = 1},
	tile_width = 1,
	tile_height = 2,
	name = "halo-heatpump",
	selection_priority = 51,
    impact_category = "metal",
    fast_replaceable_group = "heat-pipe",
    open_sound = util.sounds.machine_open,
    close_sound = util.sounds.machine_close,
    damaged_trigger_effect = util.hit_effects.entity(),
    working_sound =
    {
      sound = {filename = "__base__/sound/pump.ogg", volume = 0.3, audible_distance_modifier = 0.5},
      max_sounds_per_prototype = 2
    },
	graphics_set = {
		
		animation = {
			north = {
				filename = "__Solar-Halo__/heatpump/animationN.png",
				size = {103, 165},
				scale = 0.5,
				frame_count = 32,
				line_length = 8,
				shift = {0.3, 0},
			}, east = {
				filename = "__Solar-Halo__/heatpump/animationE.png",
				size = {130, 109},
				scale = 0.5,
				frame_count = 32,
				line_length = 8,
			}, south = {
				filename = "__Solar-Halo__/heatpump/animationS.png",
				size = {114, 160},
				scale = 0.5,
				frame_count = 32,
				line_length = 8,
				shift = {0.4, 0},
			}, west = {
				filename = "__Solar-Halo__/heatpump/animationW.png",
				size = {131, 111},
				scale = 0.5,
				frame_count = 32,
				line_length = 8,
			}
		},
	}
},{
	type = "assembling-machine",
	fixed_recipe = "halo-heatpumpreceiver",
	crafting_speed = 1,
	crafting_categories = {"halo-heatpump"},
	energy_source = {
		type = "heat",
		max_temperature = 999,
		specific_heat = "3MJ",
		max_transfer = "500MW",
		minimum_working_temperature = 40,
		connections = {
			{
				position = {x = 0, y = .8},
				direction = defines.direction.south
			}
		}
	},
	energy_usage = "500MW",
	fluid_boxes = {{
		volume = 100,
		pipe_connections = {{
			connection_type = "linked",
			linked_connection_id = 1
		}},
		production_type = "output",
		filter = "halo-heat-energy"
	}},
	effect_receiver = {
		uses_module_effects = false,
		uses_beacon_effects = false,
		uses_surface_effects = false
	},
	show_recipe_icon = false,
	show_recipe_icon_on_map = false,
	collision_box = cb,
	selection_box = sb,
	selection_priority = 1,
	flags = {"not-on-map", "not-deconstructable", "not-blueprintable", "hide-alt-info", "not-flammable", "not-selectable-in-game"},
	selectable_in_game = false,
	name = "halo-heatpump-receiver",
	hidden = true,
},{
	type = "reactor",
	heat_buffer = {
		max_temperature = 1000,
		specific_heat = "3MJ",
		max_transfer = "500MW",
		connections = {
			{position = {x = 0, y = 0}, direction = 0},
			{position = {x = 0, y = 0}, direction = 4},
			{position = {x = 0, y = 0}, direction = 8},
			{position = {x = 0, y = 0}, direction = 12}
		}
	},
	heating_radius = 1,
	energy_source = {
		type = "fluid",
		fluid_box = {
			volume = 100,
			pipe_connections = {{
				connection_type = "linked",
				linked_connection_id = 1
			}},
			filter = "halo-heat-energy",
			production_type = "input",
		},
		effectivity = 1,
		burns_fluid = true,
		scale_fluid_usage = true,
		render_no_power_icon = false,
	},
	consumption = "500MW",
	scale_energy_usage = true,
	collision_box = {
		left_top = {x = -0.4, y = -.4}, 
		right_bottom = {x = 0.4, y = .4}
	},
	selection_box = {
		left_top = {x = -.5, y = -.5},
		right_bottom = {x = .5, y = .5}
	},
	tile_height = 1,
	tile_width = 1,
	selection_priority = 1,
	flags = {"not-on-map", "not-deconstructable", "not-blueprintable", "hide-alt-info", "not-flammable", "not-selectable-in-game"},
	selectable_in_game = false,
	name = "halo-heatpump-reactor",
	hidden = true,
},{
	type = "item",
	stack_size = 10,
	place_result = "halo-heatpump",
	name = "halo-heatpump",
	subgroup = "environmental-protection",
	icon = "__Solar-Halo__/heatpump/icon.png"
},{
	type = "recipe",
	name = "halo-heatpump",
	category = "crafting",
	enabled = false,
	ingredients = {
		{type = "item", name = "pump", amount = 1},
		{type = "item", name = "heat-pipe", amount = 5},
		{type = "item", name = "petroleum-gas-barrel", amount = 2}
	},
	results = {{type = "item", name = "halo-heatpump", amount = 1}},
	energy_required = 3
},{
	type = "recipe-category",
	name = "halo-heatpump"
},{
	type = "recipe",
	name = "halo-heatpump-activity",
	category = "halo-heatpump",
	enabled = true,
	energy_required = 0.1,
	ingredients = {{
		type = "fluid", 
		name = "halo-heat-energy", 
		amount = 1
	}},
	results = {{
		type = "fluid", 
		name = "halo-heat-energy", 
		amount = 1
	}},
	hide_from_player_crafting = true,
	hidden = true
},{
	type = "recipe",
	name = "halo-heatpumpreceiver",
	category = "halo-heatpump",
	enabled = true,
	energy_required = 0.01,
	ingredients = {},
	results = {{
		type = "fluid", 
		name = "halo-heat-energy", 
		amount = 10,
		temperature = 40
	}},
	hidden = true,
	hidden_in_factoriopedia = true,
}}


