local util = require("util")

data:extend{{
	type = "reactor",
	name = "halo-thermostat",
	heat_buffer = {
		max_temperature = 999,
		specific_heat = "2MJ",
		max_transfer = "10MW",
		connections = {
			{position = {x = 0, y = 0}, direction = 0},
			{position = {x = 0, y = 0}, direction = 4},
			{position = {x = 0, y = 0}, direction = 8},
			{position = {x = 0, y = 0}, direction = 12}
		}
	},
	neighbour_bonus = 0,
	heating_radius = 1,
	energy_source = {type = "void"},
	consumption = "1W",
	scale_energy_usage = true,
	max_health = 200,
	icon = "__Solar-Halo__/thermostat/icon.png",
    corpse = "heat-pipe-remnants",
    dying_explosion = "heat-pipe-explosion",
    random_corpse_variation = true,
    impact_category = "metal",
    resistances =
    {
      {
        type = "fire",
        percent = 90
      },
      {
        type = "explosion",
        percent = 30
      },
      {
        type = "impact",
        percent = 30
      }
    },
	collision_box = {{-.1,-.1}, {0.1,0.1}},
	selection_box = {{-0.5,-0.5}, {0.5,0.5}},
	flags = {"player-creation"},
	circuit_wire_max_distance = 12,
	minable = {
		mining_time = 0.1,
		result = "halo-thermostat"
	},
	placeable_by = {item = "halo-thermostat", count = 1},
	tile_width = 1,
	tile_height = 1,
	default_temperature_signal = {type = "virtual", name = "signal-T"},
	picture = {
		filename = "__Solar-Halo__/thermostat/animation.png",
		size = {64,64},
		scale = 0.5,
	},
},{
	type = "item",
	name = "halo-thermostat",
	subgroup = "environmental-protection",
	stack_size = 50,
	icon = "__Solar-Halo__/thermostat/icon.png",
	place_result = "halo-thermostat"
},{
	type = "recipe",
	name = "halo-thermostat",
	category = "crafting",
	enabled = false,
	ingredients = {
		{type = "item", name = "heat-pipe", amount = 1},
		{type = "item", name = "advanced-circuit", amount = 2}
	},
	results = {{type = "item", name = "halo-thermostat", amount = 1}},
	energy_required = 3
}}