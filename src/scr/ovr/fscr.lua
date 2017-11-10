-----------------------------------------------------------------------------------------
--
-- fscr.lua
-- File functions
-----------------------------------------------------------------------------------------
local File = {}
local fileNumber = tostring(1) .. "f_"

function File.fileExists(dir, name)
	local res = false
	local path = system.pathForFile(dir .. name .. ".txt", system.ResourceDirectory)
	if path ~= nil then
		res = true
	end
	return res
end

function File.getFile(dir, file)
	local path = nil
	if File.fileExists(dir, fileNumber .. file) then
		path = system.pathForFile(dir .. fileNumber .. file .. ".txt", system.ResourceDirectory)
	else
		path = system.pathForFile(dir .. file .. ".txt", system.ResourceDirectory)
	end
	local file, errorString = io.open(path, "r+")
	
	if not file then
		error("File error: " .. errorString)
	else
		return file
	end
end

function File.getZoneFile(dir, zone)
	local file = File.getFile(dir, zone)
	local zoneData = {}
	
	for line in file:lines() do
		table.insert(zoneData, line)
		
	end
	
	io.close(file)
	file = nil
	
	return zoneData
end

function File.alterZoneFile(dir, file, cellString)
	local path = system.pathForFile(nil, system.ResourceDirectory)
	
	if File.fileExists(dir, fileNumber .. file) then
		print("File exists")
		path = path .. "/" .. dir .. fileNumber .. file .. ".txt"
	else
		print("file does not exist")
		path = path .. "/" .. dir .. file .. ".txt"
	end
	
	local infile = io.open(path, "r")
	io.input(infile)
	local instr = io.read("*a")
	io.close(infile)
	local infile = nil

	path = system.pathForFile(nil, system.ResourceDirectory)
	path = path .. "/" .. dir .. fileNumber .. file .. ".txt"
	
	local outfile = io.open(path, "w")
	instr = instr .. "\n" .. cellString
	outfile:write(instr)
	io.close(outfile)
	local outfile = nil
end

return File