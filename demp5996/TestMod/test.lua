-- Author:Joshua
-- Name:test
-- Description:Just doodling
-- Icon:
-- Hide: no

--[[
	General Attack plan roadmap

	Ideas:
		Use the AutoDrive mod for testing
		Print out a line renderer for the path to follow
		Print out points needed to visit for completion of farming the field

	Path finding / optimizations:

	Construct polygon boundaries of a given set of points (from our field, or any region in general)
	Populate constructed polygon with equidistant points (with a small enough epsilon so that area inside of polygon not directly represented by point is not an issue)
	
	Now we have our set of polygon points, create an autodrive compatible circuit path that can be used to test for optimization parameters
	optimize found paths for various parameters (or determine better selection algorithm for creating original paths)

	Optimizations to consider:
		Time needed
		Fuel efficiency
		Soil Erosion (conrad is determing soil erosion outside of farming simulator using more advanced and pre-existing simulating software, fs19 might not be right choice for this optimization)

	Patterns to Consider:

	Lines:
	______
	X  _   _ 
	| | | | |
	| | | | |
	| | | | |
	| | | | |
	|_| |_| |

	Spirals:
      ________
	X |  ___  |
	| | |   | |
	| | | | | |
	| | | | | |
	| | |_| | |
	| |_____| |
	|_________|


	thoughts for future me / other people:
		obstacles in field / strange fields 
]]

TestScript = {}; -- This is a Lua table
TestScript.ModDir = g_currentModDirectory

-- HelloWorld/Testing Commands

function TestScript:cmdTest() -- this how how we OOP
	print("This is a test!")
	return nil
end

function TestScript:cmdHello()
	print("Hello!")
	io.write("This is a test")
	return "World!"
end

--PathFinding Commands

--[[
	Clear contents of PathFind's PolyGon table
]]
function TestScript:cmdClearPoly()
	PathFind:ClearPoly()
	return nil
end

--[[
	Grabs frist 3 numbers (space sperated) and adds the corresponding point to PathFind's PolyGon 
]]
function TestScript:cmdAddPoint(...)
	local args = {...}
	local XYZ = {}
	for k in pairs (args) do
		if(tonumber(args[k]) ~= nil) then table.insert( XYZ, tonumber(args[k]) ) end --grab numbers
		--print(string.format( "arg[%s]:'%s'",k, args[k] )) 
	end
	PathFind:AddPoint(XYZ[1],XYZ[2],XYZ[3])
	return nil
end

_Path = {} --Global table for storing generated Paths
--[[
	Calls the MakePath function in PathFind which uses the contents of PathFind's PolyGon table to generate and return a path
]]
function TestScript:cmdMakePath()
	_Path = PathFind:MakePath()
	return nil
end

--[[
	Calls PathFind's PrintPath function which prints the ordered list in a slightly nicer format. (still blows up output)
]]
function TestScript:cmdPrintPath()
	PathFind:PrintPath(_Path)
	return nil
end

--[[
	Print the contents of PathFind's PolyGon table
]]
function TestScript:cmdPrintPoly()
	PathFind:PrintPoly()
	return nil
end

--Game Interaction Commands (Severe WIP)

--[[
	Busted function, need to figure out how to properly access Game information
]]
function TestScript:cmdGetPos()
	print("Player position data:")
	posX, posY, posZ, rotY = Player.getPositionData()
	print("Position: ", posX, posY, posZ)
end

--                FS CMD    HelpText     Func        Table
addConsoleCommand("test", "This is a test.", "cmdTest", TestScript);
addConsoleCommand("hello", "Print a hello world statement.", "cmdHello", TestScript);
addConsoleCommand("getpos", "Get PlayerPosition", "cmdGetPos", TestScript);

--PathFinding commands
addConsoleCommand("clear_poly", "Clears PathFind's PolyGon Table for storing points", "cmdClearPoly", TestScript)
addConsoleCommand("add_point", "Adds a point (x,y,z) To PathFind's PolyGon table", "cmdAddPoint", TestScript)
addConsoleCommand("make_path", "Generates A path of points from PathFind's polygon", "cmdMakePath", TestScript)
addConsoleCommand("print_poly", "Print the current contents of PathFind's PolyGon", "cmdPrintPoly", TestScript)
addConsoleCommand("print_path", "Print the Generated path returned from the make_path command", "cmdPrintPath", TestScript)