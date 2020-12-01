--[[
    This file is deprecated and may be removed. The functionality of this file has been moved to pathFind.lua
]]

PolyTest = {}

--[[
    Function for testing ability to call functions from other files
]]
function PolyTest:HelloWorld()
    print("Howdy Partner")
end

--[[
    Simple function for printing point data in a slightly nicer looking format
]]
function _pp(p)
    if p == nil then return "nil point" end
   return string.format("(%s,%s,%s)",p.x,p.y,p.z)
end

--[[
    Given a set of points, cycle through them all and return the minimum x and z values
]]
function FindMins(Poly)
    local numVerts = #Poly
    local minX = Poly[1].x
    local minZ = Poly[1].z
    for i = 1, numVerts do
        
        if(Poly[i].x < minX) then minX = Poly[i].x end
        if(Poly[i].z < minZ) then minZ = Poly[i].z end        
    end
    return minX, minZ
end

--[[
    Given a set of points, cycle through them all and return the maximum x and z values
]]
function FindMaxs(Poly)
    local numVerts = #Poly
    local maxX = 0
    local maxZ = 0
    for i = 1, numVerts do
        
        if(Poly[i].x > maxX) then maxX = Poly[i].x end
        if(Poly[i].z > maxZ) then maxZ = Poly[i].z end            
    end
    return maxX, maxZ
end

--[[
    The following function tests whether a point is in a certain polygonal region in respect to their x,z values.

    Note: The order of the polygon verticies is important, the order must not be in a sensible order that a proper polygon can be drawn
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
    Would construct a proper polygon
   10 B ---------------> C
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
]]
function InPoly(polygon, point)
    local result = false
    local j = #polygon
    for i = 1, #polygon do
        if (polygon[i].z < point.z and polygon[j].z >= point.z or polygon[j].z < point.z and polygon[i].z >= point.z) then
            if (polygon[i].x + ( point.z - polygon[i].z ) / (polygon[j].z - polygon[i].z) * (polygon[j].x - polygon[i].x) < point.x) then
                result = not result -- flip the result
                --print("Fwip")
            end
        end
        j = i
    end
    return result 
end

--[[
    Very bruteforce, make grid of points from [minX,minZ] to [maxX,maxZ]
    (y values will be approached later)
]]
function CreateGrid(minX, minZ, maxX, maxZ, delta)
    local result = {} -- Table for holding points generated

    for i = minX, maxX, delta do
        for j = minZ, maxZ, delta do
            table.insert( result, CreatePoint(i, -9, j) ) -- Create grid point
        end
    end
    return result
end

function GridPointsInPolygon(polygon, grid)
    local result = {}
    for i = 1, #grid do
        if(InPoly(polygon, grid[i])) then table.insert(result, grid[i]) end
    end
    return result
end

