-----------------------------------------------------------------------------------------
--
-- uiscr.lua
-- User Interface functions
-----------------------------------------------------------------------------------------
local Asset = require "scr.ascr"
local Data = require "scr.dscr"
local UI = {}
UI.state = "FIGHT"

function UI.loadBtnText(btn, ID)
	if UI.state == "FIGHT" then
		local movID = tonumber(UI.pByt["MOV" .. ID])
		local movUses = tostring(UI.pByt["M" .. ID .. "_U"])
		local textString = ""
		if movID ~= 0 then
			textString = Data.MOV[movID]["NAME"] .. "\n" .. 
						 movUses .. " / " .. Data.MOV[movID]["USES"]
		end
		local textOptions =
		{
		text = textString,
		}
		btn.text = display.newText(textOptions)
		btn.data = Data.MOV[movID]
		btn.text:setFillColor(0, 0, 0)
		btn.text.x = btn.x
		btn.text.y = btn.y
	elseif UI.state == "TEAM" then
		local byt = Data.PLY[ID]
		local textString = ""
		if byt ~= nil then
			textString = byt["NAME"] .. "\n" ..
			byt["CURR_HP"] .."/" .. Data.BYT[byt["ID"]]["HP"]
		end
		local textOptions = 
		{
		text = textString,
		fontSize = 15,
		}
		btn.text = display.newText(textOptions)
		btn.data = byt
		btn.text:setFillColor(0, 0, 0)
		btn.text.x = btn.x
		btn.text.y = btn.y
	end
end

function UI.load4BtnMenu()
	local btns = {
	[1] = Asset.loadImage("btn_4", -100, 175),
	[2] = Asset.loadImage("btn_4", 20, 175),
	[3] = Asset.loadImage("btn_4", -100, 235),
	[4] = Asset.loadImage("btn_4", 20, 235),
	}
	for ID, btn in pairs(btns) do
		UI.loadBtnText(btn, ID)
	end
	return btns
end

function UI.load6BtnMenu()
	local btns = {
	[1] = Asset.loadImage("btn_6", -120, 175),
	[2] = Asset.loadImage("btn_6", -40, 175),
	[3] = Asset.loadImage("btn_6", 40, 175),
	[4] = Asset.loadImage("btn_6", -120, 235),
	[5] = Asset.loadImage("btn_6", -40, 235),
	[6] = Asset.loadImage("btn_6", 40, 235),
	}
	for ID, btn in pairs(btns) do
		UI.loadBtnText(btn, ID)
	end
	return btns
end

function UI.loadMenu(state)
	UI.clearMenu()
	local menu = {}
	if state == "TEAM" then
		menu = UI.load6BtnMenu()
	else
		menu = UI.load4BtnMenu()
	end
	UI.runBtn = Asset.loadImage("btn_6", 120, 235)
	UI.runBtn:setFillColor(1, 0, 0)
	UI.menu = menu
end

function UI.clearMenu()
	if UI.menu == nil then return end
	for _, obj in pairs(UI.menu) do
		obj:removeSelf()
		obj = nil
	end
end

function UI.loadShelfText(shelf)
	local bytHeaderString = shelf.byt["NAME"] .. " - LV" .. shelf.byt["LEVEL"]
	local textOptions = {
		text = bytHeaderString,
		fontSize = 15,
	}
	shelf.bytName = display.newText(textOptions)
	shelf.bytName.x = shelf.x - shelf.contentWidth/8
	shelf.bytName.y = shelf.y - shelf.contentHeight/2 - 8
	shelf.bytName:setFillColor(0, 0, 0)
	textOptions = {
		text = shelf.byt["CURR_HP"] .. "/" .. Data.BYT[shelf.byt["ID"]]["HP"],
	}
	shelf.bytHP = display.newText(textOptions)
	shelf.bytHP.x = shelf.x
	shelf.bytHP.y = shelf.y - 8
	shelf.bytHP:setFillColor(0, 0, 0)
end

function UI.loadShelves()
	UI.pShelf = Asset.loadImage("pshlf", 80, 105)
	UI.pShelf.byt = UI.pByt
	UI.loadShelfText(UI.pShelf)
	UI.eShelf = Asset.loadImage("eshlf", -80, -215)
	UI.eShelf.byt = UI.eByt
	UI.loadShelfText(UI.eShelf)
end

function UI.loadBackground()
	UI.background = Asset.loadImage("back", 0, 0)
end

function UI.loadToggleBtn()
	UI.toggleBtn = Asset.loadImage("btn_6", 120, 175)
	local textOptions = {
		text = "TEAM",
	}
	UI.toggleBtn.text = display.newText(textOptions)
	UI.toggleBtn.text:setFillColor(0, 0, 0)
	UI.toggleBtn.text.x = UI.toggleBtn.x
	UI.toggleBtn.text.y = UI.toggleBtn.y
end

function UI.loadUI()
	UI.loadBackground()
	UI.pByt = Data.PLY[1]
	UI.eByt = Data.ENM[1]
	UI.loadMenu("FIGHT")
	UI.loadToggleBtn()
	UI.loadShelves()
end

return UI