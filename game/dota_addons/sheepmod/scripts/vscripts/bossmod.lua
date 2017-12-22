bossmod = class({})

function bossmod:IsHidden()
	return true
end

function bossmod:IsPurgable()
	return false
end

function bossmod:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function bossmod:OnCreated()
	GameRules	:GetGameModeEntity()
				:SetDamageFilter(Dynamic_Wrap(GameMode, "DamageFilter"), self)
	self:GetParent()
end

function GameMode:DamageFilter(params)
	if params.entindex_attacker_const == nil then
		return true
	end
	local attacker = EntIndexToHScript(params.entindex_attacker_const)
	local victim = EntIndexToHScript(params.entindex_victim_const)
	--if the victim is a boss and the attacker is not a creep, negate damage
	if  victim:HasModifier("bossmod") and 
		(not attacker:IsCreep() or attacker:IsSummoned() or attacker:IsIllusion()) then
		return false
	elseif victim:GetUnitName() == "sheep" then
		local pos = victim:GetAbsOrigin() + Vector(RandomInt(-20, 20), RandomInt(-20, 20), 0)
		DebugDrawText(pos, "Baaaa", false, 1)
		return false
	else
		return true
	end
end

function bossmod:OnDestroy()
	GameRules	:GetGameModeEntity()
				:ClearDamageFilter()
end


function bossmod:OnDeath(params)
	if not (params.unit == self:GetParent()) then
		return
	end
	if self:GetParent():GetTeam() == DOTA_TEAM_GOODGUYS then
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	else
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end
end			