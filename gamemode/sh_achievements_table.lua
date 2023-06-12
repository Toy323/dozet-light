GM.Achievements = {}
local translate = translate.Get



GM.Achievements["1to1"] = {
    Name = translate("challenge_1to1"),
    Desc = translate("challenge_1to1_d"),
    Reward = 61000
}

GM.Achievements["tanked"] = {
    Name = translate("challenge_tanked"),
    Desc = translate("challenge_tanked_d"),
    Goal = 10000,
    Reward = 8000
}


-- Cache count, to not call table.Count again
GM.AchievementsCount = table.Count(GM.Achievements)
-- Lol just, im too lazy for other file
GM.Statuses = {}
local function statusValueFunction(statusname)
	return function(self, lp)
		if !lp:IsValid() then return end
		local status = lp:GetStatus(statusname)
		if status and status:IsValid() then
			return math.max(status:GetStartTime() + status:GetDuration() - CurTime(), 0)
		end

		return 0
	end
end
GM.Statuses["poison"] = {
	Color = Color(180, 200, 0),
	Name = "poison",
	ValFunc = function(self, lp)
		return lp:GetPoisonDamage()
	end,
	Max = GM.MaxPoisonDamage or 1000,
	Icon = Material("zombiesurvival/poison.png")
}
GM.Statuses["bleed"] = {
	Color = Color(220, 0, 0),
	Name = "bleed",
	ValFunc = function(self, lp)
		return lp:GetBleedDamage()
	end,
    ValFunc2 = function(self, lp)
		return (lp:GetBleedDamage() * 0.01 >= 1 and lp:GetBleedDamage() * 0.01 or 1)
	end,
	Max = GM.MaxBleedDamage or 50,
	Icon = Material("zombiesurvival/bleed.png")
}
GM.Statuses["enfeeble"] = {
	Color = Color(255, 50, 50),
	Name = "enfeeb",
	ValFunc = statusValueFunction("enfeeble"),
	Max = 10,
	Icon = Material("zombiesurvival/infeeble.png")
}
GM.Statuses["dimvision"] = {
	Color = Color(90, 90, 90),
	Name = "dim_vision",
	ValFunc = statusValueFunction("dimvision"),
	Max = 10,
	Icon = Material("zombiesurvival/dim_vision.png")
}
GM.Statuses["world"] = {
	Color = Color(112, 247, 108),
	Name = "world",
	ValFunc = statusValueFunction("world"),
	Max = 30,
	Icon = Material("zombiesurvival/dim_vision.png")
}
GM.Statuses["slow"] = {
	Color = Color(75, 140, 75),
	Name = "slow",
	ValFunc = statusValueFunction("slow"),
	Max = 8,
	Icon = Material("zombiesurvival/slow.png")
}
GM.Statuses["speed"] = {
	Color = Color(75, 255, 0),
	Name = "speed",
	ValFunc = statusValueFunction("speed"),
	Max = 100,
	Icon = Material("zombiesurvival/slow.png")
}
GM.Statuses["frost"] = {
	Color = Color(0, 135, 255),
	Name = "frost",
	ValFunc = statusValueFunction("frost"),
	Max = 9,
	Icon = Material("zombiesurvival/frost.png")
}
GM.Statuses["frightened"] = {
	Color = Color(155, 0, 255),
	Name = "frightened",
	ValFunc = statusValueFunction("frightened"),
	Max = 10,
	Icon = Material("zombiesurvival/tremors.png")
}
GM.Statuses["sickness"] = {
	Color = Color(255, 120, 0),
	Name = "sickness",
	ValFunc = statusValueFunction("sickness"),
	Max = 15,
	Icon = Material("zombiesurvival/sickness.png")
}
GM.Statuses["burn"] =  {
	Color = Color(255, 120, 0),
	Name = "burned",
	ValFunc = statusValueFunction("burn"),
	Max = 600,
	Icon = Material("zombiesurvival/burn.png")
}
GM.Statuses["knockdown"] =  {
	Color = Color(157, 75, 20),
	Name = "knockdown",
	ValFunc = statusValueFunction("knockdown"),
	Max = 5,
	Icon = Material("zombiesurvival/knock_down.png")
}
GM.Statuses["strengthdartboost"] =   {
	Color = Color(200, 100, 90),
	Name = "strength",
	ValFunc = statusValueFunction("strengthdartboost"),
	Max = 10,
	Icon = Material("zombiesurvival/strength_shot.png")
}
GM.Statuses["resnya"] =   {
	Color = Color(199, 52, 39),
	Name = "resnya",
	ValFunc = statusValueFunction("resnya"),
	Max = 10,
	Icon = Material("zombiesurvival/strength_shot.png")
}
GM.Statuses["sticky"] =   {
	Color = Color(35, 190, 15),
	Name = "sticky",
	ValFunc = statusValueFunction("sticky"),
	Max = 7,
	Icon = Material("zombiesurvival/strength_shot.png")
}
GM.Statuses["adrenalineamp"] = {
	Color = Color(170, 200, 120),
	Name = "adrenaline",
	ValFunc = statusValueFunction("adrenalineamp"),
	Max = 10,
	Icon = Material("zombiesurvival/speed_up.png")
}
GM.Statuses["keyboard"] = {
	Color = Color(170, 0, 120),
	Name = "keyboard",
	ValFunc = statusValueFunction("keyboard"),
	Max = 20,
	Icon = Material("zombiesurvival/speed_up.png")
}
GM.Statuses["holly"] =  {
	Color = Color(255, 255, 255),
	Name = "holly",
	ValFunc = statusValueFunction("holly"),
	Max = 20,
	Icon = Material("zombiesurvival/cursed.png")
}
GM.Statuses["healdartboost"] = {
	Color = Color(130, 220, 110),
	Name = "speed",
	ValFunc = statusValueFunction("healdartboost"),
	Max = 10,
	Icon = Material("zombiesurvival/speed_up.png")
}
GM.Statuses["medrifledefboost"] =  {
	Color = Color(90, 120, 220),
	Name = "defence",
	ValFunc = statusValueFunction("medrifledefboost"),
	Max = 10,
	Icon = Material("zombiesurvival/defense.png")
}
GM.Statuses["sigildef"] =  {
	Color = Color(136, 6, 97),
	Name = "sigildef",
	ValFunc = statusValueFunction("sigildef"),
	Max = 3,
	Icon = Material("zombiesurvival/defense.png")
}
GM.Statuses["reaper"] = {
	Color = Color(130, 30, 140),
	Name = "reaper",
	ValFunc = statusValueFunction("reaper"),
	Max = 14,
	Icon = Material("zombiesurvival/reaper.png")
}
GM.Statuses["parasitoid"] = {
	Color = Color(238, 139, 247),
	Name = "parasitoid",
	ValFunc = statusValueFunction("parasitoid"),
	Max = 14,
	Icon = Material("zombiesurvival/reaper.png")
}
GM.Statuses["renegade"] = {
	Color = Color(235, 160, 40),
	Name = "renegade",
	ValFunc = statusValueFunction("renegade"),
	Max = 14,
	Icon = Material("zombiesurvival/headshot_stacks.png")
}
GM.Statuses["bloodlust"] =  {
	Color = Color(255, 0, 0),
	Name = "bloodlust",
	ValFunc = statusValueFunction("bloodlust"),
	Max = 10,
	Icon = Material("zombiesurvival/bleed.png")
}
GM.Statuses["bloodrage"] =  {
	Color = Color(120, 0, 0),
	Name = "bloodrage",
	ValFunc = statusValueFunction("bloodrage"),
	Max = 6,
	Icon = Material("zombiesurvival/bleed.png")
}
GM.Statuses["cursed"] =  {
	Color = Color(100, 100, 100),
	Name = "curse",
	ValFunc = statusValueFunction("cursed"),
	Max = GM.MaxCurse or 100,
	Icon = Material("zombiesurvival/cursed.png")
}
GM.Statuses["rot"] = {
	Color = Color(255, 150, 150),
	Name = "rot",
	ValFunc = statusValueFunction("rot"),
	Max = GM.MaxRotDamage or 100,
	Icon = Material("zombiesurvival/rot.png")
}
GM.Statuses["hollowing"] = {
	Color = Color(100, 100, 100),
	Name = "hollowing",
	ValFunc = statusValueFunction("hollowing"),
	Max = 1000,
	Icon = Material("zombiesurvival/hallow.png")
}
GM.Statuses["hshield"] =	{
	Color = Color(255, 255, 255),
	Name = "mantle",
	ValFunc = statusValueFunction("hshield"),
	Max = 1,
	Icon = Material("zombiesurvival/defense.png")
}
GM.Statuses["target"] =	{
	Color = Color(209, 40, 40),
	Name = "target",
	ValFunc = statusValueFunction("target"),
	Max = 10,
	Icon = Material("zombiesurvival/headshot_stacks.png")
}
GM.Statuses["death"] =	{
	Color = Color(209, 40, 40),
	Name = "death",
	ValFunc = statusValueFunction("death"),
	Max = 100,
	Icon = Material("zombiesurvival/reaper.png")
}
GM.Statuses["unreal"] =	{
	Color = Color(247, 228, 63),
	Name = "unreal",
	ValFunc = statusValueFunction("unreal"),
	Max = 14,
	Icon = Material("zombiesurvival/reaper.png")
}
GM.Statuses["flimsy"] =	{
	Color = Color(39, 8, 124),
	Name = "flimsy",
	ValFunc = statusValueFunction("flimsy"),
	Max = 25,
	Icon = Material("zombiesurvival/sickness.png")
}
GM.Statuses["portal"] =	{
	Color = Color(156, 40, 209),
	Name = "portal",
	ValFunc = statusValueFunction("portal"),
	Max = 25,
	Icon = Material("zombiesurvival/rot.png")
}
GM.Statuses["dimvision_unknown"] = {
	Color = Color(255, 255, 255),
	Name = "unknown",
	ValFunc = statusValueFunction("dimvision_unknown"),
	Max = 14,
	Icon = Material("zombiesurvival/dim_vision.png"),
}
GM.Statuses["bloodysickness"] = {
	Color = Color(255, 0, 0),
	Name = "bloodysickness",
	ValFunc = statusValueFunction("bloodysickness"),
	Max = 15,
	Icon = Material("zombiesurvival/sickness.png")
}
GM.Statuses["chains"] = {
	Color = Color(54, 73, 220),
	Name = "chains",
	ValFunc = statusValueFunction("chains"),
	Max = 10,
	Icon = Material("zombiesurvival/defense.png")
}