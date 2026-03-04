local util = require("util")

local shpipe = table.deepcopy(data.raw["item"]["heat-pipe"])
shpipe.name = "halo-superheated-pipe"
shpipe.fuel_category = "chemical"
shpipe.burnt_result = "heat-pipe"
shpipe.fuel_value = "350MJ"
shpipe.fuel_emissions_multiplier = 0
shpipe.localised_name = "superheated heat pipe"
shpipe.order = shpipe.order .. "1"
shpipe.hide_from_player_crafting = true
shpipe.auto_recycle = false
data:extend{shpipe}


data:extend{{
	type = "assembling-machine",
	name = "halo-heatsink",
	icon = "__Solar-Halo__/heatsink/icon.png",
	fluid_boxes_off_when_no_fluid_recipe = false,
	energy_source = {type = "void"},
	energy_usage = "1W",
	crafting_speed = 1,
	crafting_categories = {"halo-heatsink"},
    fast_replaceable_group = "heat-exchanger",
    damaged_trigger_effect = util.hit_effects.entity(),
	fluid_boxes = {{
			volume = 1000,
			pipe_connections = {{
				connection_type = "linked",
				linked_connection_id = 1
			}},
			production_type = "input"
		},{
			volume = 1000,
			pipe_connections = {{
				connection_type = "linked",
				linked_connection_id = 2
			}},
			production_type = "input"
		},{
			pipe_picture = pipe_picture,
			pipe_picture_frozen = pipe_frozen,
			pipe_covers = pipecoverspictures(),
			secondary_draw_order = -5,
			volume = 200,
			pipe_connections = {
				{
					connection_type = "normal",
					direction = defines.direction.west,
					position = { x = -1, y = 0.5 }
				},{
					connection_type = "normal",
					direction = defines.direction.east,
					position = { x = 1, y = 0.5 }
				}
			}, 
			production_type = "input"
		},{
			pipe_picture = pipe_picture,
			pipe_picture_frozen = pipe_frozen,
			pipe_covers = pipecoverspictures(),
			secondary_draw_order = -5,
			volume = 100,
			pipe_connections = {{
				connection_type = "normal",
				direction = defines.direction.north,
				position = { x = 0, y = -0.5 },
				flow_direction = "output"
			}},
			production_type = "output"
		}
	},
    corpse = "heat-exchanger-remnants",
    dying_explosion = "heat-exchanger-explosion",
    open_sound = util.sounds.steam_open,
    close_sound = util.sounds.steam_close,
	working_sound = {
		sound = {
			filename = "__base__/sound/heat-exchanger.ogg",
			volume = 0.65,
			modifiers = volume_multiplier("main-menu", 0.7),
			audible_distance_modifier = 0.5,
		},
		fade_in_ticks = 4,
		fade_out_ticks = 20
	},
	circuit_wire_max_distance = 12,
	max_health = 300,
	collision_box = {{-1.45,-1}, {1.45,.9}},
	selection_box = {{-1.5,-1}, {1.5,1}},
	flags = {"player-creation"},
	minable = {
		mining_time = 0.1,
		result = "halo-heatsink"
	},
	placeable_by = {item = "halo-heatsink", count = 1},
	tile_width = 3,
	tile_height = 2,
	graphics_set = {
		animation = {
			north = {
				layers = {{
						filename = "__Solar-Halo__/heatsink/animationN.png",
						size = {269, 221},
						scale = 0.5,
						shift = {-0.12,0.2},
					},{
						filename = "__base__/graphics/entity/boiler/boiler-N-shadow.png",
						size = {274, 164},
						scale = 0.5,
						draw_as_shadow = true,
						shift = {0.2,0.1},
				}}
			}, east = {
				layers = {{
						filename = "__Solar-Halo__/heatsink/animationE.png",
						size = {211, 301},
						scale = 0.5,
						shift = {-0.1,0}
					},{
						filename = "__base__/graphics/entity/boiler/boiler-E-shadow.png",
						size = {184, 194},
						scale = 0.5,
						draw_as_shadow = true,
						shift = {0.2,0.1},
				}}
			}, south = {
				layers = {{
						filename = "__Solar-Halo__/heatsink/animationS.png",
						size = {260, 201},
						scale = 0.5,
						shift = {0.1,0.1}
					},{
						filename = "__base__/graphics/entity/boiler/boiler-S-shadow.png",
						size = {311, 131},
						scale = 0.5,
						draw_as_shadow = true,
						shift = {0.2,0.1},
				}}
			}, west = {
				layers = {{
						filename = "__Solar-Halo__/heatsink/animationW.png",
						size = {196, 273},
						scale = 0.5,
						shift = {0.1,0.1}
					},{
						filename = "__base__/graphics/entity/boiler/boiler-W-shadow.png",
						size = {206,218},
						scale = 0.5,
						draw_as_shadow = true,
						shift = {0.2,0.1},
				}}
			}
		},
		
		
	}
},{
	type = "assembling-machine",
	fixed_recipe = "halo-heatsinkreceiverlow",
	crafting_speed = 1,
	crafting_categories = {"halo-heatpump"},
	energy_source = {
		type = "heat",
		max_temperature = 999,
		specific_heat = "3MJ",
		max_transfer = "500MW",
		min_working_temperature = 160,
		connections = {
			{
				position = {x = -1, y = 0.5},
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
	show_recipe_icon = false,
	show_recipe_icon_on_map = false,
	flags = {"not-on-map", "not-deconstructable", "not-blueprintable", "hide-alt-info", "not-flammable", "not-selectable-in-game"},
	selectable_in_game = false,
	name = "halo-heatsinklowreceiver",
	hidden = true,
	collision_box = {{-1.2,-0.8}, {1.2,.8}},
	selection_box = {{-1.5,-1}, {1.5,1}},
	selection_priority = 1,
	tile_width = 3,
	tile_height = 2
},{
	type = "assembling-machine",
	fixed_recipe = "halo-heatsinkreceiverhigh",
	crafting_speed = 1,
	crafting_categories = {"halo-heatpump"},
	energy_source = {
		type = "heat",
		max_temperature = 999,
		specific_heat = "3MJ",
		max_transfer = "500MW",
		min_working_temperature = 800,
		connections = {
			{
				position = {x = 1, y = 0.5},
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
	show_recipe_icon = false,
	show_recipe_icon_on_map = false,
	flags = {"not-on-map", "not-deconstructable", "not-blueprintable", "hide-alt-info", "not-flammable", "not-selectable-in-game"},
	selectable_in_game = false,
	name = "halo-heatsinkhighreceiver",
	hidden = true,
	collision_box = {{-1.2,-0.8}, {1.2,.8}},
	selection_box = {{-1.5,-1}, {1.5,1}},
	selection_priority = 1,
	tile_width = 3,
	tile_height = 2
},{
	type = "item",
	name = "halo-heatsink",
	icon = "__Solar-Halo__/heatsink/icon.png",
	subgroup = "environmental-protection",
	stack_size = 10,
	place_result = "halo-heatsink"
},{
	type = "recipe",
	name = "halo-heatsink",
	category = "crafting",
	enabled = false,
	ingredients = {
		{type = "item", name = "copper-plate", amount = 100},
		{type = "item", name = "pipe", amount = 10},
		{type = "item", name = "steel-plate", amount = 10}
	},
	results = {{type = "item", name = "halo-heatsink", amount = 1}},
	energy_required = 3
},{
	type = "recipe",
	name = "halo-heatsinkreceiverlow",
	category = "halo-heatpump",
	enabled = true,
	energy_required = 0.01,
	ingredients = {},
	results = {{
		type = "fluid", 
		name = "halo-heat-energy", 
		amount = 10,
		temperature = 160
	}},
	hidden = true,
	hidden_in_factoriopedia = true,
},{
	type = "recipe",
	name = "halo-heatsinkreceiverhigh",
	category = "halo-heatpump",
	enabled = true,
	energy_required = 0.01,
	ingredients = {},
	results = {{
		type = "fluid", 
		name = "halo-heat-energy", 
		amount = 10,
		temperature = 800
	}},
	hidden = true,
	hidden_in_factoriopedia = true,
},{
	type = "recipe-category",
	name = "halo-heatsink"
},{
	type = "recipe",
	name = "halo-heatsink-low",
	category = "halo-heatsink",
	icon = "__base__/graphics/icons/signal/signal-thermometer-blue.png",
	enabled = false,
	energy_required = 0.1,
	ingredients = {{
		type = "fluid", 
		name = "halo-heat-energy", 
		amount = 1,
		fluidbox_index = 1
	}},
	results = {},
	hide_from_player_crafting = true,
	subgroup = "fluid-recipes",
	order = "zzza",
},{
	type = "recipe",
	name = "halo-heatsink-high",
	category = "halo-heatsink",
	icon = "__base__/graphics/icons/signal/signal-thermometer-red.png",
	enabled = false,
	energy_required = 0.01,
	ingredients = {{
		type = "fluid", 
		name = "halo-heat-energy", 
		amount = 1,
		fluidbox_index = 2
	}},
	results = {},
	hide_from_player_crafting = true,
	subgroup = "fluid-recipes",
	order = "zzzb",
},{
	type = "recipe",
	name = "halo-heatsink-steam",
	category = "halo-heatsink",
	icon = "__base__/graphics/icons/fluid/steam.png",
	enabled = false,
	energy_required = 0.05,
	ingredients = {
		{
			type = "fluid", 
			name = "halo-heat-energy", 
			amount = 1,
			fluidbox_index = 1
		},{
			type = "fluid",
			name = "water",
			amount = 3,
			fluidbox_index = 3
		}
	},
	results = {{
		type = "fluid",
		name = "steam",
		amount = 30,
		temperature = 165
	}},
	hide_from_player_crafting = true,
	subgroup = "fluid-recipes",
	order = "zzzc",
},{
	type = "recipe",
	name = "halo-heatsink-coolant",
	category = "halo-heatsink",
	icon = "__space-age__/graphics/icons/fluid/fluoroketone-cold.png",
	enabled = false,
	energy_required = 0.01,
	ingredients = {
		{
			type = "fluid", 
			name = "halo-heat-energy", 
			amount = 1,
			fluidbox_index = 1
		},{
			type = "fluid",
			name = "fluoroketone-cold",
			amount = 10,
			fluidbox_index = 3
		}
	},
	results = {{
		type = "fluid",
		name = "fluoroketone-hot",
		amount = 10
	}},
	hide_from_player_crafting = true,
	subgroup = "fluid-recipes",
	order = "zzzd",
},{
	type = "recipe",
	name = "halo-heatsink-pipe",
	category = "halo-heatsink",
	enabled = false,
	energy_required = 100,
	ingredients = {
		{
			type = "fluid", 
			name = "halo-heat-energy", 
			amount = 1000,
			fluidbox_index = 2
		},{
			type = "item",
			name = "heat-pipe",
			amount = 1
		}
	},
	results = {{
		type = "item",
		name = "halo-superheated-pipe",
		amount = 1
	}},
	hide_from_player_crafting = true,
	subgroup = "fluid-recipes",
	order = "zzze",
}}
