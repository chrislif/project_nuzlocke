-----------------------------------------------------------------------------------------
--
-- btl.lua
-- Battle Scene
-----------------------------------------------------------------------------------------
local composer = require "composer"
local Data = require "scr.dscr"

local scene = composer.newScene()

function scene:create(event)
	local playerTeam = Data.loadPlayer()
end

scene:addEventListener("create", scene)

return scene