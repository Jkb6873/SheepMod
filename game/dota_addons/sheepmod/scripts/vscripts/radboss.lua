local sheepsfed = 0		--im setting these counters up to allow feeding sheep at all times, and allow stacking durations instead of refreshing. 
local timer = 0

LinkLuaModifier("bossmod","bossmod.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("winmod", "winmod.lua", LUA_MODIFIER_MOTION_NONE)

function Spawn( entityKeyValues )	--links the keyvalue file, which defines stuff like npc model. Can also be done in LUA, but cleaner this way. 
	thisEntity:AddNewModifier(nil, nil, "bossmod", {})
	thisEntity:AddNewModifier(nil, nil, "winmod", {})
	thisEntity:AddNewModifier(nil, nil, "modifier_state_flying_for_pathing_purposes_only", {})
	thisEntity:SetContextThink( "AIThink", AIThink, 0 )
end				--name, function, wait time before start. 

function AIThink()
	if thisEntity:IsAlive() ~= true then
		return nil			--if dead, end think function
	end
		
	if sheepsfed == 0 then									--if not fed, then add stun
		thisEntity:AddNewModifier(thisEntity, nil, "modifier_stunned", {duration = 1})
	elseif thisEntity:HasModifier("modifier_stunned") == true then				--if fed, but stunned, remove stun
		thisEntity:RemoveModifierByName("modifier_stunned")
	else
		CastAbilities()									--if fed and not stunned, cast abilities
	end

	Feed()											--always take food
	Poison()										--always apply poison

	return 1						--returning 1 means that this function repeats on one second intervals
end

function Feed()
	if sheepsfed > 0 then					--if sheep fed, then start counting
		timer = timer + 1
	end
	if timer == 8 then					--if count to 8 seconds, then drop a sheep, and reset timer
		sheepsfed = sheepsfed - 1
		timer = 0					--reset timer
	end
	local targets = FindUnitsInRadius(	thisEntity:GetTeam(), thisEntity:GetAbsOrigin(), nil, 200,
						DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL,
						DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	--this returns a table, containing all entities that are within 200 units of this entity. It only selects friendlies. 
	if #targets == 0 then
		return			--this is a precaution, but almost always this entity will return itself in the table
	end
	for key,unit in pairs(targets) do
		if unit:IsAlive() == true and unit:GetModelName() == "models/props_gameplay/sheep01.vmdl" then
			unit:Kill(nil, nil)		--test via model. This is because entities spawned via script will not have the correct name
			sheepsfed = sheepsfed + 1
		end
	end
end

function Poison()
	local units = 	FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, 1200,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	--similar find function, but finds only enemy heros
	for i, unit in pairs(units) do
	--deals percentage based pure damage to any enemy heros nearby. Wont effect minions. Prevents camping by boss. 
		ApplyDamage({	victim = unit,
				attacker = thisEntity, 
				damage = (unit:GetMaxHealth()* 0.07),
				damage_type = DAMAGE_TYPE_PURE})
	end
end
	

function CastAbilities()
	--if no mana, or if something is preventing spellcasting, dont try to cast. 
	local ability = thisEntity:FindAbilityByName("alternate_barrage")
	if ability == nil or ability:IsFullyCastable() == false then
		return
	end
	thisEntity:CastAbilityNoTarget(ability, -1)
end

	