function Spawn( entityKeyValues )
	leader = nil
	thisEntity:SetUnitName("sheep")
	thisEntity:AddNewModifier(self, nil, "modifier_truesight", {})
	thisEntity:SetContextThink( "Think", Think, 0 )
end

function Think()
	if thisEntity:IsAlive() ~= true then
		deathscream()
		return nil
	end
	
	if leader == nil then
		local units = 	FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, 200,
				DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		if #units ~= 0 then
			leader = units[1]
			thisEntity:SetTeam(leader:GetTeam())
		end
	else 
		follow()
	end
 
	return 0.5
end

function follow()
	if leader:IsAlive() ~= true or CalcDistanceBetweenEntityOBB(thisEntity, leader) > 800 then
		thisEntity:MoveToPosition(thisEntity:GetAbsOrigin())
		DebugDrawText(thisEntity:GetAbsOrigin(), "Please dont leave me", false, 3)
		leader = nil
		return
	else
		thisEntity:SetBaseMoveSpeed(leader:GetIdealSpeed() * timeMod())
		thisEntity:MoveToPosition(leader:GetAbsOrigin())
	end
	return
end

function deathscream()
	local value = RandomInt(1, 5)
	local pos = victim:GetAbsOrigin() + Vector(RandomInt(-20, 20), RandomInt(-20, 20), 0)
	if value == 1 then
		DebugDrawText(pos, "Baaaa", false, 3)
	elseif value == 2 then
		DebugDrawText(pos, "Monster.", false, 3)
	elseif value == 3 then
		DebugDrawText(pos, "See you in hell", false, 3)
	elseif value == 4 then
		DebugDrawText(pos, "You could have prevented this.", false, 3)
	else
		DebugDrawText(pos, "I embrace the void.", false, 3)
	end
	return
end

function timeMod()
	returnval =  .8 - .0003*GameRules:GetDOTATime(false, false) --22 minutes produces a speed of .4
	if returnval < .4 then
		return .4
	else
		return returnval
	end
end