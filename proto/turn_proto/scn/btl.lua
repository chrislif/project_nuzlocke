-----------------------------------------------------------------------------------------
--
-- btl.lua
-- Battle Scene
-----------------------------------------------------------------------------------------
local composer = require "composer"
local Manager = require "scr.mnscr"

local scene = composer.newScene()

function scene:create(event)
	Manager.startBattle()
end

scene:addEventListener("create", scene)

return scene