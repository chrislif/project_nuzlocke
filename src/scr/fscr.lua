-----------------------------------------------------------------------------------------
--
-- fscr.lua
-- File functions
-----------------------------------------------------------------------------------------
local File = {}
local fileNumber = tostring(1) .. "f_"

function File.getFile(dir, file)
	local path = system.pathForFile(dir .. file .. ".txt", system.ResourceDirectory)
	local file, errorString = io.open(path, "r+")
	
	if not file then
		error("File error: " .. errorString)
	else
		local data = {}
		
		for line in file:lines() do
			table.insert(data, line)
		end
		
		io.close(file)
		file = nil
			
		return data
	end
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
