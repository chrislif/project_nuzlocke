-----------------------------------------------------------------------------------------
--
-- tmnscr.lua
-- Team Menu functions
-----------------------------------------------------------------------------------------
local Asset = require "scr.ovr.ascr"

local tMenu = {}

function tMenu.exit(event)
	if event.phase == "began" then
		menuGroup:removeSelf()
		menuGroup = nil
		menuGroup = display.newGroup()
	end
	
	return true
end

function tMenu.load()
	menuGroup = display.newGroup()
	tMenu.background = Asset.drawImage(menuGroup, "back", 0, 0)
	tMenu.back = Asset.drawImage(menuGroup, "mnu", display.contentWidth/2 - 30, display.contentHeight/2)
	tMenu.text = Asset.drawGroupText(menuGroup, "TEAM MENU", 0, -display.contentHeight/2)
	return tMenu.back
end

return tMenu