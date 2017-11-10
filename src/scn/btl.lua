-----------------------------------------------------------------------------------------
--
-- btl.lua
-- Battle Scene
-----------------------------------------------------------------------------------------
local composer = require "composer"
local Manager = require "scr.btl.mnscr"

local scene = composer.newScene()

function scene:create(event)
	math.randomseed(os.time())
	Manager.startBattle()
end

scene:addEventListener("create", scene)

return scene