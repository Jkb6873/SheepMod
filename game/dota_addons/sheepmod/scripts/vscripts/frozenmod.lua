frozenmod = class({})

function frozenmod:IsHidden()
	return true
end

function frozenmod:IsPurgable()
	return false
end


function frozenmod:DeclareFunctions()
	return {MODIFIER_EVENT_ON_DEATH, MODIFIER_EVENT_ON_TAKEDAMAGE}
end


function frozenmod:OnDeath(params)
	if not (params.unit == self:GetParent()) then
		return
	end
	CreateUnitByName("sheep", self:GetParent():GetAbsOrigin(), true,nil,nil,DOTA_TEAM_NEUTRALS)
end

function frozenmod:OnTakeDamage(params)
	if not (params.unit == self:GetParent()) then
		return
	end

	local x = RandomInt(0, 10)
	if x % 2 == 0 then
		self:GetParent():EmitSound("Hero_Invoker.IceWall.Slow")
	else
		self:GetParent():EmitSound("Hero_Ancient_Apparition.ColdFeetTick")
	end
end