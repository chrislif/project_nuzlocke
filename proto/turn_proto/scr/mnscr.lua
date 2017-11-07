-----------------------------------------------------------------------------------------
--
-- mnscr.lua
-- Manager functions
-----------------------------------------------------------------------------------------
local UI = require "scr.uiscr"
local Data = require "scr.dscr"
local Calc = require "scr.calcscr"

local Manager = {}
local fileNumber = 1
local inputFlag = true

function Manager.getEnemyMove()
	local emov = {
		["typ"] = 1,
		["ID"] = Manager.eByt["MOV1"],
		["target"] = "player",
		["speed"] = Manager.eByt["SPE"],
	}
	local mov = {
		["typ"] = 0,
		["ID"] = 2,
		["target"] = "eTeam",
		["speed"] = 1000,
	}
	return emov
end

function Manager.getTarget(mov)
	local c_table = {
		["player"] = 0,
		["enemy"] = 1,
		["pTeam"] = 2,
		["eTeam"] = 3,
	}
	local target = c_table[mov["target"]]

	return target
end

function Manager.resolveMove(src, mov)	
	local target = Manager.getTarget(mov)
	local mov = Data.MOV[mov["ID"]]

	local user
	if src == Manager.eByt then
		user = "Enemy"
	elseif src == Manager.pByt then
		user = "Player"
	end
	
	print(user .. " Move ------------------------")
	
	if target == 0 then
		target = Manager.pByt
		local mod = Calc.getModifier(Data.BYT[src["BYTID"]]["TYPE1"], Data.BYT[src["BYTID"]]["TYPE2"], mov["TYPE"], 
										Data.BYT[target["BYTID"]]["TYPE1"], Data.BYT[target["BYTID"]]["TYPE2"])
		local atk = nil
		local def = nil
		if mov["ATK_TYPE"] == 0 then
			atk = src["ATK"]
			def = target["DEF"]
			print("PHYSICAL")
		else
			atk = src["SPATK"]
			def = target["SPDEF"]
			print("SPECIAL")
		end
		local damage = math.floor(Calc.calculateDamage(src["LEVEL"], mov["PWR"], atk, def, mod))
		print("dmg: " .. damage)
	elseif target == 1 then
		target = Manager.eByt
		local mod = Calc.getModifier(Data.BYT[src["BYTID"]]["TYPE1"], Data.BYT[src["BYTID"]]["TYPE2"], mov["TYPE"], 
										Data.BYT[target["BYTID"]]["TYPE1"], Data.BYT[target["BYTID"]]["TYPE2"])
		local atk = nil
		local def = nil
		if mov["ATK_TYPE"] == 0 then
			atk = src["ATK"]
			def = target["DEF"]
			print("PHYSICAL")
		else
			atk = src["SPATK"]
			def = target["SPDEF"]
			print("SPECIAL")
		end
		local damage = math.floor(Calc.calculateDamage(src["LEVEL"], mov["PWR"], atk, def, mod))
		print("dmg: " .. damage)
	elseif target == 2 then
		target = "Player Swap"
	elseif target == 3 then
		target = "Enemy Swap"
	end
end

function Manager.checkByts()
	if Manager.pByt["CURR_HP"] > 0 and Manager.eByt["CURR_HP"] > 0 then
		return true
	else
		return false
	end
end

function Manager.runTurn(event)
	-- Start Move
	local src = event.target
	if inputFlag == false or src.data == nil then return end
	
	local pSpeed = 0
	local eSpeed = 0
	if src.data.typ == 0 then
		if src.data["ID"] == Manager.pByt["ID"] then print("Byt is already out") return end
		pSpeed = 1000
	else
		pSpeed = Manager.pByt["SPE"]
	end
	local eMov = Manager.getEnemyMove()
	eSpeed = eMov["speed"]
	
	-- Calculate Speeds
	local firstMov = nil
	local firstSrc = nil
	local secondMov = nil
	local secondSrc = nil
	if pSpeed > eSpeed then
		firstMov = src.data
		firstSrc = Manager.pByt
		secondMov = eMov
		secondSrc = Manager.eByt
	else
		firstMov = eMov
		firstSrc = Manager.eByt
		secondMov = src.data
		secondSrc = Manager. pByt
	end
	
	-- Run Move
	Manager.resolveMove(firstSrc, firstMov)
	UI.update()
	if Manager.checkByts() then
		Manager.resolveMove(secondSrc, secondMov)
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
	-- Load Data
	Data.loadData()
	Data.loadTeams(fileNumber, 1)
	-- Load UI
	Manager.pByt = Data.PLY[1]
	Manager.eByt = Data.ENM[1]
	UI.loadUI(Data.MOV, Data.BYT, Data.PLY, Data.ENM, Manager.pByt, Manager.eByt)
	Manager.addEventListeners(UI.menu)
	UI.toggleBtn:addEventListener("tap", Manager.switchMenu)
	-- Pass Data
	Calc.passData(Data.TBL, Data.TYP, Data.MOV)
end

return Manager