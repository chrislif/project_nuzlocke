-----------------------------------------------------------------------------------------
--
-- spscr.lua
-- Sprite functions
-----------------------------------------------------------------------------------------
local Sprite = {}

function Sprite.loadSpriteSheets()
	Sprite.spriteSheetTable = {}

	local healthBarOptions =
	{
		frames =
		{
			{	-- 1) normal
				x = 0,
				y = 0,
				width = 150,
				height = 10,
			},
			{	-- 2) low health
				x = 0,
				y = 10,
				width = 150,
				height = 10,
			},
		},
	}
	local healthBarSheet = graphics.newImageSheet("ast/hbar.png", healthBarOptions)
	
	local healthBarSequenceData =
	{
		{
		name = "normal",
		start = 1,
		count = 1,
		},
		{
		name = "low",
		start = 2,
		count = 1,
		},
	}
	data = healthBarSequenceData
	
	Sprite.spriteSheetTable["hbar"] = healthBarSheet
	Sprite.spriteSheetTable["hbarData"] = healthBarSequenceData
end
	

return Sprite
