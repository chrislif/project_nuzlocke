-----------------------------------------------------------------------------------------
--
-- dscr.lua
-- Data functions
-----------------------------------------------------------------------------------------
local Dict = require "scr.dictscr"

local fileNumber = 1

local Data = {}

function Data.loadData()
	Data.TYP = Dict.loadDictionary(0, "typ_dict")
	Data.NAT = Dict.loadDictionary(0, "nat_dict")
	Data.ABL = Dict.loadDictionary(0, "abil_dict")
	Data.BST = Dict.loadDictionary(0, "bst_dict")
	Data.MOV = Dict.loadDictionary(2, "mov_dict")
	Data.MON = Dict.loadDictionary(3, "mon_dict")
	Data.PLY = Dict.loadDictionary(1, fileNumber .. "f_pteam")
end

return Data