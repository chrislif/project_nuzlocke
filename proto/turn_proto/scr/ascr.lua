-----------------------------------------------------------------------------------------
--
-- ascr.lua
-- Asset functions
-----------------------------------------------------------------------------------------
local Sprite = require "scr.spscr"
local Asset = {}

function Asset.loadData()
	Sprite.loadSpriteSheets()
end

function Asset.loadImage(img, dx, dy, bGroup)
	local newImage = display.newImage(bGroup, "ast/" .. img .. ".png")
	newImage.dx = dx
	newImage.dy = dy
	newImage.x = display.contentCenterX + dx
	newImage.y = display.contentCenterY + dy
	return newImage
end

function Asset.loadSprite(img, dx, dy, dGroup)
	local newSprite = display.newSprite(dGroup, Sprite.spriteSheetTable[img], Sprite.spriteSheetTable[img .. "Data"])
	newSprite.dx = dx
	newSprite.dy = dy
	newSprite.x = display.contentCenterX + dx
	newSprite.y = display.contentCenterY + dy
	return newSprite
end

return Asset