-----------------------------------------------------------------------------------------
--
-- omnscr.lua
-- Options Menu functions
-----------------------------------------------------------------------------------------
local Asset = require "scr.ovr.ascr"

local oMenu = {}

function oMenu.exit(event)
	menuGroup:removeSelf()
	menuGroup = nil
	menuGroup = display.newGroup()
	
	return true
end

function oMenu.load()
	menuGroup = display.newGroup()
	oMenu.background = Asset.drawImage(menuGroup, "back", 0, 0)
	oMenu.back = Asset.drawImage(menuGroup, "mnu", display.contentWidth/2 - 30, display.contentHeight/2)
	oMenu.back:addEventListener("tap", oMenu.exit)
	oMenu.text = Asset.drawGroupText(menuGroup, "OPTIONS MENU", 0, -display.contentHeight/2)
end

return oMenu