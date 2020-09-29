-- Author:conrad
-- Name:TestScript
-- Description:
-- Icon:
-- Hide: no

TestScript = {}; -- This is a Lua table

function TestScript:cmdTest(args) -- this how how we OOP
	if args ~= nil then
		print(type(args))
		return "args are "..args;
	end;
	return "Error: no arguments specified. Usage: test args";
end;

function TestScript:cmdHello()
	print("Hello!");
	return "World!";
end;

--                FS CMD    HelpText     Func        Table
addConsoleCommand("test", "View args.", "cmdTest", TestScript);
addConsoleCommand("hello", "Print a hello world statement.", "cmdHello", TestScript);
