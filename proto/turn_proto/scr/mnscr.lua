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
local toggleFlag = true

function Manager.getEnemyByt()	-- Get new Enemy Byt on Death
	local nextID = Manager.eByt["ID"] + 1
	if Data.ENM[nextID] ~= nil then
		Manager.eByt = Data.ENM[nextID]
		UI.update(Manager.pByt, Manager.eByt)
	else
		print("PLAYER WINS")
	end
end

function Manager.getEnemyMove()	-- Get Enemy Move
	local id = 0
	
	while id == 0 do
		local roll = math.random(1, 4)
		local c_table = {
			[1] = Manager.eByt["MOV1"],
			[2] = Manager.eByt["MOV2"],
			[3] = Manager.eByt["MOV3"],
			[4] = Manager.eByt["MOV4"],
		}
		
		id = c_table[roll]
		print(id)
	end
	
	local mov = Data.MOV[id]
	
	return mov
end

function Manager.getTarget(mov)	-- Get Target for a Move
	local c_table = {
		["player"] = 0,
		["enemy"] = 1,
		["pTeam"] = 2,
		["eTeam"] = 3,
	}
	local target = c_table[mov["target"]]

	return target
end

function Manager.resolveMove(src, mov)	-- Resolve a Move
	local target = Manager.getTarget(mov)
	local mov = Data.MOV[mov["ID"]]
	local damage = nil
	local effect = nil

	local user
	if src == Manager.eByt then
		user = "Enemy"
	elseif src == Manager.pByt then
		user = "Player"
	end
	
	if target == 0 then
		target = Manager.pByt
		local mod = Calc.getModifier(Data.BYT[src["BYTID"]]["TYPE1"], Data.BYT[src["BYTID"]]["TYPE2"], mov["TYPE"], 
										Data.BYT[target["BYTID"]]["TYPE1"], Data.BYT[target["BYTID"]]["TYPE2"])
		local atk = nil
		local def = nil
		if mov["ATK_TYPE"] == 0 then
			atk = Calc.getStat("ATK", src)
			def = Calc.getStat("DEF", target)
		else
			atk = Calc.getStat("SPATK", src)
			def = Calc.getStat("SPDEF", target)
		end
		damage = Calc.calculateDamage(src["LEVEL"], mov["PWR"], atk, def, mod)
		effect = Calc.rollEffect(mov["EFFECT"], mov["%EFFECT"])
		
	elseif target == 1 then
		target = Manager.eByt
		local mod = Calc.getModifier(Data.BYT[src["BYTID"]]["TYPE1"], Data.BYT[src["BYTID"]]["TYPE2"], mov["TYPE"], 
										Data.BYT[target["BYTID"]]["TYPE1"], Data.BYT[target["BYTID"]]["TYPE2"])
		local atk = nil
		local def = nil
		if mov["ATK_TYPE"] == 0 then
			atk = Calc.getStat("ATK", src)
			def = Calc.getStat("DEF", target)
		else
			atk = Calc.getStat("SPATK", src)
			def = Calc.getStat("SPDEF", target)
		end
		damage = Calc.calculateDamage(src["LEVEL"], mov["PWR"], atk, def, mod)
		
		effect = Calc.rollEffect(mov["EFFECT"], mov["%EFFECT"])
		
	elseif target == 2 then
		target = Data.PLY[mov["ID"]]
		effect = 1
		
	elseif target == 3 then
		target = Data.ENM[mov["ID"]]
		effect = 1
		
	end

	Manager.applyDamage(target, damage)
	Manager.applyEffect(target, effect)
end
	
function Manager.applyDamage(target, damage)	-- Apply Damage to Target
	if damage ~= nil and damage ~= 0 then
		target["CURR_HP"] = target["CURR_HP"] - damage
		if target["CURR_HP"] <= 0 then
			target["CURR_HP"] = 0
		end
	end
end

function Manager.applyEffect(target, effect)	-- Apply Effect to Target
	if effect == 1 then
		Manager.pByt = target
		UI.update(Manager.pByt, Manager.eByt)
		Manager.switchMenu()
	end
end

function Manager.checkByts()	-- Check Current Byt HP
	if Manager.pByt["CURR_HP"] > 0 and Manager.eByt["CURR_HP"] > 0 then
		return true
	else
		return false
	end
end

function Manager.runTurn(event)	-- Run a standard turn
	-- Start Move
	local src = event.target
	if inputFlag == false or src.data == nil then
		return 
	else
		local pSpeed = 0
		local eSpeed = 0
		if src.data.typ == 0 then
			if src.data["ID"] == Manager.pByt["ID"] then print("Byt is already out") return end
			pSpeed = 1000
		else
			pSpeed = Manager.pByt["SPE"]
		end
		local eMov = Manager.getEnemyMove()
		eSpeed = Manager.eByt["SPE"]
		
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
		UI.update(Manager.pByt, Manager.eByt)
		if Manager.checkByts() then
			Manager.resolveMove(secondSrc, secondMov)
			UI.update(Manager.pByt, Manager.eByt)
		end

		UI.loadMenu(UI.state)
		Manager.addEventListeners(UI.menu)
		
		if Manager.pByt["CURR_HP"] == 0  then
			Manager.forceSwitch()
		elseif Manager.eByt["CURR_HP"] == 0 then
			Manager.getEnemyByt()
		end
	end
end

function Manager.forceSwitch()	-- Force the Player to switch Byts
	UI.state = "FIGHT"
	Manager.switchMenu()
	toggleFlag = false
	inputFlag = false
	Manager.removeEventListeners(UI.menu)
	Manager.tempListeners(UI.menu)
end

function Manager.switchByt(event)	-- Select a Byt to switch to
	local src = event.target
	
	if src.data == nil then return end
	
	if src.data["ID"] == Manager.pByt["ID"] then print("Byt is already out") return end
	
	Manager.pByt = Data.PLY[src.data["ID"]]
	UI.update(Manager.pByt, Manager.eByt)
	Manager.removeEventListeners(UI.menu)
	Manager.addEventListeners(UI.menu)
	toggleFlag = true
	inputFlag = true
	Manager.switchMenu()
end

function Manager.tempListeners(menu)	-- Temporary Force Byt listeners
	for _, obj in pairs(menu) do
		obj:addEventListener("tap", Manager.switchByt)
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

function Manager.startBattle()	-- Run at start of Battle Scene
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
	Calc.passData(Data.BYT, Data.TBL, Data.TYP, Data.MOV)
end

return Manager