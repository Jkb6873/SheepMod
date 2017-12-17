bossmod = class({})

function bossmod:IsHidden()
	return true
end

function bossmod:IsPurgable()
	return false
end

function bossmod:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function bossmod:OnTakeDamage(params)
	PrintTable("OnTakeDamage",params)
--	if self:GetParent():PassivesDisabled() then
--		return
--	end
--	local return_damage 
--	if RollPercentage(self:GetAbility():GetSpecialValueFor("full_damage_chance")) then
--		return_damage = params.original_damage
--		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, params.attacker, return_damage, nil)
--	else
--		return_damage = self:GetAbility():GetSpecialValueFor("damage_return")*0.01*params.original_damage
--	end
--		
--	ApplyDamage(
--	{
--		victim = params.attacker, 
--		attacker = params.unit, 
--		damage = return_damage, 
--		damage_type = DAMAGE_TYPE_MAGICAL,
--		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
--		ability = self:GetAbility()
--	})
end			