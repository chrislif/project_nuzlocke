-----------------------------------------------------------------------------------------
--
-- uiscr.lua
-- User Interface functions
-----------------------------------------------------------------------------------------
local Asset = require "scr.ascr"
local UI = {}
UI.menu = nil
UI.state = "FIGHT"

function UI.loadMenu(state)
	UI.clearMenu()
	if state == "FIGHT" then
		UI.btn1 = UI.loadImage("btn", -100, 175)
		UI.btn1.xScale = .75
		UI.btn2 = UI.loadImage("btn", -100, 235)
		UI.btn2.xScale = .75
		UI.btn3 = UI.loadImage("btn", 20, 175)
		UI.btn3.xScale = .75
		UI.btn4 = UI.loadImage("btn", 20, 235)
		UI.btn4.xScale = .75
	elseif state == "TEAM" then
		UI.btn1 = UI.loadImage("btn", -120, 175)
		UI.btn1.xScale = .5
		UI.btn2 = UI.loadImage("btn", -120, 235)
		UI.btn2.xScale = .5
		UI.btn3 = UI.loadImage("btn", -40, 175)
		UI.btn3.xScale = .5
		UI.btn4 = UI.loadImage("btn", -40, 235)
		UI.btn4.xScale = .5
		UI.btn5 = UI.loadImage("btn", 40, 175)
		UI.btn5.xScale = .5
		UI.btn6 = UI.loadImage("btn", 40, 235)
		UI.btn6.xScale = .5
	end
end

function UI.clearMenu()
	if UI.menu == nil then return end
	for _, obj in pairs(UI.menu) do
		obj:removeSelf()
	end
end

function UI.switchMenu()
	if UI.state == "FIGHT" then
		UI.loadMenu("TEAM")
		UI.state = "TEAM"
	else
		UI.loadMenu("FIGHT")
		UI.state = "FIGHT"
	end
end

function UI.loadUI()
	UI.background = UI.loadImage("back", 0, 0)
	UI.pShelf = UI.loadImage("pshlf", 80, 105)
	UI.eShelf = UI.loadImage("eshlf", -80, -235)
	UI.runBtn = UI.loadImage("btn", 120, 235)
	UI.runBtn.xScale = 0.5
	UI.runBtn:setFillColor( 1, 0, 0)
	UI.toggleBtn = UI.loadImage("btn", 120, 175)
	UI.toggleBtn.xScale = 0.5
	UI.toggleBtn:addEventListener("tap", UI.switchMenu)
	UI.loadMenu("TEAM")
end

function UI.loadImage(img, dx, dy)
	local newImage = display.newImage("ast/" .. img .. ".png")
	newImage.x = display.contentCenterX + dx
	newImage.y = display.contentCenterY + dy
	return newImage
end

return UI