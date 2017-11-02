-----------------------------------------------------------------------------------------
--
-- gscr.lua
-- Grid functions
-----------------------------------------------------------------------------------------
local Cell = require "scr.cscr"
local File = require "scr.fscr"

local Grid = {}
Grid.mt = {}

function Grid.new(a, b)
	local grid = {}
	setmetatable(grid, Grid.mt)
	for i = 1, a do
		grid[i] = {}
		for j = 1, b do
			grid[i][j] = Cell.new()
		end
	end
	return grid
end

function Grid.alterCell(zone, cell, id, n)
	cell[id] = n
	cellString = tostring(cell.x) .. "." .. tostring(cell.y) .. "." .. tostring(cell.typ)
	cellString = cellString .. "." .. tostring(cell.pas) .. "." .. tostring(cell.spn)
	File.alterZoneFile(zone, cellString)
	return cell
end

function Grid.zoneToGrid(zone)
	local zoneData = File.getZoneFile(zone)
	local xsize = 0
	local ysize = 0
	
	for i in string.gmatch(zoneData[1], "%d*") do
		if i ~= "" then
			if xsize == 0 then
				xsize = i
			else
				ysize = i
			end
		end
	end
	zoneData[1] = nil
	local zoneGrid = Grid.new(xsize, ysize)
	
	for i, cellString in pairs(zoneData) do
		local id = 0
		local x = 0
		local y = 0
		for k in string.gmatch(cellString, "%d*") do
			if k ~= "" then
				if id == 0 then
					x = tonumber(k)
				elseif id == 1 then
					y = tonumber(k)
				elseif id == 2 then
					zoneGrid[x][y].typ = tonumber(k)
				elseif id == 3 then
					zoneGrid[x][y].pas = tonumber(k)
				elseif id == 4 then
					zoneGrid[x][y].spn = tonumber(k)
				end
				id = id + 1
			end	
		end
		zoneGrid[x][y].x = x
		zoneGrid[x][y].y = y
		zoneData[i] = nil
	end
	zoneData = nil
	
	return zoneGrid
end

function Grid.tostring(grid)
	local s = "{"
	local sep = ""
	local c = 0
	for _, i in pairs(grid) do
		for _, j in pairs(i) do
			local data = "cell_" .. tostring(c) .. ":" .. tostring(j.x)
			data = data .. "." .. tostring(j.y)
			data = data .. "." .. tostring(j.typ)
			data = data .. "." .. tostring(j.pas)
			data = data .. "." .. tostring(j.spn)
			s = s .. sep .. data
			sep = ", "
			c = c + 1
		end
		sep = "\n"
	end
	return s .. "}"
end

function Grid.print(g)
	print(Grid.tostring(g))
end

return Grid