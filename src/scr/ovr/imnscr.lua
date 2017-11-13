-----------------------------------------------------------------------------------------
--
-- imnscr.lua
-- ID Menu functions
-----------------------------------------------------------------------------------------
local Asset = require "scr.ovr.ascr"

local iMenu = {}

function iMenu.exit(event)
	menuGroup:removeSelf()
	menuGroup = nil
	menuGroup = display.newGroup()
	
	return true
end

function iMenu.load()
	menuGroup = display.newGroup()
	iMenu.background = Asset.drawImage(menuGroup, "back", 0, 0)
	iMenu.back = Asset.drawImage(menuGroup, "mnu", display.contentWidth/2 - 30, display.contentHeight/2)
	iMenu.back:addEventListener("tap", iMenu.exit)
	iMenu.text = Asset.drawGroupText(menuGroup, "ID MENU", 0, -display.contentHeight/2)
end

return iMenu