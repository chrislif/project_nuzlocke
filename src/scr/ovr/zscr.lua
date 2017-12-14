-----------------------------------------------------------------------------------------
--
-- zscr.lua
-- Zone functions
-----------------------------------------------------------------------------------------
local Grid = require "scr.ovr.gscr"
local Asset = require "scr.ovr.ascr"
local Dict = require "scr.ovr.dscr"

local Zone = {}
Zone.currentCell = {}
Zone.zoneGrid = nil
Zone.zoneDict = nil
Zone.player = nil

local cellMap = {}
local objMap = {}

function Zone.loadDict()
	Zone.zoneDict = Dict.loadDict()
end

function Zone.exitZone()
	for i, d in pairs(cellMap) do
		d:removeSelf()
	end
	for i, d in pairs(objMap) do
		d:removeSelf()
	end
	Zone.player:removeSelf()
	Zone.zoneGrid = {}
	cellMap = {}
	objMap = {}
end

function Zone.loadZone(zone, port)	-- Load a zone from file
	if #cellMap > 0 then
		Asset.removeMap(cellMap)
	end
	Zone.zoneGrid = Grid.getGrid(zone)
	Zone.drawCells()
	Zone.spawnObjects()
	local portCell = nil
	
	for id, cell in pairs(Zone.zoneGrid) do
		if tonumber(cell["iport"]) == port then
			portCell = cell
		end
	end
	
	local zx = portCell["x"]
	local zy = portCell["y"]
	Zone.currentCell = Zone.zoneGrid[zx .. "." .. zy]
	Zone.player = Asset.drawPlayer(Zone.currentCell)
end

function Zone.drawCells()	-- Draw, duh
	for _, cell in pairs(Zone.zoneGrid) do
		local xloc = cell["x"] - 1
		local yloc = cell["y"] - 1
		local newCell = Asset.drawCell(cell, xloc, yloc)
		local cellID = xloc + 1 .. "." .. yloc + 1
		cellMap[cellID] = newCell
	end
end

function Zone.portCheck(mdir)
	local dir_table = {
		["center"] = 0,
		["up"] = 1,
		["right"] = 2,
		["down"] = 3,
		["left"] = 4
	}
	local dir = dir_table[mdir]
	
	if Zone.currentCell["eport"] ~= 0 and Zone.currentCell["edir"] == dir then
		print("port to " .. Zone.zoneDict[Zone.currentCell["eport"]] .. " at " .. Zone.currentCell["portid"])
		Zone.exitZone()
		Zone.loadZone(Zone.zoneDict[Zone.currentCell["eport"]], Zone.currentCell["portid"])
		return true
	end

	return false
end

function Zone.passableCell(x, y)	-- Check if character can walk into cell
	local zx = Zone.currentCell["x"] - x
	local zy = Zone.currentCell["y"] - y
	local checkCell = Zone.zoneGrid[zx .. "." .. zy]
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
	local cellSize = 32
	
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
	if Zone.portCheck(mdir) == false then
		if Zone.passableCell(xshift, yshift) then
			for _, cell in pairs(cellMap) do
				transition.to(cell, {time = 400, x = cell.x + (xshift * cellSize), y = cell.y + (yshift * cellSize)})
			end
			
			for _, obj in pairs(objMap) do
				transition.to(obj, {time = 400, x = obj.x + (xshift * cellSize), y = obj.y + (yshift * cellSize)})
			end
			
			local zx = Zone.currentCell["x"] - xshift
			local zy = Zone.currentCell["y"] - yshift
			Zone.currentCell = Zone.zoneGrid[zx .. "." .. zy]
			return true
		end
	end
	return false
end

function Zone.spawnObjects()
	for id, cell in pairs(Zone.zoneGrid) do
		if cell["spn"] == 1 then
			local newObj = Asset.drawObj(cell["x"] - 1, cell["y"] - 1)
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
