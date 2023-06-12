
GM.Skills = {}
GM.SkillModifiers = {}
GM.SkillFunctions = {}
GM.SkillModifierFunctions = {}

function GM:AddSkill(id, name, description, x, y, connections, tree)
	local skill = {Connections = table.ToAssoc(connections or {})}

	if CLIENT then
		skill.x = x
		skill.y = y

		-- TODO: Dynamic skill descriptions based on modifiers on the skill.

		skill.Description = description
	end

	if #name == 0 then
		name = "Skill "..id
		skill.Disabled = true
	end

	skill.Name = name
	skill.Tree = tree

	self.Skills[id] = skill

	return skill
end

-- Use this after all skills have been added. It assigns dynamic IDs!
function GM:AddTrinket(name, swepaffix, pairedweapon, veles, weles, tier, description, status, stocks, icon, models)
	local skill = {Connections = {}}
	skill.Name = name
	skill.Trinket = swepaffix
	skill.Status = status
	local datatab = {PrintName = name, DroppedEles = weles, Tier = tier, Description = description, Status = status, Stocks = stocks, Icon = icon, PacModels = models}
	if pairedweapon then
		skill.PairedWeapon = "weapon_zs_t_" .. swepaffix
	end
	self.ZSInventoryItemData["trinket_" .. swepaffix] = datatab
	self.Skills[#self.Skills + 1] = skill
	return #self.Skills, self.ZSInventoryItemData["trinket_" .. swepaffix]
end

-- I'll leave this here, but I don't think it's needed.
function GM:GetTrinketSkillID(trinketname)
	for skillid, skill in pairs(GM.Skills) do
		if skill.Trinket and skill.Trinket == trinketname then
			return skillid
		end
	end
end

function GM:AddSkillModifier(skillid, modifier, amount)
	self.SkillModifiers[skillid] = self.SkillModifiers[skillid] or {}
	self.SkillModifiers[skillid][modifier] = (self.SkillModifiers[skillid][modifier] or 0) + amount
end

function GM:AddSkillFunction(skillid, func)
	self.SkillFunctions[skillid] = self.SkillFunctions[skillid] or {}
	table.insert(self.SkillFunctions[skillid], func)
end

function GM:SetSkillModifierFunction(modid, func)
	self.SkillModifierFunctions[modid] = func
end

function GM:MkGenericMod(modifiername)
	return function(pl, amount) pl[modifiername] = math.Clamp(amount + 1.0, 0.0, 1000.0) end
end

-- These are used for position on the screen
TREE_HEALTHTREE = 1
TREE_SPEEDTREE = 2
TREE_SUPPORTTREE = 3
TREE_BUILDINGTREE = 4
TREE_MELEETREE = 5
TREE_GUNTREE = 6
TREE_POINTS = 7
TREE_UNLOCKITEMS = 8
TREE_CUSTOMTREE = 9
TREE_CUSTOM_OLDSKILLS = 10
TREE_TECHNIC = 11

-- Dummy skill used for "connecting" to their trees.
SKILL_NONE = 0

--[[
SKILL_U_AMMOCRATE = 0 -- Unlock alternate arsenal crate that only sells cheap ammo (remove from regular?)
SKILL_U_DECOY = 0 -- "Unlock: Decoy", "Unlocks purchasing the Decoy\nZombies believe it is a human\nCan be destroyed\nExplodes when destroyed"

SKILL_OVERCHARGEFLASHLIGHT = 0 -- Your flashlight now produces a blinding flash that stuns zombies\nYour flashlight now breaks after one use

Unlock: Explosive body armor - Allows you to purchase explosive body armor, which knocks back both you and nearby zombies when you fall below 25 hp.
Olympian - +50% throw power\nsomething bad
Unlock: Antidote Medic Gun - Unlocks purchasing the Antidote Medic Gun\nTarget poison damage resistance +100%\nTarget immediately cleansed of all debuffs\nTarget is no longer healed or hastened
]]

-- unimplemented

SKILL_SPEED1 = 1
SKILL_SPEED2 = 2
SKILL_SPEED3 = 3
SKILL_SPEED4 = 4
SKILL_SPEED5 = 5
SKILL_BACKPEDDLER = 18
SKILL_LOADEDHULL = 20
SKILL_REINFORCEDHULL = 21
SKILL_REINFORCEDBLADES = 22
SKILL_AVIATOR = 23
SKILL_U_BLASTTURRET = 24
SKILL_TWINVOLLEY = 26
SKILL_TURRETOVERLOAD = 27
SKILL_LIGHTCONSTRUCT = 34
SKILL_QUICKDRAW = 39
SKILL_QUICKRELOAD = 41
SKILL_VITALITY2 = 45
SKILL_BARRICADEEXPERT = 77
SKILL_BATTLER1 = 48
SKILL_BATTLER2 = 49
SKILL_BATTLER3 = 50
SKILL_BATTLER4 = 51
SKILL_BATTLER5 = 52
SKILL_HEAVYSTRIKES = 53
SKILL_COMBOKNUCKLE = 62
SKILL_U_CRAFTINGPACK = 64
SKILL_JOUSTER = 65
SKILL_SCAVENGER = 67
SKILL_U_ZAPPER_ARC = 68
SKILL_ULTRANIMBLE = 70
SKILL_U_MEDICCLOUD = 72
SKILL_SMARTTARGETING = 73
SKILL_GOURMET = 76
SKILL_BLOODARMOR = 79
SKILL_REGENERATOR = 80
SKILL_SAFEFALL = 83
SKILL_VITALITY3 = 84
SKILL_TANKER = 86
SKILL_U_CORRUPTEDFRAGMENT = 87
SKILL_WORTHINESS3 = 78
SKILL_WORTHINESS4 = 88
SKILL_FOCUS = 40
SKILL_WORTHINESS1 = 42
SKILL_WORTHINESS2 = 43
SKILL_WOOISM = 46
SKILL_U_DRONE = 28
SKILL_U_NANITECLOUD = 29
SKILL_STOIC1 = 6
SKILL_STOIC2 = 7
SKILL_STOIC3 = 8
SKILL_STOIC4 = 9
SKILL_STOIC5 = 10
SKILL_SURGEON1 = 11
SKILL_SURGEON2 = 12
SKILL_SURGEON3 = 13
SKILL_HANDY1 = 14
SKILL_HANDY2 = 15
SKILL_HANDY3 = 16
SKILL_MOTIONI = 17
SKILL_PHASER = 19
SKILL_TURRETLOCK = 25
SKILL_HAMMERDISCIPLINE = 30
SKILL_FIELDAMP = 31
SKILL_U_ROLLERMINE = 32
SKILL_HAULMODULE = 33
SKILL_TRIGGER_DISCIPLINE1 = 35
SKILL_TRIGGER_DISCIPLINE2 = 36
SKILL_TRIGGER_DISCIPLINE3 = 37
SKILL_EGOCENTRIC = 44
SKILL_LASTSTAND = 54
SKILL_GLASSWEAPONS = 56
SKILL_CANNONBALL = 57
SKILL_CHEAPKNUCKLE = 59
SKILL_CRITICALKNUCKLE = 60
SKILL_KNUCKLEMASTER = 61
SKILL_VITALITY1 = 66
SKILL_TAUT = 69
SKILL_INSIGHT = 74
SKILL_GLUTTON = 75
SKILL_PREPAREDNESS = 82
SKILL_FORAGER = 89
SKILL_LANKY = 90
SKILL_PITCHER = 91
SKILL_BLASTPROOF = 92
SKILL_MASTERCHEF = 93
SKILL_SUGARRUSH = 94
SKILL_U_STRENGTHSHOT = 95
SKILL_STABLEHULL = 96
SKILL_LIGHTWEIGHT = 97
SKILL_AGILEI = 98
SKILL_U_CRYGASGREN = 99
SKILL_SOFTDET = 100
SKILL_STOCKPILE = 101
SKILL_ACUITY = 102
SKILL_VISION = 103
SKILL_U_ROCKETTURRET = 104
SKILL_RECLAIMSOL = 105
SKILL_ORPHICFOCUS = 106
SKILL_IRONBLOOD = 107
SKILL_BLOODLETTER = 108
SKILL_HAEMOSTASIS = 109
SKILL_SLEIGHTOFHAND = 110
SKILL_AGILEII = 111
SKILL_AGILEIII = 112
SKILL_BIOLOGYI = 113
SKILL_BIOLOGYII = 114
SKILL_BIOLOGYIII = 115
SKILL_FOCUSII = 116
SKILL_FOCUSIII = 117
SKILL_EQUIPPED = 118
SKILL_SURESTEP = 119
SKILL_INTREPID = 120
SKILL_CARDIOTONIC = 5000
SKILL_BLOODLUST = 122
SKILL_SCOURER = 123
SKILL_LANKYII = 124
SKILL_U_ANTITODESHOT = 125
SKILL_DISPERSION = 126
SKILL_MOTIONII = 127
SKILL_MOTIONIII = 128
SKILL_BRASH = 130
SKILL_CONEFFECT = 131
SKILL_CIRCULATION = 132
SKILL_SANGUINE = 133
SKILL_SANGUINE1 = 134
SKILL_ANTIGEN = 135
SKILL_INSTRUMENTS = 136
SKILL_HANDY4 = 137
SKILL_HANDY5 = 138
SKILL_TECHNICIAN = 139
SKILL_BIOLOGYIV = 140
SKILL_SURGEONIV = 141
SKILL_DELIBRATION = 142
SKILL_DRIFT = 143
SKILL_WARP = 144
SKILL_LEVELHEADED = 145
SKILL_ROBUST = 146
SKILL_STOWAGE = 147
SKILL_TRUEWOOISM = 148
SKILL_UNBOUND = 149
SKILL_HAMMERDISCIPLINE2 = 150
SKILL_HAMMERDISCIPLINE3 = 151
SKILL_U_HAMMER = 152
SKILL_REINFORCEDMANHACK = 153
SKILL_BIOLOGYV = 154
SKILL_BIOLOGYVI = 155




-- Custom Skills
SKILL_CUSTOM_UNLOCKER1 = 156
SKILL_CUSTOM_UNLOCKER2 = 196
SKILL_CUSTOM_UNLOCKER3 = 200
SKILL_CUSTOM_MELEE1 = 157
SKILL_CUSTOM_MELEE2 = 158
SKILL_CUSTOM_MELEE3 = 159
SKILL_CUSTOM_MELEE4 = 160
SKILL_CUSTOM_MELEE5 = 173
SKILL_CUSTOM_MELEE6 = 268
SKILL_CUSTOM_MELEE7 = 269
SKILL_CUSTOM_MELEE8 = 270
SKILL_CUSTOM_SPEED1 = 161
SKILL_CUSTOM_SPEED2 = 162
SKILL_CUSTOM_SPEED3 = 163
SKILL_CUSTOM_SPEED4 = 164
SKILL_CUSTOM_HEALTH1 = 165
SKILL_CUSTOM_HEALTH2 = 166
SKILL_CUSTOM_HEALTH3 = 167
SKILL_CUSTOM_HEALTH4 = 168
SKILL_CUSTOM_BLOODARMOR1 = 169
SKILL_CUSTOM_BLOODARMOR2 = 170
SKILL_CUSTOM_BLOODARMOR3 = 171
SKILL_CUSTOM_BLOODARMOR4 = 172
SKILL_CUSTOM_BLOODARMOR5 = 173
SKILL_CUSTOM_BLOODMELEE1 = 174
SKILL_CUSTOM_BLOODMELEE2 = 197
SKILL_CUSTOM_BLOODMELEE3 = 198
SKILL_CUSTOM_BLOODMELEE4 = 199
SKILL_CUSTOM_MELEE_UNLOCKER1 = 201
SKILL_CUSTOM_SMALL_COMBO_FISTS = 202




SKILL_CUSTOM_POINTS1 = 176
SKILL_CUSTOM_POINTS2 = 177
SKILL_CUSTOM_POINTS3 = 178
SKILL_CUSTOM_POINTS4 = 179
SKILL_CUSTOM_POINTS5 = 180
SKILL_CUSTOM_POINTS6 = 181
SKILL_CUSTOM_POINTS7 = 182
SKILL_CUSTOM_POINTS8 = 183
SKILL_CUSTOM_POINTS9 = 184
SKILL_CUSTOM_POINTS10 = 185
SKILL_CUSTOM_POINTS11 = 324
SKILL_CUSTOM_POINTS12 = 325
SKILL_CUSTOM_POINTS13 = 326
SKILL_CUSTOM_POINTS14 = 327
SKILL_CUSTOM_SCRAP1 = 186
SKILL_CUSTOM_SCRAP2 = 187
SKILL_CUSTOM_SCRAP3 = 188
SKILL_CUSTOM_SCRAP4 = 189
SKILL_CUSTOM_WORTH1 = 190
SKILL_CUSTOM_WORTH2 = 191
SKILL_CUSTOM_WORTH3 = 192
SKILL_CUSTOM_WORTH4 = 193
SKILL_CUSTOM_WORTH5 = 254
SKILL_CUSTOM_DISCOUNTER1 = 194
SKILL_CUSTOM_DISCOUNTER2 = 195
SKILL_CUSTOM_DISCOUNTER3 = 255




-- EndLine

-- Lock Items
SKILL_U_ULTRA_FISTS 		= 220
SKILL_U_ULTRA_TURRET 		= 221
SKILL_U_REMANTLER 			= 231
SKILL_U_ARSENALCRATE		= 256
SKILL_U_RESUPPLYBOX			= 257
SKILL_U_HAMMERUPGRADE		= 258
SKILL_U_DOOMSTICK 			= 225
SKILL_U_BULLETSTORM_MACHINE	= 291
SKILL_U_OMEGA_BULLETSTORM	= 292
SKILL_U_SCARY_RIFLE			= 293
SKILL_U_OMEGA_SCARY_RIFLE	= 294
SKILL_U_AR_DISCOUNT_TRINKET	= 299
SKILL_U_ULTRA_ZAPPER_ARC = 330
SKILL_U_OMEGA_ULTRA_ZAPPER_ARC = 333
SKILL_U_HEALSTATION_FIELD = 331
SKILL_U_DEADLY_OMEGA_SCARY_RIFLE = 334
SKILL_U_BULLETSTORM_AK47 = 335
SKILL_U_SUPER_SCYTHE = 336
SKILL_U_DEADLY_MINIGUN = 337
SKILL_U_OMEGA_ULTRA_FISTS = 344
SKILL_U_MELEE_FISTS_UNLOCKER = 346
SKILL_U_GUNTURRET_BOOMSTICK_UNLOCKER = 347
SKILL_U_GUNTURRET_DOOMSTICK_UNLOCKER = 348


--OLD CUSTOM POINTS
SKILL_SPEEDIE1 = 203
SKILL_SPEEDIE2 = 204
SKILL_SPEEDIE3 = 205
SKILL_SPEEDIE4 = 206
SKILL_MELEE_POWER = 207
SKILL_MELEE_DEFENSE1 = 208
SKILL_MELEE_DEFENSE2 = 209
SKILL_MELEE_DEFENSE3 = 210
SKILL_JUMP_BOOST = 211
SKILL_BLOOD_ARMOR1 = 212
SKILL_BLOOD_ARMOR2 = 213
SKILL_BLOOD_ARMOR3 = 214
SKILL_BLOOD_ARMOR4 = 215
SKILL_BLOOD_ARMOR5 = 259
SKILL_BLOOD_ARMOR6 = 260
SKILL_MELEE_POWER2 = 216
SKILL_MELEE_POWER3 = 217
SKILL_ARSENAL_DISCOUNT1 = 218
SKILL_ARSENAL_DISCOUNT2 = 219
SKILL_ARSENAL_DISCOUNT3 = 266
SKILL_JUMP_BOOST2 			= 222
SKILL_ULTRA_JUGGERNAUT 		= 223
SKILL_WORTH_START 			= 224
SKILL_DEPLOYMENT_HEALTH 	= 226
SKILL_DEPLOYMENT_PACKDELAY 	= 227
SKILL_MEDIC_DELAY 			= 228
SKILL_WAVE_POINTS 			= 229
SKILL_SURVIVOR 				= 230
SKILL_SURVIVOR2 			= 232
SKILL_SURVIVOR3 			= 267
SKILL_SURVIVOR4 			= 265
SKILL_SMALL_BLOODARMOR1 	= 233
SKILL_SMALL_BLOODARMOR2 	= 234
SKILL_SMALL_BLOODARMOR3 	= 235
SKILL_SMALL_BLOODARMOR4 	= 236
SKILL_SMALL_BLOODARMOR5 	= 237
SKILL_SMALL_REPAIR1 		= 238
SKILL_SMALL_REPAIR2 		= 239
SKILL_SMALL_REPAIR3 		= 261
SKILL_SMALL_REPAIR4 		= 262
SKILL_SMALL_REPAIR5 		= 263
SKILL_SMALL_REPAIR6 		= 264
SKILL_SMALL_BLOODARMOR6 	= 240 
SKILL_COMBO_FISTS 			= 241
SKILL_MELEE_DELAY_MEDIUM 	= 242
SKILL_MELEE_KNOCKBACK_MEDIUM = 243
SKILL_MELEE_RANGE_MEDIUM 	= 244
SKILL_TURRET_RANGE_OVERLOAD = 245
SKILL_MEDIUM_JUMP_BOOST 	= 246
SKILL_SMALL_POINT_MULTIPLIER = 247
SKILL_MEDIUM_DEPLOYMENT_HEALTH = 248
SKILL_RESUPPLY_DISCOUNT_DELAY1 = 249
SKILL_RESUPPLY_DISCOUNT_DELAY2 = 250
SKILL_RESUPPLY_DISCOUNT_DELAY3 = 251
SKILL_RESUPPLY_DISCOUNT_DELAY4 = 253
SKILL_MEDIUM_COMBO_FISTS = 252
SKILL_JUGGERNAUT = 332

--ENDLINE

-- TECHNICTREE
SKILL_HAMMER_REPAIR1 = 271
SKILL_HAMMER_REPAIR2 = 272
SKILL_HAMMER_REPAIR3 = 273
SKILL_HAMMER_REPAIR4 = 274
SKILL_PACK_DELAY = 275
SKILL_TINY_TURRET_UNLOCK = 276
SKILL_ULTRA_REPAIR_EMITTER = 289
SKILL_HAULMODULE_HEAVIER = 290
SKILL_SMALL_TURRET_SCANSPEED1 = 287
SKILL_SMALL_TURRET_SCANSPEED2 = 288

--ENDLINE


--STARTING Tree
SKILL_SMALL_HEALTH1 = 277
SKILL_SMALL_HEALTH2 = 278
SKILL_SMALL_HEALTH3 = 279
SKILL_SMALL_HEALTH4 = 280
SKILL_SMALL_SPEED1 = 281
SKILL_SMALL_SPEED2 = 282
SKILL_SMALL_SPEED3 = 283
SKILL_SMALL_MELEE_DMG1 = 284
SKILL_SMALL_MELEE_DMG2 = 285
SKILL_SMALL_MELEE_DELAY1 = 286

--ENDLINE 

SKILLMOD_HEALTH = 1
SKILLMOD_SPEED = 2
SKILLMOD_WORTH = 3
SKILLMOD_FALLDAMAGE_THRESHOLD_MUL = 4
SKILLMOD_FALLDAMAGE_RECOVERY_MUL = 5
SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL = 6
SKILLMOD_FOODRECOVERY_MUL = 7
SKILLMOD_FOODEATTIME_MUL = 8
SKILLMOD_JUMPPOWER_MUL = 9
SKILLMOD_RELOADSPEED_MUL = 11
SKILLMOD_DEPLOYSPEED_MUL = 12
SKILLMOD_UNARMED_DAMAGE_MUL = 13
SKILLMOD_UNARMED_SWING_DELAY_MUL = 14
SKILLMOD_MELEE_DAMAGE_MUL = 15
SKILLMOD_HAMMER_SWING_DELAY_MUL = 16
SKILLMOD_CONTROLLABLE_SPEED_MUL = 17
SKILLMOD_CONTROLLABLE_HANDLING_MUL = 18
SKILLMOD_CONTROLLABLE_HEALTH_MUL = 19
SKILLMOD_MANHACK_DAMAGE_MUL = 20
SKILLMOD_BARRICADE_PHASE_SPEED_MUL = 21
SKILLMOD_MEDKIT_COOLDOWN_MUL = 22
SKILLMOD_MEDKIT_EFFECTIVENESS_MUL = 23
SKILLMOD_REPAIRRATE_MUL = 24
SKILLMOD_TURRET_HEALTH_MUL = 25
SKILLMOD_TURRET_SCANSPEED_MUL = 26
SKILLMOD_TURRET_SCANANGLE_MUL = 27
SKILLMOD_BLOODARMOR = 28
SKILLMOD_MELEE_KNOCKBACK_MUL = 29
SKILLMOD_SELF_DAMAGE_MUL = 30
SKILLMOD_AIMSPREAD_MUL = 31
SKILLMOD_POINTS = 32
SKILLMOD_POINT_MULTIPLIER = 33
SKILLMOD_FALLDAMAGE_DAMAGE_MUL = 34
SKILLMOD_MANHACK_HEALTH_MUL = 35
SKILLMOD_DEPLOYABLE_HEALTH_MUL = 36
SKILLMOD_DEPLOYABLE_PACKTIME_MUL = 37
SKILLMOD_DRONE_SPEED_MUL = 38
SKILLMOD_DRONE_CARRYMASS_MUL = 39
SKILLMOD_MEDGUN_FIRE_DELAY_MUL = 40
SKILLMOD_RESUPPLY_DELAY_MUL = 41
SKILLMOD_FIELD_RANGE_MUL = 42
SKILLMOD_FIELD_DELAY_MUL = 43
SKILLMOD_DRONE_GUN_RANGE_MUL = 44
SKILLMOD_HEALING_RECEIVED = 45
SKILLMOD_RELOADSPEED_PISTOL_MUL = 46
SKILLMOD_RELOADSPEED_SMG_MUL = 47
SKILLMOD_RELOADSPEED_ASSAULT_MUL = 48
SKILLMOD_RELOADSPEED_SHELL_MUL = 49
SKILLMOD_RELOADSPEED_RIFLE_MUL = 50
SKILLMOD_RELOADSPEED_XBOW_MUL = 51
SKILLMOD_RELOADSPEED_PULSE_MUL = 52
SKILLMOD_RELOADSPEED_EXP_MUL = 53
SKILLMOD_MELEE_ATTACKER_DMG_REFLECT = 54
SKILLMOD_PULSE_WEAPON_SLOW_MUL = 55
SKILLMOD_MELEE_DAMAGE_TAKEN_MUL = 56
SKILLMOD_POISON_DAMAGE_TAKEN_MUL = 57
SKILLMOD_BLEED_DAMAGE_TAKEN_MUL = 58
SKILLMOD_MELEE_SWING_DELAY_MUL = 59
SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL = 60
SKILLMOD_MELEE_MOVEMENTSPEED_ON_KILL = 61
SKILLMOD_MELEE_POWERATTACK_MUL = 62
SKILLMOD_KNOCKDOWN_RECOVERY_MUL = 63
SKILLMOD_MELEE_RANGE_MUL = 64
SKILLMOD_SLOW_EFF_TAKEN_MUL = 65
SKILLMOD_EXP_DAMAGE_TAKEN_MUL = 66
SKILLMOD_FIRE_DAMAGE_TAKEN_MUL = 67
SKILLMOD_PROP_CARRY_CAPACITY_MUL = 68
SKILLMOD_PROP_THROW_STRENGTH_MUL = 69
SKILLMOD_PHYSICS_DAMAGE_TAKEN_MUL = 70
SKILLMOD_VISION_ALTER_DURATION_MUL = 71
SKILLMOD_DIMVISION_EFF_MUL = 72
SKILLMOD_PROP_CARRY_SLOW_MUL = 73
SKILLMOD_BLEED_SPEED_MUL = 74
SKILLMOD_MELEE_LEG_DAMAGE_ADD = 75
SKILLMOD_SIGIL_TELEPORT_MUL = 76
SKILLMOD_MELEE_ATTACKER_DMG_REFLECT_PERCENT = 77
SKILLMOD_POISON_SPEED_MUL = 78
SKILLMOD_PROJECTILE_DAMAGE_TAKEN_MUL = 79
SKILLMOD_EXP_DAMAGE_RADIUS = 80
SKILLMOD_MEDGUN_RELOAD_SPEED_MUL = 81
SKILLMOD_WEAPON_WEIGHT_SLOW_MUL = 82
SKILLMOD_FRIGHT_DURATION_MUL = 83
SKILLMOD_IRONSIGHT_EFF_MUL = 84
SKILLMOD_BLOODARMOR_DMG_REDUCTION = 85
SKILLMOD_BLOODARMOR_MUL = 86
SKILLMOD_BLOODARMOR_GAIN_MUL = 87
SKILLMOD_LOW_HEALTH_SLOW_MUL = 88
SKILLMOD_PROJ_SPEED = 89
SKILLMOD_SCRAP_START = 90
SKILLMOD_ENDWAVE_POINTS = 91
SKILLMOD_ARSENAL_DISCOUNT = 92
SKILLMOD_CLOUD_RADIUS = 93
SKILLMOD_CLOUD_TIME = 94
SKILLMOD_PROJECTILE_DAMAGE_MUL = 95
SKILLMOD_EXP_DAMAGE_MUL = 96
SKILLMOD_TURRET_RANGE_MUL = 97
SKILLMOD_AIM_SHAKE_MUL = 98
SKILLMOD_MEDDART_EFFECTIVENESS_MUL = 99

local GOOD = "^"..COLORID_GREEN
local BAD = "^"..COLORID_RED

--TechnicTree--
GM:AddSkill(SKILL_HAMMER_REPAIR1, "Hammer Repair I", GOOD.."+0.15 Repair Rate\n",
																4,			2,					{SKILL_NONE, SKILL_HAMMER_REPAIR2}, TREE_TECHNIC)
GM:AddSkill(SKILL_HAMMER_REPAIR2, "Hammer Repair II", GOOD.."+0.20 Repair Rate\n",
																4,			3,					{SKILL_HAMMER_REPAIR3}, TREE_TECHNIC)
GM:AddSkill(SKILL_HAMMER_REPAIR3, "Hammer Repair III", GOOD.."+0.30 Repair Rate\n",
																4,			4,					{SKILL_HAMMER_REPAIR4}, TREE_TECHNIC)
GM:AddSkill(SKILL_HAMMER_REPAIR4, "Hammer Repair IV", GOOD.."+0.48 Repair Rate\n",
																4,			5,					{}, TREE_TECHNIC)
GM:AddSkill(SKILL_PACK_DELAY, "Pack Delay", GOOD.."+8% More packing speed\n",
																6,			6,					{SKILL_NONE}, TREE_TECHNIC)
GM:AddSkill(SKILL_TINY_TURRET_UNLOCK, "Tiny Turret Unlock", "Unlocks Tiny Turret from Arsenalcrate.\n",
																-2,			3.5,					{SKILL_NONE}, TREE_TECHNIC)
.AlwaysActive = true
GM:AddSkill(SKILL_ULTRA_REPAIR_EMITTER, "Ultra RepairField Unlock", "Unlocks from Arsenalcrate.\n",
																-2,			4.5,					{SKILL_NONE}, TREE_TECHNIC)
.AlwaysActive = true
GM:AddSkill(SKILL_HAULMODULE_HEAVIER, "Heavier Drone Unlock", "Unlocks from Arsenalcrate.\n",
																-2,			5.5,					{SKILL_NONE}, TREE_TECHNIC)
.AlwaysActive = true
GM:AddSkill(SKILL_SMALL_TURRET_SCANSPEED1, "Small Turret Damage I", GOOD.."+3 Turret ScanSpeed\n",
																8,			1,					{SKILL_NONE, SKILL_SMALL_TURRET_SCANSPEED2}, TREE_TECHNIC)
GM:AddSkill(SKILL_SMALL_TURRET_SCANSPEED2, "Small Turret Damage II", GOOD.."+7 Turret ScanSpeed\n",
																8,			2,					{}, TREE_TECHNIC)


--EndLine

-- Lock Tiers Area
.AlwaysActive = true
--EndLine

--Tier Area Unlockers

--EndLine

GM:AddSkill(SKILL_U_ULTRA_ZAPPER_ARC, "Unlock: Ultra Zapper Arc", 	GOOD.."Unlocks Ultra Zapper Arc",
																4,			0,					{SKILL_NONE}, TREE_UNLOCKITEMS)
.AlwaysActive = true
GM:AddSkill(SKILL_U_OMEGA_ULTRA_ZAPPER_ARC, "Unlock: Omega Ultra Zapper Arc", 	GOOD.."Unlocks Omega Ultra Zapper Arc",
																4,			2,				{SKILL_NONE}, TREE_UNLOCKITEMS)
.AlwaysActive = true
GM:AddSkill(SKILL_U_HEALSTATION_FIELD, "Unlock: HealStation Field", 	GOOD.."Unlocks HealStation Field",
																0,			0,					{SKILL_NONE}, TREE_UNLOCKITEMS)
.AlwaysActive = true
GM:AddSkill(SKILL_U_GUNTURRET_BOOMSTICK_UNLOCKER, "Unlock: Boomstick GunTurret", 	GOOD.."Unlocks Boomstick GunTurret",
																6,			-2,					{SKILL_NONE}, TREE_UNLOCKITEMS)
.AlwaysActive = true
GM:AddSkill(SKILL_U_GUNTURRET_DOOMSTICK_UNLOCKER, "Unlock: Doomstick GunTurret", 	GOOD.."Unlocks Doomstick GunTurret",
																6,			0,					{SKILL_U_GUNTURRET_BOOMSTICK_UNLOCKER}, TREE_UNLOCKITEMS)
.AlwaysActive = true
--EndLine

--Starting Tree



--EndLine
-- Melee Unlock
GM:AddSkill(SKILL_U_ULTRA_FISTS, "Unlock: Ultra Overpowered Fist", 	GOOD.."Unlocks purchasing the Ultra Overpowered Fist (Under heavy development)",
																8.5,			4.5,					{}, TREE_MELEETREE)
.AlwaysActive = true
GM:AddSkill(SKILL_U_OMEGA_ULTRA_FISTS, "Unlock: Omega Ultra Overpowered Fist", 	GOOD.."Unlocks purchasing the Omega Ultra Overpowered Fist (Under heavy development)",
																9.5,			4.5,					{}, TREE_MELEETREE)
.AlwaysActive = true
GM:AddSkill(SKILL_U_SUPER_SCYTHE, "Unlock: Super Scythe", 	GOOD.."Unlocks purchasing the Super Scythe",
																2.65,			3.845,					{}, TREE_MELEETREE)
.AlwaysActive = true
GM:AddSkill(SKILL_U_MELEE_FISTS_UNLOCKER, "Unlock: Fists Melee", 	GOOD.."Unlocks purchasing all the Fist Melee.",
																12,			7.5,					{}, TREE_MELEETREE)
.AlwaysActive = true
--EndLine

-- CustomTree--
GM:AddSkill(SKILL_CUSTOM_HEALTH1, "Health I", GOOD.."+3 maximum health\n",
																0,			-3,					{SKILL_NONE, SKILL_CUSTOM_HEALTH2}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_HEALTH2, "Health II", GOOD.."+6 maximum health\n",
																0,			-2,					{SKILL_CUSTOM_HEALTH3}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_HEALTH3, "Health III", GOOD.."+12 maximum health\n",
																0,			-1,					{SKILL_CUSTOM_HEALTH4}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_HEALTH4, "Health IV", GOOD.."+20 maximum health\n",
																0,			-0,					{}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_SPEED1, "Speed I", GOOD.."+3 more speed\n",
																2,			-3,					{SKILL_NONE, SKILL_CUSTOM_SPEED2}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_SPEED2, "Speed II", GOOD.."+5 more speed\n",
																2,			-2,					{SKILL_CUSTOM_SPEED3}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_SPEED3, "Speed III", GOOD.."+7 more speed\n",
																2,			-1,					{SKILL_CUSTOM_SPEED4}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_SPEED4, "Speed IV", GOOD.."+15 more speed\n",
																2,			-0,					{}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_MELEE1, "Melee I", GOOD.."+%2 more damage\n",
																7,			-3,					{SKILL_NONE, SKILL_CUSTOM_MELEE2}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_MELEE2, "Melee II", GOOD.."+%2 more damage\n",
																7,			-2,					{SKILL_CUSTOM_MELEE3}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_MELEE3, "Melee III", GOOD.."+%2 more damage\n",
																7,			-1,					{SKILL_CUSTOM_MELEE4}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_MELEE4, "Melee IV", GOOD.."+%2 more damage\n",
																7,			-0,					{SKILL_CUSTOM_MELEE5}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_MELEE5, "Melee V", GOOD.."+%5 more damage\n",
																7,			1,					{SKILL_CUSTOM_BLOODMELEE1}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_MELEE6, "Melee VI", GOOD.."+%5 more damage\n",
																6,			6,					{SKILL_CUSTOM_MELEE7}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_MELEE7, "Melee VII", GOOD.."+%5 more damage\n",
																5,			6,					{SKILL_CUSTOM_MELEE8}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_MELEE8, "Melee VIII", GOOD.."+%12 more damage\n",
																4,			6,					{}, TREE_CUSTOMTREE)																
GM:AddSkill(SKILL_CUSTOM_BLOODARMOR1, "BloodArmor I", GOOD.."+3 Maximum BloodArmor\n",
																9,			-3,					{SKILL_NONE, SKILL_CUSTOM_BLOODARMOR2}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_BLOODARMOR2, "BloodArmor II", GOOD.."+5 Maximum BloodArmor\n",
																9,			-2,					{SKILL_CUSTOM_BLOODARMOR3}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_BLOODARMOR3, "BloodArmor III", GOOD.."+8 Maximum BloodArmor\n",
																9,			-1,					{SKILL_CUSTOM_BLOODARMOR4}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_BLOODARMOR4, "BloodArmor IV", GOOD.."+12 Maximum BloodArmor\n",
																9,			-0,					{SKILL_CUSTOM_BLOODARMOR5}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_BLOODARMOR5, "BloodArmor V", GOOD.."+14 Maximum BloodArmor\n",
																9,			1,					{SKILL_CUSTOM_BLOODMELEE1}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_BLOODMELEE1, "BloodMelee I", GOOD.."+3 Maximum BloodArmor\n"..GOOD.."+6% more melee damage\n",
																8,			2,					{SKILL_CUSTOM_BLOODMELEE2}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_BLOODMELEE2, "BloodMelee II", GOOD.."+4 Maximum BloodArmor\n"..GOOD.."+9% more melee damage\n",
																8,			3,					{SKILL_CUSTOM_BLOODMELEE3}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_BLOODMELEE3, "BloodMelee III", GOOD.."+6 Maximum BloodArmor\n"..GOOD.."+10% more melee damage\n",
																8,			4,					{SKILL_CUSTOM_BLOODMELEE4}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_BLOODMELEE4, "BloodMelee IV", GOOD.."+7 Maximum BloodArmor\n"..GOOD.."+12% more melee damage\n",
																8,			5,					{SKILL_CUSTOM_MELEE_UNLOCKER1}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_MELEE_UNLOCKER1, "Melee Unlocker I", "You need to unlock this first.\nIn order to proceed to all the other skills up ahead.\n",
																8,			6,					{SKILL_CUSTOM_SMALL_COMBO_FISTS,SKILL_CUSTOM_MELEE6}, TREE_CUSTOMTREE)
GM:AddSkill(SKILL_CUSTOM_SMALL_COMBO_FISTS, "Small Combo Fists", GOOD.."-15% Fire Delay using fists\n"..GOOD.."+25% more damage using fists\n",
																8,			7,					{}, TREE_CUSTOMTREE)
-- EndLine
-- OP Skills Add																
GM:AddSkill(SKILL_JUGGERNAUT, "Juggernaut", GOOD.."When below 20% of health you take 60% less damage from zombie's \n"..GOOD.."(DOES NOT EFFECT CHEM'S DAMAGE)",
																-10.35,			7.5,		{}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_SPEEDIE1, "Speedie I", GOOD.."+6 movement speed",
																6,			9,				{SKILL_MELEE_DEFENSE1, SKILL_SPEEDIE2 }, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_SPEEDIE2, "Speedie II", GOOD.."+10 movement speed",
																6,			10,				{SKILL_SPEEDIE3}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_SPEEDIE3, "Speedie III", GOOD.."+15 movement speed",
																7,			10,				{SKILL_SPEEDIE4}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_SPEEDIE4, "Speedie IIII", GOOD.."+20 movement speed",
																8,			10,				{}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_MELEE_DEFENSE1, "Melee Defense I", GOOD.."-1% DMG Taken From Zombies",
																4,		9,				{SKILL_MELEE_DEFENSE2}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_MELEE_DEFENSE2, "Melee Defense II", GOOD.."-5% DMG Taken From Zombies",
																4,		9.5,				{SKILL_MELEE_DEFENSE3}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_MELEE_DEFENSE3, "Melee Defense III", GOOD.."-9% DMG Taken From Zombies",
																5,		10,				{SKILL_BLOOD_ARMOR1}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_BLOOD_ARMOR1, "Blood Armor I", GOOD.."+20 More Maximum Blood Armor",
																4,		10,				{SKILL_BLOOD_ARMOR2}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_BLOOD_ARMOR2, "Blood Armor II", GOOD.."+25 More Maximum Blood Armor",
																3,		9,				{SKILL_BLOOD_ARMOR3, SKILL_JUMP_BOOST}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_BLOOD_ARMOR3, "Blood Armor III", GOOD.."+44 More Maximum Blood Armor",
																3,		10,				{SKILL_BLOOD_ARMOR4}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_BLOOD_ARMOR4, "Blood Armor IV", GOOD.."+90 More Maximum Blood Armor",
																4,		11,				{SKILL_BLOOD_ARMOR5}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_BLOOD_ARMOR5, "Blood Armor V", GOOD.."+35 More Maximum Blood Armor",
																4,		12,				{SKILL_BLOOD_ARMOR6}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_BLOOD_ARMOR6, "Blood Armor VI", GOOD.."+50 More Maximum Blood Armor",
																4,		13,				{}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_JUMP_BOOST, "Jump Boost", GOOD.."+5% More Jump Boost",
																2,		8,				{SKILL_JUMP_BOOST2}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_JUMP_BOOST2, "Jump Boost2", GOOD.."+25% More Jump Boost",
																2,		9,				{SKILL_WORTH_START}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_WORTH_START, "Worth Start", GOOD.."+65 More Worth",
																-1.4,		9,				{SKILL_U_DOOMSTICK, SKILL_MEDIC_DELAY, SKILL_DEPLOYMENT_HEALTH}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_U_DOOMSTICK, "Unlock: Doomstick", GOOD.."Unlocks purchasing the Doomstick from ArsenalCrate",
																-2.6,			9.7,					{}, TREE_CUSTOM_OLDSKILLS)
.AlwaysActive = true
GM:AddSkill(SKILL_MEDIC_DELAY, "Medic Delay", GOOD.."150% Medic Delay on MedicalKit",
																-3.2,			7.3,					{SKILL_SURVIVOR}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_DEPLOYMENT_HEALTH, "DeployMent Health", GOOD.."80% more health to deployment's",
																-3.2,			8.7,					{SKILL_DEPLOYMENT_PACKDELAY}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_DEPLOYMENT_PACKDELAY, "DeployMent Delay", GOOD.."-60% Delay packtime",
																-4.2,			8.7,					{}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_U_ULTRA_TURRET, "Unlock: Ultra Turret", 	GOOD.."Unlocks purchasing the Ultra Turret",
																6.5,			13.8,					{}, TREE_CUSTOM_OLDSKILLS)
.AlwaysActive = true
GM:AddSkill(SKILL_SURVIVOR, "Survivor I", 	GOOD.."+12 More Health",
																-4.2,			7.3,					{SKILL_SURVIVOR2}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_SURVIVOR2, "Survivor II", 	GOOD.."+17 More Health",
																-6.2,			6.4,					{SKILL_WAVE_POINTS, SKILL_SURVIVOR3}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_SURVIVOR3, "Survivor III", 	GOOD.."+20 More Health",
																-7.48,			6.6,					{SKILL_SURVIVOR4}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_SURVIVOR4, "Survivor IV", 	GOOD.."+40 More Health",
																-9.35,			6.4,					{SKILL_JUGGERNAUT}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_WAVE_POINTS, "Wave Points", 	GOOD.."Gives you +18 more points on wave ends",
																-7.2,			5.8,					{}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_U_REMANTLER, "Unlock: Remantler", 	GOOD.."Unlocks purchasing the Deployment Remantler",
																3,			0,					{SKILL_NONE}, TREE_CUSTOM_OLDSKILLS)
.AlwaysActive = true
GM:AddSkill(SKILL_U_ARSENALCRATE, "Unlock: ArsenalCrate", 	GOOD.."Unlocks purchasing the Deployment ArsenalCrate",
																1,			0,					{SKILL_NONE}, TREE_CUSTOM_OLDSKILLS)
.AlwaysActive = true
GM:AddSkill(SKILL_U_RESUPPLYBOX, "Unlock: ResupplyCrate", 	GOOD.."Unlocks purchasing the Deployment Resuppy Crate",
																2,			0,					{SKILL_NONE}, TREE_CUSTOM_OLDSKILLS)
.AlwaysActive = true
GM:AddSkill(SKILL_U_HAMMERUPGRADE, "Unlock: HammerUpgrade", GOOD.."Unlocks purchasing the Hammer Material",
																4,			2.5,				{SKILL_NONE}, TREE_CUSTOM_OLDSKILLS)
.AlwaysActive = true
GM:AddSkill(SKILL_MELEE_POWER, "Melee Power I", GOOD.."+10% melee damage",
																6,			8,					{SKILL_NONE, SKILL_MELEE_POWER2, SKILL_SPEEDIE1}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_MELEE_POWER2, "Melee Power II", GOOD.."+15% melee damage",
																6.5,			8.5,					{SKILL_MELEE_POWER3}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_MELEE_POWER3, "Melee Power III", GOOD.."+30% melee damage",
																6.5,			11.5,					{SKILL_U_ULTRA_TURRET}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_ARSENAL_DISCOUNT1, "Arsenal Discount I", GOOD.."-0.03 Weapon Cost",
																8.5,			13.5,					{SKILL_ARSENAL_DISCOUNT2}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_ARSENAL_DISCOUNT2, "Arsenal Discount II", GOOD.."-0.08 Weapon Cost",
																8.8,			12.8,					{SKILL_ARSENAL_DISCOUNT3}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_ARSENAL_DISCOUNT3, "Arsenal Discount III", GOOD.."-0.13 Weapon Cost",
																8.25,			11.45,					{}, TREE_CUSTOM_OLDSKILLS)
-- Armor Skill Tree
GM:AddSkill(SKILL_SMALL_BLOODARMOR1, "Small Blood Armor I", GOOD.."+5 More Maximum Blood Armor",
																-12,		-7,				{SKILL_NONE, SKILL_SMALL_BLOODARMOR2}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_SMALL_BLOODARMOR2, "Small Blood Armor II", GOOD.."+8 More Maximum Blood Armor",
																-11,		-7,				{SKILL_SMALL_BLOODARMOR3}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_SMALL_BLOODARMOR3, "Small Blood Armor III", GOOD.."+12 More Maximum Blood Armor",
																-10,		-7,				{SKILL_SMALL_BLOODARMOR4}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_SMALL_BLOODARMOR4, "Small Blood Armor IIII", GOOD.."+25 More Maximum Blood Armor",
																-9,		-7,				{SKILL_SMALL_BLOODARMOR5}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_SMALL_BLOODARMOR5, "Small Blood Armor V", GOOD.."+45 More Maximum Blood Armor",
																-8,		-7,				{SKILL_SMALL_BLOODARMOR6}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_SMALL_BLOODARMOR6, "Small Blood Armor VI", GOOD.."+75 More Maximum Blood Armor",
																-7,		-6.5,				{}, TREE_CUSTOM_OLDSKILLS)
-- End Line

-- Medium Support Skill Tree
GM:AddSkill(SKILL_RESUPPLY_DISCOUNT_DELAY1, "Resupply Discount Delay I", GOOD.."-2% Resupply Delay",
																0,		-4.5,				{SKILL_NONE, SKILL_RESUPPLY_DISCOUNT_DELAY2}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_RESUPPLY_DISCOUNT_DELAY2, "Resupply Discount Delay II", GOOD.."-7% Resupply Delay",
																1,		-4.5,				{SKILL_RESUPPLY_DISCOUNT_DELAY3}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_RESUPPLY_DISCOUNT_DELAY3, "Resupply Discount Delay III", GOOD.."-11% Resupply Delay",
																1,		-5.5,				{SKILL_SMALL_POINT_MULTIPLIER, SKILL_RESUPPLY_DISCOUNT_DELAY4, SKILL_MEDIUM_JUMP_BOOST}, TREE_CUSTOM_OLDSKILLS)--{SKILL_COMBO_FISTS,
GM:AddSkill(SKILL_RESUPPLY_DISCOUNT_DELAY4, "Resupply Discount Delay IV", GOOD.."-26% Resupply Delay",
																1,		-6.35,				{}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_SMALL_POINT_MULTIPLIER, 	"Point Multiplier", GOOD.."+9% More Points When Killing/Repairing.",
																2,		-4.5,				{SKILL_MEDIUM_DEPLOYMENT_HEALTH, SKILL_MELEE_KNOCKBACK_MEDIUM}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_MELEE_KNOCKBACK_MEDIUM, 	"Medium KnockBack Delay", GOOD.."+50% More KnockBack on zombies.",
																4,		-4.5,				{SKILL_MELEE_RANGE_MEDIUM, SKILL_MELEE_DELAY_MEDIUM}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_MELEE_RANGE_MEDIUM, 		"Medium Melee Range", GOOD.."+15% More Range using Melee's.",
																5,		-3.5,				{}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_MELEE_DELAY_MEDIUM, 		"Medium Melee Delay", GOOD.."-13% Melee Delay.",
																5,		-4.5,				{}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_MEDIUM_DEPLOYMENT_HEALTH, "Medium DeployMent Health", GOOD.."+150% More Health on DeployMents.",
																2.3,		-3.5,			{SKILL_COMBO_FISTS}, TREE_CUSTOM_OLDSKILLS)															
GM:AddSkill(SKILL_MEDIUM_JUMP_BOOST, 		"Medium JumpBoost", GOOD.."15% more JumpPower",
																2.6,		-5.8,			{SKILL_TURRET_RANGE_OVERLOAD}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_TURRET_RANGE_OVERLOAD, 	"TurretRange Overload", GOOD.."150% more TurretRange",
																3.4,		-5.5,				{}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_COMBO_FISTS, 				"Combo Fists", GOOD.."-36% Swing Delay\n"..GOOD.."+35% more damage using Fists",
															3.8,		-2.8,				{SKILL_MEDIUM_COMBO_FISTS}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_MEDIUM_COMBO_FISTS, 		"Medium Combo Fists", GOOD.."-36% Swing Delay\n"..GOOD.."+45% more damage using Fists",
															5.8,		-2.8,				{}, TREE_CUSTOM_OLDSKILLS)
-- End Line

-- Repair Cade Skill Tree
GM:AddSkill(SKILL_SMALL_REPAIR1, "Small Repair I", GOOD.."+5% More Repair",
																11,		-6,				{SKILL_NONE, SKILL_SMALL_REPAIR2}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_SMALL_REPAIR2, "Small Repair II", GOOD.."+11% More Repair",
																12,		-6,				{SKILL_SMALL_REPAIR3}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_SMALL_REPAIR3, "Small Repair III", GOOD.."+17% More Repair",
																13,		-6,				{SKILL_SMALL_REPAIR4}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_SMALL_REPAIR4, "Small Repair IV", GOOD.."+25% More Repair",
																14,		-6,				{SKILL_SMALL_REPAIR5}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_SMALL_REPAIR5, "Small Repair V", GOOD.."+38% More Repair",
																15,		-6,				{SKILL_SMALL_REPAIR6}, TREE_CUSTOM_OLDSKILLS)
GM:AddSkill(SKILL_SMALL_REPAIR6, "Small Repair VI", GOOD.."+58% More Repair",
																16,		-6,				{}, TREE_CUSTOM_OLDSKILLS)
-- End Line
-- Point Tree
GM:AddSkill(SKILL_CUSTOM_UNLOCKER1, "Skill Unlocker I", "You need to unlock this first.\nIn order to unlock all the other skills in here\n",
																0,			0,					{SKILL_NONE, SKILL_CUSTOM_POINTS1}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_POINTS1, "Point I", GOOD.."+2% more points given when killing zombies\n",
																0,			1,					{SKILL_CUSTOM_POINTS2}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_POINTS2, "Point II", GOOD.."+2% more points given when killing zombies\n",
																0,			2,					{SKILL_CUSTOM_POINTS3}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_POINTS3, "Point III", GOOD.."+4% more points given when killing zombies\n",
																0,			3,					{SKILL_CUSTOM_WORTH1, SKILL_CUSTOM_DISCOUNTER1, SKILL_CUSTOM_POINTS4}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_POINTS4, "Point IV", GOOD.."+4% more points given when killing zombies\n",
																0,			4,					{SKILL_CUSTOM_POINTS5}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_POINTS5, "Point V", GOOD.."+6% more points given when killing zombies\n",
																0,			5,					{SKILL_CUSTOM_POINTS6}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_POINTS6, "Point VI", GOOD.."+6% more points given when killing zombies\n",
																0,			6,					{SKILL_CUSTOM_UNLOCKER2, SKILL_CUSTOM_POINTS7}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_POINTS7, "Point VII", GOOD.."+6% more points given when killing zombies\n",
																-1,			6,					{SKILL_CUSTOM_POINTS8}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_POINTS8, "Point VIII", GOOD.."+8% more points given when killing zombies\n",
																-2,			6,					{SKILL_CUSTOM_POINTS9}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_POINTS9, "Point VIIII", GOOD.."+10% more points given when killing zombies\n",
																-3,			6,					{SKILL_CUSTOM_POINTS10}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_POINTS10, "Point X", GOOD.."+10% more points given when killing zombies\n",
																-4,			6,					{SKILL_CUSTOM_UNLOCKER3}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_POINTS11, "Point XI", GOOD.."+10% more points given when killing zombies\n",
																-7,			3.5,					{SKILL_CUSTOM_POINTS12}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_POINTS12, "Point XII", GOOD.."+10% more points given when killing zombies\n",
																-8,			3.5,					{SKILL_CUSTOM_POINTS13}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_POINTS13, "Point XIII", GOOD.."+20% more points given when killing zombies\n",
																-9,			3.5,					{SKILL_CUSTOM_POINTS14}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_POINTS14, "Point XIV", GOOD.."+100% more points given when killing zombies\n"..GOOD.."-10% Weapon Cost\n"..GOOD.."150+ WorthStart\n",
																-10,			3.5,					{}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_UNLOCKER2, "Skill Unlocker II", "You need to unlock this first.\nIn order to unlock all the other skills up ahead.\n",
																0,			8,					{SKILL_CUSTOM_SCRAP1, SKILL_CUSTOM_WORTH2, SKILL_CUSTOM_DISCOUNTER2}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_UNLOCKER3, "Skill Unlocker III", "You need to unlock this first.\nIn order to unlock all the other skills up ahead.\n",
																-6,			3.5,				{SKILL_CUSTOM_DISCOUNTER3,SKILL_CUSTOM_POINTS11}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_SCRAP1, "Scrap I", GOOD.."+12 Starting Scrap.\n",
																-1,			8,					{SKILL_CUSTOM_SCRAP2}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_SCRAP2, "Scrap II", GOOD.."+16 Starting Scrap.\n",
																-2,			8,					{SKILL_CUSTOM_SCRAP3}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_SCRAP3, "Scrap III", GOOD.."+20 Starting Scrap.\n",
																-3,			8,					{SKILL_CUSTOM_SCRAP4}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_SCRAP4, "Scrap IV", GOOD.."+32 Starting Scrap.\n",
																-4,			8,					{}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_WORTH1, "Worth I", GOOD.."+15 Starting Worth.\n",
																-1,		3,					{}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_WORTH2, "Worth II", GOOD.."+20 Starting Worth.\n",
																1,		8,					{SKILL_CUSTOM_WORTH3}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_WORTH3, "Worth III", GOOD.."+35 Starting Worth.\n",
																2,		8,					{SKILL_CUSTOM_WORTH4}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_WORTH4, "Worth IV", GOOD.."+50 Starting Worth.\n",
																3,		8,					{SKILL_CUSTOM_WORTH5}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_WORTH5, "Worth V", GOOD.."+75 Starting Worth.\n",
																4,		8,					{}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_DISCOUNTER1, "Discounter I", GOOD.."-2% Cost when buying from ArsenalCrate.\n",
																1,		3,					{}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_DISCOUNTER2, "Discounter II", GOOD.."-3% Cost when buying from ArsenalCrate.\n",
																0,		9,					{}, TREE_POINTS)
GM:AddSkill(SKILL_CUSTOM_DISCOUNTER3, "Discounter III", GOOD.."-8% Cost when buying from ArsenalCrate.\n",
																-7,		4,					{}, TREE_POINTS)
-- EndLine
-- Health Tree
GM:AddSkill(SKILL_STOIC1, "Stoic I", GOOD.."+1 maximum health\n",
																-4,			-6,					{SKILL_NONE, SKILL_STOIC2}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_STOIC2, "Stoic II", GOOD.."+2 maximum health\n",
																-4,			-4,					{SKILL_STOIC3, SKILL_VITALITY1, SKILL_REGENERATOR}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_STOIC3, "Stoic III", GOOD.."+4 maximum health\n",
																-3,			-2,					{SKILL_STOIC4}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_STOIC4, "Stoic IV", GOOD.."+6 maximum health\n",
																-3,			0,					{SKILL_STOIC5}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_STOIC5, "Stoic V", GOOD.."+7 maximum health\n",
																-3,			2,					{SKILL_BLOODARMOR, SKILL_TANKER}, TREE_HEALTHTREE)
--GM:AddSkill(SKILL_D_HEMOPHILIA, "Debuff: Hemophilia", GOOD.."+10 starting Worth\n"..GOOD.."+3 starting scrap\n"..BAD.."Bleed for 25% extra damage when hit",
																--4,			2,					{}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_GLUTTON, "Glutton", GOOD.."Gain up to 30 blood armor when you eat food\n"..GOOD.."Blood armor gained can exceed the cap by 40\n"..BAD.."-5 maximum health\n"..BAD.."No longer receive health from eating food",
																3,			-2,					{SKILL_GOURMET, SKILL_BLOODARMOR}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_PREPAREDNESS, "Preparedness", GOOD.."Your starting item can be a random food item",
																4,			-6,					{SKILL_NONE}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_GOURMET, "Gourmet", GOOD.."+100% recovery from food\n"..BAD.."+200% time to eat food",
																4,			-4,					{SKILL_PREPAREDNESS, SKILL_VITALITY1}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_HAEMOSTASIS, "Haemostasis", GOOD.."Resist status effects while you have at least 2 blood armor\n"..BAD.."Lose 2 blood armor on resist\n"..BAD.."-25% blood armor damage absorption",
																2,			6,					{}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_BLOODLETTER, "Bloodletter", GOOD.."+100% blood armor generated\n"..BAD.."Losing all blood armor inflicts 5 bleed damage",
																0,			4,					{SKILL_ANTIGEN}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_REGENERATOR, "Regenerator", GOOD.."Regenerate 1 health every 6s when below 60% health\n"..BAD.."-6 maximum health",
																-4,			-2,					{}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_BLOODARMOR, "Blood Armor", GOOD.."Regenerate 1 blood armor every 8 seconds upto your blood armor max\nBase blood armor maximum is 20\nBase blood armor damage absorption is 50%\n"..BAD.."-13 maximum health",
																2,			2,					{SKILL_IRONBLOOD, SKILL_BLOODLETTER}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_IRONBLOOD, "Iron Blood", GOOD.."+25% damage reduction from blood armor\n"..GOOD.."Bonus doubled when health is 50% or less\n"..BAD.."-50% maximum blood armor",
																2,			4,					{SKILL_HAEMOSTASIS, SKILL_CIRCULATION}, TREE_HEALTHTREE)
--GM:AddSkill(SKILL_D_WEAKNESS, "Debuff: Weakness", GOOD.."+15 starting Worth\n"..GOOD.."+1 end of wave points\n"..BAD.."-45 maximum health",
																--1.5,			0,					{}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_VITALITY1, "Vitality I", GOOD.."+1 maximum health",
																0,			-4,					{SKILL_VITALITY2}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_VITALITY2, "Vitality II", GOOD.."+1 maximum health",
																0,			-2,					{SKILL_VITALITY3}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_VITALITY3, "Vitality III", GOOD.."+1 maximum health",
																0,			-0,					{}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_TANKER, "Tanker", GOOD.."+20 maximum health\n",
																-3,			4,					{}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_FORAGER, "Forager", GOOD.."25% chance to collect food from resupply boxes",
																5,			-2,					{SKILL_GOURMET}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_SUGARRUSH, "Sugar Rush", GOOD.."+35 speed boost from food for 14 seconds\n"..BAD.."-35% recovery from food\n",
																4,			0,					{SKILL_GOURMET}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_CIRCULATION, "Circulation", GOOD.."+1 maximum blood armor",
																4,			4,					{SKILL_SANGUINE}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_SANGUINE, "Sanguine I", GOOD.."+11 maximum blood armor\n"..GOOD.."+9 maximum health",
																4,			8,					{SKILL_SANGUINE1}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_SANGUINE1, "Sanguine II", GOOD.."+10 maximum blood armor",
																2,			8,					{}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_ANTIGEN, "Antigen", GOOD.."+5% blood armor damage absorption\n"..GOOD.."+3 maximum health",
																-2,			4,					{}, TREE_HEALTHTREE)
-- Speed Tree

GM:AddSkill(SKILL_SPEED1, "Speed I", GOOD.."+0.75 movement speed\n",
																-4,			6,					{SKILL_NONE, SKILL_SPEED2}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_SPEED2, "Speed II", GOOD.."+1.5 movement speed\n",
																-4,			4,					{SKILL_SPEED3, SKILL_PHASER, SKILL_SPEED2}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_SPEED3, "Speed III", GOOD.."+3 movement speed\n",
																-4,			2,					{SKILL_SPEED4}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_SPEED4, "Speed IV", GOOD.."+4.5 movement speed\n",
																-4,			0,					{SKILL_SPEED5, SKILL_SAFEFALL}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_SPEED5, "Speed V", GOOD.."+5.25 movement speed\n",
																-4,			-2,					{SKILL_ULTRANIMBLE, SKILL_BACKPEDDLER, SKILL_MOTIONI, SKILL_CARDIOTONIC, SKILL_UNBOUND}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_AGILEI, "Agile I", GOOD.."+4% jumping power\n",
																4,			6,					{SKILL_NONE, SKILL_AGILEII}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_AGILEII, "Agile II", GOOD.."+5% jumping power\n",
																4,			2,					{SKILL_AGILEIII, SKILL_WORTHINESS3}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_AGILEIII, "Agile III", GOOD.."+6% jumping power\n",
																4,			-2,					{SKILL_SAFEFALL, SKILL_ULTRANIMBLE, SKILL_SURESTEP, SKILL_INTREPID}, TREE_SPEEDTREE)
--GM:AddSkill(SKILL_D_SLOW, "Debuff: Slow", GOOD.."+15 starting Worth\n"..GOOD.."+1 end of wave points\n"..BAD.."-33.75 movement speed",
																--0,			-4,					{}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_MOTIONI, "Motion I", GOOD.."+0.75 movement speed",
																-2,			-2,					{SKILL_MOTIONII}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_MOTIONII, "Motion II", GOOD.."+0.75 movement speed",
																-1,			-1,					{SKILL_MOTIONIII}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_MOTIONIII, "Motion III", GOOD.."+0.75 movement speed",
																0,			-2,					{}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_BACKPEDDLER, "Backpeddler", GOOD.."Move the same speed in all directions\n"..BAD.."-7 movement speed\n"..BAD.."Receive leg damage on any melee hit",
																-6,			0,					{}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_PHASER, "Phaser", GOOD.."+15% barricade phasing movement speed\n"..GOOD.."-15% sigil teleportation time",
																-1,			4,					{SKILL_DRIFT}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_DRIFT, "Drift", GOOD.."+5% barricade phasing movement speed",
																1,			3,					{SKILL_WARP}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_WARP, "Warp", GOOD.."-5% sigil teleportation time",
																2,			2,					{}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_SAFEFALL, "Safe Fall", GOOD.."-40% fall damage taken\n"..GOOD.."+50% faster fall damage knockdown recovery\n"..GOOD.."-40% slow down from landing or fall damage",
																0,			0,					{}, TREE_SPEEDTREE)
--GM:AddSkill(SKILL_D_WIDELOAD, "Debuff: Wide Load", GOOD.."+20 starting Worth\n"..GOOD.."-5% resupply delay\n"..BAD.."Phasing speed limited to 1 for the first 6 seconds of phasing",
																--1,			1,					{}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_U_CORRUPTEDFRAGMENT, "Unlock: Corrupted Fragment", GOOD.."Unlocks purchasing the Corrupted Fragment\nGoes to corrupted sigils instead",
																-2,			0,					{SKILL_NONE}, TREE_UNLOCKITEMS)
GM:AddSkill(SKILL_ULTRANIMBLE, "Ultra Nimble", GOOD.."+15 movement speed\n",
																0,			-6,					{}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_WORTHINESS3, "Worthiness III", GOOD.."+5 starting worth\n"..GOOD.."+3 starting points",
																6,			2,					{}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_SURESTEP, "Sure Step", GOOD.."-30% effectiveness of slows\n"..BAD.."-4 movement speed",
																6,			0,					{}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_INTREPID, "Intrepid", GOOD.."-35% low health slow intensity\n"..BAD.."-4 movement speed",
																6,			-4,					{SKILL_ROBUST}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_ROBUST, "Robust", GOOD.."-6% movement speed reduction with heavy weapons",
																5,			-5,					{}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_CARDIOTONIC, "Cardiotonic", GOOD.."Hold shift to run whilst draining blood armor\n"..BAD.."-12 movement speed\n"..BAD.."-20% blood armor damage absorption\nSprinting grants +40 move speed",
																-6,			-4,					{}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_UNBOUND, "Unbound", GOOD.."-60% reduced delay from switching weapons affecting movement speed\n"..BAD.."-4 movement speed",
																-4,			-4,					{}, TREE_SPEEDTREE)
-- Medic Tree
GM:AddSkill(SKILL_SURGEON1, "Surgeon I", GOOD.."-8% medical kit cooldown",
																-4,			6,					{SKILL_NONE, SKILL_SURGEON2}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_SURGEON2, "Surgeon II", GOOD.."-9% medical kit cooldown",
																-4,			3,					{SKILL_WORTHINESS4, SKILL_SURGEON3}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_SURGEON3, "Surgeon III", GOOD.."-10% medical kit cooldown",
																-4,			0,					{SKILL_SURGEONIV}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_SURGEONIV, "Surgeon IV", GOOD.."-11% medical kit cooldown",
																-4,			-3,					{SKILL_DISPERSION}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_BIOLOGYI, "Biology I", GOOD.."+8% medic tool effectiveness",
																3,			6,					{SKILL_NONE, SKILL_BIOLOGYII}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_BIOLOGYII, "Biology II", GOOD.."+9% medic tool effectiveness",
																3,			4,					{SKILL_BIOLOGYIII, SKILL_SMARTTARGETING}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_BIOLOGYIII, "Biology III", GOOD.."+10% medic tool effectiveness",
																3,			2,					{SKILL_BIOLOGYIV}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_BIOLOGYIV, "Biology IV", GOOD.."+11% medic tool effectiveness",
																3,			0,					{SKILL_BIOLOGYV}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_BIOLOGYV, "Biology V", GOOD.."+16% medic tool effectiveness",
																3,			-2,					{SKILL_BIOLOGYVI, SKILL_DISPERSION}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_BIOLOGYVI, "Biology VI", GOOD.."+16% medic tool effectiveness",
																3,			-4,					{SKILL_DISPERSION}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_U_MEDICCLOUD, "Unlock: Medic Cloud Bomb", GOOD.."Unlocks purchasing the Medic Cloud Bomb\nSlowly heals all humans inside the cloud",
																2,			0,					{SKILL_NONE}, TREE_UNLOCKITEMS)
.AlwaysActive = true
GM:AddSkill(SKILL_SMARTTARGETING, "Smart Targeting", GOOD.."Medical weapon darts lock onto targets with right click\n"..BAD.."+75% medic tool fire delay\n"..BAD.."-30% healing effectiveness on medical darts",
																6,			2,					{}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_RECLAIMSOL, "Recoverable Solution", GOOD.."60% of wasted medical dart ammo is returned to you\n"..BAD.."+150% medic tool fire delay\n"..BAD.."-40% medic tool reload speed\n"..BAD.."Cannot speed boost full health players",
																6,			0,					{SKILL_SMARTTARGETING}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_U_STRENGTHSHOT, "Unlock: Strength Shot Gun", GOOD.."Unlocks purchasing the Strength Shot Gun\nTarget damage +25% for 10 seconds\nExtra damage is given to you as points\nTarget is not healed",
																0,			2,					{SKILL_NONE}, TREE_UNLOCKITEMS)
GM:AddSkill(SKILL_WORTHINESS4, "Worthiness IV", GOOD.."+5 starting worth\n"..GOOD.."+3 starting points",
																-6,			3,					{}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_U_ANTITODESHOT, "Unlock: Antidote Handgun", GOOD.."Unlocks purchasing the Antidote Handgun\nFires piercing blasts that heal poison greatly\nCleanses statuses from targets with a small point gain\nDoes not heal health",
																0,			-2,					{SKILL_NONE}, TREE_UNLOCKITEMS)
GM:AddSkill(SKILL_DISPERSION, "Dispersion", GOOD.."+15% cloud bomb radius\n"..BAD.."-10% cloud bomb time",
																-0,			-3,					{}, TREE_SUPPORTTREE)

-- Defence Tree
GM:AddSkill(SKILL_HANDY1, "Handy I", GOOD.."+4% repair rate",
																-5,			-6,					{SKILL_NONE, SKILL_HANDY2}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_HANDY2, "Handy II", GOOD.."+5% repair rate",
																-5,			-4,					{SKILL_HANDY3,SKILL_LOADEDHULL}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_HANDY3, "Handy III", GOOD.."+6% repair rate",
																-5,			-1,					{SKILL_HANDY4}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_HANDY4, "Handy IV", GOOD.."+7% repair rate",
																-3,			1,					{SKILL_HANDY5,SKILL_BARRICADEEXPERT}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_HANDY5, "Handy V", GOOD.."+8% repair rate",
																-3,			3,					{SKILL_HAMMERDISCIPLINE3,SKILL_BARRICADEEXPERT,SKILL_TAUT}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_HAMMERDISCIPLINE, "Hammer Discipline", GOOD.."-10% swing delay with the Carpenter Hammer",
																0,			1,					{SKILL_BARRICADEEXPERT}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_HAMMERDISCIPLINE3, "Super Handy", GOOD.."-15% swing delay with the Carpenter Hammer",
																-3,			5,					{SKILL_BARRICADEEXPERT}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_BARRICADEEXPERT, "Reinforcer", GOOD.."Props hit with a hammer in the last 2 seconds take 8% less damage\n"..GOOD.."Gain points from protected props\n"..GOOD.."-30% swing delay with the Carpenter Hammer",
																0,			3,					{SKILL_TECHNICIAN}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_LOADEDHULL, "Loaded Hull", GOOD.."Controllables explode when destroyed, dealing explosive damage\n"..BAD.."-10% Controllable health",
																-2,			-4,					{SKILL_REINFORCEDHULL, SKILL_REINFORCEDBLADES}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_REINFORCEDHULL, "Reinforced Hull", GOOD.."+25% Controllable health\n"..BAD.."-20% Controllable handling\n"..BAD.."-20% Controllable speed",
																-2,			-2,					{SKILL_STABLEHULL,SKILL_AVIATOR,SKILL_HAMMERDISCIPLINE2}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_STABLEHULL, "Stable Hull", GOOD.."Controllables are immune to high speed impacts\n"..BAD.."-20% Controllable speed",
																0,			-3,					{SKILL_HAMMERDISCIPLINE2,SKILL_REINFORCEDBLADES}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_REINFORCEDBLADES, "Reinforced Blades", GOOD.."+25% Manhack damage\n"..GOOD.."+15% Manhack health",
																0,			-5,					{}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_AVIATOR, "Aviator", GOOD.."+40% Controllable speed and handling\n"..BAD.."-25% Controllable health",
																-4,			-2,					{SKILL_HANDY3,SKILL_HANDY2}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_U_BLASTTURRET, "Unlock: Blast Turret", GOOD.."Unlocks purchasing the Blast Turret\nFires buckshot instead of SMG ammo\nDamage is higher close up\nCannot scan for targets far away",
																-2,			-2,					{SKILL_NONE}, TREE_UNLOCKITEMS)
.AlwaysActive = true
GM:AddSkill(SKILL_TURRETLOCK, "Turret Lock", "-90% turret scan angle\n"..BAD.."-90% turret target lock angle",
																-6,			-2,					{SKILL_HANDY3,SKILL_HANDY2,SKILL_TURRETOVERLOAD}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_TWINVOLLEY, "Twin Volley", GOOD.."Fire twice as many bullets in manual turret mode\n"..BAD.."+100% turret ammo usage in manual turret mode\n"..BAD.."+50% turret fire delay in manual turret mode",
																-10,		-5,					{}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_TURRETOVERLOAD, "Turret Overload", GOOD.." +100% Turret scan speed\n"..BAD.."-30% Turret range",
																-8,			-2,					{SKILL_INSTRUMENTS}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_U_DRONE, "Unlock: Pulse Drone", GOOD.."Unlocks the Pulse Drone Variant\nFires short range pulse projectiles instead of bullets",
																0,			4,					{SKILL_NONE}, TREE_UNLOCKITEMS)
.AlwaysActive = true
GM:AddSkill(SKILL_U_NANITECLOUD, "Unlock: Nanite Cloud Bomb", GOOD.."Unlocks purchasing the Nanite Cloud Bomb\nSlowly repairs all props and deployables inside the cloud",
																-2,			4,					{SKILL_NONE}, TREE_UNLOCKITEMS)
.AlwaysActive = true
GM:AddSkill(SKILL_FIELDAMP, "Field Amplifier", GOOD.."-20% zapper and repair field delay\n"..BAD.."+40% zapper and repair field range",
																6,			4,					{SKILL_TECHNICIAN}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_TECHNICIAN, "Field Technician", GOOD.." +3% zapper and repair field range\n"..GOOD.."-3% zapper and repair field delay",
																4,			3,					{}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_U_ROLLERMINE, "Unlock: Rollermine", GOOD.."Unlocks purchasing Rollermines\nRolls along the ground, shocking zombies and dealing damage",
																2,			4,					{SKILL_NONE}, TREE_UNLOCKITEMS)
GM:AddSkill(SKILL_U_HAMMER, "Unlock: Hammer", GOOD.."Unlocks purchasing Hammer\n It's this isn't joke?",
																4,			-6,					{SKILL_NONE}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_HAULMODULE, "Unlock: Hauling Drone", GOOD.."Unlocks the Hauling Drone\nRapidly transports props and items but cannot attack",
																2,			-2,					{SKILL_NONE}, TREE_UNLOCKITEMS)
GM:AddSkill(SKILL_LIGHTCONSTRUCT, "Light Construction", GOOD.."-25% deployable pack time\n"..BAD.."-25% deployable health",
																8,			-1,					{}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_STOCKPILE, "Stockpiling", GOOD.."Collect four times as much from resupplies\n",
																8,			-3,					{}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_ACUITY, "Supplier's Acuity", GOOD.."Locate nearby resupply boxes if behind walls\n"..GOOD.."Locate nearby unplaced resupply boxes on players through walls\n"..GOOD.."Locate nearby resupply packs through walls",
																6,			-3,					{SKILL_INSIGHT, SKILL_STOCKPILE, SSKILL_STOWAGE}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_VISION, "Refiner's Vision", GOOD.."Locate nearby remantlers if behind walls\n"..GOOD.."Locate nearby unplaced remantlers on players through walls",
																6,			-6,					{SKILL_NONE, SKILL_ACUITY}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_U_ROCKETTURRET, "Unlock: Rocket Turret", GOOD.."Unlocks purchasing the Rocket Turret\nFires explosives instead of SMG ammo\nDeals damage in a radius\nHigh tier deployable",
																0,			10,					{SKILL_NONE}, TREE_UNLOCKITEMS)
GM:AddSkill(SKILL_INSIGHT, "Buyer's Insight", GOOD.."Locate nearby arsenal crates if behind walls\n"..GOOD.."Locate nearby unplaced arsenal crates on players through walls\n"..GOOD.."Locate nearby arsenal packs through walls",
																6,			-0,					{SKILL_LIGHTCONSTRUCT,SKILL_FIELDAMP}, TREE_BUILDINGTREE)
.AlwaysActive = true
GM:AddSkill(SKILL_U_ZAPPER_ARC, "Unlock: Arc Zapper", GOOD.."Unlocks purchasing the Arc Zapper\nZaps zombies that get nearby, and jumps in an arc\nMid tier deployable and long cooldown\nRequires a steady upkeep of pulse ammo",
																2,			2,					{SKILL_NONE}, TREE_UNLOCKITEMS)
.AlwaysActive = true
--GM:AddSkill(SKILL_D_LATEBUYER, "Debuff: Late Buyer", GOOD.."+20 starting Worth\n"..GOOD.."2% arsenal discount\n"..BAD.."Unable to use points at arsenal crates until the second half of the round",
																--8,			1,					{}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_U_CRAFTINGPACK, "Unlock: Crafting Pack", GOOD.."Unlocks purchasing the Sawblade component\n"..GOOD.."Unlocks purchasing the Electrobattery component\n"..GOOD.."Unlocks purchasing the CPU Parts component",
																-2,			2,					{SKILL_NONE}, TREE_UNLOCKITEMS)
.AlwaysActive = true
GM:AddSkill(SKILL_TAUT, "Taut", GOOD.."Damage does not make you drop props\n"..GOOD.."-40% prop carrying slow down",
																-5,			3,					{}, TREE_BUILDINGTREE)
--GM:AddSkill(SKILL_D_NOODLEARMS, "Debuff: Noodle Arms", GOOD.."+5 starting Worth\n"..GOOD.."+1 starting scrap\n"..BAD.."Unable to pick up objects",
																---7,			2,					{SKILL_U_ROCKETTURRET}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_INSTRUMENTS, "Instruments", GOOD.."+5% turret range",
																-10,		-3,					{SKILL_TWINVOLLEY}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_STOWAGE, 	"Stowage", GOOD.."Resupply usages build up when you're not there\n",
																4,			-3,					{SKILL_U_HAMMER, SKILL_ACUITY}, TREE_BUILDINGTREE)

-- Gunnery Tree
GM:AddSkill(SKILL_TRIGGER_DISCIPLINE1, "Trigger Discipline I", GOOD.."+2% weapon reload speed\n"..GOOD.."+2% weapon draw speed",
																-5,			6,					{SKILL_TRIGGER_DISCIPLINE2, SKILL_NONE}, TREE_GUNTREE)
GM:AddSkill(SKILL_TRIGGER_DISCIPLINE2, "Trigger Discipline II", GOOD.."+3% weapon reload speed\n"..GOOD.."+3% weapon draw speed",
																-4,			3,					{SKILL_TRIGGER_DISCIPLINE3, SKILL_LEVELHEADED, SKILL_EQUIPPED}, TREE_GUNTREE)
GM:AddSkill(SKILL_TRIGGER_DISCIPLINE3, "Trigger Discipline III", GOOD.."+4% weapon reload speed\n"..GOOD.."+4% weapon draw speed",
																-3,			0,					{SKILL_QUICKRELOAD, SKILL_QUICKDRAW, SKILL_WORTHINESS1, SKILL_EGOCENTRIC}, TREE_GUNTREE)
--GM:AddSkill(SKILL_D_PALSY, "Debuff: Palsy", GOOD.."+10 starting Worth\n"..GOOD.."-3% resupply delay\n"..BAD.."Aiming ability reduced when health is low",
																--0,			4,					{SKILL_LEVELHEADED}, TREE_GUNTREE)
GM:AddSkill(SKILL_LEVELHEADED, "Level Headed", GOOD.."-5% reduced effect of aim shake effects",
																-2,			2,					{}, TREE_GUNTREE)
GM:AddSkill(SKILL_QUICKDRAW, "Quick Draw", GOOD.."+65% weapon draw speed\n"..BAD.."-15% weapon reload speed",
																0,			1,					{}, TREE_GUNTREE)
GM:AddSkill(SKILL_FOCUS, "Focus I", GOOD.."+3% tighter aiming reticule\n"..GOOD.."+3% weapon reload speed",
																5,			6,					{SKILL_NONE, SKILL_FOCUSII}, TREE_GUNTREE)
GM:AddSkill(SKILL_FOCUSII, "Focus II", GOOD.."+4% tighter aiming reticule\n"..GOOD.."+4% weapon reload speed",
																4,			3,					{SKILL_FOCUSIII, SKILL_SCAVENGER, SKILL_LEVELHEADED, SKILL_PITCHER}, TREE_GUNTREE)
GM:AddSkill(SKILL_FOCUSIII, "Focus III", GOOD.."+5% tighter aiming reticule\n"..GOOD.."+5% weapon reload speed",
																3,			0,					{SKILL_EGOCENTRIC, SKILL_WOOISM, SKILL_ORPHICFOCUS, SKILL_SCOURER}, TREE_GUNTREE)
GM:AddSkill(SKILL_QUICKRELOAD, "Quick Reload", GOOD.."+10% weapon reload speed\n"..BAD.."-25% weapon draw speed",
																-5,			1,					{SKILL_SLEIGHTOFHAND}, TREE_GUNTREE)
GM:AddSkill(SKILL_SLEIGHTOFHAND, "Sleight of Hand", GOOD.."+10% weapon reload speed\n"..BAD.."-5% tighter aiming reticule",
																-5,			-1,					{}, TREE_GUNTREE)
GM:AddSkill(SKILL_U_CRYGASGREN, "Unlock: Cryo Gas Grenade", GOOD.."Unlocks purchasing the Cryo Gas Grenade\nVariant of the Corrosive Gas Grenade\nCryo gas deals a bit of damage over time\nZombies are slowed in the effect",
																4,			-2,					{SKILL_NONE}, TREE_UNLOCKITEMS)
GM:AddSkill(SKILL_SOFTDET, "Soft Detonation", GOOD.."-40% explosive damage taken\n"..BAD.."-10% explosive damage radius",
																0,			-5,					{}, TREE_GUNTREE)
GM:AddSkill(SKILL_ORPHICFOCUS, "Orphic Focus", GOOD.."90% spread while ironsighting\n"..GOOD.."+2% tighter aiming reticule\n"..BAD.."110% spread at any other time\n"..BAD.."-6% reload speed",
																5,			-1,					{SKILL_DELIBRATION}, TREE_GUNTREE)
GM:AddSkill(SKILL_DELIBRATION, "Delibration", GOOD.."+1% tighter aiming reticule",
																6,			-3,					{}, TREE_GUNTREE)
GM:AddSkill(SKILL_EGOCENTRIC, "Egocentric", GOOD.."-35% damage vs. yourself\n"..GOOD.."+5 health",
																0,			-1,					{SKILL_BLASTPROOF}, TREE_GUNTREE)
GM:AddSkill(SKILL_BLASTPROOF, "Blast Proof", GOOD.."-45% damage vs. yourself\n"..BAD.."-7% reload speed\n"..BAD.."-12% weapon draw speed",
																0,			-3,					{SKILL_SOFTDET, SKILL_CANNONBALL, SKILL_CONEFFECT}, TREE_GUNTREE)
GM:AddSkill(SKILL_WOOISM, "Zeal", GOOD.."-50% speed reduction from being ironsighted\n"..BAD.."-25% accuracy bonus from ironsighting",
																5,			1,					{SKILL_TRUEWOOISM}, TREE_GUNTREE)
GM:AddSkill(SKILL_SCAVENGER, "Scavenger's Eyes", GOOD.."See nearby weapons, ammo, and items through walls",
																7,			4,					{}, TREE_GUNTREE)
GM:AddSkill(SKILL_PITCHER, "Pitcher", GOOD.."+10% object throw and thrown weapon velocity",
																6,			2,					{}, TREE_GUNTREE)
GM:AddSkill(SKILL_EQUIPPED, "Alacrity", GOOD.."Your starting item can be a random special trinket",
																-6,			2,					{}, TREE_GUNTREE)
GM:AddSkill(SKILL_WORTHINESS1, "Worthiness I", GOOD.."+5 starting worth\n"..GOOD.."3 starting points",
																-4,			-3,					{}, TREE_GUNTREE)
GM:AddSkill(SKILL_CANNONBALL, "Cannonball", "-25% projectile speed\n"..GOOD.."+3% projectile damage",
																-2,			-3,					{}, TREE_GUNTREE)
GM:AddSkill(SKILL_SCOURER, "Scourer", GOOD.."Earn end of wave points as scrap\n"..BAD.."Earn no end of wave points",
																4,			-3,					{}, TREE_GUNTREE)
GM:AddSkill(SKILL_CONEFFECT, "Concentrated Effect", GOOD.."+5% explosive damage\n"..BAD.."-20% explosive damage radius",
																2,			-5,					{}, TREE_GUNTREE)
GM:AddSkill(SKILL_TRUEWOOISM, "Wooism", GOOD.."No accuracy penalty from moving or jumping\n"..BAD.."No accuracy bonus from crouching or ironsighting",
																7,			0,					{}, TREE_GUNTREE)

-- Melee Tree
GM:AddSkill(SKILL_WORTHINESS2, "Worthiness II", GOOD.."+5 starting worth\n"..GOOD.."3 starting points",
																4,			0,					{}, TREE_MELEETREE)
GM:AddSkill(SKILL_BATTLER1, "Battler I", GOOD.."+4% melee damage",
																-6,			-6,					{SKILL_BATTLER2, SKILL_NONE}, TREE_MELEETREE)
GM:AddSkill(SKILL_BATTLER2, "Battler II", GOOD.."+5% melee damage",
																-6,			-4,					{SKILL_BATTLER3, SKILL_LIGHTWEIGHT}, TREE_MELEETREE)
GM:AddSkill(SKILL_BATTLER3, "Battler III", GOOD.."+5% melee damage",
																-4,			-2,					{SKILL_BATTLER4, SKILL_LANKY}, TREE_MELEETREE)
GM:AddSkill(SKILL_BATTLER4, "Battler IV", GOOD.."+6% melee damage",
																-2,			0,					{SKILL_BATTLER5, SKILL_MASTERCHEF}, TREE_MELEETREE)
GM:AddSkill(SKILL_BATTLER5, "Battler V", GOOD.."+7% melee damage",
																0,			2,					{SKILL_U_SUPER_SCYTHE, SKILL_GLASSWEAPONS, SKILL_BLOODLUST}, TREE_MELEETREE)
GM:AddSkill(SKILL_LASTSTAND, "Last Stand", GOOD.."Double melee damage when below 25% health\n"..BAD.."0.85x melee weapon damage at any other time",
																0,			6,					{}, TREE_MELEETREE)
GM:AddSkill(SKILL_GLASSWEAPONS, "Glass Weapons", GOOD.."3.5x melee weapon damage vs. zombies\n"..BAD.."Your melee weapons have a 50% chance to break when hitting a zombie",
																2,			4,					{}, TREE_MELEETREE)
--GM:AddSkill(SKILL_D_CLUMSY, "Debuff: Clumsy", GOOD.."+20 starting Worth\n"..GOOD.."+5 starting points\n"..BAD.."Very easy to be knocked down",
																---2,			2,					{}, TREE_MELEETREE)
GM:AddSkill(SKILL_CHEAPKNUCKLE, "Cheap Tactics", GOOD.."Slow targets when striking with a melee weapon from behind\n"..BAD.."-10% melee range",
																4,			-2,					{SKILL_HEAVYSTRIKES, SKILL_WORTHINESS2}, TREE_MELEETREE)
GM:AddSkill(SKILL_CRITICALKNUCKLE, "Critical Knuckle", GOOD.."Knockback when using unarmed strikes\n"..BAD.."-25% unarmed strike damage\n"..BAD.."+25% time before next unarmed strike",
																6,			-2,					{SKILL_BRASH}, TREE_MELEETREE)
GM:AddSkill(SKILL_KNUCKLEMASTER, "Knuckle Master", GOOD.."+75% unarmed strike damage\n"..GOOD.."Movement speed is no longer slower when using unarmed strikes\n"..BAD.."+35% time before next unarmed strike",
																6,			-6,					{SKILL_NONE, SKILL_COMBOKNUCKLE}, TREE_MELEETREE)
GM:AddSkill(SKILL_COMBOKNUCKLE, "Combo Knuckle", GOOD.."Next unarmed strike is 2x faster if hitting something\n"..BAD.."Next unarmed attack is 2x slower if not hitting something",
																6,			-4,					{SKILL_CHEAPKNUCKLE, SKILL_CRITICALKNUCKLE}, TREE_MELEETREE)
GM:AddSkill(SKILL_HEAVYSTRIKES, "Heavy Strikes", GOOD.."+100% melee knockback\n"..BAD.."8% of melee damage dealt is reflected back to you\n"..BAD.."100% reflected if using unarmed strikes",
																2,			0,					{SKILL_BATTLER5, SKILL_JOUSTER}, TREE_MELEETREE)
GM:AddSkill(SKILL_JOUSTER, "Jouster", GOOD.."+10% melee damage\n"..BAD.."-100% melee knockback",
																2,			2,					{}, TREE_MELEETREE)
GM:AddSkill(SKILL_LANKY, "Lanky I", GOOD.."+10% melee range\n"..BAD.."-15% melee damage",
																-4,			0,					{SKILL_LANKYII}, TREE_MELEETREE)
GM:AddSkill(SKILL_LANKYII, "Lanky II", GOOD.."+10% melee range\n"..BAD.."-15% melee damage",
																-4,			2,					{}, TREE_MELEETREE)
GM:AddSkill(SKILL_MASTERCHEF, "Master Chef", GOOD.."Zombies hit by culinary weapons in the past second have a chance to drop food items on death\n"..BAD.."-10% melee damage",
																0,			-3,					{SKILL_BATTLER4}, TREE_MELEETREE)
GM:AddSkill(SKILL_LIGHTWEIGHT, "Lightweight", GOOD.."+6 movement speed with a melee weapon equipped\n"..BAD.."-20% melee damage",
																-6,			-2,					{}, TREE_MELEETREE)
GM:AddSkill(SKILL_BLOODLUST, "Bloodlust", "Gain phantom health equal to half the damage taken from zombies\nLose phantom health equal to any healing received\nPhantom health decreases by 5 per second\n"..GOOD.."Heal 25% of damage done with melee from remaining phantom health\n"..BAD.."-50% healing received",
																-2,			4,					{SKILL_LASTSTAND}, TREE_MELEETREE)
GM:AddSkill(SKILL_BRASH, "Brash", GOOD.."-16% melee swing impact delay\n"..BAD.."-15 speed on melee kill for 10 seconds",
																6,			0,					{}, TREE_MELEETREE)

GM:SetSkillModifierFunction(SKILLMOD_SPEED, function(pl, amount)
	pl.SkillSpeedAdd = amount
end)

GM:SetSkillModifierFunction(SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, function(pl, amount)
	pl.MedicHealMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MEDKIT_COOLDOWN_MUL, function(pl, amount)
	pl.MedicCooldownMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_WORTH, function(pl, amount)
	pl.ExtraStartingWorth = amount + math.min(math.floor(pl:GetZSRemortLevel() * 0))
end)

GM:SetSkillModifierFunction(SKILLMOD_FALLDAMAGE_THRESHOLD_MUL, function(pl, amount)
	pl.FallDamageThresholdMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL, function(pl, amount)
	pl.FallDamageSlowDownMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_FOODEATTIME_MUL, function(pl, amount)
	pl.FoodEatTimeMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_JUMPPOWER_MUL, function(pl, amount)
	pl.JumpPowerMul = math.Clamp(amount + 1.0, 0.0, 10.0)

	if SERVER then
		pl:ResetJumpPower()
	end
end)

GM:SetSkillModifierFunction(SKILLMOD_DEPLOYSPEED_MUL, function(pl, amount)
	pl.DeploySpeedMultiplier = math.Clamp(amount + 1.0, 0.05, 100.0)

	for _, wep in pairs(pl:GetWeapons()) do
		GAMEMODE:DoChangeDeploySpeed(wep)
	end
end)

GM:SetSkillModifierFunction(SKILLMOD_BLOODARMOR, function(pl, amount)
	local oldarmor = pl:GetBloodArmor()
	local oldcap = pl.MaxBloodArmor or 20
	local new = 20 + math.Clamp(amount, -20, 200)

	pl.MaxBloodArmor = new

	if SERVER then
		if oldarmor > oldcap then
			local overcap = oldarmor - oldcap
			pl:SetBloodArmor(pl.MaxBloodArmor + overcap)
		else
			pl:SetBloodArmor(pl:GetBloodArmor() / oldcap * new)
		end
	end
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplier = math.Clamp(amount + 1.0, 0.05, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_DAMAGE_MUL, function(pl, amount)
	pl.MeleeDamageMultiplier = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_SELF_DAMAGE_MUL, function(pl, amount)
	pl.SelfDamageMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_KNOCKBACK_MUL, function(pl, amount)
	pl.MeleeKnockbackMultiplier = math.Clamp(amount + 1.0, 0.0, 10000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_UNARMED_DAMAGE_MUL, function(pl, amount)
	pl.UnarmedDamageMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_UNARMED_SWING_DELAY_MUL, function(pl, amount)
	pl.UnarmedDelayMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_BARRICADE_PHASE_SPEED_MUL, function(pl, amount)
	pl.BarricadePhaseSpeedMul = math.Clamp(amount + 1.0, 0.05, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_HAMMER_SWING_DELAY_MUL, function(pl, amount)
	pl.HammerSwingDelayMul = math.Clamp(amount + 1.0, 0.01, 1.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_REPAIRRATE_MUL, function(pl, amount)
	pl.RepairRateMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_AIMSPREAD_MUL, function(pl, amount)
	pl.AimSpreadMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MEDGUN_FIRE_DELAY_MUL, function(pl, amount)
	pl.MedgunFireDelayMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MEDGUN_RELOAD_SPEED_MUL, function(pl, amount)
	pl.MedgunReloadSpeedMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_DRONE_GUN_RANGE_MUL, function(pl, amount)
	pl.DroneGunRangeMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_HEALING_RECEIVED, function(pl, amount)
	pl.HealingReceived = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_PISTOL_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierPISTOL = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_SMG_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierSMG1 = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_ASSAULT_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierAR2 = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_SHELL_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierBUCKSHOT = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_RIFLE_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplier357 = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_XBOW_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierXBOWBOLT = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_PULSE_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierPULSE = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_EXP_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierIMPACTMINE = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_ATTACKER_DMG_REFLECT, function(pl, amount)
	pl.BarbedArmor = math.Clamp(amount, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_PULSE_WEAPON_SLOW_MUL, function(pl, amount)
	pl.PulseWeaponSlowMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, function(pl, amount)
	pl.MeleeDamageTakenMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_POISON_DAMAGE_TAKEN_MUL, function(pl, amount)
	pl.PoisonDamageTakenMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_BLEED_DAMAGE_TAKEN_MUL, function(pl, amount)
	pl.BleedDamageTakenMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_SWING_DELAY_MUL, function(pl, amount)
	pl.MeleeSwingDelayMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, function(pl, amount)
	pl.MeleeDamageToBloodArmorMul = math.Clamp(amount, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_MOVEMENTSPEED_ON_KILL, function(pl, amount)
	pl.MeleeMovementSpeedOnKill = math.Clamp(amount, -15, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_POWERATTACK_MUL, function(pl, amount)
	pl.MeleePowerAttackMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_KNOCKDOWN_RECOVERY_MUL, function(pl, amount)
	pl.KnockdownRecoveryMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_RANGE_MUL, function(pl, amount)
	pl.MeleeRangeMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_SLOW_EFF_TAKEN_MUL, function(pl, amount)
	pl.SlowEffTakenMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_EXP_DAMAGE_TAKEN_MUL, function(pl, amount)
	pl.ExplosiveDamageTakenMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_FIRE_DAMAGE_TAKEN_MUL, function(pl, amount)
	pl.FireDamageTakenMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_PROP_CARRY_CAPACITY_MUL, function(pl, amount)
	pl.PropCarryCapacityMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_PROP_THROW_STRENGTH_MUL, function(pl, amount)
	pl.ObjectThrowStrengthMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_PHYSICS_DAMAGE_TAKEN_MUL, function(pl, amount)
	pl.PhysicsDamageTakenMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_VISION_ALTER_DURATION_MUL, function(pl, amount)
	pl.VisionAlterDurationMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_DIMVISION_EFF_MUL, function(pl, amount)
	pl.DimVisionEffMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_PROP_CARRY_SLOW_MUL, function(pl, amount)
	pl.PropCarrySlowMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_BLEED_SPEED_MUL, function(pl, amount)
	pl.BleedSpeedMul = math.Clamp(amount + 1.0, 0.1, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_LEG_DAMAGE_ADD, function(pl, amount)
	pl.MeleeLegDamageAdd = math.Clamp(amount, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_SIGIL_TELEPORT_MUL, function(pl, amount)
	pl.SigilTeleportTimeMul = math.Clamp(amount + 1.0, 0.1, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_ATTACKER_DMG_REFLECT_PERCENT, function(pl, amount)
	pl.BarbedArmorPercent = math.Clamp(amount, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_POISON_SPEED_MUL, function(pl, amount)
	pl.PoisonSpeedMul = math.Clamp(amount + 1.0, 0.1, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_PROJECTILE_DAMAGE_TAKEN_MUL, GM:MkGenericMod("ProjDamageTakenMul"))
GM:SetSkillModifierFunction(SKILLMOD_EXP_DAMAGE_RADIUS, GM:MkGenericMod("ExpDamageRadiusMul"))
GM:SetSkillModifierFunction(SKILLMOD_WEAPON_WEIGHT_SLOW_MUL, GM:MkGenericMod("WeaponWeightSlowMul"))
GM:SetSkillModifierFunction(SKILLMOD_FRIGHT_DURATION_MUL, GM:MkGenericMod("FrightDurationMul"))
GM:SetSkillModifierFunction(SKILLMOD_IRONSIGHT_EFF_MUL, GM:MkGenericMod("IronsightEffMul"))
GM:SetSkillModifierFunction(SKILLMOD_MEDDART_EFFECTIVENESS_MUL, GM:MkGenericMod("MedDartEffMul"))

GM:SetSkillModifierFunction(SKILLMOD_BLOODARMOR_DMG_REDUCTION, function(pl, amount)
	pl.BloodArmorDamageReductionAdd = amount
end)

GM:SetSkillModifierFunction(SKILLMOD_BLOODARMOR_MUL, function(pl, amount)
	local mul = math.Clamp(amount + 1.0, 0.0, 1500.0)

	pl.MaxBloodArmorMul = mul

	local oldarmor = pl:GetBloodArmor()
	local oldcap = pl.MaxBloodArmor or 20
	local new = pl.MaxBloodArmor * mul

	pl.MaxBloodArmor = new

	if SERVER then
		if oldarmor > oldcap then
			local overcap = oldarmor - oldcap
			pl:SetBloodArmor(pl.MaxBloodArmor + overcap)
		else
			pl:SetBloodArmor(pl:GetBloodArmor() / oldcap * new)
		end
	end
end)

GM:SetSkillModifierFunction(SKILLMOD_BLOODARMOR_GAIN_MUL, GM:MkGenericMod("BloodarmorGainMul"))
GM:SetSkillModifierFunction(SKILLMOD_LOW_HEALTH_SLOW_MUL, GM:MkGenericMod("LowHealthSlowMul"))
GM:SetSkillModifierFunction(SKILLMOD_PROJ_SPEED, GM:MkGenericMod("ProjectileSpeedMul"))

GM:SetSkillModifierFunction(SKILLMOD_ENDWAVE_POINTS, function(pl,amount)
	pl.EndWavePointsExtra = math.Clamp(amount, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_ARSENAL_DISCOUNT, GM:MkGenericMod("ArsenalDiscount"))
GM:SetSkillModifierFunction(SKILLMOD_CLOUD_RADIUS, GM:MkGenericMod("CloudRadius"))
GM:SetSkillModifierFunction(SKILLMOD_CLOUD_TIME, GM:MkGenericMod("CloudTime"))
GM:SetSkillModifierFunction(SKILLMOD_EXP_DAMAGE_MUL, GM:MkGenericMod("ExplosiveDamageMul"))
GM:SetSkillModifierFunction(SKILLMOD_PROJECTILE_DAMAGE_MUL, GM:MkGenericMod("ProjectileDamageMul"))
GM:SetSkillModifierFunction(SKILLMOD_TURRET_RANGE_MUL, GM:MkGenericMod("TurretRangeMul"))
GM:SetSkillModifierFunction(SKILLMOD_AIM_SHAKE_MUL, GM:MkGenericMod("AimShakeMul"))

GM:AddSkillModifier(SKILL_SPEED1, SKILLMOD_SPEED, 0.75)
GM:AddSkillModifier(SKILL_SPEED2, SKILLMOD_SPEED, 1.5)
GM:AddSkillModifier(SKILL_SPEED3, SKILLMOD_SPEED, 3)
GM:AddSkillModifier(SKILL_SPEED4, SKILLMOD_SPEED, 4.5)
GM:AddSkillModifier(SKILL_SPEED5, SKILLMOD_SPEED, 5.25)

-- CUSTOM SKILLS
GM:AddSkillModifier(SKILL_SPEEDIE1, 			SKILLMOD_SPEED, 3)
GM:AddSkillModifier(SKILL_SPEEDIE2, 			SKILLMOD_SPEED, 6)
GM:AddSkillModifier(SKILL_SPEEDIE3, 			SKILLMOD_SPEED, 8)
GM:AddSkillModifier(SKILL_SPEEDIE4, 			SKILLMOD_SPEED, 14)

GM:AddSkillModifier(SKILL_JUMP_BOOST,      		SKILLMOD_JUMPPOWER_MUL, 0.02)
GM:AddSkillModifier(SKILL_JUMP_BOOST2,      	SKILLMOD_JUMPPOWER_MUL, 0.08)
GM:AddSkillModifier(SKILL_MEDIC_DELAY,      	SKILLMOD_MEDKIT_COOLDOWN_MUL, -1.5)
GM:AddSkillModifier(SKILL_SURVIVOR,      		SKILLMOD_HEALTH, 12)
GM:AddSkillModifier(SKILL_SURVIVOR2,      		SKILLMOD_HEALTH, 18)
GM:AddSkillModifier(SKILL_SURVIVOR3,      		SKILLMOD_HEALTH, 25)
GM:AddSkillModifier(SKILL_SURVIVOR4,      		SKILLMOD_HEALTH, 45)
GM:AddSkillModifier(SKILL_WAVE_POINTS,      	SKILLMOD_ENDWAVE_POINTS, 13)
GM:AddSkillModifier(SKILL_DEPLOYMENT_PACKDELAY, SKILLMOD_DEPLOYABLE_PACKTIME_MUL, -0.60)
GM:AddSkillModifier(SKILL_DEPLOYMENT_HEALTH, 	SKILLMOD_DEPLOYABLE_HEALTH_MUL, 0.80)
GM:AddSkillModifier(SKILL_WORTH_START,      	SKILLMOD_WORTH, 25)
GM:AddSkillModifier(SKILL_BLOOD_ARMOR1,    		SKILLMOD_BLOODARMOR, 20)
GM:AddSkillModifier(SKILL_BLOOD_ARMOR2,    		SKILLMOD_BLOODARMOR, 25)
GM:AddSkillModifier(SKILL_BLOOD_ARMOR3,    		SKILLMOD_BLOODARMOR, 44)
GM:AddSkillModifier(SKILL_BLOOD_ARMOR4,    		SKILLMOD_BLOODARMOR, 90)
GM:AddSkillModifier(SKILL_BLOOD_ARMOR5,    		SKILLMOD_BLOODARMOR, 35)
GM:AddSkillModifier(SKILL_BLOOD_ARMOR6,    		SKILLMOD_BLOODARMOR, 50)
GM:AddSkillModifier(SKILL_MELEE_DEFENSE1,  		SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.01 )
GM:AddSkillModifier(SKILL_MELEE_DEFENSE2, 		SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.04 )
GM:AddSkillModifier(SKILL_MELEE_DEFENSE3, 		SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.09 )
GM:AddSkillModifier(SKILL_MELEE_POWER, 			SKILLMOD_MELEE_DAMAGE_MUL, 0.10)
GM:AddSkillModifier(SKILL_MELEE_POWER2, 		SKILLMOD_MELEE_DAMAGE_MUL, 0.15)
GM:AddSkillModifier(SKILL_MELEE_POWER3, 		SKILLMOD_MELEE_DAMAGE_MUL, 0.30)
GM:AddSkillModifier(SKILL_ARSENAL_DISCOUNT1,	SKILLMOD_ARSENAL_DISCOUNT, -0.03)
GM:AddSkillModifier(SKILL_ARSENAL_DISCOUNT2,	SKILLMOD_ARSENAL_DISCOUNT, -0.08)
GM:AddSkillModifier(SKILL_ARSENAL_DISCOUNT2,	SKILLMOD_ARSENAL_DISCOUNT, -0.13)

-- End Line

-- TechnicTree
GM:AddSkillModifier(SKILL_HAMMER_REPAIR1,			SKILLMOD_REPAIRRATE_MUL, 0.15)
GM:AddSkillModifier(SKILL_HAMMER_REPAIR2,			SKILLMOD_REPAIRRATE_MUL, 0.20)
GM:AddSkillModifier(SKILL_HAMMER_REPAIR3,			SKILLMOD_REPAIRRATE_MUL, 0.30)
GM:AddSkillModifier(SKILL_HAMMER_REPAIR4,			SKILLMOD_REPAIRRATE_MUL, 0.48)
GM:AddSkillModifier(SKILL_PACK_DELAY, 				SKILLMOD_DEPLOYABLE_PACKTIME_MUL, -0.08)
GM:AddSkillModifier(SKILL_SMALL_TURRET_SCANSPEED1, 	SKILLMOD_TURRET_SCANSPEED_MUL, 0.03)
GM:AddSkillModifier(SKILL_SMALL_TURRET_SCANSPEED2, 	SKILLMOD_TURRET_SCANSPEED_MUL, 0.07)
-- End Line

-- End Line
-- Reload Skill Tree

-- End Line

-- Armor Skill Tree
GM:AddSkillModifier(SKILL_SMALL_BLOODARMOR1,      		SKILLMOD_BLOODARMOR, 5)
GM:AddSkillModifier(SKILL_SMALL_BLOODARMOR2,      		SKILLMOD_BLOODARMOR, 8)
GM:AddSkillModifier(SKILL_SMALL_BLOODARMOR3,      		SKILLMOD_BLOODARMOR, 12)
GM:AddSkillModifier(SKILL_SMALL_BLOODARMOR4,      		SKILLMOD_BLOODARMOR, 25)
GM:AddSkillModifier(SKILL_SMALL_BLOODARMOR5,      		SKILLMOD_BLOODARMOR, 45)
GM:AddSkillModifier(SKILL_SMALL_BLOODARMOR6,      		SKILLMOD_BLOODARMOR, 75)
-- End Line

-- Medium Support Skill Tree
GM:AddSkillModifier(SKILL_SMALL_POINT_MULTIPLIER,			SKILLMOD_POINT_MULTIPLIER, 0.09)
GM:AddSkillModifier(SKILL_MEDIUM_DEPLOYMENT_HEALTH, 		SKILLMOD_DEPLOYABLE_HEALTH_MUL, 1.50)
GM:AddSkillModifier(SKILL_MEDIUM_JUMP_BOOST,      			SKILLMOD_JUMPPOWER_MUL, 0.15)
GM:AddSkillModifier(SKILL_TURRET_RANGE_OVERLOAD,			SKILLMOD_TURRET_RANGE_MUL, 25)
GM:AddSkillModifier(SKILL_MELEE_RANGE_MEDIUM, 				SKILLMOD_MELEE_RANGE_MUL,  0.45)
GM:AddSkillModifier(SKILL_MELEE_KNOCKBACK_MEDIUM, 			SKILLMOD_MELEE_KNOCKBACK_MUL, 0.5)
GM:AddSkillModifier(SKILL_MELEE_DELAY_MEDIUM, 				SKILLMOD_MELEE_SWING_DELAY_MUL, -0.13)
GM:AddSkillModifier(SKILL_COMBO_FISTS, 						SKILLMOD_UNARMED_SWING_DELAY_MUL, -0.36)
GM:AddSkillModifier(SKILL_COMBO_FISTS, 						SKILLMOD_UNARMED_DAMAGE_MUL, 0.35)
GM:AddSkillModifier(SKILL_MEDIUM_COMBO_FISTS, 				SKILLMOD_UNARMED_SWING_DELAY_MUL, -0.36)
GM:AddSkillModifier(SKILL_MEDIUM_COMBO_FISTS, 				SKILLMOD_UNARMED_DAMAGE_MUL, 0.45)

GM:AddSkillModifier(SKILL_RESUPPLY_DISCOUNT_DELAY1,			SKILLMOD_RESUPPLY_DELAY_MUL, -0.02)
GM:AddSkillModifier(SKILL_RESUPPLY_DISCOUNT_DELAY2,			SKILLMOD_RESUPPLY_DELAY_MUL, -0.07)
GM:AddSkillModifier(SKILL_RESUPPLY_DISCOUNT_DELAY3,			SKILLMOD_RESUPPLY_DELAY_MUL, -0.13)
GM:AddSkillModifier(SKILL_RESUPPLY_DISCOUNT_DELAY4,			SKILLMOD_RESUPPLY_DELAY_MUL, -0.26)
-- End Line

-- Repair Cade Skill Tree
GM:AddSkillModifier(SKILL_SMALL_REPAIR1,				SKILLMOD_REPAIRRATE_MUL, 7)
GM:AddSkillModifier(SKILL_SMALL_REPAIR2,				SKILLMOD_REPAIRRATE_MUL, 11)
GM:AddSkillModifier(SKILL_SMALL_REPAIR3,				SKILLMOD_REPAIRRATE_MUL, 17)
GM:AddSkillModifier(SKILL_SMALL_REPAIR4,				SKILLMOD_REPAIRRATE_MUL, 25)
GM:AddSkillModifier(SKILL_SMALL_REPAIR5,				SKILLMOD_REPAIRRATE_MUL, 38)
GM:AddSkillModifier(SKILL_SMALL_REPAIR6,				SKILLMOD_REPAIRRATE_MUL, 58)
-- End Line
-- CustomTree--
GM:AddSkillModifier(SKILL_CUSTOM_HEALTH1, SKILLMOD_HEALTH, 3)
GM:AddSkillModifier(SKILL_CUSTOM_HEALTH2, SKILLMOD_HEALTH, 6)
GM:AddSkillModifier(SKILL_CUSTOM_HEALTH3, SKILLMOD_HEALTH, 12)
GM:AddSkillModifier(SKILL_CUSTOM_HEALTH4, SKILLMOD_HEALTH, 20)

GM:AddSkillModifier(SKILL_CUSTOM_SPEED1, SKILLMOD_SPEED, 3)
GM:AddSkillModifier(SKILL_CUSTOM_SPEED2, SKILLMOD_SPEED, 5)
GM:AddSkillModifier(SKILL_CUSTOM_SPEED3, SKILLMOD_SPEED, 7)
GM:AddSkillModifier(SKILL_CUSTOM_SPEED4, SKILLMOD_SPEED, 15)

GM:AddSkillModifier(SKILL_CUSTOM_MELEE1, SKILLMOD_MELEE_DAMAGE_MUL, 0.02)
GM:AddSkillModifier(SKILL_CUSTOM_MELEE2, SKILLMOD_MELEE_DAMAGE_MUL, 0.02)
GM:AddSkillModifier(SKILL_CUSTOM_MELEE3, SKILLMOD_MELEE_DAMAGE_MUL, 0.02)
GM:AddSkillModifier(SKILL_CUSTOM_MELEE4, SKILLMOD_MELEE_DAMAGE_MUL, 0.02)
GM:AddSkillModifier(SKILL_CUSTOM_MELEE5, SKILLMOD_MELEE_DAMAGE_MUL, 0.05)
GM:AddSkillModifier(SKILL_CUSTOM_MELEE6, SKILLMOD_MELEE_DAMAGE_MUL, 0.05)
GM:AddSkillModifier(SKILL_CUSTOM_MELEE7, SKILLMOD_MELEE_DAMAGE_MUL, 0.05)
GM:AddSkillModifier(SKILL_CUSTOM_MELEE8, SKILLMOD_MELEE_DAMAGE_MUL, 0.12)

GM:AddSkillModifier(SKILL_CUSTOM_BLOODARMOR1, SKILLMOD_BLOODARMOR, 2)
GM:AddSkillModifier(SKILL_CUSTOM_BLOODARMOR2, SKILLMOD_BLOODARMOR, 5)
GM:AddSkillModifier(SKILL_CUSTOM_BLOODARMOR3, SKILLMOD_BLOODARMOR, 8)
GM:AddSkillModifier(SKILL_CUSTOM_BLOODARMOR4, SKILLMOD_BLOODARMOR, 12)
GM:AddSkillModifier(SKILL_CUSTOM_BLOODARMOR5, SKILLMOD_BLOODARMOR, 14)


GM:AddSkillModifier(SKILL_CUSTOM_BLOODMELEE1, SKILLMOD_BLOODARMOR, 3)
GM:AddSkillModifier(SKILL_CUSTOM_BLOODMELEE1, SKILLMOD_MELEE_DAMAGE_MUL, 0.06)
GM:AddSkillModifier(SKILL_CUSTOM_BLOODMELEE2, SKILLMOD_BLOODARMOR, 4)
GM:AddSkillModifier(SKILL_CUSTOM_BLOODMELEE2, SKILLMOD_MELEE_DAMAGE_MUL, 0.09)
GM:AddSkillModifier(SKILL_CUSTOM_BLOODMELEE3, SKILLMOD_BLOODARMOR, 6)
GM:AddSkillModifier(SKILL_CUSTOM_BLOODMELEE3, SKILLMOD_MELEE_DAMAGE_MUL, 0.10)
GM:AddSkillModifier(SKILL_CUSTOM_BLOODMELEE4, SKILLMOD_BLOODARMOR, 7)
GM:AddSkillModifier(SKILL_CUSTOM_BLOODMELEE4, SKILLMOD_MELEE_DAMAGE_MUL, 0.12)
GM:AddSkillModifier(SKILL_CUSTOM_SMALL_COMBO_FISTS, SKILLMOD_UNARMED_DAMAGE_MUL, 0.25)
GM:AddSkillModifier(SKILL_CUSTOM_SMALL_COMBO_FISTS, SKILLMOD_UNARMED_SWING_DELAY_MUL, -0.15)
-- EndLine

-- Custom PointTree

-- EndLine

--EndLine


--Gun ReloadSpeed
GM:AddSkillModifier(SKILL_GUN_RELOAD1, SKILLMOD_RELOADSPEED_MUL, 0.01)
GM:AddSkillModifier(SKILL_GUN_RELOAD2, SKILLMOD_RELOADSPEED_MUL, 0.01)
GM:AddSkillModifier(SKILL_GUN_RELOAD3, SKILLMOD_RELOADSPEED_MUL, 0.015)
GM:AddSkillModifier(SKILL_GUN_RELOAD4, SKILLMOD_RELOADSPEED_MUL, 0.02)
GM:AddSkillModifier(SKILL_GUN_RELOAD5, SKILLMOD_RELOADSPEED_MUL, 0.03)
GM:AddSkillModifier(SKILL_GUN_RELOAD6, SKILLMOD_RELOADSPEED_MUL, 0.05)
GM:AddSkillModifier(SKILL_GUN_RELOAD7, SKILLMOD_RELOADSPEED_MUL, 0.065)
GM:AddSkillModifier(SKILL_GUN_RELOAD8, SKILLMOD_RELOADSPEED_MUL, 0.12)
--EndLine

GM:AddSkillModifier(SKILL_STOIC1, SKILLMOD_HEALTH, 1)
GM:AddSkillModifier(SKILL_STOIC2, SKILLMOD_HEALTH, 2)
GM:AddSkillModifier(SKILL_STOIC3, SKILLMOD_HEALTH, 4)
GM:AddSkillModifier(SKILL_STOIC4, SKILLMOD_HEALTH, 6)
GM:AddSkillModifier(SKILL_STOIC5, SKILLMOD_HEALTH, 7)

GM:AddSkillModifier(SKILL_VITALITY1, SKILLMOD_HEALTH, 1)
GM:AddSkillModifier(SKILL_VITALITY2, SKILLMOD_HEALTH, 1)
GM:AddSkillModifier(SKILL_VITALITY3, SKILLMOD_HEALTH, 1)

GM:AddSkillModifier(SKILL_MOTIONI, SKILLMOD_SPEED, 0.75)
GM:AddSkillModifier(SKILL_MOTIONII, SKILLMOD_SPEED, 0.75)
GM:AddSkillModifier(SKILL_MOTIONIII, SKILLMOD_SPEED, 0.75)

GM:AddSkillModifier(SKILL_FOCUS, SKILLMOD_AIMSPREAD_MUL, -0.03)
GM:AddSkillModifier(SKILL_FOCUS, SKILLMOD_RELOADSPEED_MUL, 0.03)

GM:AddSkillModifier(SKILL_FOCUSII, SKILLMOD_AIMSPREAD_MUL, -0.04)
GM:AddSkillModifier(SKILL_FOCUSII, SKILLMOD_RELOADSPEED_MUL, 0.04)

GM:AddSkillModifier(SKILL_FOCUSIII, SKILLMOD_AIMSPREAD_MUL, -0.05)
GM:AddSkillModifier(SKILL_FOCUSIII, SKILLMOD_RELOADSPEED_MUL, 0.05)

GM:AddSkillModifier(SKILL_ORPHICFOCUS, SKILLMOD_RELOADSPEED_MUL, -0.06)
GM:AddSkillModifier(SKILL_ORPHICFOCUS, SKILLMOD_AIMSPREAD_MUL, -0.02)

GM:AddSkillModifier(SKILL_DELIBRATION, SKILLMOD_AIMSPREAD_MUL, -0.01)

GM:AddSkillModifier(SKILL_WOOISM, SKILLMOD_IRONSIGHT_EFF_MUL, -0.25)

GM:AddSkillModifier(SKILL_GLUTTON, SKILLMOD_HEALTH, 5)

GM:AddSkillModifier(SKILL_TANKER, SKILLMOD_HEALTH, 20)

GM:AddSkillModifier(SKILL_ULTRANIMBLE, SKILLMOD_SPEED, 15)

GM:AddSkillModifier(SKILL_EGOCENTRIC, SKILLMOD_SELF_DAMAGE_MUL, -0.35)
GM:AddSkillModifier(SKILL_EGOCENTRIC, SKILLMOD_HEALTH, 5)

GM:AddSkillModifier(SKILL_BLASTPROOF, SKILLMOD_SELF_DAMAGE_MUL, -0.45)
GM:AddSkillModifier(SKILL_BLASTPROOF, SKILLMOD_RELOADSPEED_MUL, -0.07)
GM:AddSkillModifier(SKILL_BLASTPROOF, SKILLMOD_DEPLOYSPEED_MUL, -0.12)

GM:AddSkillModifier(SKILL_SURGEON1, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.08)
GM:AddSkillModifier(SKILL_SURGEON2, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.09)
GM:AddSkillModifier(SKILL_SURGEON3, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.10)
GM:AddSkillModifier(SKILL_SURGEONIV, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.11)

GM:AddSkillModifier(SKILL_BIOLOGYI, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.08)
GM:AddSkillModifier(SKILL_BIOLOGYII, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.09)
GM:AddSkillModifier(SKILL_BIOLOGYIII, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.1)
GM:AddSkillModifier(SKILL_BIOLOGYIV, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.11)
GM:AddSkillModifier(SKILL_BIOLOGYV, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.16)
GM:AddSkillModifier(SKILL_BIOLOGYIV, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.16)

GM:AddSkillModifier(SKILL_HANDY1, SKILLMOD_REPAIRRATE_MUL, 0.04)
GM:AddSkillModifier(SKILL_HANDY2, SKILLMOD_REPAIRRATE_MUL, 0.05)
GM:AddSkillModifier(SKILL_HANDY3, SKILLMOD_REPAIRRATE_MUL, 0.06)
GM:AddSkillModifier(SKILL_HANDY4, SKILLMOD_REPAIRRATE_MUL, 0.07)
GM:AddSkillModifier(SKILL_HANDY5, SKILLMOD_REPAIRRATE_MUL, 0.08)


GM:AddSkillModifier(SKILL_GOURMET, SKILLMOD_FOODEATTIME_MUL, 2.0)
GM:AddSkillModifier(SKILL_GOURMET, SKILLMOD_FOODRECOVERY_MUL, 1.0)

GM:AddSkillModifier(SKILL_SUGARRUSH, SKILLMOD_FOODRECOVERY_MUL, -0.35)

GM:AddSkillModifier(SKILL_BATTLER1, SKILLMOD_MELEE_DAMAGE_MUL, 0.04)
GM:AddSkillModifier(SKILL_BATTLER2, SKILLMOD_MELEE_DAMAGE_MUL, 0.05)
GM:AddSkillModifier(SKILL_BATTLER3, SKILLMOD_MELEE_DAMAGE_MUL, 0.05)
GM:AddSkillModifier(SKILL_BATTLER4, SKILLMOD_MELEE_DAMAGE_MUL, 0.06)
GM:AddSkillModifier(SKILL_BATTLER5, SKILLMOD_MELEE_DAMAGE_MUL, 0.07)

GM:AddSkillModifier(SKILL_JOUSTER, SKILLMOD_MELEE_DAMAGE_MUL, 0.1)
GM:AddSkillModifier(SKILL_JOUSTER, SKILLMOD_MELEE_KNOCKBACK_MUL, 1.0)

GM:AddSkillModifier(SKILL_QUICKDRAW, SKILLMOD_DEPLOYSPEED_MUL, 0.65)
GM:AddSkillModifier(SKILL_QUICKDRAW, SKILLMOD_RELOADSPEED_MUL, -0.15)

GM:AddSkillModifier(SKILL_QUICKRELOAD, SKILLMOD_RELOADSPEED_MUL, 0.10)
GM:AddSkillModifier(SKILL_QUICKRELOAD, SKILLMOD_DEPLOYSPEED_MUL, -0.25)

GM:AddSkillModifier(SKILL_SLEIGHTOFHAND, SKILLMOD_RELOADSPEED_MUL, 0.10)
GM:AddSkillModifier(SKILL_SLEIGHTOFHAND, SKILLMOD_AIMSPREAD_MUL, -0.05)

GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE1, SKILLMOD_RELOADSPEED_MUL, 0.02)
GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE1, SKILLMOD_DEPLOYSPEED_MUL, 0.02)

GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE2, SKILLMOD_RELOADSPEED_MUL, 0.03)
GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE2, SKILLMOD_DEPLOYSPEED_MUL, 0.03)

GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE3, SKILLMOD_RELOADSPEED_MUL, 0.04)
GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE3, SKILLMOD_DEPLOYSPEED_MUL, 0.04)

GM:AddSkillModifier(SKILL_PHASER, SKILLMOD_BARRICADE_PHASE_SPEED_MUL, 0.15)
GM:AddSkillModifier(SKILL_PHASER, SKILLMOD_SIGIL_TELEPORT_MUL, 0.15)

GM:AddSkillModifier(SKILL_DRIFT, SKILLMOD_BARRICADE_PHASE_SPEED_MUL, 0.05)

GM:AddSkillModifier(SKILL_WARP, SKILLMOD_SIGIL_TELEPORT_MUL, -0.05)

GM:AddSkillModifier(SKILL_HAMMERDISCIPLINE, SKILLMOD_HAMMER_SWING_DELAY_MUL, -0.1)
GM:AddSkillModifier(SKILL_HAMMERDISCIPLINE2, SKILLMOD_HAMMER_SWING_DELAY_MUL, -0.15)
GM:AddSkillModifier(SKILL_HAMMERDISCIPLINE3, SKILLMOD_HAMMER_SWING_DELAY_MUL, -0.05)
GM:AddSkillModifier(SKILL_BARRICADEEXPERT, SKILLMOD_HAMMER_SWING_DELAY_MUL, -0.3)

GM:AddSkillModifier(SKILL_SAFEFALL, SKILLMOD_FALLDAMAGE_DAMAGE_MUL, -0.4)
GM:AddSkillModifier(SKILL_SAFEFALL, SKILLMOD_FALLDAMAGE_RECOVERY_MUL, -0.5)
GM:AddSkillModifier(SKILL_SAFEFALL, SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL, -0.4)

GM:AddSkillModifier(SKILL_BACKPEDDLER, SKILLMOD_SPEED, -7)
GM:AddSkillFunction(SKILL_BACKPEDDLER, function(pl, active)
	pl.NoBWSpeedPenalty = active
end)


GM:AddSkillFunction(SKILL_TAUT, function(pl, active)
	pl.BuffTaut = active
end)

GM:AddSkillModifier(SKILL_BLOODARMOR, SKILLMOD_HEALTH, 13)

GM:AddSkillModifier(SKILL_HAEMOSTASIS, SKILLMOD_BLOODARMOR_DMG_REDUCTION, -0.25)

GM:AddSkillModifier(SKILL_REGENERATOR, SKILLMOD_HEALTH, 6)


GM:AddSkillFunction(SKILL_WOOISM, function(pl, active)
	pl.Wooism = active
end)

GM:AddSkillFunction(SKILL_ORPHICFOCUS, function(pl, active)
	pl.Orphic = active
end)

GM:AddSkillModifier(SKILL_WORTHINESS1, SKILLMOD_WORTH, 5)
GM:AddSkillModifier(SKILL_WORTHINESS2, SKILLMOD_WORTH, 5)
GM:AddSkillModifier(SKILL_WORTHINESS3, SKILLMOD_WORTH, 5)
GM:AddSkillModifier(SKILL_WORTHINESS4, SKILLMOD_WORTH, 5)

GM:AddSkillModifier(SKILL_KNUCKLEMASTER, SKILLMOD_UNARMED_SWING_DELAY_MUL, 0.35)
GM:AddSkillModifier(SKILL_KNUCKLEMASTER, SKILLMOD_UNARMED_DAMAGE_MUL, 0.75)

GM:AddSkillModifier(SKILL_CRITICALKNUCKLE, SKILLMOD_UNARMED_DAMAGE_MUL, 0.25)
GM:AddSkillModifier(SKILL_CRITICALKNUCKLE, SKILLMOD_UNARMED_SWING_DELAY_MUL, 0.25)

GM:AddSkillModifier(SKILL_SMARTTARGETING, SKILLMOD_MEDGUN_FIRE_DELAY_MUL, 0.75)
GM:AddSkillModifier(SKILL_SMARTTARGETING, SKILLMOD_MEDDART_EFFECTIVENESS_MUL, -0.3)

GM:AddSkillModifier(SKILL_RECLAIMSOL, SKILLMOD_MEDGUN_FIRE_DELAY_MUL, 1.5)
GM:AddSkillModifier(SKILL_RECLAIMSOL, SKILLMOD_MEDGUN_RELOAD_SPEED_MUL, -0.4)

GM:AddSkillModifier(SKILL_LANKY, SKILLMOD_MELEE_DAMAGE_MUL, 0.15)
GM:AddSkillModifier(SKILL_LANKY, SKILLMOD_MELEE_RANGE_MUL, 0.1)

GM:AddSkillModifier(SKILL_LANKYII, SKILLMOD_MELEE_DAMAGE_MUL, 0.15)
GM:AddSkillModifier(SKILL_LANKYII, SKILLMOD_MELEE_RANGE_MUL, 0.1)


GM:AddSkillModifier(SKILL_MASTERCHEF, SKILLMOD_MELEE_DAMAGE_MUL, 0.10)

GM:AddSkillModifier(SKILL_LIGHTWEIGHT, SKILLMOD_MELEE_DAMAGE_MUL, 0.2)

GM:AddSkillModifier(SKILL_AGILEI, SKILLMOD_JUMPPOWER_MUL, 0.04)

GM:AddSkillModifier(SKILL_AGILEII, SKILLMOD_JUMPPOWER_MUL, 0.05)

GM:AddSkillModifier(SKILL_AGILEIII, SKILLMOD_JUMPPOWER_MUL, 0.06)

GM:AddSkillModifier(SKILL_SOFTDET, SKILLMOD_EXP_DAMAGE_RADIUS, -0.10)
GM:AddSkillModifier(SKILL_SOFTDET, SKILLMOD_EXP_DAMAGE_TAKEN_MUL, -0.4)

GM:AddSkillModifier(SKILL_IRONBLOOD, SKILLMOD_BLOODARMOR_DMG_REDUCTION, 0.25)
GM:AddSkillModifier(SKILL_IRONBLOOD, SKILLMOD_BLOODARMOR_MUL, -0.5)

GM:AddSkillModifier(SKILL_BLOODLETTER, SKILLMOD_BLOODARMOR_GAIN_MUL, 1)

GM:AddSkillModifier(SKILL_SURESTEP, SKILLMOD_SPEED, 4)
GM:AddSkillModifier(SKILL_SURESTEP, SKILLMOD_SLOW_EFF_TAKEN_MUL, -0.35)

GM:AddSkillModifier(SKILL_INTREPID, SKILLMOD_SPEED, 4)
GM:AddSkillModifier(SKILL_INTREPID, SKILLMOD_LOW_HEALTH_SLOW_MUL, -0.35)

GM:AddSkillModifier(SKILL_UNBOUND, SKILLMOD_SPEED, 4)

GM:AddSkillModifier(SKILL_CHEAPKNUCKLE, SKILLMOD_MELEE_RANGE_MUL, 0.1)

GM:AddSkillModifier(SKILL_HEAVYSTRIKES, SKILLMOD_MELEE_KNOCKBACK_MUL, 1)

GM:AddSkillModifier(SKILL_CANNONBALL, SKILLMOD_PROJ_SPEED, -0.25)
GM:AddSkillModifier(SKILL_CANNONBALL, SKILLMOD_PROJECTILE_DAMAGE_MUL, 0.03)

GM:AddSkillModifier(SKILL_CONEFFECT, SKILLMOD_EXP_DAMAGE_RADIUS, -0.2)
GM:AddSkillModifier(SKILL_CONEFFECT, SKILLMOD_EXP_DAMAGE_MUL, 0.05)

GM:AddSkillModifier(SKILL_CARDIOTONIC, SKILLMOD_SPEED, 12)
GM:AddSkillModifier(SKILL_CARDIOTONIC, SKILLMOD_BLOODARMOR_DMG_REDUCTION, -0.2)

GM:AddSkillFunction(SKILL_SCOURER, function(pl, active)
	pl.Scourer = active
end)

GM:AddSkillModifier(SKILL_DISPERSION, SKILLMOD_CLOUD_RADIUS, 0.15)
GM:AddSkillModifier(SKILL_DISPERSION, SKILLMOD_CLOUD_TIME, -0.1)

GM:AddSkillModifier(SKILL_BRASH, SKILLMOD_MELEE_SWING_DELAY_MUL, -0.16)
GM:AddSkillModifier(SKILL_BRASH, SKILLMOD_MELEE_MOVEMENTSPEED_ON_KILL, -15)

GM:AddSkillModifier(SKILL_CIRCULATION, SKILLMOD_BLOODARMOR, 1)

GM:AddSkillModifier(SKILL_SANGUINE, SKILLMOD_BLOODARMOR, 11)
GM:AddSkillModifier(SKILL_SANGUINE, SKILLMOD_HEALTH, 9)

GM:AddSkillModifier(SKILL_SANGUINE1, SKILLMOD_BLOODARMOR, 20)

GM:AddSkillModifier(SKILL_ANTIGEN, SKILLMOD_BLOODARMOR_DMG_REDUCTION, 0.05)
GM:AddSkillModifier(SKILL_ANTIGEN, SKILLMOD_HEALTH, 3)

GM:AddSkillModifier(SKILL_INSTRUMENTS, SKILLMOD_TURRET_RANGE_MUL, 0.05)

GM:AddSkillModifier(SKILL_LEVELHEADED, SKILLMOD_AIM_SHAKE_MUL, -0.05)

GM:AddSkillModifier(SKILL_ROBUST, SKILLMOD_WEAPON_WEIGHT_SLOW_MUL, -0.06)

GM:AddSkillModifier(SKILL_TAUT, SKILLMOD_PROP_CARRY_SLOW_MUL, -0.4)

GM:AddSkillModifier(SKILL_TURRETOVERLOAD, SKILLMOD_TURRET_RANGE_MUL, 0.3)

GM:AddSkillFunction(SKILL_STOWAGE, function(pl, active)
	pl.Stowage = active
end)

GM:AddSkillFunction(SKILL_TRUEWOOISM, function(pl, active)
	pl.TrueWooism = active
end)
