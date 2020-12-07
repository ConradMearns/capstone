Point = {}
Point.__index = Point

function CreatePoint(x,y,z)
    local object = {}
    setmetatable(object,Point)
    
    object.x = x
    object.y = y
    object.z = z
    object.visited = false
    
    function object:print()
        print("[",object.x,object.y,object.z,"]")
    end

    return object
end