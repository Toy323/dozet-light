CLASS.Base = "zombie_legs"

CLASS.Name = "Baracat"
CLASS.TranslationName = "class_baracat"
CLASS.Description = "description_baracat"
CLASS.Help = "controls_baracat"
CLASS.Model = Model("models/player/catpants.mdl")
CLASS.OverrideModel = Model("models/player/catpants.mdl")
--CLASS.BetterVersion = "Baragat"
CLASS.Variations = false

CLASS.Weight = 0.6
CLASS.Wave = 3 / 6

CLASS.NoFallDamage = true
CLASS.NoFallSlowdown = true

CLASS.KnockbackScale = 0
CLASS.BaraCat = true
CLASS.FearPerInstance = 1


CLASS.Points = 3

CLASS.SWEP = "weapon_zs_baracat"

CLASS.Health = 120
CLASS.Speed = 870
CLASS.JumpPower = 700


CLASS.ModelScale = 0.65
CLASS.Hull = {Vector(-16, -16, 0), Vector(16, 16, 32)}
CLASS.HullDuck = {Vector(-16, -16, 0), Vector(16, 16, 32)}
CLASS.ViewOffset = Vector(0, 0, 32 * CLASS.ModelScale)
CLASS.ViewOffsetDucked = Vector(0, 0, 32 * CLASS.ModelScale)
CLASS.StepSize = 25
CLASS.CrouchedWalkSpeed = 1
CLASS.Mass = DEFAULT_MASS * CLASS.ModelScale * 0.65

CLASS.NoCollideAll = true


CLASS.CanFeignDeath = false

CLASS.CantDuck = true

CLASS.SWEP = "weapon_zs_baracat"

CLASS.BloodColor = -1

local math_random = math.random
local CurTime = CurTime

local ACT_RUN = ACT_RUN

function CLASS:PlayerStepSoundTime(pl, iType, bWalking)
	return GAMEMODE.BaseClass.PlayerStepSoundTime(GAMEMODE.BaseClass, pl, iType, bWalking) * self.ModelScale
end

function CLASS:ScalePlayerDamage(pl, hitgroup, dmginfo)
	if not dmginfo:IsBulletDamage() then return true end

	if hitgroup ~= HITGROUP_LEFTLEG and hitgroup ~= HITGROUP_RIGHTLEG and hitgroup ~= HITGROUP_GEAR and hitgroup ~= HITGROUP_GENERIC and dmginfo:GetDamagePosition().z > pl:LocalToWorld(Vector(0, 0, self.Hull[2].z * 1.33)).z then
		dmginfo:SetDamage(0)
		dmginfo:ScaleDamage(0)
	end

	return true
end

function CLASS:IgnoreLegDamage(pl, dmginfo)
	return true
end

local StepSounds = {
	"npc/zombie/foot1.wav",
	"npc/zombie/foot2.wav",
	"npc/zombie/foot3.wav"
}
function CLASS:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)

	pl:EmitSound(StepSounds[math_random(#StepSounds)], 77, 50)

	if iFoot == 0 then
		pl:EmitSound("^npc/strider/strider_step4.wav", 90, math_random(95, 115))
	else
		pl:EmitSound("^npc/strider/strider_step5.wav", 90, math_random(95, 115))
	end

	return true
end

function CLASS:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	local feign = pl.FeignDeath
	if feign and feign:IsValid() then
		if feign:GetState() == 1 then
			pl:SetCycle(1 - math.max(feign:GetStateEndTime() - CurTime(), 0) * 0.666)
		else
			pl:SetCycle(math.max(feign:GetStateEndTime() - CurTime(), 0) * 0.666)
		end
		pl:SetPlaybackRate(0)

		return true
	end

	local len2d = velocity:Length2D()
	if len2d > 1 then
		pl:SetPlaybackRate(math.min(len2d / maxseqgroundspeed * 0.75 / self.ModelScale, 3))
	else
		pl:SetPlaybackRate(1 / self.ModelScale)
	end

	return true
end
