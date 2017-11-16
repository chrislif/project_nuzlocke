-----------------------------------------------------------------------------------------
--
-- jmnscr.lua
-- Journal Menu functions
-----------------------------------------------------------------------------------------
local Asset = require "scr.ovr.ascr"

local jMenu = {}

function jMenu.exit(event)
	if event.phase == "began" then
		menuGroup:removeSelf()
		menuGroup = nil
		menuGroup = display.newGroup()
	end
	
	return true
end

function jMenu.load()
	menuGroup = display.newGroup()
	jMenu.background = Asset.drawImage(menuGroup, "back", 0, 0)
	jMenu.back = Asset.drawImage(menuGroup, "mnu", display.contentWidth/2 - 30, display.contentHeight/2)
	jMenu.text = Asset.drawGroupText(menuGroup, "JOURNAL MENU", 0, -display.contentHeight/2)
	return jMenu.back
end

return jMenu
