-----------------------------------------------------------------------------------------
--
-- ascr.lua
-- Asset functions
-----------------------------------------------------------------------------------------

local Asset = {}

function Asset.loadImage(img, dx, dy)
	local newImage = display.newImage("ast/" .. img .. ".png")
	newImage.x = display.contentCenterX + dx
	newImage.y = display.contentCenterY + dy
	return newImage
end

return Asset