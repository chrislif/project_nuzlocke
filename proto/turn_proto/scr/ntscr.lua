-----------------------------------------------------------------------------------------
--
-- ntscr.lua
-- Nature Dictionary functions
-----------------------------------------------------------------------------------------
local File = require "scr.fscr"

local NatDict = {}

function NatDict.loadDictionary()
	local natData = File.getFile("nat_dict")
	local natDict = {}
	
	for _, dataString in pairs(natData) do
		local id = 0
		local name = ""
		for data in string.gmatch(dataString, "%w*") do
			if data ~= "" then
				if id ~= 0 then
					name = data
				else
					id = tonumber(data)
				end
			end
		end
		natDict[id] = name
	end
	
	return natDict
end

return NatDict