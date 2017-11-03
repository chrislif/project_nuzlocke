-----------------------------------------------------------------------------------------
--
-- dscr.lua
-- Data functions
-----------------------------------------------------------------------------------------
local pTeam = require "scr.ptscr"
local TypDict = require "scr.tyscr"
local MonDict = require "scr.monscr"
local MovDict = require "scr.mvscr"
local NatDict = require "scr.ntscr"

local fileNumber = 1

local Data = {}
Data.playerTeam = {}
Data.typDict = {}
Data.movDict = {}
Data.natDict = {}
Data.monDict = {}


function Data.loadData()
	Data.loadTypDict()
	Data.loadMovDict()
	Data.loadNatDict()
	Data.loadMonDict()
	Data.loadPlayerTeam()
end

function Data.loadMovDict()
	Data.movDict = MovDict.loadDictionary()
end

function Data.loadNatDict()
	Data.natDict = NatDict.loadDictionary()
end

function Data.loadPlayerTeam()
	Data.playerTeam = pTeam.loadPlayerTeam(fileNumber)
end

function Data.loadMonDict()
	Data.monDict = MonDict.loadDictionary()
end

function Data.loadTypDict()
	Data.typDict = TypDict.loadDictionary()
end

return Data