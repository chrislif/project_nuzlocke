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
			{	-- 1) down standing
				x = 0,
				y = 0,
				width = 33,
				height = 33,
			},
			{	-- 2) down left foot
				x = 33,
				y = 0,
				width = 33,
				height = 33,
			},
			{	-- 3) down right foot
				x = 0,
				y = 33,
				width = 33,
				height = 33,
			},
			{	-- 4 up standing
				x = 33,
				y = 33,
				width = 33,
				height = 33,
			},
			{	-- 5) up left foot
				x = 0,
				y = 66,
				width = 33,
				height = 33,
			},
			{	-- 6) up right foot
				x = 33,
				y = 66,
				width = 33,
				height = 33,
			},
			{	-- 7) stand right
				x = 0,
				y = 99,
				width = 33,
				height = 33,
			},
			{	-- 8) right left foot
				x = 33,
				y = 99,
				width = 33,
				height = 33,
			},
			{	-- 9) right right foot
				x = 0,
				y = 132,
				width = 33,
				height = 33
			},
			{	-- 10) stand left
				x = 33,
				y = 132,
				width = 33,
				height = 33,
			},
			{	-- 11) left left foot
				x = 0,
				y = 165,
				width = 33,
				height = 33,
			},
			{	-- 12) left right foot
				x = 33,
				y = 165,
				width = 33,
				height = 33,
			},
		},
	}
	local playerSheet = graphics.newImageSheet("ast/plr.png", playerOptions)
	
	local playerSequenceData =
	{
		{
		name = "stand_d",
		start = 1,
		count = 1,
		},
		{
		name = "stand_u",
		start = 4,
		count = 1,
		},
		{
		name = "stand_r",
		start = 7,
		count = 1,
		},
		{
		name = "stand_l",
		start = 8,
		count = 1,
		},
		{
		name = "walk_d",
		frames = {2, 1, 3, 1},
		time = 400,
		loopCount = 1,
		loopDirection = "forward"
		},
		{
		name = "walk_u",
		frames = {5, 4, 6, 4},
		time = 400,
		loopCount = 1,
		loopDirection = "forward"
		},
		{
		name = "walk_l",
		frames = {11, 10, 12, 10},
		time = 400,
		loopCount = 1,
		loopDirection = "forward"
		},
		{
		name = "walk_r",
		frames = {8, 7, 9, 7},
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
