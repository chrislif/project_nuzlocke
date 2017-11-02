-----------------------------------------------------------------------------------------
--
-- zscr.lua
-- Zone functions
-----------------------------------------------------------------------------------------
local Grid = require "gscr"
local Asset = require "ascr"

local Zone = {}

local zoneName = nil
local zoneGrid = nil
local zx = 1
local zy = 1
local cellMap = {}

function Zone.loadZone(zone)
	if #cellMap > 0 then
		Asset.removeMap(cellMap)
	end
	zoneName = zone
	zoneGrid = Grid.zoneToGrid(zone)
	Zone.drawCells(zx, zy)
end

function Zone.drawCells(cx, cy)
	for _, i in pairs(zoneGrid) do
		for _, j in pairs(i) do
			local newCell = Asset.drawCell(j, tonumber(j.x) - cx, tonumber(j.y) - cy)
			table.insert(cellMap, newCell)
		end
	end
end

function Zone.printCurrent()
	if zoneGrid ~= nil then
		Grid.print(zoneGrid)
	end
end

return Zone
