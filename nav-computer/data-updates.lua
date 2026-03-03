local targets = data.raw["ammo"]["halo-nav-pack"].ammo_type.target_filter
for name, _ in pairs(data.raw["asteroid"]) do
	table.insert(targets, name)
end