function Spawn()
	port_opened = false
	sheep_taken = false
	foundwinner = false
	radboss = Entities:FindAllByName("radboss")[1]
	direboss = Entities:FindAllByName("direboss")[1]
	badfount = Entities:FindAllByName("ent_dota_fountain_bad")[1]
	goodfount = Entities:FindAllByName("ent_dota_fountain_good")[1]
	thisEntity:SetContextThink("Think", Think, 10)
end

function Think()
	local time = GameRules:GetDOTATime(false, false)
	if time % 300 < 1 and time > 1 and port_opened == false then 	--if 5 minutes passed and portal not open
	--if time % 300 < 1 and port_opened == false then
		OpenPortal()
	elseif time % 300 > 60 and port_opened == true then	--if 1 minute since opened
		ClosePortal()
	elseif sheep_taken == false and port_opened == true then --if opened and no sheep taken
		TakeSheep()
	end	
	radboss:MoveToPosition(thisEntity:GetAbsOrigin())
	direboss:MoveToPosition(thisEntity:GetAbsOrigin())
	CheckReach()
	return .25
end

function CheckReach()
	if foundwinner then
		return
	end

	if CalcDistanceBetweenEntityOBB(direboss, thisEntity) < 25 then
		EmitGlobalSound("jboberg_01.music.battle_02")
		direboss:Stop()
		print("direboss found")
		foundwinner = true
		Notifications:TopToAll({text="(NOT)SANTA IS NOW WEAK, FINISH HIM OFF", duration=10.0})
		Notifications:BottomToAll({text="THE RADIANT CANNOT HIDE IN THEIR BASE", duration=10.0})
		radboss:RemoveModifierByName("bossprotection")
		goodfount:AddNewModifier(thisEntity, nil, "modifier_stunned", {})
	elseif CalcDistanceBetweenEntityOBB(radboss, thisEntity) < 25 then
		EmitGlobalSound("jboberg_01.music.battle_02")
		radboss:Stop()
		print("radboss found")
		foundwinner = true
		Notifications:TopToAll({text="THE GRONCH IS NOW WEAK, FINISH HIM OFF", duration=10.0})
		Notifications:BottomToAll({text="THE DIRE CANNOT HIDE IN THEIR BASE", duration=10.0})
		direboss:RemoveModifierByName("bossprotection")
		badfount:AddNewModifier(thisEntity, nil, "modifier_stunned", {})
	end
end

function OpenPortal()
	Msg("The Portal Has Opened, Bring a Sheep Sacrifice")
	mist =	ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_shadow_dance_sceptor_body_pyro.vpcf",
		PATTACH_ABSORIGIN, thisEntity)
	ParticleManager:SetParticleControl(mist, 1, thisEntity:GetAbsOrigin())
	mist2 =	ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_shadow_dance_sceptor_body_pyro.vpcf",
		PATTACH_ABSORIGIN, thisEntity)
	ParticleManager:SetParticleControl(mist2, 1, thisEntity:GetAbsOrigin())
	port_opened = true
	sheep_taken = false
end

function ClosePortal()
	ParticleManager:DestroyParticle(mist, false)
	ParticleManager:DestroyParticle(mist2, false)
	port_opened = false
	sheep_taken = false
end

function TakeSheep() 
	local targets = FindUnitsInRadius(	thisEntity:GetTeam(), thisEntity:GetAbsOrigin(), nil, 100,
					DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL,
					DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for key,unit in pairs(targets) do
		if unit:IsAlive() == true and unit:GetModelName() == "models/props_gameplay/sheep01.vmdl" then
			unit:Kill(nil, nil)
			sheep_taken = true
			port_opened = false
			local grab =	ParticleManager:CreateParticle("particles/econ/items/shadow_demon/sd_ti7_shadow_poison/sd_ti7_golden_shadow_poison_release_crush_carrier.vpcf",
					PATTACH_ABSORIGIN, thisEntity)
			ParticleManager:SetParticleControl(grab, 0, thisEntity:GetAbsOrigin())
			ParticleManager:SetParticleControl(grab, 1, Vector(particle_radius,0,0))
			local boom =	ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf",
					PATTACH_ABSORIGIN, thisEntity)
			ParticleManager:SetParticleControl(boom, 0, thisEntity:GetAbsOrigin())
			ParticleManager:SetParticleControl(boom, 1, Vector(particle_radius,0,0))
			
			local boom2 =	ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_wings_grow_rope.vpcf",
					PATTACH_ABSORIGIN, thisEntity)
			ParticleManager:SetParticleControl(boom2, 0, thisEntity:GetAbsOrigin())
			ParticleManager:SetParticleControl(boom2, 1, Vector(particle_radius,0,0))
			ClosePortal()
			SurvivalSetup(unit:GetTeam())
			return
		end
	end
end

function SurvivalSetup(dotateam)
	--shake screen
	ScreenShake(thisEntity:GetAbsOrigin(), 50.0, 50.0, 10.0, 1500, 0, true)
	--create timer, every .5 seconds, spawn a unit. 
	Timers:CreateTimer('spawner', {
		--endtime = 1.1,
		callback = function()
			if dotateam == DOTA_TEAM_GOODGUYS then
				temp = CreateUnitByName("npc_dota_creep_goodguys_melee", thisEntity:GetAbsOrigin(), true, nil, nil, dotateam)
				temp2 = CreateUnitByName("npc_dota_creep_goodguys_ranged", thisEntity:GetAbsOrigin(), true, nil, nil, dotateam)
			elseif dotateam == DOTA_TEAM_BADGUYS then
				temp = CreateUnitByName("npc_dota_creep_badguys_melee", thisEntity:GetAbsOrigin(), true, nil, nil, dotateam)
				temp2 = CreateUnitByName("npc_dota_creep_badguys_ranged", thisEntity:GetAbsOrigin(), true, nil, nil, dotateam)
			end
		--create a timer, after 1 second, move the spawned unit
			Timers:CreateTimer(1, function()
				if dotateam == DOTA_TEAM_GOODGUYS then
					temp:MoveToPositionAggressive(direboss:GetAbsOrigin())
					temp2:MoveToPositionAggressive(direboss:GetAbsOrigin())
				elseif dotateam == DOTA_TEAM_BADGUYS then
					temp:MoveToPositionAggressive(radboss:GetAbsOrigin())
					temp2:MoveToPositionAggressive(radboss:GetAbsOrigin())
				end
				end
			)
		return 1.1
		end
	})
	Timers:CreateTimer(30, function()
		Timers:RemoveTimer("spawner")
		end
	)
end