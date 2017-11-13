-----------------------------------------------------------------------------------------
--
-- tmnscr.lua
-- Team Menu functions
-----------------------------------------------------------------------------------------
local Asset = require "scr.ovr.ascr"

local tMenu = {}

function tMenu.exit(event)
	menuGroup:removeSelf()
	menuGroup = nil
	menuGroup = display.newGroup()
	
	return true
end

function tMenu.load()
	menuGroup = display.newGroup()
	tMenu.background = Asset.drawImage(menuGroup, "back", 0, 0)
	tMenu.back = Asset.drawImage(menuGroup, "mnu", display.contentWidth/2 - 30, display.contentHeight/2)
	tMenu.back:addEventListener("tap", tMenu.exit)
	tMenu.text = Asset.drawGroupText(menuGroup, "TEAM MENU", 0, -display.contentHeight/2)
end

return tMenu