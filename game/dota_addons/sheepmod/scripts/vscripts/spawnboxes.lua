function Spawn( entityKeyValues )
	direfountain = Vector(-1443.77, -1377.76, 521)
	radfountain = Vector(-6949.65, -7132.55, 521)
	BoxSpawn(direfountain, radfountain)
	thisEntity:SetContextThink( "Think", Think, 0 )
end

function Think()
	if thisEntity:IsAlive() ~= true then
		return nil
	end
	time = GameRules:GetDOTATime(false, false)
	if time % 60 > 0 and time % 60 < 1 then
		print("BOXES ARE SPAWNING")
		BoxSpawn(direfountain, radfountain)
	end
	return 1
end


function BoxSpawn(dire, rad)
	local units = Entities:FindAllByModel("models/props_winter/present.vmdl")
	Fake, Real = CountUnits(units)
	print("FAKE AND REAL FOUND: ", Fake, " ", Real)
	if (Real < 3 and Real >= 0) then
		for i = 1, (3-Real) do
			boxPos = FindSpawnLocation(dire, rad, 1500)
			CreateUnitByName("sheepbox", boxPos, true,nil,nil,DOTA_TEAM_NEUTRALS)
		end
	end
	if (Fake < 7 and Fake >= 0) then
		for i = 1, (7-Real) do
			boxPos = FindSpawnLocation(dire, rad, 1500)
			CreateUnitByName("fakebox", boxPos, true,nil,nil,DOTA_TEAM_NEUTRALS)
		end
	end
end

function CountUnits(units)
	numFake = 0
	numReal = 0
	for key,val in pairs(units) do
		if val:GetUnitName() == "sheepbox" then
			numReal = numReal + 1
		elseif val:GetUnitName() == "fakebox" then
			numFake = numFake + 1
		end
	end
	return numFake, numReal 
end

function FindSpawnLocation(dire, rad, radius)
	local position = nil
	while position == nil do
		local x = RandomFloat(rad.x, dire.x)	--RandomFloat(GetWorldMinX(), GetWorldMaxX())
		local y = RandomFloat(rad.y, dire.y)	--RandomFloat(GetWorldMinY(), GetWorldMaxY())
		position = Vector(x, y, 0)
		local direLength = GridNav:FindPathLength( dire, position )
		local radLength = GridNav:FindPathLength( rad, position )
		--print(x, '\t', y, '\t', direLength, radLength)
		if (direLength < radius or radLength < radius) then	    	
			--print(position)
			position = nil
		end
	end
	return position
end