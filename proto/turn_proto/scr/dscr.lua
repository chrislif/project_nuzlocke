-----------------------------------------------------------------------------------------
--
-- dscr.lua
-- Data functions
-----------------------------------------------------------------------------------------
local File = require "scr.fscr"

local Data = {}

function Data.splitString(str, c)
	res = {}
	for data in string.gmatch(dataString, ".") do
	
	end
	
	return res
end

function Data.loadPlayer()
	local playerData = File.getPlayerFile()
	local playerTeam = {}
	local position = 1
	
	for _, dataString in pairs(playerData) do
		local monster = {}
		print(dataString)
		
		playerTeam[position] = monster
		position = position + 1
	end
	
	return playerTeam
end

return Data