-----------------------------------------------------------------------------------------
--
-- btl.lua
-- Battle Scene
-----------------------------------------------------------------------------------------
local composer = require "composer"
local Data = require "scr.dscr"
local UI = require "scr.uiscr"

local scene = composer.newScene()
local fileNumber = 1
scene.pMon = nil
scene.eMon = nil

function scene.switchMon(side, id)
	if side == "p" then
		return Data.PLY[id]
	else
		return Data.ENM[id]
	end
end

function scene:create(event)
	Data.loadData()
	Data.loadTeams(fileNumber, 1)
end

function scene:show(event)
	if event.phase == "did" then
		scene.pMon = scene.switchMon("p", 1)
		scene.eMon = scene.switchMon("e", 1)
		UI.loadUI()
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)

return scene