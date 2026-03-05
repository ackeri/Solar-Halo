local util = require("util")

local modules = data.raw["module"]
local newmodules = {}
local unlocks = data.raw["technology"]["halo-module"].effects

function bound(min, val, max)
	if val < min then
		return min
	elseif val > max then
		return max
	else
		return val
	end
end

for name,proto in pairs(modules) do
	local newm = table.deepcopy(proto)
	newm.name = "halo-charged-"..name
	newm.tier = newm.tier + 1
	newm.hidden = true
	
	if newm.icon then
		newm.icons = {{
			icon = newm.icon,
			icon_size = newm.icon_size,
		}}
	end
	table.insert(newm.icons,1,{
		icon = "__Solar-Halo__/modules/frame.png",
		icon_size = 64,
	})
	newm.localised_name = {"halo-name-charged", util.getLocalName(proto)}
	newm.localised_description = {"halo-description-charged", util.getLocalName(proto)}
	
	newm.spoil_ticks = 60*60*60
	newm.spoil_result = name
	newm.auto_recycle = false
	
	local e = newm.effect
	if e.consumption ~= nil then
		e.consumption = bound(-325, e.consumption * 2, 325)
	end
	if e.speed ~= nil then
		e.speed = bound(-325, e.speed * 2, 325)
	end
	if e.productivity ~= nil then
		e.productivity = bound(-325, e.productivity * 2, 325)
	end
	if e.pollution ~= nil then
		e.pollution = bound(-325, e.pollution * 2, 325)
	end
	if e.quality ~= nil then
		e.quality = bound(-325, e.quality * 2, 325)
	end
	table.insert(newmodules, newm)
	
	local newmrecipe = {
		type = "recipe",
		name = newm.name,
		category = "crafting-with-fluid",
		ingredients = {
			{type = "item", name = name, amount = 1},
			{type = "fluid", name = "halo-compute", amount = 100000}
		},
		results = {{type = "item", name = newm.name, amount = 1}},
		allow_productivity = false,
		allow_quality = false,
		energy_required = 30,
		hide_from_player_crafting = true,
	}
	table.insert(newmodules, newmrecipe)
	
	local newunlock = {
		type = "unlock-recipe",
		recipe = newm.name
	}
	table.insert(unlocks, newunlock)
end

data:extend(newmodules)