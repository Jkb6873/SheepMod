function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "Think", Think, 10)
end

function Think()
	if GameRules:GetDOTATime(false, false) < 1 and GameRules:GetDOTATime(false, false) > 0 then
		StartSpawning()
		return nil
	end
	return 1
end

function StartSpawning()
	temp = Entities:FindAllByName("radboss")
	temp2 = Entities:FindAllByName("direboss")
	radboss = temp[1]
	direboss = temp2[1]
	rSpawn = Vector(-5464.15, -7452.67, 393)
	dSpawn = Vector(-2607.54, -947.665, 393)
	Timers:CreateTimer(function()
		units1 = {
			CreateUnitByName("npc_dota_creep_goodguys_melee", rSpawn, true, nil, nil, DOTA_TEAM_GOODGUYS),
			CreateUnitByName("npc_dota_creep_goodguys_melee", rSpawn, true, nil, nil, DOTA_TEAM_GOODGUYS),
			CreateUnitByName("npc_dota_creep_goodguys_melee", rSpawn, true, nil, nil, DOTA_TEAM_GOODGUYS),
			CreateUnitByName("npc_dota_creep_goodguys_melee", rSpawn, true, nil, nil, DOTA_TEAM_GOODGUYS),
			CreateUnitByName("npc_dota_creep_goodguys_ranged", rSpawn, true, nil, nil, DOTA_TEAM_GOODGUYS)			
		}
		units2 = {
			CreateUnitByName("npc_dota_creep_badguys_melee", dSpawn, true, nil, nil, DOTA_TEAM_BADGUYS),
			CreateUnitByName("npc_dota_creep_badguys_melee", dSpawn, true, nil, nil, DOTA_TEAM_BADGUYS),
			CreateUnitByName("npc_dota_creep_badguys_melee", dSpawn, true, nil, nil, DOTA_TEAM_BADGUYS),
			CreateUnitByName("npc_dota_creep_badguys_melee", dSpawn, true, nil, nil, DOTA_TEAM_BADGUYS),
			CreateUnitByName("npc_dota_creep_badguys_ranged", dSpawn, true, nil, nil, DOTA_TEAM_BADGUYS)			
		}
		Timers:CreateTimer(.25, function()
			for _, v in pairs(units1) do
				v:MoveToPositionAggressive(direboss:GetAbsOrigin())
			end
			for _, v in pairs(units2) do
				v:MoveToPositionAggressive(radboss:GetAbsOrigin())
			end
			end
		)
		return 60.0
		end
	)
end