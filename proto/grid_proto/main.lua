-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local Grid = require "gscr"

local zoneGrid = Grid.zoneToGrid("zone0")

local File = require "fscr"

File.alterZoneFile("zone0", "1.1.33.2.999")
File.alterZoneFile("zone0", "1.2.0.0.000")

zoneGrid = Grid.zoneToGrid("zone0")
