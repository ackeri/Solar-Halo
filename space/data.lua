data:extend{{
	type = "space-location",
	name = "halo-solar-orbit",
	order = "aa",
	subgroup = "planets",
	gravity_pull = 150,
	distance = 4,
	orientation = 0.125,
	solar_power_in_space = 10000,
	icon = "__Solar-Halo__/space/solarorbit.png",
	icon_size = 512,
	starmap_icon = "__Solar-Halo__/blank.png",
	starmap_icon_size = 1,
	fly_condition = true,
	auto_save_on_first_trip = true,
	asteroid_spawn_definitions = {{
		asteroid = "halo-flare",
		probability = 0.02,
		speed = 10 * meter/second,
	}},
},{
	type = "space-connection",
	name = "vulcanus-solar",
	subgroup = "planet-connections",
	order = "aa",
	from = "vulcanus",
	to = "halo-solar-orbit",
	length = 30000,
	icons = {{
			icon = "__space-age__/graphics/icons/planet-route.png" 
		},{
			icon = "__space-age__/graphics/icons/vulcanus.png",
			icon_size = 64,
			scale = 0.36,
			shift = {-7, -7}
		},{
			icon = "__Solar-Halo__/space/solarorbit.png",
			icon_size = 512,
			scale = 0.36 * (64 / 512),
			shift = {8, 8},
			tint = {0, 0, 0, 0.3}
		},{
			icon = "__Solar-Halo__/space/solarorbit.png",
			icon_size = 512,
			scale = 0.38 * (64 / 512),
			shift = {6, 6}
	}},
	asteroid_spawn_definitions = {{
		asteroid = "halo-flare",
		spawn_points = {{
			distance = 0.1,
			probability = 0.0001,
			speed = 2 * meter/second,
			angle_when_stopped = 0,
		},{
			distance = 0.3,
			probability = 0.005,
			speed = 4 * meter/second,
			angle_when_stopped = 0,
		},{
			distance = 0.5,
			probability = 0.01,
			speed = 5 * meter/second,
			angle_when_stopped = 0,
		},{
			distance = 0.7,
			probability = 0.015,
			speed = 6 * meter/second,
			angle_when_stopped = 0,
		},{
			distance = 0.9,
			probability = 0.02,
			speed = 7 * meter/second,
			angle_when_stopped = 0,
		}},
	}},
},{
	type = "asteroid",
	name = "halo-flare",
	subgroup = "space-environment",
	order = "zz",
	mass = 100000,
	graphics_set = {
		rotation_speed = 0.05,
		specular_strength = 0,
		normal_strength = 0,
		sss_amount = 0,
		brightness = 1,
		ambient_light = {1,1,1,1},

		lights = {
			color = {1,1,1,1},
			direction = {0,0,-1},
		},
		variations = {{
			color_texture = {
				filename = "__Solar-Halo__/space/flare.png",
				width = 256,
				height = 256,
				scale = 0.5,
			},
			normal_map = {
				filename = "__Solar-Halo__/space/normal.png",
				width = 1,
				height = 1,
				scale = 128,
			},
			roughness_map = {
				filename = "__Solar-Halo__/space/roughness.png",
				width = 1,
				height = 1,
				scale = 128,
			},
		}},
	},
	max_health = 500,
	resistances = {
		{type = "physical", decrease = 0, percent = 99},
		{type = "explosion", decrease = 0, percent = 95},
		{type = "laser", decrease = 0, percent = 50},
	},
	create_ghost_on_death = false,
	icon = "__Solar-Halo__/space/flare.png",
	icon_size = 256,
	collision_box = {{-1.5, -1.5}, {1.5, 1.5}},
	selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
}}