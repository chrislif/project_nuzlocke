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
local objMap = {}
local player = nil

function Zone.loadZone(zone)
	if #cellMap > 0 then
		Asset.removeMap(cellMap)
	end
	zoneName = zone
	zoneGrid = Grid.zoneToGrid(zone)
	Zone.drawCells()
	Zone.spawnObjects()
	player = Asset.drawPlayer()
end

function Zone.drawCells()
	for _, i in pairs(zoneGrid) do
		for _, j in pairs(i) do
			local newCell = Asset.drawCell(j, tonumber(j.x) - zx, tonumber(j.y) - zy)
			table.insert(cellMap, newCell)
		end
	end
end

function Zone.spawnObjects()
	for _, i in pairs(zoneGrid) do
		for _, j in pairs(i) do
			if j.spn > 0 then
				local newObj = Asset.drawObj(tonumber(j.x) - zx, tonumber(j.y) - zy)
				objMap[j] = newObj
			end
		end
	end
end

function Zone.printCurrent()
	if zoneGrid ~= nil then
		Grid.print(zoneGrid)
	end
end

return Zone
