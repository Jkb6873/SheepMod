function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "Think", Think, 0 )
end

function Think ()
	if thisEntity:IsAlive() == false then
		v1 = thisEntity:GetAbsOrigin()
		local unit = CreateUnitByName("sheep", v1, true,nil,nil,DOTA_TEAM_NEUTRALS)
		return nil
	end
	return 1		
end