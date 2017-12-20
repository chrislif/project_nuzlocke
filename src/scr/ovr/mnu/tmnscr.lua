-----------------------------------------------------------------------------------------
--
-- tmnscr.lua
-- Team Menu functions
-----------------------------------------------------------------------------------------
local Asset = require "scr.ovr.ascr"
local Data = require "scr.dscr"
local Calc = require "scr.btl.calcscr"

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
	
	-- Title
	tMenu.text = Asset.drawGroupText(menuGroup, "TEAM MENU", 0, -display.contentHeight/2)
	
	for id, byt in pairs(Data.PLY) do
		-- Team ID
		local id_tag = Asset.drawGroupText(menuGroup, "BYT " .. id, -display.contentWidth/3, -display.contentHeight/2 + (64 * tonumber(id)))
		-- Name
		local name_tag = Asset.drawGroupText(menuGroup, byt["NAME"], -display.contentWidth/3 + 64, -display.contentHeight/2 + (64 * tonumber(id)))
		-- Current HP
		local curr_hp_tag = Asset.drawGroupText(menuGroup, byt["CURR_HP"], -display.contentWidth/3, -display.contentHeight/2 + (64 * tonumber(id)) + 32)
		-- Max HP
		local max_hp_tag = Asset.drawGroupText(menuGroup, " / " .. Calc.getStat("HP", byt), -display.contentWidth/3 + 26, -display.contentHeight/2 + (64 * tonumber(id)) + 32)	
	end
	 
	return tMenu.back
end

return tMenu
