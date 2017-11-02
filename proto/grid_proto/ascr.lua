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
sprTable[0] = "plr.png"

function Asset.drawCell(cell, dx, dy)
	local img = imgTable[cell.typ]

	local newCell = display.newImage("assets/" .. img)
	newCell.x = display.contentCenterX + (dx * cellSize)
	newCell.y = display.contentCenterY + (dy * cellSize)
	
	return newCell
end

function Asset.removeMap(cellMap)
	for _, cell in pairs(cellMap) do
		cell:removeSelf()
	end
end

return Asset