local rocketrecipe = {
	type = "recipe",
	name = "halo-rocket",
	category = "rocket-building",
	enabled = false,
	ingredients = {
		{type = "item", name = "rocket-fuel", amount = 1},
		{type = "item", name = "low-density-structure", amount = 1},
		{type = "fluid", name = "halo-compute", amount = 1000},
	},
	results = {{type = "item", name = "rocket-part", amount = 1}},
	energy_required = 3,
	hide_from_player_crafting = true,
}
data:extend{rocketrecipe}

for name, proto in pairs(data.raw["rocket-silo"]) do
	if proto.fixed_recipe == "rocket-part" then
		proto.fixed_recipe = nil
		proto.disabled_when_recipe_not_researched = true
	end

	if name == "rocket-silo" and proto.fluid_boxes == nil then
		proto.fluid_boxes = {{
				volume = 500,
				pipe_connections = {{
						direction = defines.direction.west,
						position = {x = -4, y = -4}
				}},
				production_type = "input"
		}}
	end
end
