-----------------------------------------------------------------------------------------
--
-- ovr.lua
-- Overworld Scene
-----------------------------------------------------------------------------------------
local composer = require "composer"
local Zone = require "scr.zscr"

local scene = composer.newScene()
local lx = 0
local ly = 0
local endFlag = false
local moveFlag = true

function scene:create(event)
	Zone.loadZone("zone0")
end

function scene.allowMove(event)
	moveFlag = true
end

function scene.getTapLocation()
	if ly < display.contentHeight/4 then
		return "up"
	elseif ly > display.contentHeight * (3/4) then
		return "down"
	elseif lx < display.contentWidth/4 then
		return "left"
	elseif lx > display.contentWidth * (3/4) then
		return "right"
	end
	return "center"
end

function scene.moveScene(event)
	if endFlag == false then
		if moveFlag == true then
			moveFlag = false
			timer.performWithDelay(400, scene.allowMove)
			local mdir = scene.getTapLocation()
			Zone.moveZone(mdir)
		end
	elseif endFlag == true then
		timer.cancel(event.source)
	end
end

function scene.tapCheck(event)
	local moveTime = nil
	lx = event.x
	ly = event.y
	if event.phase == "began" then
		endFlag = false
		timer.performWithDelay(16, scene.moveScene, -1)
	elseif event.phase == "moved" then
		lx = event.x
		ly = event.y
	elseif event.phase == "ended" then
		endFlag = true
	end
	return true
end

Runtime:addEventListener("touch", scene.tapCheck)
scene:addEventListener("create", scene)

return scene