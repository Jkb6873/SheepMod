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
	explosion =	ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf",
		PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(explosion, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(explosion, 3, self:GetParent():GetAbsOrigin())
	self:GetParent():EmitSound("Hero_Lich.FrostBlast.Immortal")

	self:GetParent():SetModelScale(.01)
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