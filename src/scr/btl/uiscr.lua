-----------------------------------------------------------------------------------------
--
-- uiscr.lua
-- User Interface functions
-----------------------------------------------------------------------------------------
local Asset = require "scr.btl.ascr"
local Calc = require "scr.btl.calcscr"
local Data = require "scr.btl.dscr"

local UI = {}
UI.state = "FIGHT"

function UI.loadText(obj, textStr, dx, dy)
	local textOptions = {
		parent = UI.menuGroup,
		text = textStr,
		fontSize = 15,
		align = "center"
	}
	obj.text = display.newText(textOptions)
	obj.text.x = obj.x + dx
	obj.text.y = obj.y + dy
	obj.text:setFillColor(0, 0, 0)
	return obj.text
end

function UI.loadMenuText(btn, ID)
	if UI.state == "FIGHT" then
		local movID = UI.pByt["MOV" .. ID]
		local movUses = UI.pByt["M" .. ID .. "_U"]
		local textString = ""
		if movID ~= 0 then
			textString = Data.MOV[movID]["NAME"] .. "\n" .. 
			movUses .. " / " .. Data.MOV[movID]["USES"]
		end
		UI.loadText(btn, textString, 0, 0)
		if movID ~= 0 then
			btn.data = {
				["typ"] = 1,
				["ID"] = movID,
				["move"] = "M" .. ID,
				["target"] = "enemy",
			}
		end
	elseif UI.state == "TEAM" then
		local byt = Data.PLY[ID]
		local textString = ""
		if byt ~= nil then
			textString = byt["NAME"] .. "\n" ..
			byt["CURR_HP"] .."/" .. Calc.getStat("HP", byt)
		end
		UI.loadText(btn, textString, 0, 0)
		if byt ~= nil then
			btn.data = {
				["typ"] = 0,
				["ID"] = byt["ID"],
				["target"] = "pTeam"
			}
		end
	end
end

function UI.loadShelfText(shelf)
	local bytHeaderString = shelf.byt["NAME"] .. " - LV" .. shelf.byt["LEVEL"]
	shelf.header = UI.loadText(shelf, bytHeaderString, -shelf.contentWidth/8, -shelf.contentHeight/2 - 8)
	local healthString = shelf.byt["CURR_HP"] .. "/" .. Calc.getStat("HP", shelf.byt)
	UI.loadText(shelf, healthString, 0, -8)
end

function UI.moveHealthBar(hbar, dir)
	local eq = dir * math.floor(hbar.contentWidth/2 - (hbar.contentWidth * hbar.hPcnt)/2)
	hbar.xScale = hbar.hPcnt
	if hbar.xScale < 0.25 then
		hbar:setSequence("low")
	end
	hbar.x = hbar.x + eq
end

function UI.setHealthBar(shelf)
	local dir = 0
	if shelf.id == "player" then 
		dir = 1
	else 
		dir = -1
	end
	
	shelf.health = Asset.loadSprite("hbar", shelf.dx, shelf.dy - 20, UI.menuGroup)
	shelf.health.hPcnt = shelf.byt["CURR_HP"] / Calc.getStat("HP", shelf.byt)
	
	if shelf.health.hPcnt > 0 then
		UI.moveHealthBar(shelf.health, dir)
	else
		shelf.health:removeSelf()
		shelf.health = nil
	end
end

function UI.setStatus(shelf)
	shelf.status = nil
	
	local c_table = {
		[0] = nil,
		[1] = "brn",
		[2] = "psn",
		[3] = "stn",
		[4] = "frz",
		[5] = "slp",
	}
	if c_table[shelf.byt["CURR_EFT"]] ~= nil then
		shelf.status = Asset.loadImage(c_table[shelf.byt["CURR_EFT"]] .. "_lb", shelf.dx + 60, shelf.dy - 40, UI.menuGroup)
	end
end

function UI.clearShelves()
	if UI.pShelf ~= nil then
		UI.pShelf.header:removeSelf()
		UI.pShelf.header = nil
		UI.pShelf.text:removeSelf()
		UI.pShelf.text = nil	
		if UI.pShelf.status ~= nil then
			UI.pShelf.status:removeSelf()
			UI.pShelf.status = nil
		end
		if UI.pShelf.health ~= nil then
			UI.pShelf.health:removeSelf()
			UI.pShelf.health = nil
		end
		UI.pShelf:removeSelf()
		UI.pShelf = nil
	end
	
	if UI.eShelf ~= nil then
		UI.eShelf.header:removeSelf()
		UI.eShelf.header = nil
		UI.eShelf.text:removeSelf()
		UI.eShelf.text = nil
		if UI.eShelf.status ~= nil then
			UI.eShelf.status:removeSelf()
			UI.eShelf.status = nil
		end
		if UI.eShelf.health ~= nil then
			UI.eShelf.health:removeSelf()
			UI.eShelf.health = nil
		end
		UI.eShelf:removeSelf()
		UI.eShelf = nil
	end
