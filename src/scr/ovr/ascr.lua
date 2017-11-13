-----------------------------------------------------------------------------------------
--
-- ascr.lua
-- Asset functions
-----------------------------------------------------------------------------------------
local Sprite = require "scr.ovr.spscr"
local Asset = {}

local cellSize = 32
local spriteSheetTable = Sprite.loadSpriteSheets()

local imgTable = {
	[0] = "bar.png",
	[1] = "grs.png",
	[2] = "snd.png",
	[3] = "wtr.png",
	[4] = "tgrs.png",
}

local sprTable = {}
sprTable[0] = "box.png"

local player = nil

function Asset.drawText(str, dx, dy)
	local text = display.newText({text = str, fontSize = 15})
	text.x = display.contentCenterX + dx
	text.y = display.contentCenterY + dy
	text:setFillColor(0, 0, 0)
	return text
end

function Asset.drawGroupText(group, str, dx, dy)
	local text = display.newText({parent = group, text = str, fontSize = 15})
	
	text.x = display.contentCenterX + dx
	text.y = display.contentCenterY + dy
	text:setFillColor(0, 0, 0)
	return text
end

function Asset.drawImage(group, img, dx, dy)
	local newImg = display.newImage(group, "ast/" .. img .. ".png")
	
	newImg.dx = dx
	newImg.dy = dy
	newImg.x = display.contentCenterX + dx
	newImg.y = display.contentCenterY + dy
	
	return newImg
end

function Asset.drawMenu(img, dx, dy)
	local img = display.newImage("ast/" .. img .. ".png")
	
	img.dx = dx
	img.dy = dy
	img.x = display.contentCenterX + dx
	img.y = display.contentCenterY + dy
	
	return img
end

function Asset.drawCell(cell, dx, dy)
	local img = imgTable[cell.typ]

	local newCell = display.newImage("ast/" .. img)
	newCell.x = display.contentCenterX + (dx * cellSize)
	newCell.y = display.contentCenterY + (dy * cellSize)
	
	return newCell
end

function Asset.drawObj(dx, dy)
	local img = sprTable[0]

	local newObj = display.newImage("ast/" .. img)
	newObj.x = display.contentCenterX + (dx * cellSize)
	newObj.y = display.contentCenterY + (dy * cellSize)
	
	return newObj
end

function Asset.playerAnimate(mdir)
	if player ~= nil then
		player:setSequence("dwalk")
		player:play()
	end
end

function Asset.drawPlayer()
	player = display.newSprite(spriteSheetTable["player"], spriteSheetTable["playerData"])
	player.x = display.contentCenterX
	player.y = display.contentCenterY - 8
end

function Asset.removeMap(cellMap)
	for _, cell in pairs(cellMap) do
		cell:removeSelf()
	end
end

return Asset