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
	UI.runBtn:setFillColor( 1, 0, 0)
	UI.toggleBtn = Asset.loadImage("btn_6", 120, 175)
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
	local textOptions = 
	{
		text = bytHeaderString,
		fontSize = 15,
	}
	shelf.bytName = display.newText(textOptions)
	shelf.bytName.x = shelf.x - shelf.contentWidth/8
	shelf.bytName.y = shelf.y - shelf.contentHeight/2 - 8
	shelf.bytName:setFillColor(0, 0, 0)
end

function UI.loadShelves()
	UI.pShelf = Asset.loadImage("pshlf", 80, 105)
	UI.pShelf.byt = UI.pByt
	UI.loadShelfText(UI.pShelf)
	UI.eShelf = Asset.loadImage("eshlf", -80, -215)
	UI.eShelf.byt = UI.eByt
	UI.loadShelfText(UI.eShelf)
end

function UI.switchMenu()
	if UI.state == "FIGHT" then
		UI.state = "TEAM"
	else
		UI.state = "FIGHT"
	end
	UI.loadMenu(UI.state)
end

function UI.addEventListeners()
	UI.toggleBtn:addEventListener("tap", UI.switchMenu)
end

function UI.loadBackground()
	UI.background = Asset.loadImage("back", 0, 0)
end

function UI.loadUI()
	UI.loadBackground()
	UI.pByt = Data.PLY[1]
	UI.eByt = Data.ENM[1]
	UI.loadMenu("FIGHT")
	UI.loadShelves()
	UI.addEventListeners()
end

return UI