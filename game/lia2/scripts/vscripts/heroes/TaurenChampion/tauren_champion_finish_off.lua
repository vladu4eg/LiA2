tauren_champion_finish_off = class({})
LinkLuaModifier("modifier_tauren_champion_finish_off","heroes/TaurenChampion/modifier_tauren_champion_finish_off.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tauren_champion_finish_off_counter","heroes/TaurenChampion/modifier_tauren_champion_finish_off_counter.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tauren_champion_finish_off_animation","heroes/TaurenChampion/modifier_tauren_champion_finish_off_animation.lua",LUA_MODIFIER_MOTION_NONE)

function tauren_champion_finish_off:GetIntrinsicModifierName()
	return "modifier_tauren_champion_finish_off"
end

