-----------------------------------------------------------------------------------------
--
-- dscr.lua
-- Dictionary functions
-----------------------------------------------------------------------------------------
local File = require "scr.fscr"

local fileNumber = tostring(1) .. "f_"

local Data = {}

function Data.assignID(ct, dataID)
	local pID_table = 
	{
		[0] = "ID", [1] = "BYTID", [2] = "NAME", [3] = "LEVEL", [4] = "BOOST",
		[5] = "HP", [6] = "ATK",  [7] = "DEF", 
		[8] = "SPATK", [9] = "SPDEF", [10] = "SPE",
		[11] = "HP_EV", [12] = "ATK_EV",[13] = "DEF_EV",
		[14] = "SPATK_EV", [15] = "SPDEF_EV", [16] = "SPE_EV",
		[17] = "ABIL", [18] = "NAT", [19] = "CURR_HP", [20] = "CURR_EFT",
		[21] = "MOV1", [22] = "M1_U",
		[23] = "MOV2", [24] = "M2_U",
		[25] = "MOV3", [26] = "M3_U",
		[27] = "MOV4", [28] = "M4_U"
	}
	
	local bytID_table = 
	{
		[0] = "ID", [1] = "NAME", [2] = "TYPE1", [3] = "TYPE2", 
		[4] = "HP", [5] = "ATK", [6] = "DEF", [7] = "SPATK", [8] = "SPDEF", [9] = "SPE",
		[10] = "EVO_LEVEL", [11] = "EVO_ID"
	}

	local mvID_table =
	{
		[0] = "ID", [1] = "NAME", [2] = "TYPE", [3] = "ATK_TYPE", 
		[4] = "PWR", [5] = "EFFECT", [6] = "%EFFECT", [7] = "USES",
	}
	local typBonus_table =
	{
		[0] = "ID", [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 5,
		[6] = 6, [7] = 7, [8] = 8, [9] = 9, [10] = 10, [11] = 11, 
		[12] = 12, [13] = 13, [14] = 14, [15] = 15, [16] = 16, [17] = 17,
	}
	local c_table = 
	{
		[1] = pID_table,
		[2] = mvID_table,
		[3] = bytID_table,
		[4] = typBonus_table,
	}
	return c_table[ct][dataID]
end

function Data.complexLoad(typ, dir, file)
	local fileData = File.getFile(dir, file)
	local dict = {}
	local dataCell = {}
	local dataID = 0
	
	local tableFlag = false
	local dataTable = {}
	local tableName = ""
	local tableID = 0
	
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
						dataCell[Data.assignID(typ, dataID)] = data
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

function Data.standardLoad(dir, file)
	local fileData = File.getFile(dir, file)
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

function Data.loadData()
	Data.TYP = Data.loadDictionary(0, "fil/dict/", "typ_dict")
	Data.TBL = Data.loadDictionary(4, "fil/dict/", "typ_tbl")
	Data.NAT = Data.loadDictionary(0, "fil/dict/", "nat_dict")
	Data.ABL = Data.loadDictionary(0, "fil/dict/", "abil_dict")
	Data.BST = Data.loadDictionary(0, "fil/dict/", "bst_dict")
	Data.NPC = Data.loadDictionary(0, "fil/dict/", "npc_dict")
	Data.MOV = Data.loadDictionary(2, "fil/dict/", "mov_dict")
	Data.BYT = Data.loadDictionary(3, "fil/dict/", "byt_dict")
	Data.PLY = Data.loadDictionary(1, "fil/", fileNumber .. "pteam")
end

function Data.alterTeam()
	
end

function Data.loadTeams(pNum, eNum)
	Data.PLY = Data.loadDictionary(1, "fil/", pNum .. "f_pteam")
	Data.ENM = Data.loadDictionary(1, "fil/npc/", eNum .. "_eteam")
end

function Data.loadDictionary(typ, dir, file)
	if typ > 0 then
		return Data.complexLoad(typ, dir, file)
	else
		return Data.standardLoad(dir, file)
	end
end

return Data