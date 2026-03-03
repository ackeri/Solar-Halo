

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
--TODO search all recipes to replace

---------Rocket Silo Fix---------
for name, proto in pairs(data.raw["rocket-silo"]) do
	proto.fixed_recipe = nil
	if proto.fluid_boxes == nil or #proto.fluid_boxes < 2 then
		local mi = proto.collision_box.left_top or proto.collision_box[1]
		local ma = proto.collision_box.right_bottom or proto.collision_box[2]
		local minx = mi.x or mi[1]
		local maxx = ma.x or ma[1]
		local miny = mi.y or mi[2]
		local maxy = ma.y or ma[2]
		proto.fluid_boxes = {{
				volume = 500,
				pipe_connections = {{
						direction = defines.direction.west,
						position = {x = minx, y = 0}
					},{
						direction = defines.direction.east,
						position = {x = maxx, y = 0}
				}},
				production_type = "input"
			},{
				volume = 500,
				pipe_connections = {{
						direction = defines.direction.north,
						position = {x = 0, y = miny}
					},{
						direction = defines.direction.south,
						position = {x = 0, y = maxy}
				}},
				production_type = "input"
		}}
	end
end