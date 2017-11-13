-----------------------------------------------------------------------------------------
--
-- bmnscr.lua
-- Belt Menu functions
-----------------------------------------------------------------------------------------
local Asset = require "scr.ovr.ascr"

local bMenu = {}

function bMenu.exit(event)
	menuGroup:removeSelf()
	menuGroup = nil
	menuGroup = display.newGroup()
	
	return true
end

function bMenu.load()
	menuGroup = display.newGroup()
	bMenu.background = Asset.drawImage(menuGroup, "back", 0, 0)
	bMenu.back = Asset.drawImage(menuGroup, "mnu", display.contentWidth/2 - 30, display.contentHeight/2)
	bMenu.back:addEventListener("tap", bMenu.exit)
	bMenu.text = Asset.drawGroupText(menuGroup, "BELT MENU", 0, -display.contentHeight/2)
end

return bMenu