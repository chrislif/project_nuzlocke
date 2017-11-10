-----------------------------------------------------------------------------------------
--
-- mnscr.lua
-- Manager functions
-----------------------------------------------------------------------------------------
local composer = require "composer"
local UI = require "scr.btl.uiscr"
local Data = require "scr.btl.dscr"
local Calc = require "scr.btl.calcscr"

local Manager = {}
local fileNumber = 1
local inputFlag = true
local toggleFlag = true

function Manager.runEnd(winner)	-- Run the end of Battle
	toggleFlag = false
	inputFlag = false
	
	if winner == "player" then
		
		
	else
		
		
	end
	
	UI.remove()
	composer:gotoScene("scn.ovr")
	composer.removeScene("scn.btl")
end

function Manager.getEnemyByt()	-- Get new Enemy Byt on Death
	local nextID = Manager.eByt["ID"] + 1
	if Data.ENM[nextID] ~= nil then
		Manager.eByt = Data.ENM[nextID]
		UI.update(Manager.pByt, Manager.eByt)
	else
		Manager.runEnd("player")
		return
	end
end

function Manager.getEnemyMove()	-- Get Enemy Move
	local id = 0
	local movID = 0
	
	while id == 0 do
		local roll = math.random(1, 4)
		local c_table = {
			[1] = Manager.eByt["MOV1"],
			[2] = Manager.eByt["MOV2"],
			[3] = Manager.eByt["MOV3"],
			[4] = Manager.eByt["MOV4"],
		}
		movID = "M" .. roll
		id = c_table[roll]
	end
	
	local mov = {
		["typ"] = Data.MOV[id]["ATK_TYPE"],
		["ID"] = id,
		["move"] = movID,
		["TYPE"] = Data.MOV[id]["TYPE"],
		["target"] = "player",
		["speed"] = Manager.eByt["SPE"],
	}
	
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

function Manager.resolveEffects(checkTime, byt)
	if checkTime == 1 then
		if byt["CURR_EFT"] == 3 then
			local effectFlag = false
			if Calc.rollEffect(1, 30) > 0 then
				effectFlag = true
				print(byt["NAME"] .. " is unable to move")
			end
			return effectFlag
		elseif byt["CURR_EFT"] == 4 then
			local effectFlag = true
			if Calc.rollEffect(1, 30) > 0 then
				byt["CURR_EFT"] = 0
				effectFlag = false
				print(byt["NAME"] .. " unfreezes")
			else
				print(byt["NAME"] .. " is frozen")
			end
			return effectFlag
		elseif byt["CURR_EFT"] == 5 then
			local effectFlag = true
			if Calc.rollEffect(1, 30) > 0 then
				byt["CURR_EFT"] = 0
				effectFlag = false
				print(byt["NAME"] .. " woke up")
			else
				print(byt["NAME"] .. " is fast asleep")
			end
			return effectFlag
		end
		return false
	else
		if byt["CURR_EFT"] == 1 then
			local damage = math.floor(Calc.getStat("HP", byt)/10)
			byt["CURR_HP"] = byt["CURR_HP"] - damage
			print(byt["NAME"] .. " takes " .. damage .. " damage from burn")
		elseif byt["CURR_EFT"] == 2 then
			local damage = math.floor(Calc.getStat("HP", byt)/10)
			byt["CURR_HP"] = byt["CURR_HP"] - damage
			print(byt["NAME"] .. " takes " .. damage .. " damage from psn")
		end
	end
end

