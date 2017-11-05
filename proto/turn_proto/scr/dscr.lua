-----------------------------------------------------------------------------------------
--
-- dscr.lua
-- Data functions
-----------------------------------------------------------------------------------------
local Dict = require "scr.dictscr"

local Data = {}

function Data.loadData()
	Data.TYP = Dict.loadDictionary(0, "dict", "typ_dict")
	Data.NAT = Dict.loadDictionary(0, "dict", "nat_dict")
	Data.ABL = Dict.loadDictionary(0, "dict", "abil_dict")
	Data.BST = Dict.loadDictionary(0, "dict", "bst_dict")
	Data.NPC = Dict.loadDictionary(0, "dict", "npc_dict")
	Data.MOV = Dict.loadDictionary(2, "dict", "mov_dict")
	Data.BYT = Dict.loadDictionary(3, "dict", "byt_dict")
end

function Data.loadTeams(pNum, eNum)
	Data.PLY = Dict.loadDictionary(1, nil, pNum .. "f_pteam")
	Data.ENM = Dict.loadDictionary(1, "npc", eNum .. "_eteam")
end

return Data