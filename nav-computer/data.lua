local util = require("util")

data:extend{{
	type = "ammo-turret",
	name = "halo-nav-computer",
	icon = "__Solar-Halo__/nav-computer/icon.png",
	collision_box = {{-1.5,-1.5}, {1.5,1.5}},
	selection_box = {{-1.5,-1.5}, {1.5,1.5}},
	flags = {"not-rotatable", "player-creation"},
	minable = {mining_time = 0.5, result = "halo-nav-computer"},
	surface_conditions = {{
		property = "gravity",
		min = 0,
		max = 0,
	}},
	placeable_by = {item = "halo-nav-computer", count = 1},
	tile_width = 3,
	tile_height = 3,
	max_health = 500,
	circuit_wire_max_distance = 12,
	starting_attack_speed = 10,
	attacking_speed = 10,
	ending_attack_speed = 10,
	default_speed = 1000,
	call_for_help_radius = 0,
	folded_animation = {north = {
		width = 1,
		height = 1,
		filenames = {"__Solar-Halo__/blank.png"},
		size = 1,
		lines_per_file = 1,
	}},
	attack_parameters = {
		type = "beam",
		range = 500,
		cooldown = 6,
		ammo_type = {
			target_filter = {} --data-updates.lua
		},
		activation_type = "activate",
		ammo_category = "halo-compute"
	},
	automated_ammo_count = 10,
	inventory_size = 1,
	energy_per_shot = "5MJ",
	energy_source = {
		type = "electric",
		buffer_capacity = "5MJ",
		usage_priority = "secondary-input",
		drain = "500kW",
	},
	graphics_set = {
		base_visualisation = {
			animation = {
				filename = "__Solar-Halo__/nav-computer/animation.png",
				width = 128,
				height = 128,
				frame_count = 1,
				line_length = 1,
				scale = 1,
				shift = {0,-.3},
			},
		},
	},
},{
	type = "item",
	name = "halo-nav-computer",
	subgroup = "space-platform",
	order = "zzz",
	stack_size = 10,
	icon = "__Solar-Halo__/nav-computer/icon.png",
	place_result = "halo-nav-computer",
},{
	type = "recipe",
	name = "halo-nav-computer",
	category = "crafting",
	enabled = false,
	ingredients = {
		{type = "item", name = "low-density-structure", amount = 10},
		{type = "item", name = "processing-unit", amount = 40},
		{type = "item", name = "raw-fish", amount = 1}
	},
	results = {{type = "item", name = "halo-nav-computer", amount = 1}},
	energy_required = 30
},{
	icon = "__Solar-Halo__/nav-computer/nav-pack-grey.png",
	type = "ammo-category",
	name = "halo-compute",
	subgroup = "ammo-category",
},{
	type = "ammo",
	name = "halo-nav-pack",
	stack_size = 50,
	icon = "__Solar-Halo__/nav-computer/nav-pack.png",
	weight = 2^15,
	auto_recycle = true,
	ammo_category = "halo-compute",
	spoil_ticks = 60*60*5,
	magazine_size = 10,
	ammo_type = {
		action = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					type = "script",
					effect_id = "navcomp"
				}
			}
		},
		target_filter = {},
	},
	subgroup = "space-platform",
	order = "zzzz",
},{
	type = "recipe",
	name = "halo-nav-pack",
	category = "crafting-with-fluid",
	enabled = false,
	ingredients = {
		{type = "fluid", name = "halo-compute", amount = 1000}
	},
	results = {{type = "item", name = "halo-nav-pack", amount = 1}},
	energy_required = 3,
	hide_from_player_crafting = true,
}}