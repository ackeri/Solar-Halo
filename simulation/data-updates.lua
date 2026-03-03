local util = require("util")

function outputsTool(recipe)
	if data.raw["recipe"][recipe] and data.raw["recipe"][recipe].results then
		for _,r in ipairs(data.raw["recipe"][recipe].results) do
			local proto = data.raw["tool"][r.name]
			if proto then
				return proto
			end
		end
	end
end

local sciences = {}
for name, proto in pairs(data.raw["technology"]) do
	if proto.effects then
		for _,eff in ipairs(proto.effects) do
			if eff.type == "unlock-recipe" then
				local tool = outputsTool(eff.recipe)
				if tool then
					sciences[tool] = proto
				end
			end
		end
	end
end

function genIngredients(name)
	local packs = {"automation-science-pack", "logistic-science-pack", "chemical-science-pack", "space-science-pack", "halo-science-pack"}
	local out = {}
	for _,p in ipairs(packs) do
		if name ~= p then
			table.insert(out, {p, 1})
		end
	end
	table.insert(out, {name, 1})
	return out
end

local sims = {}
for tool, tech in pairs(sciences) do
	local newr = {
		type = "recipe",
		name = "halo-" .. tool.name,
		localised_name = {"halo-name-simulate", util.getLocalName(tool)},
		enabled = false,
		category = "crafting-with-fluid",
		ingredients = {
			{type = "fluid", name = "halo-compute", amount = 10000}
		},
		results = {{type = "item", name = tool.name, amount = 1}},
		energy_required = 0.5,
		hide_from_player_crafting = true,
		hidden_in_factoriopedia = true,
	}
	table.insert(sims, newr)
	if tech.name ~= "automation-science-pack" and
		tech.name ~= "logistic-science-pack" and
		tech.name ~= "chemical-science-pack" and
		tech.name ~= "space-science-pack" and
		tech.name ~= "halo-science-pack" then
		local newt = {
			type = "technology",
			name = "halo-sim-" .. tool.name,
			localised_name = {"halo-name-simulate", util.getLocalName(tool)},
			localised_description = {"halo-description-simulate"},
			icon = tool.icon,
			icon_size = tool.icon_size,
			icons = tool.icons,
			essential = false,
			unit = {count = 2000, time = 30, ingredients = genIngredients(tool.name)},
			prerequisites = {"halo-sim", tech.name},
			effects = {{
				type = "unlock-recipe",
				recipe = "halo-" .. tool.name
			}}
		}
		table.insert(sims, newt)
	end
end

data:extend(sims)