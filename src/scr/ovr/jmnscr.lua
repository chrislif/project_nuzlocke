-----------------------------------------------------------------------------------------
--
-- jmnscr.lua
-- Journal Menu functions
-----------------------------------------------------------------------------------------
local Asset = require "scr.ovr.ascr"

local jMenu = {}

function jMenu.exit(event)
	menuGroup:removeSelf()
	menuGroup = nil
	menuGroup = display.newGroup()
	
	return true
end

function jMenu.load()
	menuGroup = display.newGroup()
	jMenu.background = Asset.drawImage(menuGroup, "back", 0, 0)
	jMenu.back = Asset.drawImage(menuGroup, "mnu", display.contentWidth/2 - 30, display.contentHeight/2)
	jMenu.back:addEventListener("tap", jMenu.exit)
	jMenu.text = Asset.drawGroupText(menuGroup, "JOURNAL MENU", 0, -display.contentHeight/2)
end

return jMenu