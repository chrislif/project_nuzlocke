-----------------------------------------------------------------------------------------
--
-- bmnscr.lua
-- Belt Menu functions
-----------------------------------------------------------------------------------------
local Asset = require "scr.ovr.ascr"

local bMenu = {}

function bMenu.exit(event)
	if event.phase == "began" then
		menuGroup:removeSelf()
		menuGroup = nil
		menuGroup = display.newGroup()
	end
	
	return true
end

function bMenu.load()
	menuGroup = display.newGroup()
	bMenu.background = Asset.drawImage(menuGroup, "back", 0, 0)
	bMenu.back = Asset.drawImage(menuGroup, "mnu", display.contentWidth/2 - 30, display.contentHeight/2)
	bMenu.text = Asset.drawGroupText(menuGroup, "BELT MENU", 0, -display.contentHeight/2)
	return bMenu.back
end

return bMenu
