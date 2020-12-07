PathFind = {}

--[[
    Simple function for printing point data in a slightly nicer looking format
]]
function _pp(p)
    if p == nil then return "nil point" end
   return string.format("(%s,%s,%s)",p.x,p.y,p.z)
end

--[[
    Add Point to end of table.
]]
function Add(t, point)
    print("\tAdding point to path:", _pp(point))
    table.insert( t, point)
end

--[[
    Find and set a point's visited flag as true, the visited flag is used in generating paths to exclude points for selection, as they've already been Selected before
]]
function MarkAsVisited(t, point)
    
    print(string.format( "\tMarking %s as visited", _pp(point) ))
    for i = 1, #t do
        -- print("Searching table")
        if t[i] ~= nil and t[i].x == point.x and t[i].y == point.y and t[i].z == point.z then 
            t[i].visited = true
        end
    end
end

--[[
    Given a set of points to consider, all which need to be visited and trating the first point as the start and end point, create an ordered list of points that
    is considered a 'path' given some Selection function or optimization
]]
function GeneratePath(ConsideredPoints)
    print("Trying to make a Path from Recieved Points")
    StartPoint = ConsideredPoints[1]
    EndPoint = ConsideredPoints[1]
    
    Path = {}
    Remaining = ConsideredPoints
    Add(Path, StartPoint)    
    Current = StartPoint -- Set CurrentPoint to Start Point
    -- . . . Find path
    for i = 1, #ConsideredPoints do
        print(string.format("Step %s]---",i))
        print("I am at: ",_pp(Current))
        
        -- Select Point
        NextPoint = SelectPoint(Current, Remaining)

        -- Add point to path
        Add(Path, NextPoint)
        
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
    Selects point by using Euclidian distance formula in respect to point's x and z coords
]]
function SelectPoint(current, remaining)
    print("\tSelecting a new Point")

    BestPoint = current

    -- Mark current
    MarkAsVisited(remaining, current)

    print("\tSelecting point with minXZ Distance.")
    BestPoint = SelectMinXZDist(current, remaining)

    print("\tCurrent Point:", _pp(current))
    print("\tBest Point found:", _pp(BestPoint))

    return BestPoint
end

--[[
    Iterate through a list and determine what point best minimizes travel with respect to X and Z axis
]]
function SelectMinXZDist(point, list)
    minDist = 9999999
    minPoint = nil

    for i = 1, #list do
        --print("BOOL: ", list[i].visited)
        if list[i].visited == true then goto continue end -- Found a visited entry (don't select)
        
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

--[[
    Euclidian distance formula
]]
function XZDistance(a,b)
    return math.sqrt(math.pow(b.x - a.x,2) + math.pow(b.z - a.z,2))
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

--[[
    Function determines what points given a grid lie within the bounds of the given polygon, returns the list of grid points within the polygon
]]
function GridPointsInPolygon(polygon, grid)
    local result = {}
    for i = 1, #grid do
        if(InPoly(polygon, grid[i])) then table.insert(result, grid[i]) end
    end
    return result
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
    Slightly nicer way to print lots of path points that doesn't flood screen as much
]]
_NL = 8 -- number of points to print before going to a new line
function PathFind:PrintPath(list)
    print("--------------------------------")
    str = "START |--\n"
    for i =1, #list do 
        str = str .. string.format( "\t%s -- >\t",_pp(Path[i])) 
        if i % _NL == 0 then 
            print(str)
            str = "\n" 
        end
    end
    str = str .. "\t--| END"
    print(str)
    print("--------------------------------")
    print(string.format("Done printing path of [%s] points.", #list))
end

PolyGon = {} -- Global PolyGon table for storing point data for path creation
--[[
    Function that empties the PolyGon table.
]]
function PathFind:ClearPoly()
    print("Cleared any previous entries in PolyGon")
    ClearTable(PolyGon)
    for k in pairs (PolyGon) do print(PolyGon[k]) end
    print("If you saw any numbers above here, we had a problem.")
end

--[[
    Wrapper function that adds a point to the PolyGon table
]]
function PathFind:AddPoint(_x,_y,_z)
    table.insert(PolyGon, CreatePoint(_x,_y,_z))
    print("Point Added: ", _pp(PolyGon[#PolyGon]))
end

--[[
    Creates a set of grid points and returns them. 
]]
DELTA_LIM = 32 --This number is the divisor used to determine the delta size for the space between points to consider
function GetGrid()
    --Get mins and maxs
    local minx,minz = FindMins(PolyGon)
    local maxx, maxz = FindMaxs(PolyGon)

    x_diff = maxx - minx
    z_diff = maxz - minz
    min_diff = math.min(x_diff, z_diff)
    a = (min_diff) / DELTA_LIM
    delta = math.max(1, math.floor(a+0.5))
    
    --[[
        print("x_diff:", x_diff)
        print("z_diff:", z_diff)
        print("min_diff:", min_diff)
        print("delta:", delta)
    ]]

    --Get Grid points
    Grid = CreateGrid(minx,minz, maxx, maxz, delta)
    print("#Grid Points: ", #Grid)
    return Grid
end

--[[
    Wrapper Function for creating and returning a path using the PolGon table
]]
function PathFind:MakePath()
    
    --Get Grid points
    Grid = GetGrid()

    --Get important points
    ConsideredPoints = GridPointsInPolygon(PolyGon, Grid)
    print("#Considered Points:", #ConsideredPoints)

    --Generate Path
    Path = GeneratePath(ConsideredPoints)
    
    --print("Printing Selected Path:") --Print was removed from wrapper function to keep from flooding output
    --PrintPath(Path)

    print(string.format("Path Generated. [%s] points long.", #Path))
    return Path
end

--[[
    Wrapper Function used for printing the contents of the PolyGon table
]]
function PathFind:PrintPoly()
    print("Contents of PolyGon:")
    for k in pairs (PolyGon) do print(string.format( "%s] [%s]",k, _pp(PolyGon[k]) )) end
end

--[[
    Set all locations of a given table to nil, clearing it.
]]
function ClearTable(t)
    for k in pairs (t) do t[k] = nil end
end

--[[
    A quick test function to test the functionality of each wrapper function in a more isolated space.
]]
function PathFind:WrapperFunctionUnitTest()
    PathFind.ClearPoly()
    PathFind:AddPoint(0,20,0)
    PathFind:AddPoint(100,20,0)
    PathFind:AddPoint(100,20,30)
    PathFind:AddPoint(0,20,30)
    _P = PathFind:MakePath()
    PathFind:PrintPath(_P)
end

--[[
    Following code is for testing bits and bobs in LUA~land outside of Farming Simulator to verify code functions before having to make, move, install, launch, and load mod for FS
    require("Point")
    --PathFind.Test()
    PathFind.WrapperFunctionUnitTest()
]]