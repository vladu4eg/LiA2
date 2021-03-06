
wave_12_crit_extreme = class({})
LinkLuaModifier( "modifier_wave_12_crit_extreme", "abilities/wave_12_crit_extreme.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function wave_12_crit_extreme:GetIntrinsicModifierName()
	return "modifier_wave_12_crit_extreme"
end

--------------------------------------------------------------------------------


modifier_wave_12_crit_extreme = class({})

--------------------------------------------------------------------------------

function modifier_wave_12_crit_extreme:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_wave_12_crit_extreme:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_wave_12_crit_extreme:OnCreated( kv )
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_multiplier = self:GetAbility():GetSpecialValueFor( "crit_multiplier" )

	if IsServer() then
		self.pseudo = PseudoRandom:New(self:GetAbility():GetSpecialValueFor("crit_chance")*0.01)
		self.bIsCrit = false
	end
end

--------------------------------------------------------------------------------

function modifier_wave_12_crit_extreme:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_wave_12_crit_extreme:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() then
		local hTarget = params.target
		local hAttacker = params.attacker

		if self:GetParent():PassivesDisabled() then
			return 0.0
		end

		if hTarget and ( hTarget:IsBuilding() == false ) and ( hTarget:IsOther() == false ) and hAttacker and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) then
			if self.pseudo:Trigger() then -- expose RollPseudoRandomPercentage?
				self.bIsCrit = true
				return self.crit_multiplier
			end
		end
	end

	return 0.0
end

--------------------------------------------------------------------------------

function modifier_wave_12_crit_extreme:OnAttackLanded( params )
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil and self.bIsCrit then
				EmitSoundOn( "DOTA_Item.Daedelus.Crit", self:GetParent() )
				self.bIsCrit = false
			end
		end
	end

	return 0.0
end

--------------------------------------------------------------------------------
