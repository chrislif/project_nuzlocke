-----------------------------------------------------------------------------------------
--
-- uiscr.lua
-- User Interface functions
-----------------------------------------------------------------------------------------
local Asset = require "scr.ascr"
local Calc = require "scr.calcscr"
local UI = {}
UI.state = "FIGHT"

local backGroup = display.newGroup()
local menuGroup = display.newGroup()

function UI.loadText(obj, textStr, dx, dy)
	local textOptions = {
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
			textString = UI.movData[movID]["NAME"] .. "\n" .. 
			movUses .. " / " .. UI.movData[movID]["USES"]
		end
		UI.loadText(btn, textString, 0, 0)
		if movID ~= 0 then
			btn.data = {
				["typ"] = 1,
				["ID"] = movID,
				["target"] = "enemy"
			}
		end
	elseif UI.state == "TEAM" then
		local byt = UI.pData[ID]
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
	
	shelf.health = Asset.loadSprite("hbar", shelf.dx, shelf.dy - 20, menuGroup)
	shelf.health.hPcnt = shelf.byt["CURR_HP"] / Calc.getStat("HP", shelf.byt)
	
	if shelf.health.hPcnt > 0 then
		UI.moveHealthBar(shelf.health, dir)
	else
		shelf.health:removeSelf()
	end
end

function UI.clearShelves()
	UI.pShelf.header:removeSelf()
	UI.pShelf.text:removeSelf()
	UI.pShelf:removeSelf()
	
	UI.eShelf.header:removeSelf()
	UI.eShelf.text:removeSelf()
	UI.eShelf:removeSelf()
end

function UI.loadShelves()
	-- Player Shelf
	UI.pShelf = Asset.loadImage("pshlf", 80, 105, menuGroup)
	UI.pShelf.byt = UI.pByt
	UI.pShelf.id = "player"
	UI.setHealthBar(UI.pShelf)
	UI.loadShelfText(UI.pShelf)
	-- Enemy Shelf
	UI.eShelf = Asset.loadImage("eshlf", -80, -215, menuGroup)
	UI.eShelf.byt = UI.eByt
	UI.eShelf.id = "enemy"
	UI.setHealthBar(UI.eShelf)
	UI.loadShelfText(UI.eShelf)
end

function UI.loadToggleBtn()
	UI.toggleBtn = Asset.loadImage("btn_6", 120, 175, menuGroup)
	UI.loadText(UI.toggleBtn, "TEAM", 0, 0)
end


function UI.load4BtnMenu()
	local btns = {
	[1] = Asset.loadImage("btn_4", -100, 175, menuGroup),
	[2] = Asset.loadImage("btn_4", 20, 175, menuGroup),
	[3] = Asset.loadImage("btn_4", -100, 235, menuGroup),
	[4] = Asset.loadImage("btn_4", 20, 235, menuGroup),
	}
	for ID, btn in pairs(btns) do
		UI.loadMenuText(btn, ID)
	end
	return btns
end

function UI.load6BtnMenu()
	local btns = {
	[1] = Asset.loadImage("btn_6", -120, 175, menuGroup),
	[2] = Asset.loadImage("btn_6", -40, 175, menuGroup),
	[3] = Asset.loadImage("btn_6", 40, 175, menuGroup),
	[4] = Asset.loadImage("btn_6", -120, 235, menuGroup),
	[5] = Asset.loadImage("btn_6", -40, 235, menuGroup),
	[6] = Asset.loadImage("btn_6", 40, 235, menuGroup),
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
end

function UI.loadMenu(state)
	UI.clearMenu()
	local menu = {}
	if state == "TEAM" then
		menu = UI.load6BtnMenu()
	else
		menu = UI.load4BtnMenu()
	end
	UI.runBtn = Asset.loadImage("btn_6", 120, 235, menuGroup)
	UI.runBtn:setFillColor(1, 0, 0)
	UI.menu = menu
end

function UI.loadBackground()
	UI.background = Asset.loadImage("back", 0, 0, backGroup)
end

function UI.loadUI(movData, bytData, pData, eData, pByt, eByt)
	-- Pass Data
	UI.eData = eData
	UI.pData = pData
	UI.bytData = bytData
	UI.movData = movData
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

return UI