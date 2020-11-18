--Meta Class
-- Point = {x = -1, y = -1, z = -1}

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

--[[
    function Point:new(o, x,y,z)
        o = o or {}
        setmetatable(o, self)
        self.__index = self
    
        self.x = x
        self.y = y
        self.z = z
    
        print("Created point with: ",x, y, z)
        return o
    end
    
    function Point:print()
        print("Point info: [",self.x,", ",self.y,", ",self.z,"]")
    end

]]