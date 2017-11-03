-----------------------------------------------------------------------------------------
--
-- monscr.lua
-- Monster Dictionary functions
-----------------------------------------------------------------------------------------
local File = require "scr.fscr"

local MonDict = {}

function MonDict.assignID(dataID)
	local c_table = 
	{
		[0] = "ID", [1] = "NAME", [2] = "TYPE1", [3] = "TYPE2", 
		[4] = "HP", [5] = "ATK", [6] = "DEF", [7] = "SPATK", [8] = "SPDEF", [9] = "SPE",
		[10] = "EVO_LEVEL", [11] = "EVO_ID"
	}
	
	return c_table[dataID]
end

function MonDict.loadDictionary()
	local monData = File.getFile("mon_dict")
	local monDict = {}
	local mon = {}
	local inflag = nil
	local mon_mlist = {["TABLE_NAME"] = "MOVE"}
	local mon_alist = {["TABLE_NAME"] = "ABILITY"}
	local dataID = 0
	
	for i, dataString in pairs(monData) do
		for data in string.gmatch(dataString, "[/%w]*") do
			if data ~= "" then
				if data ~= "/" then
					if data == "m" then
						inflag = "m"
					elseif data == "a" then
						inflag = "a"
					elseif inflag == nil then
						if tonumber(data) ~= nil then
							data = tonumber(data)
						end
						mon[MonDict.assignID(dataID)] = data
						dataID = dataID + 1
					elseif inflag == "m" then
						table.insert(mon_mlist, tonumber(data))
					elseif inflag == "a" then
						table.insert(mon_alist, tonumber(data))
					end
				else
					mon["MLIST"] = mon_mlist
					mon["ALIST"] = mon_alist
					monDict[mon["ID"]] = mon
					
					mon_mlist = {["TABLE_NAME"] = "MOVE"}
					mon_alist = {["TABLE_NAME"] = "ABILITY"}
					mon = {}
					inflag = nil
					dataID = 0
				end
			end
		end
	end
	return monDict
end

return MonDict