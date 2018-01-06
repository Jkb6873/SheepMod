LinkLuaModifier("frozenmod","frozenmod", LUA_MODIFIER_MOTION_NONE)


function Spawn( entityKeyValues )
	thisEntity:AddNewModifier(nil, nil, "frozenmod", {})
end
