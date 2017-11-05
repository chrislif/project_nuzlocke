-----------------------------------------------------------------------------------------
--
-- mnscr.lua
-- Manager functions
-----------------------------------------------------------------------------------------
local UI = require "scr.uiscr"
local Data = require "scr.dscr"

local Manager = {}
local fileNumber = 1

function Manager.startBattle()
	Data.loadData()
	Data.loadTeams(fileNumber, 1)
	UI.loadUI()
end

return Manager