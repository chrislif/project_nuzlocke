-----------------------------------------------------------------------------------------
--
-- dscr.lua
-- Dictionary functions
-----------------------------------------------------------------------------------------
local File = require "scr.ovr.fscr"

local Dict = {}

function Dict.loadDict()
	local fileData = File.getFile("fil/map/", "zone_dict")
	local dict = {}
	
	for _, dataString in pairs(fileData) do
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
		dict[id] = name
	end

	return dict
end

return Dict