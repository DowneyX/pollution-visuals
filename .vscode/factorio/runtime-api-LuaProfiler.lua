---@meta
---@diagnostic disable

--$Factorio 1.1.72
--$Overlay 5
--$Section LuaProfiler
-- This file is automatically generated. Edits will be overwritten.

---An object used to measure script performance.
---
---**Note:** Since performance is non-deterministic, these objects don't allow reading the raw time values from Lua. They can be used anywhere a [LocalisedString](https://lua-api.factorio.com/latest/Concepts.html#LocalisedString) is used, except for [LuaGuiElement::add](https://lua-api.factorio.com/latest/LuaGuiElement.html#LuaGuiElement.add)'s LocalisedString arguments, [LuaSurface::create_entity](https://lua-api.factorio.com/latest/LuaSurface.html#LuaSurface.create_entity)'s `text` argument, and [LuaEntity::add_market_item](https://lua-api.factorio.com/latest/LuaEntity.html#LuaEntity.add_market_item).
---
---[View documentation](https://lua-api.factorio.com/latest/LuaProfiler.html)
---@class LuaProfiler:LuaObject
---[R]  
---The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaProfiler.html#LuaProfiler.object_name)
---@field object_name string 
---[R]  
---Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaProfiler.html#LuaProfiler.valid)
---@field valid boolean 
local LuaProfiler={
---Add the duration of another timer to this timer. Useful to reduce start/stop overhead when accumulating time onto many timers at once.
---
---**Note:** If other is running, the time to now will be added.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaProfiler.html#LuaProfiler.add)
---@param other LuaProfiler@The timer to add to this timer.
add=function(other)end,
---Divides the current duration by a set value. Useful for calculating the average of many iterations.
---
---**Note:** Does nothing if this isn't stopped.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaProfiler.html#LuaProfiler.divide)
---@param number double@The number to divide by. Must be > 0.
divide=function(number)end,
---All methods and properties that this object supports.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaProfiler.html#LuaProfiler.help)
---@return string
help=function()end,
---Resets the clock, also restarting it.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaProfiler.html#LuaProfiler.reset)
reset=function()end,
---Start the clock again, without resetting it.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaProfiler.html#LuaProfiler.restart)
restart=function()end,
---Stops the clock.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaProfiler.html#LuaProfiler.stop)
stop=function()end,
}


