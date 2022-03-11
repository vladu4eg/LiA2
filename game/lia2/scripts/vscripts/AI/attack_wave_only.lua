if IsClient() then return end
require('survival/AIcreeps')

function Spawn(entityKeyValues)
    thisEntity:SetHullRadius(30) 
	if thisEntity:GetPlayerOwnerID() ~= -1 then
		return
	end
	
	thisEntity:SetContextThink( "attack_wave_only", ThinkAllWave , 0.1)
end

function ThinkAllWave()
	if not thisEntity:IsAlive() or thisEntity:IsIllusion() then
		return nil 
	end

	if GameRules:IsGamePaused() then
		return 1
	end

	local radius = 99999
	if GetMapName() == "lia_8_clans" then
		radius = 5000
	end

	local enemies = FindUnitsInRadius( 
						thisEntity:GetTeamNumber(),		--команда юнита
						thisEntity:GetAbsOrigin(),		--местоположение юнита
						nil,	--айди юнита (необязательно)
						radius,	--радиус поиска
						DOTA_UNIT_TARGET_TEAM_ENEMY,	-- юнитов чьей команды ищем вражеской/дружественной
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	--юнитов какого типа ищем 
						DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,	--поиск по флагам
						FIND_CLOSEST,	--сортировка от ближнего к дальнему 
						false )

	local enemy = enemies[1]	-- врагом выбирается первый близжайший
	if enemy ~= nil then
		AttackMove(thisEntity, enemy:GetAbsOrigin())
	end
	
	return 2
end

function AttackMove ( unit, point )
	print("that shit work !!!")
	Timers:CreateTimer(0.1, function()
		ExecuteOrderFromTable({
			UnitIndex = unit:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = point,
			Queue = false,
		})
	end)
end