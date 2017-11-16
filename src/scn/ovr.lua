-----------------------------------------------------------------------------------------
--
-- ovr.lua
-- Overworld Scene
-----------------------------------------------------------------------------------------
local composer = require "composer"
local Zone = require "scr.ovr.zscr"
local Menu = require "scr.ovr.mnscr"

local scene = composer.newScene()
local lx = 0
local ly = 0
local endFlag = false
local moveFlag = true

function scene:create(event)	-- Load up first zone
	Zone.loadZone("zone0")
	Menu.load()
end

function scene.allowMove(event)	-- Allow movement
	moveFlag = true
	Menu.menuFlag = true
end

function scene.getEncounter()	-- Roll if there is an encounter
	local roll = math.random(1, 100)
	if roll > 60 then
		composer.gotoScene("scn.btl")
	end
end

function scene.checkEncounter()	-- Check if cell is an encounter cell
	local c_table = {
		[0] = 0,
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 1,
	}

	local getEncounter = c_table[Zone.zoneGrid[Zone.currentCell.x][Zone.currentCell.y].typ]
	if getEncounter > 0 then scene.getEncounter() end
end

function scene.getTapLocation()	-- Get location of tap
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

function scene.moveScene(event)	-- Move screen if allowed
	if endFlag == false then
		if moveFlag == true then
			moveFlag = false
			Menu.menuFlag = false
			timer.performWithDelay(400, scene.allowMove)
			local mdir = scene.getTapLocation()
			local encounterFlag = Zone.moveZone(mdir)
			if encounterFlag and mdir ~= "center" then timer.performWithDelay(400, scene.checkEncounter) end
		end
	elseif endFlag == true then
		timer.cancel(event.source)
	end
end

function scene.checkMenuTap(event)
	local width = Menu.menuBtn.contentWidth
	local height = Menu.menuBtn.contentHeight
	
	local xMinCheck = Menu.menuBtn.x - width/2
	local xMaxCheck = Menu.menuBtn.x + width/2
	local yMinCheck = Menu.menuBtn.y - height/2
	local yMaxCheck = Menu.menuBtn.y + height/2
	
	if event.x >= xMinCheck and event.x <= xMaxCheck then
		if event.y >= yMinCheck and event.y <= yMaxCheck then
			return true
		end
	end
	return false
end

function scene.tapCheck(event)	-- Detect screen tap v touch
	local moveTime = nil
	lx = event.x
	ly = event.y
	if event.phase == "began" then
		if scene.checkMenuTap(event) then
			scene.toggleMenu(event)
		else
			endFlag = false
			timer.performWithDelay(16, scene.moveScene, -1)
		end
	elseif event.phase == "moved" then
		lx = event.x
		ly = event.y
	elseif event.phase == "ended" then
		endFlag = true
	end
	return true
end

function scene.toggleMenu(event)
	if Menu.state == "hide" then
		moveFlag = false
	else
		moveFlag = true
	end
	Menu.toggle()
end

function scene:show(event)	-- Unpause overworld out of battle
	if event.phase == "will" then
		Runtime:addEventListener("touch", scene.tapCheck)
	end
end

function scene:hide(event)	-- Pause Overworld while in battle Mode
	if event.phase == "will" then
		Runtime:removeEventListener("touch", scene.tapCheck)
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

-- Check for mem leaks
-- function showMem()
	-- print("mem " .. collectgarbage("count"))
	
-- end

-- --Runtime:addEventListener("enterFrame", showMem)

return scene
