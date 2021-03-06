-----------------------------------------------------------------------------------------
--
-- gscr.lua
-- Grid functions
-----------------------------------------------------------------------------------------
local Cell = require "scr.ovr.cscr"
local File = require "scr.fscr"

local Grid = {}

function Grid.assignID(id)
	local idTable = {
		[0] = "x", [1] = "y", [2] = "typ", [3] = "pas", [4] = "spn", [5] = "iport", [6] = "eport", [7] = "edir", [8] = "portid",
	}
	return idTable[id]
end

function Grid.getGrid(zone)	-- Translates zone file to 2D Grid
	local zoneData = File.getFile("fil/map/", zone)
	local zoneGrid = {}
	local zoneCell = {}
	local dataID = 0
	
	for i, cellString in pairs(zoneData) do
		for data in string.gmatch(cellString, "[-*_/%w]*") do
			if data ~= "" then
				if data == "/" then
					zoneGrid[zoneCell["x"] .. "." .. zoneCell["y"]] = zoneCell
					dataID = 0
					zoneCell = {}
				else
					if tonumber(data) ~= nil then
						data = tonumber(data)
					end
					zoneCell[Grid.assignID(dataID)] = data
					dataID = dataID + 1
					
				end
				
			end	
		end
	end
	zoneData = nil
	
	return zoneGrid
end

function Grid.tostring(grid)
	for i, cell in pairs(grid) do
		print("CELL: " .. i)
		for j, data in pairs(cell) do
			print(j .. ": " .. data)
		end
	end
end

return Grid
