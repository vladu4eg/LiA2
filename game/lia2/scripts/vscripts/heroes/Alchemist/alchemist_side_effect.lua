alchemist_side_effect = class({})
LinkLuaModifier("modifier_alchemist_side_effect","heroes/Alchemist/modifier_alchemist_side_effect.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_alchemist_side_effect_thinker","heroes/Alchemist/modifier_alchemist_side_effect_thinker.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_alchemist_side_effect_debuff","heroes/Alchemist/modifier_alchemist_side_effect_debuff.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_alchemist_side_effect_burn","heroes/Alchemist/modifier_alchemist_side_effect_burn.lua",LUA_MODIFIER_MOTION_NONE)

function alchemist_side_effect:GetIntrinsicModifierName()
	return "modifier_alchemist_side_effect"
end

