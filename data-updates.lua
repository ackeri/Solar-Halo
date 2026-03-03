require("modules.data-updates")
require("rocketparts.data-updates")
require("nav-computer.data-updates")
require("simulation.data-updates")

----------Lab Fix----------
for name, proto in pairs(data.raw["lab"]) do
	table.insert(proto.inputs, "halo-science-pack")
end
