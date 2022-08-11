---@meta
---@diagnostic disable

--$Factorio 1.1.61
--$Overlay 5
--$Section LuaEquipmentGrid
-- This file is automatically generated. Edits will be overwritten.

---An equipment grid is for example the inside of a power armor.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html)
---@class LuaEquipmentGrid:LuaObject
---[R]  
---The total energy stored in all batteries in the equipment grid.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.available_in_batteries)
---@field available_in_batteries double 
---[R]  
---Total energy storage capacity of all batteries in the equipment grid.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.battery_capacity)
---@field battery_capacity double 
---[R]  
---All the equipment in this grid.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.equipment)
---@field equipment LuaEquipment[] 
---[R]  
---Total energy per tick generated by the equipment inside this grid.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.generator_energy)
---@field generator_energy double 
---[R]  
---Height of the equipment grid.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.height)
---@field height uint 
---[RW]  
---True if this movement bonus equipment is turned off, otherwise false.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.inhibit_movement_bonus)
---@field inhibit_movement_bonus boolean 
---[R]  
---The maximum amount of shields this equipment grid has.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.max_shield)
---@field max_shield float 
---[R]  
---Maximum energy per tick that can be created by any solar panels in the equipment grid. Actual generated energy varies depending on the daylight levels.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.max_solar_energy)
---@field max_solar_energy double 
---[R]  
---The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.object_name)
---@field object_name string 
---[R]
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.prototype)
---@field prototype LuaEquipmentGridPrototype 
---[R]  
---The amount of shields this equipment grid has.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.shield)
---@field shield float 
---[R]  
---Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.valid)
---@field valid boolean 
---[R]  
---Width of the equipment grid.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.width)
---@field width uint 
local LuaEquipmentGrid={
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.can_move)
---@class LuaEquipmentGrid.can_move_param
---The equipment to move
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.can_move)
---@field equipment LuaEquipment 
---Where to put it
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.can_move)
---@field position EquipmentPosition 


---Check whether moving an equipment would succeed.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.can_move)
---@param param LuaEquipmentGrid.can_move_param
---@return boolean
can_move=function(param)end,
---Clear all equipment from the grid, removing it without actually returning it.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.clear)
---@param by_player PlayerIdentification?@If provided, the action is done 'as' this player and [on_player_removed_equipment](https://lua-api.factorio.com/latest/events.html#on_player_removed_equipment) is triggered.
clear=function(by_player)end,
---Find equipment in the Equipment Grid based off a position.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.get)
---@param position EquipmentPosition@The position
---@return LuaEquipment?@The found equipment, or `nil` if equipment could not be found at the given position.
get=function(position)end,
---Get counts of all equipment in this grid.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.get_contents)
---@return {[string]: uint}@The counts, indexed by equipment names.
get_contents=function()end,
---All methods and properties that this object supports.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.help)
---@return string
help=function()end,
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.move)
---@class LuaEquipmentGrid.move_param
---The equipment to move
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.move)
---@field equipment LuaEquipment 
---Where to put it
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.move)
---@field position EquipmentPosition 


---Move an equipment within this grid.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.move)
---@param param LuaEquipmentGrid.move_param
---@return boolean@`true` if the equipment was successfully moved.
move=function(param)end,
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.put)
---@class LuaEquipmentGrid.put_param
---Equipment prototype name
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.put)
---@field name string 
---Grid position to put the equipment in.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.put)
---@field position? EquipmentPosition 
---If provided the action is done 'as' this player and [on_player_placed_equipment](https://lua-api.factorio.com/latest/events.html#on_player_placed_equipment) is triggered.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.put)
---@field by_player? PlayerIdentification 


---Insert an equipment into the grid.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.put)
---@param param LuaEquipmentGrid.put_param
---@return LuaEquipment?@The newly-added equipment, or `nil` if the equipment could not be added.
put=function(param)end,
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.take)
---@class LuaEquipmentGrid.take_param
---Take the equipment that contains this position in the grid.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.take)
---@field position? EquipmentPosition 
---Take this exact equipment.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.take)
---@field equipment? LuaEquipment 
---If provided the action is done 'as' this player and [on_player_removed_equipment](https://lua-api.factorio.com/latest/events.html#on_player_removed_equipment) is triggered.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.take)
---@field by_player? PlayerIdentification 


---Remove an equipment from the grid.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.take)
---@param param LuaEquipmentGrid.take_param
---@return SimpleItemStack?@The removed equipment, or `nil` if no equipment was removed.
take=function(param)end,
---Remove all equipment from the grid.
---
---[View documentation](https://lua-api.factorio.com/latest/LuaEquipmentGrid.html#LuaEquipmentGrid.take_all)
---@param by_player PlayerIdentification?@If provided, the action is done 'as' this player and [on_player_removed_equipment](https://lua-api.factorio.com/latest/events.html#on_player_removed_equipment) is triggered.
---@return {[string]: uint}@Count of each removed equipment, indexed by their prototype names.
take_all=function(by_player)end,
}


