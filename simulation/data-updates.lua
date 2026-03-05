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

local recipewhitelist = {
	"automation-science-pack",
	"logistic-science-pack",
	"chemical-science-pack",
	"space-science-pack",
	"halo-science-pack"
}

local whitelist = {
	"production-science-pack",
	"utility-science-pack",
	"military-science-pack",
	"metallurgic-science-pack",
	"agricultural-science-pack",
	"electromagnetic-science-pack",
	"cryogenic-science-pack",
	"promethium-science-pack",
	"halo-science-pack",
	"pelagos-science-pack",
	"hydraulic-science-pack",
	"battlefield-science-pack",
	"electrochemical-science-pack",
}

function contains(list, element)
	for _,v in ipairs(list) do
		if v == element then
			return true
		end
	end
	return false
end

local sims = {}
for tool, tech in pairs(sciences) do
	if contains(recipewhitelist, tool.name) or
		contains(whitelist, tool.name) then
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
			allow_productivity = true,
			hide_from_player_crafting = true,
			hidden_in_factoriopedia = true,
		}
		table.insert(sims, newr)
	end
	if contains(whitelist, tool.name) then
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