-- Inserters could not load or unload a heatsink, because they took one of its
-- hidden receivers (see heatsink/control.lua). Put the heatsinks already placed
-- back in front of their receivers.
local heatsink = require("heatsink.control")
for _, surface in pairs(game.surfaces) do
	for _, entity in pairs(surface.find_entities_filtered{name = "halo-heatsink"}) do
		heatsink.bring_to_front(entity)
	end
end
