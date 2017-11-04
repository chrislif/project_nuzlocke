-----------------------------------------------------------------------------------------
--
-- fscr.lua
-- File functions
-----------------------------------------------------------------------------------------
local File = {}

function File.getFile(file)
	local path = system.pathForFile("fil/" .. file .. ".txt", system.ResourceDirectory)
	local file, errorString = io.open(path, "r+")
	
	if not file then
		print("File error: " .. errorString)
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

return File