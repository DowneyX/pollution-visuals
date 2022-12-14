---@meta
---@diagnostic disable

--$Factorio 1.1.72
--$Overlay 5
--$Section LuaWallControlBehavior
-- This file is automatically generated. Edits will be overwritten.

---Control behavior for walls.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaWallControlBehavior.html)
---@class LuaWallControlBehavior:LuaControlBehavior
---[RW]  
---The circuit condition.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaWallControlBehavior.html#LuaWallControlBehavior.circuit_condition)
---@field circuit_condition CircuitConditionDefinition 
---[R]  
---The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaWallControlBehavior.html#LuaWallControlBehavior.object_name)
---@field object_name string 
---[RW]
---
---[View documentation](https://lua-api.factorio.com/latest/LuaWallControlBehavior.html#LuaWallControlBehavior.open_gate)
---@field open_gate boolean 
---[RW]
---
---[View documentation](https://lua-api.factorio.com/latest/LuaWallControlBehavior.html#LuaWallControlBehavior.output_signal)
---@field output_signal SignalID 
---[RW]
---
---[View documentation](https://lua-api.factorio.com/latest/LuaWallControlBehavior.html#LuaWallControlBehavior.read_sensor)
---@field read_sensor boolean 
---[R]  
---Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaWallControlBehavior.html#LuaWallControlBehavior.valid)
---@field valid boolean 
local LuaWallControlBehavior={
---All methods and properties that this object supports.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaWallControlBehavior.html#LuaWallControlBehavior.help)
---@return string
help=function()end,
}


