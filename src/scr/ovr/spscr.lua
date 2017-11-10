-----------------------------------------------------------------------------------------
--
-- spscr.lua
-- Sprite functions
-----------------------------------------------------------------------------------------
local Sprite = {}

function Sprite.loadSpriteSheets()
	local spriteSheetTable = {}
	
	-- Player
	local playerOptions = 
	{
		frames = 
		{
			{	-- 1) standing
				x = 0,
				y = 0,
				width = 33,
				height = 33,
			},
			{	-- 2) left foot forward
				x = 0,
				y = 33,
				width = 33,
				height = 33,
			},
			{	-- 3) transition stand
				x = 0,
				y = 66,
				width = 33,
				height = 33,
			},
			{	-- 4) right foot forward
				x = 0,
				y = 99,
				width = 33,
				height = 33
			},
		},
	}
	local playerSheet = graphics.newImageSheet("ast/plr.png", playerOptions)
	
	local playerSequenceData =
	{
		{
		name = "idle",
		start = 1,
		count = 1,
		},
		{
		name = "dwalk",
		frames = {2, 3, 4, 1},
		time = 400,
		loopCount = 1,
		loopDirection = "forward"
		},
	}
	
	spriteSheetTable["player"] = playerSheet
	spriteSheetTable["playerData"] = playerSequenceData

	return spriteSheetTable
end

return Sprite