-----------------------------------------------------------------------------------------
--
-- zscr.lua
-- Zone functions
-----------------------------------------------------------------------------------------
local Grid = require "scr.gscr"
local Asset = require "scr.ascr"

local Zone = {}

local zoneName = nil
local zoneGrid = nil
local zx = 1
local zy = 1
local cellSize = 32
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
			local xloc = tonumber(j.x) - zx
			local yloc = tonumber(j.y) - zy
			local newCell = Asset.drawCell(j, xloc, yloc)
			local cellID = xloc + 1 .. "." .. yloc + 1
			cellMap[cellID] = newCell
		end
	end
end

function Zone.passableCell(x, y)
	local checkCell = zoneGrid[zx - x]
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

function Zone.moveZone(mdir)
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
