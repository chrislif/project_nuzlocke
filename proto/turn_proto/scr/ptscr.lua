-----------------------------------------------------------------------------------------
--
-- ptscr.lua
-- Player Team functions
-----------------------------------------------------------------------------------------
local File = require "scr.fscr"

local pTeam = {}

function pTeam.assignStatID(dataID)
	local c_table = 
	{
		[0] = "ID", [1] = "NAME", [2] = "LEVEL",
		[3] = "HP", [4] = "ATK",  [5] = "DEF", 
		[6] = "SPATK", [7] = "SPDEF", [8] = "SPE",
		[9] = "HP_EV", [10] = "ATK_EV",[11] = "DEF_EV",
		[12] = "SPATK_EV", [13] = "SPDEF_EV", [14] = "SPE_EV",
		[15] = "ABIL", [16] = "NAT",
		[17] = "MOV1", [18] = "M1_U",
		[19] = "MOV2", [20] = "M2_U",
		[21] = "MOV3", [22] = "M3_U",
		[23] = "MOV4", [24] = "M4_U"
	}
	
	return c_table[dataID]
end

function pTeam.loadPlayerTeam(fileNumber)
	local playerData = File.getFile(fileNumber .. "f_pteam")
	local playerTeam = {}
	local mon = {}
	local out = ""
	local position = 1
	local dataID = 0
	
	for _, dataString in pairs(playerData) do
		for data in string.gmatch(dataString, ".") do
			if data ~= "." and data ~= "/"then
				out = out .. data
			else
				local statID = pTeam.assignStatID(dataID)
				if statID ~= "NAME" then 
					out = tonumber(out) 
				end
				mon[statID] =  out
				dataID = dataID + 1
				out = ""
				if data == "/" then
					playerTeam[position] = mon
					mon = {}
					dataID = 0
					if position <= 6 then
						position = position + 1
					end
				end
			end
		end
	end
	return playerTeam
end

return pTeam