tauren_champion_accumulated_rage = class({})
LinkLuaModifier("modifier_tauren_champion_accumulated_rage","heroes/TaurenChampion/modifier_tauren_champion_accumulated_rage.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tauren_champion_accumulated_rage_block","heroes/TaurenChampion/modifier_tauren_champion_accumulated_rage_block.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tauren_champion_accumulated_rage_damage","heroes/TaurenChampion/modifier_tauren_champion_accumulated_rage_damage.lua",LUA_MODIFIER_MOTION_NONE)

function tauren_champion_accumulated_rage:GetIntrinsicModifierName()
	return "modifier_tauren_champion_accumulated_rage"
end

