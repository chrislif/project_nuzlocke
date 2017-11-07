-----------------------------------------------------------------------------------------
--
-- calcscr.lua
-- Calculation functions
-----------------------------------------------------------------------------------------
local Calc = {}

function Calc.passData(TBL, TYP, MOV)
	Calc.TBL = TBL
	Calc.TYP = TYP
	Calc.MOV = MOV
end

function Calc.getTypeBonus(mTyp, tTyp)
	local bonus = Calc.TBL[mTyp][tTyp]
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
	if Calc.MOV[tTyp1] ~= nil then
		mod = mod * Calc.getTypeBonus(mTyp, tTyp1)
	end
	if Calc.MOV[tTyp2] ~= nil then
		mod = mod * Calc.getTypeBonus(mTyp, tTyp2)
	end
	
	-- STAB Bonus
	if Calc.MOV[uTyp1] ~= nil and uTyp1 == mTyp then 
		mod = mod * 1.5
	end
	if Calc.MOV[uTyp2] ~= nil and uTyp2 == mTyp then
		mod = mod * 1.5
	end
	
	return mod
end

function Calc.calculateDamage(level, power, attack, defense, mod)
	print("lvl: " .. level)
	print("pwr: " .. power)
	print("atk: " .. attack)
	print("def: " .. defense)
	print("mod: " .. mod)
	return ((((2 * level)/5 + 2) * power * (attack/defense))/ 50 + 2) * mod
end

return Calc