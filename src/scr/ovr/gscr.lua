-----------------------------------------------------------------------------------------
--
-- gscr.lua
-- Grid functions
-----------------------------------------------------------------------------------------
local Cell = require "scr.ovr.cscr"
local File = require "scr.ovr.fscr"

local Grid = {}
Grid.mt = {}

function Grid.assignID(typ, dataID)
	local id_table = {
		[0] = "oldZone", [1] = "ID", [2] = "newZone", [3] = "newID"
	}
	local c_table = {
		[0] = id_table,
	}
	return c_table[typ][dataID]
end

function Grid.connectFile()
	dir = "fil/map/" 
	file = "zoneConnections"
	local file = File.getFile(dir, file)
	local dict = {}
	local dataCell = {}
	local dataID = 0
	
	local tableFlag = false
	local dataTable = {}
	local tableName = ""
	local tableID = 0
	
	local fileData = {}
	for line in file:lines() do
		table.insert(fileData, line)
	end
	
	for _, dataString in pairs(fileData) do
		for data in string.gmatch(dataString, "[-*_/%w]*") do
			if data ~= "" then
				if tableFlag == false then
					if data == "/" then
						dict[dataCell["ID"]] = dataCell
						dataID = 0
						dataCell = {}
					elseif data == "_" then
						tableFlag = true
					else
						if tonumber(data) ~= nil then
							data = tonumber(data)
						end
						
						dataCell[Grid.assignID(0, dataID)] = data
						dataID = dataID + 1
					end
				else
					if data == "*" then
						dataCell[tableName] = dataTable
						tableFlag = false
						dataTable = {}
						tableName = ""
						tableID = 0
					else
						if tableID > 0 then
							table.insert(dataTable, data)
							tableID = tableID + 1
						else
							tableName = data
							tableID = tableID + 1
						end
					end
				end
			end
		end
	end
	return dict
end

function Grid.new(a, b)	-- Create a new grid
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

function Grid.alterCell(zone, cell, id, n)	-- Appends to bottom of zone file to alter a Cell
	cell[id] = n
	cellString = tostring(cell.x) .. "." .. tostring(cell.y) .. "." .. tostring(cell.typ)
	cellString = cellString .. "." .. tostring(cell.pas) .. "." .. tostring(cell.spn)
	File.alterZoneFile("fil/map/", zone, cellString)
	return cell
end

function Grid.zoneToGrid(zone)	-- Translates zone file to 2D Grid
	local zoneData = File.getZoneFile("fil/map/", zone)
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

function Grid.tostring(grid)	-- If you can't figure out what this does there is no hope
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
