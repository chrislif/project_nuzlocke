-----------------------------------------------------------------------------------------
--
-- btl.lua
-- Battle Scene
-----------------------------------------------------------------------------------------
local composer = require "composer"
local Data = require "scr.dscr"

local scene = composer.newScene()
local playerTeam = nil

function scene:create(event)
	Data.loadData()
end

scene:addEventListener("create", scene)

return scene