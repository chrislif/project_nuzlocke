-----------------------------------------------------------------------------------------
--
-- tyscr.lua
-- Type functions
-----------------------------------------------------------------------------------------
local File = require "scr.fscr"

local Type = {}

function Type.loadDictionary()
	local typeData = File.getFile("typ_dict")
	local typeDict = {}
	
	for i, dataString in pairs(typeData) do
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
		typeDict[id] = name
	end
	return typeDict
end

return Type