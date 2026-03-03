local util = require("util")

local cb = {{-3.9,-3.9}, {3.9,3.9}}
local sb = {{-4,-4}, {4,4}}

data:extend{{
    type = "assembling-machine",
    name = "halo-terminal",

    icon = "__Solar-Halo__/terminal/icon.png",
    collision_box = cb,
    selection_box = sb,

    crafting_speed = 1,
    crafting_categories = {"halo-terminal"},
    energy_usage = "520MW",
    energy_source = {
        type = "electric",
        buffer_capacity = "500MJ",
        usage_priority = "tertiary",
        drain = "4MW"
    },

    module_slots = 2,
    allowed_effects = {"speed", "consumption"},
    effect_receiver = {
        uses_beacon_effects = false,
        uses_surface_effects = false,
    },
	circuit_wire_max_distance = 12,

	dying_explosion = "laser-turret-explosion",
	corpse = "fusion-reactor-remnants",

    emissions_per_second = {},
	health = 200,
    placeable_by = {item = "halo-terminal", count = 1},
    minable = {
        mining_time = 2,
        result = "halo-terminal"
    },
    fluid_boxes_off_when_no_fluid_recipe = false,
    fluid_boxes = {
        {
			pipe_picture = util.pipe_picture,
			pipe_picture_frozen = util.pipe_frozen,
			pipe_covers = util.pipecoverspictures(),
			secondary_draw_order = -5,
            volume = 10,
            pipe_connections = {{
                position = {x = -3.5, y = -3.5},
                direction = defines.direction.north
            }},
            production_type = "input"
        },{
			pipe_picture = util.pipe_picture,
			pipe_picture_frozen = util.pipe_frozen,
			pipe_covers = util.pipecoverspictures(),
			secondary_draw_order = -5,
            volume = 10,
            pipe_connections = {{
                position = {x = -3.5, y = -2.5},
                direction = defines.direction.west
            }},
            production_type = "output"
		},{
			pipe_picture = util.pipe_picture,
			pipe_picture_frozen = util.pipe_frozen,
			pipe_covers = util.pipecoverspictures(),
			secondary_draw_order = -5,
            volume = 10,
            pipe_connections = {{
                position = {x = -2.5, y = -3.5},
                direction = defines.direction.north
            }},
            production_type = "input"
        },{
			pipe_picture = util.pipe_picture,
			pipe_picture_frozen = util.pipe_frozen,
			pipe_covers = util.pipecoverspictures(),
			secondary_draw_order = -5,
            volume = 10,
            pipe_connections = {{
                position = {x = -3.5, y = -3.5},
                direction = defines.direction.west
            }},
            production_type = "output"
        },{
            volume = 10500,
            pipe_connections = {{
                connection_type = "linked",
                linked_connection_id = 1
            }},
            production_type = "output"
        }
    },
	
	open_sound = "__base__/sound/gate-open-2.ogg",
	close_sound = "__base__/sound/gate-close-5.ogg",
	working_sound = "__base__/sound/beacon-var-2.ogg",
	impact_category = "metal",
    damaged_trigger_effect = util.hit_effects.entity(),
	
	graphics_set = {
		animation = {
			layers = {{
					filename = "__Solar-Halo__/terminal/animation.png",
					width = 530,
					height = 530,
					frame_count = 1,
					line_length = 1,
					shift = {0,0},
					scale = 0.5,
				},{
					filename = "__Solar-Halo__/terminal/shadow.png",
					width = 1000,
					height = 666,
					frame_count = 1,
					shift = {0,0},
					scale = 0.5,
					draw_as_shadow = true,
			}}
		},
		working_visualisations = {{
			apply_tint = "status",
			always_draw = true,
			animation = {
				filename = "__Solar-Halo__/terminal/glow.png",
				width = 530,
				height = 530,
				frame_count = 1,
				line_length = 1,
				shift = {0,0},
				scale = 0.5,
				draw_as_glow = true,
				blend_mode = "additive",
			}
		}},
		frozen_patch = {
			filename = "__Solar-Halo__/terminal/frozen.png",
			width = 530,
			height = 530,
			scale = 0.5
		},
		status_colors = {
			idle = {0,0,0,0},
			working = {0,0.5,0.5,1},
			full_output = {0,0,1,1},
		},
	}
},{
	type = "generator",
	name = "halo-terminal-turbine",
	collision_box = cb,
	selection_box = sb,
	selection_priority = 1,
	icon = "__Solar-Halo__/terminal/icon.png",
	energy_source = {
		type = "electric",
		usage_priority = "tertiary",
	},
	fluid_box = {
		volume = 500,
		pipe_connections = {{
			connection_type = "linked",
			linked_connection_id = 1
		}},
		production_type = "input",
		filter = "halo-energy-proxy"
	},
	fluid_usage_per_tick = 1000,
	maximum_temperature = 15,
	scale_fluid_usage = true,
	burns_fluid = true,
	max_power_output = "20GW",
	selectable_in_game = false,
	hidden = true,
	hidden_in_factoriopedia = true,
	flags = {"not-on-map", "not-deconstructable", "not-blueprintable", "hide-alt-info", "not-flammable", "not-selectable-in-game"},
},{
	type = "item",
	name = "halo-terminal",
	order = "zz",
	subgroup = "energy",
	stack_size = 10,
	icon = "__Solar-Halo__/terminal/icon.png",
	place_result = "halo-terminal",
	pick_sound = "__base__/sound/item/energy-shield-inventory-pickup.ogg",
	inventory_move_sound = "__base__/sound/item/energy-shield-inventory-move.ogg",
},{
	type = "recipe",
	category = "electromagnetics",
	name = "halo-terminal",
	enabled = false,
	energy_required = 5,
	ingredients = {
	{type = "item", name = "holmium-plate", amount = 50},
	{type = "item", name = "accumulator", amount = 10},
	{type = "item", name = "storage-tank", amount = 2},
	{type = "item", name = "advanced-circuit", amount = 20}
	},
	results = {{type = "item", name = "halo-terminal", amount = 1}},
	allow_productivity = false
},{
	type = "fluid",
	name = "halo-charged-electrolyte",
	icon = "__Solar-Halo__/terminal/charged.png",
	default_temperature = 15,
	base_color = {r=1,g=0.5,b=1,a=1},
	flow_color = {r=1,g=0.5,b=1,a=1},
	auto_barrel = true,
	subgroup = "fluid",
	order = "electrolyte2"
	--1 GJ per fluid, 5000 per rocket (compared to 160 for fuel cells or 4000 for fusion)
},{
	type = "fluid",
	name = "halo-energy-proxy",
	icon = "__Solar-Halo__/terminal/energy.png",
	default_temperature = 15,
	base_color = {0,0,0,0},
	flow_color = {0,0,0,0},
	auto_barrel = false,
	subgroup = "fluid",
	hidden = true,
	hidden_in_factoriopedia = true,
	fuel_value = "1MJ",
},{
	type = "recipe-category",
	name = "halo-terminal",
},{
	type = "recipe",
	category = "halo-terminal",
	name = "halo-charge",
	enabled = false,
	energy_required = 2,
	ingredients = {
		{type = "fluid", name = "electrolyte", amount = 1, fluidbox_index = 1}
	},
	results = {
		{type = "fluid", name = "halo-charged-electrolyte", amount = 1, fluidbox_index = 1}
	},
	allow_productivity = false,
	allow_quality = false,
	allow_consumption = false,
	allow_speed = false,
	subgroup = "fulgora-processes",
	order = "zza",
	hide_from_player_crafting = true,
},{
	type = "recipe",
	category = "halo-terminal",
	name = "halo-discharge",
	icon = "__Solar-Halo__/terminal/energy.png",
	enabled = false,
	energy_required = .1,
	ingredients = {
		{type = "fluid", name = "halo-charged-electrolyte", amount = 1, fluidbox_index = 2}
	},
	results = {
		{type = "fluid", name = "electrolyte", amount = 1, fluidbox_index = 2},
		{type = "fluid", name = "halo-energy-proxy", amount = 1000, fluidbox_index = 3}
	},
	allow_productivity = false,
	allow_quality = false,
	subgroup = "fulgora-processes",
	order = "zzb",
	hide_from_player_crafting = true,
}}