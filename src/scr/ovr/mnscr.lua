-----------------------------------------------------------------------------------------
--
-- mnscr.lua
-- Menu functions
-----------------------------------------------------------------------------------------
local Asset = require "scr.ovr.ascr"
local tMenu = require "scr.ovr.tmnscr"
local bMenu = require "scr.ovr.bmnscr"
local iMenu = require "scr.ovr.imnscr"
local jMenu = require "scr.ovr.jmnscr"
local oMenu = require "scr.ovr.omnscr"

local Menu = {}
Menu.menuBtn = nil
Menu.state = "hide"
Menu.menu = nil
Menu.menuFlag = true

function Menu.load()
	Menu.menuBtn = Asset.drawMenu("mnu", display.contentWidth/2 - 30, display.contentHeight/2)
end

function Menu.toggle()
	if Menu.menuFlag == true then
		if Menu.state == "hide" then
			Menu.show()
		else
			Menu.hide()
		end
	end
end

function Menu.hide(event)
	print("hide")
	Menu.state = "hide"
	for i, obj in pairs(Menu.menu) do
		obj.text:removeSelf()
		obj.text = nil
		obj:removeSelf()
		i = nil
	end
	Menu.menu = nil
end

function Menu.exit(event)
	if event.phase == "began" then
		menuGroup:removeSelf()
		menuGroup = nil
		menuGroup = display.newGroup()
	end
	
	Menu.menuFlag = true
end

function Menu.chooseMenu(event)
	if event.phase == "began" then
		local menuBtn = nil
		if Menu.menuFlag == true then
			local self = event.target
			if self.id == 0 then
				menuBtn = oMenu.load()
			elseif self.id == 1 then
				menuBtn = jMenu.load()
			elseif self.id == 2 then
				menuBtn = iMenu.load()
			elseif self.id == 3 then
				menuBtn = bMenu.load()
			elseif self.id == 4 then
				menuBtn = tMenu.load()
			end	
			menuBtn:addEventListener("touch", Menu.exit)
		end
		Menu.menuFlag = false
	end
end

function Menu.drawMenu()
	Menu.menu = {
	[0] = Asset.drawMenu("btn_4", display.contentWidth/2 - 64, display.contentHeight/2 - 64),
	[1] = Asset.drawMenu("btn_4", display.contentWidth/2 - 64, display.contentHeight/2 - 128),
	[2] = Asset.drawMenu("btn_4", display.contentWidth/2 - 64, display.contentHeight/2 - 192),
	[3] = Asset.drawMenu("btn_4", display.contentWidth/2 - 64, display.contentHeight/2 - 256),
	[4] = Asset.drawMenu("btn_4", display.contentWidth/2 - 64, display.contentHeight/2 - 320),
	}
	local t_table = {
	[0] = "OPTIONS",
	[1] = "JOURNAL",
	[2] = "ID",
	[3] = "BELT",
	[4] = "TEAM",
	}
	for i, obj in pairs(Menu.menu) do
		obj.text = Asset.drawText(t_table[i], obj.dx, obj.dy)
		obj.id = i
		obj:addEventListener("touch", Menu.chooseMenu)
	end
	
end

function Menu.show(event)
	print("show")
	Menu.state = "show"
	if Menu.menu ~= nil then
		Menu.hide()
	end
	Menu.drawMenu()
end


return Menu
