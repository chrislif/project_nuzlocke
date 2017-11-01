-----------------------------------------------------------------------------------------
--
-- cscr.lua
-- Cell functions
-----------------------------------------------------------------------------------------
local Cell = {}
Cell.mt = {}

function Cell.new()
	local cell = {}
	setmetatable(cell, Cell.mt)
	cell.typ = -1
	cell.pas = -1
	cell.spn = -1
	return cell
end

return Cell