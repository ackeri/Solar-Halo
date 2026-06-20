local util = require("halo-util")
local item_sounds = require("__base__.prototypes.item_sounds")
local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")
local rocket_shift = 48

data:extend{{
	type = "item",
	name = "halo-rocket-silo",
	icon = "__Solar-Halo__/rocketsilo/icon.png",
	subgroup = "space-interactors",
	order = "a[rocket-silo]",
	inventory_move_sound = item_sounds.mechanical_large_inventory_move,
	pick_sound = item_sounds.mechanical_large_inventory_pickup,
	drop_sound = item_sounds.mechanical_large_inventory_move,
	place_result = "halo-rocket-silo",
	weight = 10 * tons,
	stack_size = 1,
},{
	type = "rocket-silo",
	name = "halo-rocket-silo",
	subgroup = "space-interactors",
	icon = "__Solar-Halo__/rocketsilo/icon.png",
	flags = { "placeable-player", "player-creation" },
	fast_transfer_modules_into_module_slots_only = true,
	crafting_categories = { "halo-rocket-building" },
	fast_replaceable_group = "rocket-silo",
	rocket_parts_required = 10,
	rocket_quick_relaunch_start_offset = -0.625,
	cargo_station_parameters = {
		is_input_station = false,
		is_output_station = true,
		hatch_definitions = { silo_cargo_hatch({ 0, 0 }) },
		prefer_packed_cargo_units = true,
	},
	crafting_speed = 1,
	icon_draw_specification = { shift = { 0, 2 } },
	module_slots = 2,
	icons_positioning = {
		{ inventory_index = defines.inventory.assembling_machine_modules, shift = { 0, 3.3 } },
	},
	fixed_recipe = "halo-rocket-part",
	show_recipe_icon = false,
	allowed_effects = {"consumption", "speed", "productivity"},
	effect_receiver = {uses_beacon_effects = false, uses_surface_effects = false},
	minable = { mining_time = 1, result = "halo-rocket-silo" },
	max_health = 6000,
	corpse = "rocket-silo-remnants",
	dying_explosion = "rocket-silo-explosion",
	collision_box = { { -4.20, -4.20 }, { 4.20, 4.20 } },
	selection_box = { { -4.5, -4.5 }, { 4.5, 4.5 } },
	damaged_trigger_effect = hit_effects.entity(),
	hole_clipping_box = { { -2.75, -1.15 }, { 2.75, 2.25 } },
	resistances = {
		{
			type = "fire",
			percent = 60,
		},
		{
			type = "impact",
			percent = 60,
		},
	},
	impact_category = "metal-large",

	energy_source = {
		type = "electric",
		usage_priority = "secondary-input",
		drain = "500MW",
	},
	energy_usage = "50GW",
	fluid_boxes = {{
		pipe_picture = util.pipe_picture,
		pipe_covers = util.pipecoverspictures(),
		volume = 100,
		pipe_connections = {
			{ flow_direction = "input-output", direction = defines.direction.north, position = { 0, -4 } },
			{ flow_direction = "input-output", direction = defines.direction.south, position = { 0, 4 } },
			{ flow_direction = "input-output", direction = defines.direction.east, position = { 4, 0 } },
			{ flow_direction = "input-output", direction = defines.direction.west, position = { -4, 0 } },
		},
		production_type = "input",
	}},
	lamp_energy_usage = "0kW",
	active_energy_usage = "2GW",
	rocket_entity = "halo-rocket-silo-rocket",
	times_to_blink = 3,
	light_blinking_speed = 1 / (3 * 60),
	door_opening_speed = 1 / (4.25 * 60),
	
	circuit_connector = circuit_connector_definitions["rocket-silo"],
	circuit_wire_max_distance = default_circuit_wire_max_distance,
	heating_energy = "300kW",
	launch_to_space_platforms = true,
	to_be_inserted_to_rocket_inventory_size = 20,
	logistic_trash_inventory_size = 20,
	inventory_size = 20,

	base_engine_light = {
		intensity = 0,
		size = 25,
		shift = { 0, 1.5 },
	},

	hole_sprite = {
		filename = "__base__/graphics/entity/rocket-silo/01-rocket-silo-hole.png",
		width = 400,
		height = 270,
		shift = util.factutil.by_pixel(-5, 16),
		scale = 0.5,
	},

	hole_light_sprite = {
		filename = "__base__/graphics/entity/rocket-silo/01-rocket-silo-hole-light.png",
		width = 400,
		height = 270,
		shift = util.factutil.by_pixel(-5, 16),
		tint = { 1, 1, 1, 0 },
		scale = 0.5,
	},

	rocket_shadow_overlay_sprite = {
		filename = "__base__/graphics/entity/rocket-silo/03-rocket-over-shadow-over-rocket.png",
		width = 426,
		height = 288,
		shift = util.factutil.by_pixel(-2, 21),
		scale = 0.5,
	},

	door_back_sprite = {
		filename = "__base__/graphics/entity/rocket-silo/04-door-back.png",
		width = 312,
		height = 286,
		shift = util.factutil.by_pixel(37, 12),
		scale = 0.5,
	},
	door_back_open_offset = { 1.8, -1.8 * 0.43299225 },
	door_front_sprite = {
		filename = "__base__/graphics/entity/rocket-silo/05-door-front.png",
		width = 332,
		height = 300,
		shift = util.factutil.by_pixel(-28, 33),
		scale = 0.5,
	},
	door_front_open_offset = { -1.8, 1.8 * 0.43299225 },

	base_day_sprite = {
		--filename = "__base__/graphics/entity/rocket-silo/06-rocket-silo.png",
		filename = "__Solar-Halo__/rocketsilo/06-rocket-silo.png",
		dice_y = 3,
		width = 608,
		height = 596,
		shift = util.factutil.by_pixel(3, -1),
		scale = 0.5,
	},

	red_lights_back_sprites = {
		layers = {{
			filename = "__base__/graphics/entity/rocket-silo/07-red-lights-back/red-light.png",
			width = 32,
			height = 32,
			shift = { 1.34375, 0.28125 - 1.375 },
			scale = 0.5,
		},{
			filename = "__base__/graphics/entity/rocket-silo/07-red-lights-back/red-light.png",
			width = 32,
			height = 32,
			shift = { 2.3125, 0.9375 - 1.375 },
			scale = 0.5,
		},{
			filename = "__base__/graphics/entity/rocket-silo/07-red-lights-back/red-light.png",
			width = 32,
			height = 32,
			shift = { 2.65625, 1.90625 - 1.375 },
			scale = 0.5,
		},{
			filename = "__base__/graphics/entity/rocket-silo/07-red-lights-back/red-light.png",
			width = 32,
			height = 32,
			shift = { -2.65625, 1.90625 - 1.375 },
			scale = 0.5,
		},{
			filename = "__base__/graphics/entity/rocket-silo/07-red-lights-back/red-light.png",
			width = 32,
			height = 32,
			shift = { -2.3125, 0.9375 - 1.375 },
			scale = 0.5,
		},{
			filename = "__base__/graphics/entity/rocket-silo/07-red-lights-back/red-light.png",
			width = 32,
			height = 32,
			shift = { -1.34375, 0.28125 - 1.375 },
			scale = 0.5,
		},{
			filename = "__base__/graphics/entity/rocket-silo/07-red-lights-back/red-light.png",
			width = 32,
			height = 32,
			shift = { 0, 0 - 1.375 },
			scale = 0.5,
		}},
	},

	red_lights_front_sprites = {
		layers = {{
			filename = "__base__/graphics/entity/rocket-silo/07-red-lights-back/red-light.png",
			width = 32,
			height = 32,
			shift = { 2.3125, 2.8125 - 1.375 },
			scale = 0.5,
		},{
			filename = "__base__/graphics/entity/rocket-silo/07-red-lights-back/red-light.png",
			width = 32,
			height = 32,
			shift = { 1.34375, 3.40625 - 1.375 },
			scale = 0.5,
		},{
			filename = "__base__/graphics/entity/rocket-silo/07-red-lights-back/red-light.png",
			width = 32,
			height = 32,
			shift = { 0, 3.75 - 1.375 },
			scale = 0.5,
		},{
			filename = "__base__/graphics/entity/rocket-silo/07-red-lights-back/red-light.png",
			width = 32,
			height = 32,
			shift = { 0, 3.75 - 1.375 },
			scale = 0.5,
		},{
			filename = "__base__/graphics/entity/rocket-silo/07-red-lights-back/red-light.png",
			width = 32,
			height = 32,
			shift = { -2.3125, 2.8125 - 1.375 },
			scale = 0.5,
		}},
	},

	base_front_sprite = {
		filename = "__Solar-Halo__/rocketsilo/14-rocket-silo-front.png",
		width = 580,
		height = 262,
		shift = util.factutil.by_pixel(-1, 78),
		scale = 0.5,
	},
	silo_fade_out_start_distance = 8,
	silo_fade_out_end_distance = 15,

	alarm_sound = "__base__/sound/silo-alarm.ogg",
	quick_alarm_sound = {
		filename = "__base__/sound/silo-alarm-short.ogg",
		volume = 1.0,
		aggregation = { max_count = 2, remove = true, count_already_playing = true },
	},
	clamps_on_sound = {
		filename = "__base__/sound/silo-clamps-on.ogg",
		volume = 1.0,
		aggregation = { max_count = 1, remove = false, count_already_playing = true },
	},
	clamps_off_sound = {
		filename = "__base__/sound/silo-clamps-off.ogg",
		volume = 0.8,
		aggregation = { max_count = 1, remove = false, count_already_playing = true },
	},
	doors_sound = {
		filename = "__base__/sound/silo-doors.ogg",
		volume = 0.8,
		aggregation = { max_count = 3, remove = true, count_already_playing = true },
	},
	raise_rocket_sound = {
		filename = "__base__/sound/silo-raise-rocket.ogg",
		volume = 1.0,
		aggregation = { max_count = 2, remove = true, count_already_playing = true },
	},
	open_sound = { filename = "__base__/sound/open-close/silo-open.ogg", volume = 0.7 },
	close_sound = { filename = "__base__/sound/open-close/silo-close.ogg", volume = 0.7 },
	working_sound = {
		sound = {
			filename = "__base__/sound/accumulator-discharging.ogg",
			volume = 0.8,
			aggregation = { max_count = 3, remove = true, count_already_playing = true },
		},
		fade_in_ticks = 10,
		fade_out_ticks = 15,
	},
},
{
	type = "rocket-silo-rocket",
	name = "halo-rocket-silo-rocket",
	flags = { "not-on-map" },
	hidden = true,
	collision_mask = { layers = {}, not_colliding_with_itself = true },
	collision_box = { { -2, -7 }, { 2, 4 } },
	selection_box = { { 0, 0 }, { 0, 0 } },
	dying_explosion = "massive-explosion",
	shadow_slave_entity = "rocket-silo-rocket-shadow",
	inventory_size = 20,
	rising_speed = 1 / (3 * 60),
	engine_starting_speed = 1000000000,
	flying_speed = 1 / (2000 * 60),
	flying_acceleration = 10.0,
	icon_draw_specification = { render_layer = "air-entity-info-icon" },
	glow_light = {
		intensity = 1,
		size = 30,
		shift = { 0, 1.5 },
		color = { 1, 1, 1 },
	},
	cargo_pod_entity = "cargo-pod",
	rocket_sprite = {
		layers = {
			util.factutil.sprite_load("__base__/graphics/entity/rocket-silo/rocket-static-pod", {
				dice_y = 4,
				shift = util.factutil.by_pixel(0, 17.0 + rocket_shift),
				scale = 0.5,
			})
		},
	},

	rocket_shadow_sprite = util.factutil.sprite_load("__base__/graphics/entity/rocket-silo/rocket-static-pod-shadow", {
		priority = "medium",
		shift = util.factutil.by_pixel(-80, -210 + rocket_shift),
		draw_as_shadow = true,
		scale = 0.5,
	}),
	rocket_flame_left_rotation = 0.0611,
	rocket_flame_right_rotation = 0.952,
	rocket_initial_offset = { 0, 3 },
	rocket_rise_offset = { 0, 1 },
	rocket_launch_offset = { 0, -1256 },
	cargo_attachment_offset = util.factutil.by_pixel(0, -63.4),
	rocket_render_layer_switch_distance = 9.5,
	full_render_layer_switch_distance = 11,
	effects_fade_in_start_distance = 4.5,
	effects_fade_in_end_distance = 7.5,
	shadow_fade_out_start_ratio = 0.25,
	shadow_fade_out_end_ratio = 0.75,
	rocket_visible_distance_from_center = 2.75,
	rocket_above_wires_slice_offset_from_center = -3,
	rocket_air_object_slice_offset_from_center = -6,
	
	flying_sound = {
		filename = "__space-age__/sound/entity/railgun-turret/railgun-turret-gunshot-2.ogg",
		volume = 1.0,
		modifiers = volume_multiplier("main-menu", 0.6),
		audible_distance_modifier = 6,
		aggregation = { max_count = 3, remove = true, count_already_playing = true, priority = "oldest" },
	},
},{
	type = "recipe-category",
	name = "halo-rocket-building",
},{
	type = "recipe",
	name = "halo-rocket-part",
	icons = {{
		icon = "__base__/graphics/icons/rocket-part.png", 
		icon_size = 64 
	}},
	energy_required = 3,
	enabled = true,
	hide_from_player_crafting = true,
	auto_recycle = false,
	category = "halo-rocket-building",
	order = "b[rocket-part]a",
	ingredients = {
		{ type = "item", name = "low-density-structure", amount = 1 },
		{ type = "fluid", name = "halo-compute", amount = 1000 },
	},
	results = { { type = "item", name = "rocket-part", amount = 1 } },
	main_product = "rocket-part",
	allow_productivity = true,
},{
	type = "recipe",
	name = "halo-rocket-silo",
	icons = {{
		icon = "__Solar-Halo__/rocketsilo/icon.png", 
		icon_size = 64 
	}},
	energy_required = 120,
	enabled = false,
	hide_from_player_crafting = true,
	category = "electromagnetics",
	ingredients = {
		{ type = "item", name = "concrete", amount = 1000 },
		{ type = "item", name = "steel-plate", amount = 500 },
		{ type = "item", name = "electric-engine-unit", amount = 800 },
		{ type = "item", name = "supercapacitor", amount = 1000 },
		{ type = "item", name = "superconductor", amount = 400 },
	},
	results = { { type = "item", name = "halo-rocket-silo", amount = 1 } },
}}



data.raw.item["halo-rocket-silo"].flags = data.raw.item["rocket-silo"].flags or {}
table.insert(data.raw.item["halo-rocket-silo"].flags, "draw-logistic-overlay")

