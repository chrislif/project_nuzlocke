-----------------------------------------------------------------------------------------
--
-- mnscr.lua
-- Menu functions
-----------------------------------------------------------------------------------------
local Asset = require "scr.ovr.ascr"

local Menu = {}
Menu.menuBtn = nil
Menu.state = "hide"

function Menu.load()
	Menu.menuBtn = Asset.drawMenu("mnu", display.contentWidth/2 - 30, display.contentHeight/2)
end

function Menu.toggle(event)
	if Menu.state == "hide" then
		Menu.show()
	else
		Menu.hide()
	end
	
end

function Menu.hide(event)
	print("hide")
	Menu.state = "hide"
	
end

function Menu.show(event)
	print("show")
	Menu.state = "show"
	
end


return Menu