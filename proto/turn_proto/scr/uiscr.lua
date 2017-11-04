-----------------------------------------------------------------------------------------
--
-- uiscr.lua
-- User Interface functions
-----------------------------------------------------------------------------------------
local Asset = require "scr.ascr"
local UI = {}

function UI.loadUI()
	UI.background = UI.loadImage("back", 0, 0)
	UI.btn1 = UI.loadImage("btn", -80, 235)
	UI.btn2 = UI.loadImage("btn", 80, 235)
	UI.btn3 = UI.loadImage("btn", -80, 175)
	UI.btn4 = UI.loadImage("btn", 80, 175)
	UI.pShelf = UI.loadImage("pshlf", 80, 105)
	UI.eShelf = UI.loadImage("eshlf", -80, -235)
end

function UI.loadImage(img, dx, dy)
	local newImage = display.newImage("ast/" .. img .. ".png")
	newImage.x = display.contentCenterX + dx
	newImage.y = display.contentCenterY + dy
	return newImage
end

return UI