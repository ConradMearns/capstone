Point = {}

function CreatePoint(x,y,z)
    local object = {}
    object.x = x
    object.y = y
    object.z = z

    function object:print()
        print("[",object.x,object.y,object.z,"]")
    end

    return object
end