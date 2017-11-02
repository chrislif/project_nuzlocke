-----------------------------------------------------------------------------------------
--
-- zscr.lua
-- Zone functions
-----------------------------------------------------------------------------------------
local Grid = require "gscr"

local Zone = {}

local cZone = nil
local zoneGrid = nil

function Zone.loadZone(zone)
	cZone = zone
	zoneGrid = Grid.zoneToGrid(zone)
end

function Zone.printCurrent()
	if zoneGrid ~= nil then
		Grid.print(zoneGrid)
	end
end

return Zone
