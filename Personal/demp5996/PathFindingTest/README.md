# XRFS19 Path Finding commands usage

Here is a quick description for the unfortunate souls tasked with continuing this project on the usage of the current implementation of the PathFinding comamnds for the FS19 path finding and GIS map data mod.

Functinality of the current mod is very limited and serves more as a backend to be built off of for LUA pathfinding. The current implementation was designed to interact with FS19 as little as possible and only directly through the use of wrapper functions and console commands.

The Pathfinding commands and functions at your disposal are:
## clear_poly
This function clears the contents of the global PolyGon table that is used to store point data for path construction.

## add_point x y z
Add point accets variable arguments but will take the first 3 numbers it can and construct a point from them and add it to the global PolyGon table

### An important note on points and polygons. 
The oder where points are added to the polygons is fickle and important. 
The order of the polygon verticies is important, the order must not be in a sensible order that a proper polygon can be drawn

```LUA
i.e.:     
polygon = 
{
	A = 1,0,1
	B = 10,0,1
	C = 10,0,10
	D = 1,0,10
}
would be a sensible format as the order constructs a proper polygon
In respect to x,z
10 B                  C
9
8
7
6
5
4
3
2
1 A                  D
0 1 2 3 4 5 6 7 8 9 10
Would construct a proper polygon in respect of A->B->C->D
but a polygon constructed in a different way such as A->C->B->D would not properly work 

10 B --------------->C
9 ^                  |
8 |                  |
7 |                  |
6 |                  |
5 |                  |
4 |                  |
3 |                  |
2 |                  V
1 A <--------------- D
0 1 2 3 4 5 6 7 8 9 10
```

## print_poly
Prints the contents of the PolyGon table in PathFind.lua

## make_path
Runs the current path finding function to using the PolyGon table to construct and return a list of ordered points that represents a symbolic path to follow.

## print_path
Prints out the contents of the global path table that is populated with make_path

## Quick Example Usage
To use the PathFinding functions, make sure the developer console is enabled, and press the \` key in game to show the console; and again to enable user input:

### Enabling the developer console:
Modify the game.xml located in the base directory for the game’s installation. 
Change 
```XML
<controls>false</controls>
```
to 
```XML
<controls>true</controls>
```

A simple proper usage would be to add all the points to be considered in the proper order
```LUA
add_point 0 0 0
add_point 10 0 0
add_point 10 0 10
add_point 0 0 10
```
Followed by some verification of the contents of the PolyGon, then a call to the path creation function and finally, print out the contents of the create path
```LUA
print_poly 
make_path
print_path
```
After path creation, it is advisable to clear the contents of the poly for further tests and usages
```LUA
clear_path
```