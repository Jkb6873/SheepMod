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
end

function GameMode:DamageFilter(params)
	if params.entindex_attacker_const == nil then
		return true
	elseif  (not EntIndexToHScript(params.entindex_attacker_const):IsCreep()) and
		EntIndexToHScript(params.entindex_victim_const):HasModifier("bossmod") then
		return false
	else 
		PrintTable(params)
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