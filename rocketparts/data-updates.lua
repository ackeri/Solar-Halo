function newrecipe(proto)
	local newr = table.deepcopy(proto)
	newr.name = "halo-" .. proto.name
	if newr.icon then
		newr.icons = {{
			icon = newr.icon,
			icon_size = newr.icon_size,
		}}
		newr.icon = nil
		newr.icon_size = nil
	end
	if newr.icons == nil then newr.icons = {} end
	table.insert(newr.icons,1,{
		icon = "__Solar-Halo__/computer/compute.png",
		icon_size = 64,
	})
	
	local usesProc = false
	for _,ing in ipairs(newr.ingredients) do
		if ing.name == "processing-unit" and ing.type == "item" then
			ing.type = "fluid"
			ing.name = "halo-compute"
			ing.amount = ing.amount * 1000
			usesProc = true
		end
	end
	
	if usesProc then
		return newr
	else
		return newr --nil
	end
end

local tech = data.raw["technology"]["halo-rocket"]
local newrecipes = {}
for name, proto in pairs(data.raw["recipe"]) do
	if proto.results and proto.results[1] and proto.results[1].name == "rocket-part" then
		local newr = newrecipe(proto)
		if newr then
			table.insert(newrecipes, newr)
			table.insert(tech.effects, {
				type = "unlock-recipe",
				recipe = newr.name
			})
		end
	end
end
data:extend(newrecipes)

---------Rocket Silo Fix---------
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