function Manager.resolveMove(src, mov, movNum)	-- Resolve a Move
	local target = Manager.getTarget(mov)
	local mov = Data.MOV[mov["ID"]]
	local skipFlag = false
	local damage = nil
	local effect = nil
	
	local user
	if src == Manager.eByt then
		user = "Enemy"
	elseif src == Manager.pByt then
		user = "Player"
	end
	
	print(user .. " TURN -----------------------")
	
	if target ~= 2 or target ~= 3 then
		print(user .. "'s " .. src["NAME"] .. " used " .. mov["NAME"])
	else
		print(src["NAME"] .. " switched")
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
		effect = 10
	elseif target == 3 then
		target = Data.ENM[mov["ID"]]
		effect = 10
	end
	
	skipFlag = Manager.resolveEffects(1, src)
	
	if skipFlag == false then
		if damage ~= nil then
			print(target["NAME"] .. " takes " .. damage .. " damage")
		end
		Manager.applyDamage(target, damage)
		
		if effect ~= 10 then
			if target["CURR_EFT"] == 0 then
				print("apply effect " .. effect .. " to " .. target["NAME"])
			end
			src[movNum .. "_U"] = src[movNum .. "_U"] - 1
		end
		Manager.applyEffect(target, effect)
	end
	Manager.resolveEffects(2, src)
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
	if effect == 1 then 		-- Burn
		if target["CURR_EFT"] == 0 then
			target["CURR_EFT"] = 1
		else
			print(target["NAME"] .. " is already " .. target["CURR_EFT"])
		end
	elseif effect == 2 then		-- Psn
		if target["CURR_EFT"] == 0 then
			target["CURR_EFT"] = 2
		else
			print(target["NAME"] .. " is already " .. target["CURR_EFT"])
		end
	elseif effect == 3 then		-- Stun
		if target["CURR_EFT"] == 0 then
			target["CURR_EFT"] = 3
		else
			print(target["NAME"] .. " is already " .. target["CURR_EFT"])
		end
	elseif effect == 4 then		-- Freeze
		if target["CURR_EFT"] == 0 then
			target["CURR_EFT"] = 4
		else
			print(target["NAME"] .. " is already " .. target["CURR_EFT"])
		end
	elseif effect == 5 then		-- Sleep
		if target["CURR_EFT"] == 0 then
			target["CURR_EFT"] = 5
		else
			print(target["NAME"] .. " is already " .. target["CURR_EFT"])
		end
	elseif effect == 6 then		-- Confuse
	elseif effect == 7 then		-- DoT
	elseif effect == 8 then		-- Leech
	elseif effect == 9 then		-- Flinch
	elseif effect == 10 then	-- Swap
		Manager.pByt = target
		Manager.switchMenu()
	end
	UI.update(Manager.pByt, Manager.eByt)
end

function Manager.checkByts()	-- Check Current Byt HP
	if Manager.pByt["CURR_HP"] > 0 and Manager.eByt["CURR_HP"] > 0 then
		return true
	else
		return false
	end
end

function Manager.forceSwitch()	-- Force the Player to switch Byts
	local playerCheck = false
	for i, byt in pairs(Data.PLY) do
		if byt["CURR_HP"] > 0 then
			playerCheck = true
		end
	end
	if playerCheck == false then
		Manager.runEnd("enemy")
		return
	end
	
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

function Manager.runTurn(event)	-- Run a standard turn
	-- Start Move
	local src = event.target
	
	if inputFlag == false or src.data == nil then	-- Disable Input
		return 
	else
		if src.data["move"] ~= nil then
			if Manager.pByt[src.data["move"] .. "_U"] < 1 then print("No uses of move left") return end
		end
		-- Run Standard Turn
		print("RUN TURN --------------------------")
		local pSpeed = 0
		local eSpeed = 0
		if src.data.typ == 0 then
			if src.data["ID"] == Manager.pByt["ID"] then print("Byt is already out") return end
			pSpeed = 1000
		else
			pSpeed = Calc.getStat("SPE", Manager.pByt)
		end
		local eMov = Manager.getEnemyMove()
		eSpeed = Calc.getStat("SPE", Manager.eByt)
		
		-- Calculate Speeds
		local firstMov = nil
		local firstSrc = nil
		local secondMov = nil
		local secondSrc = nil
		if pSpeed > eSpeed then
			firstSrc = Manager.pByt
			firstMov = src.data
			firstMovNum = src.data["move"]
			
			secondSrc = Manager.eByt
			secondMov = eMov
			secondMovNum = eMov["move"]
		else
			firstSrc = Manager.eByt
			firstMov = eMov
			firstMovNum = eMov["move"]
			
			secondSrc = Manager. pByt
			secondMov = src.data
			secondMovNum = src.data["move"]
		end
		
		-- Run Move
		Manager.resolveMove(firstSrc, firstMov, firstMovNum)
		UI.update(Manager.pByt, Manager.eByt)
		if Manager.checkByts() then
			Manager.resolveMove(secondSrc, secondMov, secondMovNum)
			UI.update(Manager.pByt, Manager.eByt)
		end

		UI.loadMenu(UI.state)
		Manager.addEventListeners(UI.menu)
		
		-- Check HP Values
		if Manager.pByt["CURR_HP"] == 0  then
			Manager.pByt["CURR_EFT"] = 0
			Manager.forceSwitch()
		elseif Manager.eByt["CURR_HP"] == 0 then
			Manager.eByt["CURR_EFT"] = 0
			Manager.getEnemyByt()
		end
		
	end
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
	inputFlag = true
	toggleFlag = true
	-- Load Data
	Data.loadData()
	Data.loadTeams(fileNumber, 1)
	-- Load UI
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