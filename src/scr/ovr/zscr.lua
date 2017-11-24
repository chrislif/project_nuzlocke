-----------------------------------------------------------------------------------------
--
-- zscr.lua
-- Zone functions
-----------------------------------------------------------------------------------------
local Grid = require "scr.ovr.gscr"
local Asset = require "scr.ovr.ascr"

local Zone = {}
Zone.currentCell = {}
Zone.currentCell.x = 1
Zone.currentCell.y = 1
Zone.zoneGrid = nil

local zoneName = nil
Zone.zx = 1
Zone.zy = 1
local cellSize = 32
local cellMap = {}
local objMap = {}
local player = nil

function Zone.loadZone(zone)	-- Load a zone from file
	if #cellMap > 0 then
		Asset.removeMap(cellMap)
	end
	zoneName = zone
	Zone.zoneGrid = Grid.getGrid(zone)
	Zone.drawCells()
	Zone.spawnObjects()
	player = Asset.drawPlayer()
end

function Zone.drawCells()	-- Draw, duh
	for _, cell in pairs(Zone.zoneGrid) do
		local xloc = cell["x"] - Zone.zx
		local yloc = cell["y"] - Zone.zy
		local newCell = Asset.drawCell(cell, xloc, yloc)
		local cellID = xloc + 1 .. "." .. yloc + 1
		cellMap[cellID] = newCell
	end
end

function Zone.passableCell(x, y)	-- Check if character can walk into cell
	local checkCell = Zone.zoneGrid[Zone.zx - x]
	if checkCell ~= nil then
		checkCell = checkCell[Zone.zy - y]
	end
	if checkCell == nil then
		return false
	end
	if checkCell.pas < 1 then
		return false
	end
	return true
end

function Zone.moveZone(mdir)	-- Move the zone in response to user input
	local xshift = 0
	local yshift = 0
	if mdir == "up" then
		yshift = 1
	elseif mdir == "left" then
		xshift = 1
	elseif mdir == "right" then
		xshift = -1
	elseif mdir == "down" then
		yshift = -1
	end
	
	Asset.playerAnimate(mdir)
	if Zone.passableCell(xshift, yshift) then
		for _, cell in pairs(cellMap) do
			transition.to(cell, {time = 400, x = cell.x + (xshift * cellSize), y = cell.y + (yshift * cellSize)})
			
		end
		for _, obj in pairs(objMap) do
			transition.to(obj, {time = 400, x = obj.x + (xshift * cellSize), y = obj.y + (yshift * cellSize)})
		end
		
		Zone.zx = Zone.zx - xshift
		Zone.zy = Zone.zy - yshift
		Zone.currentCell.x = Zone.zx
		Zone.currentCell.y = Zone.zy
		return true
	end
	return false
end

function Zone.spawnObjects()
	for id, cell in pairs(Zone.zoneGrid) do
		if cell[spn] == 1 then
			local newObj = Asset.drawObj(cell["x"] - Zone.zx, cell["y"] - Zone.zy)
			table.insert(objMap, newObj)
		end
	end
end

function Zone.printCurrent()
	if Zone.zoneGrid ~= nil then
		Grid.print(Zone.zoneGrid)
	end
end

return Zone
