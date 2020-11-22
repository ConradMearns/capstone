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

function TestScript:cmdTest() -- this how how we OOP
	print("This is a test!")
	return nil
end

function TestScript:cmdHello()
	print("Hello!")
	io.write("This is a test")
	return "World!"
end

function TestScript:cmdTestPoly()
	--local PolyTest = require(TestScript.ModDir .. "PolyTest")
	PolyTest.HelloWorld()
	print("Testing polygon stuff")
	PolyTest.TestStuff()
	return nil
end

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
addConsoleCommand("test_poly", "Test some functions from PolyTest", "cmdTestPoly", TestScript);
addConsoleCommand("getpos", "Get PlayerPosition", "cmdGetPos", TestScript);



