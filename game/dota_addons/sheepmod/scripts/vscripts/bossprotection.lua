bossprotection = class({})

function bossprotection:IsHidden()
	return true
end

function bossprotection:IsPurgable()
	return false
end

function bossprotection:OnCreated()
	GameRules:	GetGameModeEntity()
				:SetDamageFilter(Dynamic_Wrap(GameMode, "DamageFilter"), self)
end

function bossprotection:CheckState()
	local state = {}
	state[MODIFIER_STATE_MAGIC_IMMUNE] = true
	state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	state[MODIFIER_STATE_UNSELECTABLE] = true
	return state
end





function GameMode:DamageFilter(params)
	if params.entindex_attacker_const == nil then
		return true
	end
	local attacker = EntIndexToHScript(params.entindex_attacker_const)
	local victim = EntIndexToHScript(params.entindex_victim_const)
	--if the victim is a boss and the attacker is not a creep, negate damage
	if  victim:HasModifier("bossprotection") and 
		(not attacker:IsCreep() or attacker:IsSummoned() or attacker:IsIllusion()) then
		return false
	elseif victim:GetUnitName() == "sheep" then
		local pos = victim:GetAbsOrigin() + Vector(RandomInt(-20, 20), RandomInt(-20, 20), 0)
		DebugDrawText(pos, "Baaaa", false, 1)
		EmitBaaa(victim)
		return false
	else
		return true
	end
end

function EmitBaaa(entity)
	local x = RandomInt(1, 100)
	if x == 100 then
		entity:EmitSound("axe_axe_sheepstick_02")
	elseif x % 2 == 0 then
		entity:EmitSound("Hero_ShadowShaman.SheepHex.Target")
	else
		entity:EmitSound("axe_axe_sheepstick_01")
	end
end