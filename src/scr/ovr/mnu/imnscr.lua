-----------------------------------------------------------------------------------------
--
-- imnscr.lua
-- ID Menu functions
-----------------------------------------------------------------------------------------
local Asset = require "scr.ovr.ascr"

local iMenu = {}

function iMenu.exit(event)
	if event.phase == "began" then
		menuGroup:removeSelf()
		menuGroup = nil
		menuGroup = display.newGroup()
	end
	
	return true
end

function iMenu.load()
	menuGroup = display.newGroup()
	iMenu.background = Asset.drawImage(menuGroup, "back", 0, 0)
	iMenu.back = Asset.drawImage(menuGroup, "mnu", display.contentWidth/2 - 30, display.contentHeight/2)
	iMenu.text = Asset.drawGroupText(menuGroup, "ID MENU", 0, -display.contentHeight/2)
	return iMenu.back
end

return iMenu
