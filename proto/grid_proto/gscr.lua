-----------------------------------------------------------------------------------------
--
-- gscr.lua
-- Grid functions
-----------------------------------------------------------------------------------------
local Cell = require "cscr"
local File = require "fscr"

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
		zoneData[i] = nil
	end
	zoneData = nil
	
	Grid.print(zoneGrid)
	return zoneGrid
end

function Grid.tostring(grid)
	local s = "{"
	local sep = ""
	for x, i in pairs(grid) do
		for y, j in pairs(i) do
			local data = "id:" .. x
			data = data .. "." .. y
			data = data .. "." .. tostring(j.typ)
			data = data .. "." .. tostring(j.pas)
			data = data .. "." .. tostring(j.spn)
			s = s .. sep .. data
			sep = ", "
			y = y + 1
		end
		sep = "\n"
		x = x + 1
	end
	return s .. "}"
end

function Grid.print(g)
	print(Grid.tostring(g))
end

return Grid