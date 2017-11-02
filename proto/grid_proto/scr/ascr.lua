-----------------------------------------------------------------------------------------
--
-- ascr.lua
-- Asset functions
-----------------------------------------------------------------------------------------
local Asset = {}

local cellSize = 32

local imgTable = {}
imgTable[0] = "bar.png"
imgTable[1] = "grs.png"
imgTable[2] = "snd.png"
imgTable[3] = "wtr.png"

local sprTable = {}
sprTable[0] = "box.png"

function Asset.drawCell(cell, dx, dy)
	local img = imgTable[cell.typ]

	local newCell = display.newImage("assets/" .. img)
	newCell.x = display.contentCenterX + (dx * cellSize)
	newCell.y = display.contentCenterY + (dy * cellSize)
	
	return newCell
end

function Asset.drawObj(dx, dy)
	local img = sprTable[0]

	local newObj = display.newImage("assets/" .. img)
	newObj.x = display.contentCenterX + (dx * cellSize)
	newObj.y = display.contentCenterY + (dy * cellSize)
	
	return newObj
end

function Asset.drawPlayer()
	local player = display.newImage("assets/plr.png")
	player.x = display.contentCenterX
	player.y = display.contentCenterY - 16
end

function Asset.removeMap(cellMap)
	for _, cell in pairs(cellMap) do
		cell:removeSelf()
	end
end

return Asset