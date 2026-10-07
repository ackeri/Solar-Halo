-- The thermostat is deprecated (see thermostat/control.lua): convert the ones
-- already placed, and the ones sitting in inventories, into heat pipes.
require("thermostat.control").convert_all()
