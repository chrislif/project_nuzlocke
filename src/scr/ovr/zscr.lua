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
local zx = 1
local zy = 1
local cellSize = 32
local cellMap = {}
local objMap = {}
local player = nil

function Zone.loadZone(zone)	-- Load a zone from file
	if #cellMap > 0 then
		Asset.removeMap(cellMap)
	end
	zoneName = zone
	Zone.zoneGrid = Grid.zoneToGrid(zone)
	Zone.drawCells()
	Zone.spawnObjects()
	player = Asset.drawPlayer()
end

function Zone.drawCells()	-- Draw, duh
	for _, i in pairs(Zone.zoneGrid) do
		for _, j in pairs(i) do
			local xloc = tonumber(j.x) - zx
			local yloc = tonumber(j.y) - zy
			local newCell = Asset.drawCell(j, xloc, yloc)
			local cellID = xloc + 1 .. "." .. yloc + 1
			cellMap[cellID] = newCell
		end
	end
end

function Zone.passableCell(x, y)	-- Check if character can walk into cell
	local checkCell = Zone.zoneGrid[zx - x]
	if checkCell ~= nil then
		checkCell = checkCell[zy - y]
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
	
	if Zone.passableCell(xshift, yshift) then
		for _, cell in pairs(cellMap) do
			transition.to(cell, {time = 400, x = cell.x + (xshift * cellSize), y = cell.y + (yshift * cellSize)})
			
		end
		for _, obj in pairs(objMap) do
			transition.to(obj, {time = 400, x = obj.x + (xshift * cellSize), y = obj.y + (yshift * cellSize)})
		end
		Asset.playerAnimate(mdir)
		zx = zx - xshift
		zy = zy - yshift
		Zone.currentCell.x = zx
		Zone.currentCell.y = zy
		return true
	end
	return false
end

function Zone.spawnObjects()
	for _, i in pairs(Zone.zoneGrid) do
		for _, j in pairs(i) do
			if j.spn > 0 then
				local newObj = Asset.drawObj(tonumber(j.x) - zx, tonumber(j.y) - zy)
				objMap[j] = newObj
			end
		end
	end
end

function Zone.printCurrent()
	if Zone.zoneGrid ~= nil then
		Grid.print(Zone.zoneGrid)
	end
end

return Zone