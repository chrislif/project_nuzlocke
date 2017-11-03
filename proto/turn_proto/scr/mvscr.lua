-----------------------------------------------------------------------------------------
--
-- mvscr.lua
-- Move Dictionary functions
-----------------------------------------------------------------------------------------
local File = require "scr.fscr"

local MovDict = {}

function MovDict.assignID(dataID)
	local c_table = 
	{
		[0] = "ID", [1]= "NAME", [2] = "TYPE", [3] = "ATK_TYPE", 
		[4] = "PWR", [5] = "EFFECT", [6] = "%EFFECT", [7] = "USES",
	}
	
	return c_table[dataID]
end

function MovDict.loadDictionary()
	local movData = File.getFile("mov_dict")
	local movDict = {}
	
	for _, dataString in pairs(movData) do
		local mov = {}
		local dataID = 0
		for data in string.gmatch(dataString, "%w*") do
			if data ~= "" then
				if tonumber(data) ~= nil then
					data = tonumber(data)
				end
				mov[MovDict.assignID(dataID)] = data
				dataID = dataID + 1
			end
		end
		movDict[mov["ID"]] = mov
	end
	
	return movDict
end

return MovDict