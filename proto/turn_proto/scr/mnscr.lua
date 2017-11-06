-----------------------------------------------------------------------------------------
--
-- mnscr.lua
-- Manager functions
-----------------------------------------------------------------------------------------
local UI = require "scr.uiscr"
local Data = require "scr.dscr"

local Manager = {}
local fileNumber = 1
local inputFlag = true

function Manager.runTurn(event)
	if inputFlag == false then return end
	local src = event.target
	--inputFlag = false
	if src.data ~= nil then
		print(src.data["ID"])
	end
end

function Manager.addEventListeners(menu)
	for _, obj in pairs(menu) do
		obj:addEventListener("tap", Manager.runTurn)
	end
end

function Manager.removeEventListeners(menu)
	for _, obj in pairs(menu) do
		obj:removeEventListener("tap", Manager.runTurn)
	end
end

function Manager.switchMenu()
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

function Manager.startBattle()
	Data.loadData()
	Data.loadTeams(fileNumber, 1)
	UI.loadUI()
	Manager.addEventListeners(UI.menu)
	UI.toggleBtn:addEventListener("tap", Manager.switchMenu)
end

return Manager