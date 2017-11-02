-----------------------------------------------------------------------------------------
--
-- ovr.lua
-- Overworld Scene
-----------------------------------------------------------------------------------------
local composer = require "composer"
local Zone = require "scr.zscr"

local scene = composer.newScene()

function scene.gameLoop()

end

function scene:create(event)
	Zone.loadZone("zone1")
	
end

scene:addEventListener("create", scene)

return scene