end

function UI.loadShelves()
	-- Player Shelf
	UI.pShelf = Asset.loadImage("pshlf", 80, 105, UI.menuGroup)
	UI.pShelf.byt = UI.pByt
	UI.pShelf.id = "player"
	UI.setHealthBar(UI.pShelf)
	UI.loadShelfText(UI.pShelf)
	UI.setStatus(UI.pShelf)
	
	-- Enemy Shelf
	UI.eShelf = Asset.loadImage("eshlf", -80, -215, UI.menuGroup)
	UI.eShelf.byt = UI.eByt
	UI.eShelf.id = "enemy"
	UI.setHealthBar(UI.eShelf)
	UI.loadShelfText(UI.eShelf)
	UI.setStatus(UI.eShelf)
end

function UI.removeToggleBtn()
	UI.toggleBtn.text:removeSelf()
	UI.toggleBtn:removeSelf()
end

function UI.loadToggleBtn()
	UI.toggleBtn = Asset.loadImage("btn_6", 120, 175, UI.menuGroup)
	UI.loadText(UI.toggleBtn, "TEAM", 0, 0)
end

function UI.load4BtnMenu()
	local btns = {
	[1] = Asset.loadImage("btn_4", -100, 175, UI.menuGroup),
	[2] = Asset.loadImage("btn_4", 20, 175, UI.menuGroup),
	[3] = Asset.loadImage("btn_4", -100, 235, UI.menuGroup),
	[4] = Asset.loadImage("btn_4", 20, 235, UI.menuGroup),
	}
	for ID, btn in pairs(btns) do
		UI.loadMenuText(btn, ID)
	end
	return btns
end

function UI.load6BtnMenu()
	local btns = {
	[1] = Asset.loadImage("btn_6", -120, 175, UI.menuGroup),
	[2] = Asset.loadImage("btn_6", -40, 175, UI.menuGroup),
	[3] = Asset.loadImage("btn_6", 40, 175, UI.menuGroup),
	[4] = Asset.loadImage("btn_6", -120, 235, UI.menuGroup),
	[5] = Asset.loadImage("btn_6", -40, 235, UI.menuGroup),
	[6] = Asset.loadImage("btn_6", 40, 235, UI.menuGroup),
	}
	for ID, btn in pairs(btns) do
		UI.loadMenuText(btn, ID)
	end
	return btns
end

function UI.clearMenu()
	if UI.menu ~= nil then
		for _, obj in pairs(UI.menu) do
			obj.text:removeSelf()
			obj:removeSelf()
			obj = nil
		end
	end
	if UI.runBtn ~= nil then
		UI.runBtn:removeSelf()
	end
end

function UI.loadMenu(state)
	UI.clearMenu()
	local menu = {}
	if state == "TEAM" then
		menu = UI.load6BtnMenu()
	else
		menu = UI.load4BtnMenu()
	end
	UI.runBtn = Asset.loadImage("btn_6", 120, 235, UI.menuGroup)
	UI.runBtn:setFillColor(1, 0, 0)
	UI.menu = menu
end

function UI.loadBackground()
	UI.background = Asset.loadImage("back", 0, 0, UI.backGroup)
end

function UI.loadUI(pByt, eByt)
	if UI.backGroup == nil then
		UI.backGroup = display.newGroup()
	end
	if UI.menuGroup == nil then
		UI.menuGroup = display.newGroup()
	end

	UI.pByt = pByt
	UI.eByt = eByt
	
	Asset.loadData()
	UI.loadBackground()
	UI.loadMenu("FIGHT")
	UI.loadToggleBtn()
	UI.loadShelves()
end

function UI.update(pByt, eByt)
	UI.clearShelves()
	UI.pByt = pByt
	UI.eByt = eByt
	UI.loadShelves()
end

function UI.remove()
	UI.backGroup:removeSelf()
	UI.backGroup = nil
	UI.menuGroup:removeSelf()
	UI.menuGroup = nil
	UI.menu = nil
	UI.toggleBtn = nil
	UI.runBtn = nil
end

return UI