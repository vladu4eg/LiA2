if IsClient() then return end
require('timers')

function Spawn(entityKeyValues)
	thisEntity.destructable = 1
	thisEntity:FindAbilityByName("barrel_no_health_bar"):SetLevel(1)
	
	local unitName = thisEntity:GetUnitName()



	if unitName == "barricades" or unitName == "arena_rock" then
		thisEntity:SetHullRadius(50)
	end

	if unitName == "barricades_big" then
		thisEntity:SetHullRadius(55)
	end

	if unitName == "barricades_small" then
		thisEntity:SetHullRadius(45)
	end

	if unitName == "big_barrel" then
		thisEntity:SetHullRadius(24)
	end

	if unitName == "small_barrel" then
		thisEntity:SetHullRadius(24)
	end
	
	if unitName == "npc_dota_creature_barrel" then
		thisEntity:SetHullRadius(24)
	end

	if unitName == "small_barrel_side" then
		thisEntity:SetHullRadius(50)
	end

	if thisEntity:GetUnitName() == "tnt_barrel" then
        thisEntity:FindAbilityByName("barrel_explosion"):SetLevel(1)
    end
	
	thisEntity:SetTeam(DOTA_TEAM_GOODGUYS)
	
	Timers:CreateTimer(0.01,function()
		thisEntity:RemoveModifierByName("modifier_invulnerable")

		--print(unitName,thisEntity:GetHullRadius())
	end)

	if GetMapName() == "lia_8_clans" then
		if unitName == "barricades_2" or unitName == "arena_rock_2" then
			thisEntity:SetHullRadius(50)
			thisEntity:SetTeam(DOTA_TEAM_CUSTOM_1)
		end
	
		if unitName == "barricades_big_2" then
			thisEntity:SetHullRadius(55)
			thisEntity:SetTeam(DOTA_TEAM_CUSTOM_1)
		end
	
		if unitName == "barricades_small_2" then
			thisEntity:SetHullRadius(45)
			thisEntity:SetTeam(DOTA_TEAM_CUSTOM_1)
		end
	
		if unitName == "big_barrel_2" then
			thisEntity:SetHullRadius(24)
			thisEntity:SetTeam(DOTA_TEAM_CUSTOM_1)
		end
	
		if unitName == "small_barrel_2" then
			thisEntity:SetHullRadius(24)
			thisEntity:SetTeam(DOTA_TEAM_CUSTOM_1)
		end
		
		if unitName == "npc_dota_creature_barrel_2" then
			thisEntity:SetHullRadius(24)
			thisEntity:SetTeam(DOTA_TEAM_CUSTOM_1)
		end
	
		if unitName == "small_barrel_side_2" then
			thisEntity:SetHullRadius(50)
			thisEntity:SetTeam(DOTA_TEAM_CUSTOM_1)
		end
	
		if thisEntity:GetUnitName() == "tnt_barrel_2" then
			thisEntity:FindAbilityByName("barrel_explosion"):SetLevel(1)
		end
		
		
		
		Timers:CreateTimer(0.01,function()
			thisEntity:RemoveModifierByName("modifier_invulnerable")
	
			--print(unitName,thisEntity:GetHullRadius())
		end)
	end
	--print("barrelspawned")
end