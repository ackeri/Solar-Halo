--data.lua
require("space.data")
require("computer.data")
require("terminal.data")
require("heatpump.data")
require("heatsink.data")
require("thermostat.data")
require("nav-computer.data")
require("gmo.data")
require("technology.data")

data:extend{{
	type = "fluid",
	name = "halo-heat-energy",
	icon = "__base__/graphics/icons/signal/signal-thermometer-red.png",
	default_temperature = 15,
	base_color = {r=0,g=0,b=0,a=0},
	flow_color = {r=0,g=0,b=0,a=0},
	auto_barrel = false,
	fuel_value = "1MJ",
	max_temperature = 999,
	hidden = true
}}
