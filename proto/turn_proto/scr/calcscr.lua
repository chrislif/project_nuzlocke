-----------------------------------------------------------------------------------------
--
-- calcscr.lua
-- Calculation functions
-----------------------------------------------------------------------------------------
local Data = require "scr.dscr"

local Calc = {}

function Calc.getNatBoost(stat, byt)
	return 1
end

function Calc.getStat(stat, byt)
	local base = Data.BYT[byt["ID"]][stat]
	local IV = byt[stat]
	local EV = byt[stat.."_EV"]
	local level = byt["LEVEL"]
	local natBoost = Calc.getNatBoost(stat, byt)
	local res = 0
	
	if stat == "HP" then
		res = math.floor((2 * base + IV + math.floor(EV/4) * level)/100) + level + 10
	else
		res = math.floor(((math.floor((2 * base + IV + math.floor(EV/4)) * level)/100) + 5) * natBoost)
		if stat == "ATK" and byt["CURR_EFT"] == "BURN" then
			print(byt["NAME"] .. " ATK IS HALF DUE TO BURN")
			res = math.floor(res * 0.5)
		elseif stat == "SPE" and byt["CURR_EFT"] == "STUN" then
			res = math.floor(res * 0.5)
		elseif stat == "SPDEF" and byt["CURR_EFT"] == "FRZ" then
			res = math.floor(res * 1.25)
		end
	end
	
	return res
end

function Calc.rollEffect(effect, chance)
	local roll = math.random(0, 100)
	if roll >= chance then return 0 end
	return effect
end

function Calc.getTypeBonus(mTyp, tTyp)
	local bonus = Data.TBL[mTyp][tTyp]
	local res = 1
	if bonus == 2 then
		res = 2
	elseif bonus == 1 then
		res = 1
	elseif bonus == 0 then
		res = 0
	elseif bonus == -1 then
		res = 0.5
	end
	
	return res
end

function Calc.getModifier(uTyp1, uTyp2, mTyp, tTyp1, tTyp2)
	local mod = 1
	
	-- Type Multiplier
	if Data.MOV[tTyp1] ~= nil then
		mod = mod * Calc.getTypeBonus(mTyp, tTyp1)
	end
	if Data.MOV[tTyp2] ~= nil then
		mod = mod * Calc.getTypeBonus(mTyp, tTyp2)
	end
	
	if mod > 1 then
		print("SUPER EFFECTIVE")
	elseif mod > 0 and mod < 1 then
		print("NOT VERY EFFECTIVE")
	elseif mod == 0 then
		print("MOVE FAILS")
	end
	
	-- STAB Bonus
	if Data.MOV[uTyp1] ~= nil and uTyp1 == mTyp then 
		mod = mod * 1.5
	end
	if Data.MOV[uTyp2] ~= nil and uTyp2 == mTyp then
		mod = mod * 1.5
	end
	
	return mod
end

function Calc.calculateDamage(level, power, attack, defense, mod)
	local damage = math.floor(((((2 * level)/5 + 2) * power * (attack/defense))/ 50 + 2) * mod)
	if damage == 0 then
		damage = 1
	end
	return damage
end

return Calc