--[[
    Function for testing functionds and object creation
]]
function PolyTest:TestStuff()

    print("TestPoint-")
    TestPoint = CreatePoint(5,5,5)
    TestPoint.print()
    print("----")
    print("TestPolygon-")
    TestPolygon = {
        CreatePoint(0,0,0),     --LL
        CreatePoint(0,8,10),    --UL
        CreatePoint(10,11,10),  --UR
        CreatePoint(10,5,0),    --LR
    }
    for i = 1, #TestPolygon do
        TestPolygon[i].print()
    end
    print("----")
    
    print('Finding Polygon Mins')
    print('Mins: ', FindMins(TestPolygon))
    
    print('Finding Polygon Maxs')
    print('Maxs: ', FindMaxs(TestPolygon))
    
    print("Testing is TestPoint is in TestPolygon")
    C = InPoly(TestPolygon, TestPoint)
    print(C)
    print("----")

    local minx,minz = FindMins(TestPolygon)
    local maxx, maxx = FindMaxs(TestPolygon)
    
    Grid = CreateGrid(minx,minz, maxx, maxx, 1)
    print("#Grid Points: ", #Grid)

    ConsideredPoints = GridPointsInPolygon(TestPolygon, Grid)
    print("#Considered Points:", #ConsideredPoints)
    for i = 1, #ConsideredPoints do print(_pp(ConsideredPoints[i])) end
    print("--------------------.")

    Path = GeneratePathFromPoints(ConsideredPoints)

    print("Printing Selected Path:")

    print("Start.")
    print("#PATH,",#Path)
    for i = 1, #Path do
        print(string.format("%s]\t%s",i, _pp(Path[i])))
    end
    print("End.")



    print("A different approach:")

    

end

--[[
    Function that takes a set of points to consider, and from those points returns an ordered path to follow.
    Treats first point as starting/ending point

    Some Finding algorithms to consider:

    Simple:
        Shortest x-z distance first (easy, quick, pick a point and go to it)
        Straight lines (minimizes turns) by placing bias on direction selection

    Not so Simple:
        Shortest local height distance first (optimize purely against height)
            Will require some threshhold to avoid jumping across map from local hills
    ]]
function GeneratePathFromPoints(ConsideredPoints)

    print("Generating Path from Recieved Points")
    StartPoint = ConsideredPoints[1]
    --StartPoint.print()
    EndPoint = ConsideredPoints[1]
    --EndPoint.print()
    
    Path = {}
    Remaining = ConsideredPoints
    Add(Path, StartPoint)
    Remove(Remaining, StartPoint) -- Remove From remaining
    
    Current = StartPoint -- Set CurrentPoint to Start Point
    
    -- . . . Find path
    for i = 1, #ConsideredPoints-1 do
        print(string.format("%s]---",i))
        print("I am at:",_pp(Current))
        
        -- Select Point
        NextPoint = SelectPoint(Current, Remaining)

        if NextPoint == nil then
            print("Next Point is nil, breaking")
            Add(Path, EndPoint)
            --table.insert( Path, EndPoint) -- Add ending Point to Table (Also starting point)

            print("Returning path of [",#Path,"]")
            return Path -- Return the calculated path
        end

        -- Add point to path
        Add(Path, NextPoint)
        --table.insert( Path, NextPoint)

        -- Set Current point
        print("Going to:", _pp(NextPoint))
        Current = NextPoint
        print("---.")
    end
    
    Add(Path, EndPoint)
    --table.insert( Path, EndPoint) -- Add ending Point to Table (Also starting point)
    print("Returning path")
    return Path -- Return the calculated path
end

--[[
    This function is very bad. Dont assert indices of a LUA table as nil especially through iteration, create a better one
]]
function Remove(t, point)
    print("\tRemoving point from table:", _pp(point))
    --print("#Table", #t)
    local _i = 1
    for i = 1, #t do
        -- print("Searching table")
        if t[i] ~= nil and t[i].x == point.x and t[i].y == point.y and t[i].z == point.z then 
            _i = i
        end
    end
    t[_i] = nil
    print("\tPoint removed.") 
end

function Add(t, point)
    print("\tAdding point to path:", _pp(point))
    table.insert( t, point)
end

--[[
    Euclidian distance formula in respect to point's x and z coords
]]
function SelectPoint(current, remaining)
    print("Selecting a new Point")
    print("#remaining", #remaining)



    BestPoint = current

    -- Remove From remaining
    print("Removing current")
    Remove(Remaining, current)

    print("Selecting point with minXZ Distance.")
    BestPoint = SelectMinXZDist(current, remaining)

    print("Current Point:", _pp(current))
    print("Best Point found:", _pp(BestPoint))

    print("Printing remaining:")
    print("------------------------------------")
    for j = 0, #remaining do 
        print(j,"]", _pp(remaining[j]))
    end
    print("------------------------------------")
    return BestPoint
end

function SelectMinXZDist(point, list)
    minDist = 9999999
    minPoint = nil

    print("\t\tSelectMinXZDist here: #List is: ", #list)

    for i = 1, #list do
        if list[i] == nil then goto continue end -- Found a nil entry (possibly removed)
        
        _d = XZDistance(point, list[i])
        if(_d < minDist) then
            minDist = _d
            minPoint = list[i]
        end
        
        ::continue:: -- goto block to simulate continue for selection loop
    end

    if minPoint == nil then print("Returning nil point from SelectMinXZDist") end
    return minPoint
end

function XZDistance(a,b)
    return math.sqrt(math.pow(b.x - a.x,2) + math.pow(b.z - a.z,2))
end

--[[
    Following code is for testing bits and bobs in LUA~land outside of Farming Simulator to verify code functions before having to make, move, install, launch, and load mod for FS
    ]]
require("Point")
PolyTest.TestStuff()
