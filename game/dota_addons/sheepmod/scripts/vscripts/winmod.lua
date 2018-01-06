winmod = class({})


function winmod:IsHidden()
	return true
end

function winmod:IsPurgable()
	return false
end

function winmod:DeclareFunctions()
	return {MODIFIER_EVENT_ON_DEATH}
end


function winmod:OnDeath(params)
	if not (params.unit == self:GetParent()) then
		return
	end
	if self:GetParent():GetTeam() == DOTA_TEAM_GOODGUYS then
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	else
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end
end			