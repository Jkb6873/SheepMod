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