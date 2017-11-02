-----------------------------------------------------------------------------------------
--
-- fscr.lua
-- File functions
-----------------------------------------------------------------------------------------
local File = {}
local fileNumber = tostring(1) .. "f_"

function File.fileExists(name)
	local res = false
	local path = system.pathForFile("map/" .. name .. ".txt", system.ResourceDirectory)
	if path ~= nil then
		res = true
	end
	return res
end

function File.getFile(file)
	local path = nil
	if File.fileExists(fileNumber .. file) then
		path = system.pathForFile("map/" .. fileNumber .. file .. ".txt", system.ResourceDirectory)
	else
		path = system.pathForFile("map/" .. file .. ".txt", system.ResourceDirectory)
	end
	local file, errorString = io.open(path, "r+")
	
	if not file then
		print("File error: " .. errorString)
	else
		return file
	end
end

function File.getZoneFile(zone)
	local file = File.getFile(zone)
	local zoneData = {}
	
	for line in file:lines() do
		table.insert(zoneData, line)
	end
	
	io.close(file)
	file = nil
	
	return zoneData
end

function File.alterZoneFile(file, cellString)
	local path = system.pathForFile(nil, system.ResourceDirectory)
	
	if File.fileExists(fileNumber .. file) then
		print("File exists")
		path = path .. "/map/" .. fileNumber .. file .. ".txt"
	else
		print("file does not exist")
		path = path .. "/map/" .. file .. ".txt"
	end
	
	
	
	local infile = io.open(path, "r")
	io.input(infile)
	local instr = io.read("*a")
	io.close(infile)
	local infile = nil

	path = system.pathForFile(nil, system.ResourceDirectory)
	path = path .. "/map/" .. fileNumber .. file .. ".txt"
	
	local outfile = io.open(path, "w")
	instr = instr .. "\n" .. cellString
	outfile:write(instr)
	io.close(outfile)
	local outfile = nil
end

return File