local util = require("util")

data:extend{{
	type = "assembling-machine",
	name = "halo-computer",

	icon = "__Solar-Halo__/computer/icon.png",
	collision_box = {{-1.9,-1.9},{1.9,1.9}},
	selection_box = {{-2,-2},{2,2}},
	tile_width = 4,
	tile_height = 4,
	flags = {"player-creation", "hide-alt-info", "not-rotatable"},
	build_sound = "__base__/sound/combinator.ogg",
	open_sound = "__base__/sound/gate-open-2.ogg",
	close_sound = "__base__/sound/gate-close-5.ogg",
	working_sound = "__base__/sound/beacon-var-2.ogg",
	impact_category = "metal",
    damaged_trigger_effect = util.hit_effects.entity(),
	
	circuit_wire_max_distance = 12,
	
	max_health = 400,
	dying_explosion = "laser-turret-explosion",
	corpse = "tesla-turret-remnants",
	
	crafting_categories = {"halo-computing"},
	crafting_speed = 1,
	fixed_recipe = "halo-compute",
	show_recipe_icon = false,

	energy_usage = "1GW",
	energy_source = {
		type = "electric",
		usage_priority = "secondary-input",
		drain = "200MW",
		buffer_capacity = "1GJ",
	},

	module_slots = 2,
	allowed_effects = {"speed", "consumption"},
	effect_receiver = {uses_beacon_effects = false, uses_surface_effects = false},
	emissions_per_second = {},
	
	fluid_boxes = {{
		volume = 1000,
		pipe_picture = util.pipe_picture,
		pipe_covers = util.pipecoverspictures(),
		secondary_draw_order = -5,
		pipe_connections = {{
				direction = defines.direction.north,
				position = {0.5,-1.5},
			},{
				direction = defines.direction.east,
				position = {1.5,-0.5},
			},{
				direction = defines.direction.south,
				position = {-0.5,1.5},
			},{
				direction = defines.direction.west,
				position = {-1.5,0.5},
		}},
		production_type = "output",
	}},

	placeable_by = {item = "halo-computer", count = 1},
	minable = {
		mining_time = 2,
		result = "halo-computer",
	},
	
	graphics_set = {
		animation = {
			layers = {{
					filename = "__Solar-Halo__/computer/animation.png",
					width = 270,
					height = 310,
					frame_count = 64,
					line_length = 8,
					shift = {0,0},
					scale = 0.5,
				},{
					filename = "__Solar-Halo__/computer/shadow.png",
					width = 500,
					height = 350,
					frame_count = 1,
					repeat_count = 64,
					shift = {0,0},
					scale = 0.5,
					draw_as_shadow = true,
			}}
		},
		working_visualisations = {{
			apply_tint = "status",
			always_draw = true,
			animation = {
				filename = "__Solar-Halo__/computer/glow.png",
				width = 270,
				height = 310,
				frame_count = 64,
				line_length = 8,
				shift = {0,0},
				scale = 0.5,
				draw_as_glow = true,
				blend_mode = "additive",
			}
		}},
		status_colors = {
			idle = {0,0,0,0},
			working = {0.3,0.3,1,1},
			disabled = {1,0,0,1},
			no_power = {0,0,0,0},
			low_power = {0.1,0.1,1,0.2},
			full_output = {0.3,0.3,1,1},
		},
	}
},{
	type = "heat-pipe",
	name = "halo-computer-heat",
	hidden = true,
	hidden_in_factoriopedia = true,
	collision_box = {{-1.9,-1.9},{1.9,1.9}},
	tile_width = 4,
	tile_height = 4,
	selectable_in_game = false,
	default_temperature = 15,
	heat_buffer = {
		max_temperature = 1000,
		specific_heat = "200MJ",
		max_transfer = "10GW",
		connections = {{
				direction = defines.direction.north,
				position = {x = -1.5, y = -1.5},
			},{
				direction = defines.direction.north,
				position = {x = 1.5, y = -1.5},
			},{
				direction = defines.direction.east,
				position = {x = 1.5, y = -1.5},
			},{
				direction = defines.direction.east,
				position = {x = 1.5, y = 1.5},
			},{
				direction = defines.direction.south,
				position = {x = 1.5, y = 1.5},
			},{
				direction = defines.direction.south,
				position = {x = -1.5, y = 1.5},
			},{
				direction = defines.direction.west,
				position = {x = -1.5, y = 1.5},
			},{
				direction = defines.direction.west,
				position = {x = -1.5, y = -1.5},
		}},
	},
	flags = {"not-on-map", "not-deconstructable", "not-blueprintable", "hide-alt-info", "not-flammable", "not-selectable-in-game"},
},{
	type = "item",
	name = "halo-computer",
	order = "zz",
	subgroup = "production-machine",
	stack_size = 10,
	icon = "__Solar-Halo__/computer/icon.png",
	place_result = "halo-computer",
	pick_sound = "__base__/sound/item/lab-inventory-pickup.ogg",
	inventory_move_sound = "__base__/sound/item/lab-inventory-move.ogg",
},{
	type = "recipe",
	name = "halo-computer",
	enabled = false,
	energy_required = 8,
	ingredients = {
		{type = "item", name = "decider-combinator", amount = 8},
		{type = "item", name = "processing-unit", amount = 150},
		{type = "item", name = "copper-plate", amount = 100}
	},
	results = {{type = "item", name = "halo-computer", amount = 1}}
},{
	type = "recipe-category",
	name = "halo-computing",
},{
	type = "fluid",
	name = "halo-compute",
	icon = "__Solar-Halo__/computer/compute.png",
	default_temperature = 15,
	base_color = {r=0,g=0,b=0,a=1},
	flow_color = {r=0,g=0,b=0,a=1},
	auto_barrel = false,
	subgroup = "fluid",
	order = "zzz"
},{
	type = "recipe",
	category = "halo-computing",
	name = "halo-compute",
	enabled = false,
	energy_required = 1,
	ingredients = {},
	results = {{type = "fluid", name = "halo-compute", amount = 1000}},
	hide_from_player_crafting = true
}}
