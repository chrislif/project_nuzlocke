-----------------------------------------------------------------------------------------
--
-- turn.lua
-- Turn Manager functions - Experimental
-----------------------------------------------------------------------------------------
local composer = require "composer"
local Data = require "scr.dscr"
local UI = require "scr.btl.uiscr"
local fileNumber = 1

local Manager = {}
local inputFlag = false
local toggleFlag = false

function Manager.switchMenu()	-- Switch Menu between Fight and Team
	if toggleFlag == false then return end
	if UI.state == "FIGHT" then
		UI.state = "TEAM"
		UI.toggleBtn.text.text = "FIGHT"
	else
		UI.state = "FIGHT"
		UI.toggleBtn.text.text = "TEAM"
	end
	Manager.removeEventListeners(UI.menu)
	UI.loadMenu(UI.state)
	Manager.addEventListeners(UI.menu)
end

function Manager.printText(data)
	inputFlag = false
	toggleFlag = false
	UI.loadTextBox(Data.MOV[data["ID"]]["NAME"])
	
	
end

function Manager.runTurn(event)
	local src = event.target
	
	if inputFlag == false or src.data == nil then 
		return
	else
		print("INPUT")
		Manager.printText(src.data)
	end
end

function Manager.addEventListeners(menu)	-- Normal Menu Listeners
	for _, obj in pairs(menu) do
		obj:addEventListener("tap", Manager.runTurn)
	end
end

function Manager.removeEventListeners(menu)	-- Remove all Menu Listeners
	for _, obj in pairs(menu) do
		obj:removeEventListener("tap", Manager.runTurn)
	end
end

function Manager.startBattle()
	inputFlag = true
	toggleFlag = true
	-- Load Data
	Data.loadTeams(fileNumber, 1)
	-- Load Teams
	Manager.pByt = Data.PLY[1]
	Manager.eByt = Data.ENM[1]
	UI.loadUI(Manager.pByt, Manager.eByt)
	UI.toggleBtn:addEventListener("tap", Manager.switchMenu)
	Manager.addEventListeners(UI.menu)
end

function Manager.exitScene(event)
	UI.remove()
end

return Manager
