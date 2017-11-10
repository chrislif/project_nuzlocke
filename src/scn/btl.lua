-----------------------------------------------------------------------------------------
--
-- btl.lua
-- Battle Scene
-----------------------------------------------------------------------------------------
local composer = require "composer"
local Manager = require "scr.btl.mnscr"

local scene = composer.newScene()

function scene.gameLoop()
	if Manager.endFlag == true then
		composer:gotoScene("scn.ovr")
	end
end

function scene:create(event)
	math.randomseed(os.time())
	Manager.startBattle()
	timer.performWithDelay(10, scene.gameLoop, -1)
end

scene:addEventListener("create", scene)

return scene