INVCAT_TRINKETS = 1
INVCAT_COMPONENTS = 2
INVCAT_CONSUMABLES = 3
INVCAT_WEAPONS = 4

GM.ZSInventoryItemData = {}
GM.ZSInventoryCategories = {
	[INVCAT_TRINKETS] = translate.Get("vgui_trin"),
	[INVCAT_COMPONENTS] =  translate.Get("vgui_comp"),
	[INVCAT_CONSUMABLES] = translate.Get("vgui_cons"),
	[INVCAT_WEAPONS] = translate.Get("vgui_weap")
}
GM.ZSInventoryPrefix = {
	[INVCAT_TRINKETS] = "trin",
	[INVCAT_COMPONENTS] = "comp",
	[INVCAT_CONSUMABLES] = "cons",
	[INVCAT_WEAPONS] = "weap"
}

GM.Assemblies = {}
GM.TakeItem = {}
GM.Breakdowns = {}

function GM:GetInventoryItemType(item)
	--print(type(item))
--	if type(item) == "Weapon" then
		--item = item:GetClass()
	--end
	for typ, aff in pairs(self.ZSInventoryPrefix) do
		if string.sub(item, 1, 4) == aff then
			return typ
		end
	end

	return -1
end

local index = 1
function GM:AddInventoryItemData(intname, name, description, weles, tier, stocks, icon, bounty, b2)
	local datatab = {PrintName = name, DroppedEles = weles, Tier = tier, Description = description, Stocks = stocks, Index = index, Icon = icon, Bounty = bounty, BountyNeed = b2}
	self.ZSInventoryItemData[intname] = datatab
	self.ZSInventoryItemData[index] = datatab

	index = index + 1
end


local trs = translate.Get
local function funcofvoid(pl, nouse)
	local use = {}
	for item,v in pairs(pl:GetInventoryItems()) do
		local g = table.HasValue(string.Explode("_",item), "curse")
		if item ~= nouse and string.len(item) >= 7 and !g then
			table.insert(use, #use + 1,item)
		end
	end
	if #use <= 1 then return end
	local toeat = table.Random(use)
	local use2 = {}
	for item,v in pairs(GAMEMODE.ZSInventoryItemData) do
		local g = table.HasValue(string.Explode("_",item), "curse")
		if item ~= nouse and (GAMEMODE.ZSInventoryItemData[item].Tier or 1) == (GAMEMODE.ZSInventoryItemData[toeat].Tier or 1) and string.len(item) >= 7 and !g then
			table.insert(use2, #use2 + 1,item)
		end
	end
	if #use2 <= 1 then return end
	pl:TakeInventoryItem(toeat)
	local gived = table.Random(use2)
	pl:AddInventoryItem(gived)
	net.Start("zs_trinketcorrupt")
		net.WriteString(toeat)
		net.WriteString(gived)
	net.Send(pl)
end
local function funcofd1(pl, nouse)
	local use = {}
	for item,v in pairs(pl:GetInventoryItems()) do
		if item ~= nouse and string.len(item) >= 7  then
			table.insert(use, #use + 1,item)
		end
		
	end
	if #use <= 1 then return end
	local toeat = table.Random(use)
	local use2 = {}
	for item,v in pairs(GAMEMODE.ZSInventoryItemData) do
		if item ~= nouse and (GAMEMODE.ZSInventoryItemData[item].Tier or 1) == (GAMEMODE.ZSInventoryItemData[toeat].Tier or 1) and string.len(item) >= 7 then
			table.insert(use2, #use2 + 1,item)
		end
	end
	if #use2 <= 1 then return end
	
	local gived = table.Random(use2)
	if table.HasValue(string.Explode("_",toeat), "curse") then
		local g = GAMEMODE.Curses[math.random(1,#GAMEMODE.Curses)]
		pl:AddInventoryItem(g)
		net.Start("zs_invitem")
			net.WriteString(g)
		net.Send(pl)
	elseif math.random(1,10) ~= 1 then
		pl:AddInventoryItem(toeat)
		net.Start("zs_invitem")
		net.WriteString(toeat)
	net.Send(pl)
	else
		pl:AddInventoryItem(gived)
		net.Start("zs_invitem")
		net.WriteString(gived)
	net.Send(pl)
	end

end
GM:AddInventoryItemData("cons_void",		trs("c_void"),			trs("c_void_d"),								"models/props_c17/trappropeller_lever.mdl", 3, nil, nil, function(pl) 
	funcofvoid(pl, "cons_void")
end,3)
GM:AddInventoryItemData("cons_xmas_goodness",		trs("c_new_year"),			trs("c_new_year_d"),								"models/props_c17/trappropeller_lever.mdl", 3, nil, nil, function(pl) 
	local droped = ents.Create("prop_gift")
	droped:SetPos(pl:GetPos()+Vector(0,0,70))
	droped:Spawn()
end,1)
GM:AddInventoryItemData("cons_bounty",		trs("c_bounty"),			trs("c_bounty_d"),								"models/props_c17/trappropeller_lever.mdl", 3, nil, nil, function(pl) 
	local tbl = {"headshoter", "ind_buffer", "ultra_at", "pearl","broken_world","whysoul","altevesoul"} 
	if pl.MedicalBounty then
		tbl = GAMEMODE.MedPremium
	end
	local need = pl.SeededBounty or {}
	while #need < 3 do
		local item = tbl[math.random(1,#tbl)]
		if !table.HasValue(need,item) then 
			need[#need+1] = item
		end
		if #need > 2 then
			break
		end
	end
	pl.SeededBounty = need
	net.Start("zs_upgradeitem")
	net.WriteTable(need)
	net.Send(pl)
end,0)
GM:AddInventoryItemData("cons_wildcard",		trs("c_wildcard"),			trs("c_wildcard_d"),								"models/props_c17/trappropeller_lever.mdl", 4, nil, nil, function(pl) 
	local lcall = pl.LastCall or "cons_void"
	local callback = GAMEMODE.ZSInventoryItemData[lcall].Bounty
	local n = 1
	if math.random(1,20) == 5 then
		n = 3
	end
	for i=1,n do
		timer.Simple(i*0.1, function()
			local uses = GAMEMODE.ZSInventoryItemData[lcall].BountyNeed*0.5*(pl.ChargesUse or 1)
			if pl:HasInventoryItem(lcall) and callback and uses <= pl:GetChargesActive() then
				callback(pl)
				if pl:IsSkillActive(SKILL_DOUBLE) and math.random(1,4) == 1 then
					uses = 0
				end
				pl:SetChargesActive(pl:GetChargesActive()-uses)
				if n == 2 then
					pl:TakeInventoryItem("cons_wildcard")
				end
			end
		end)
	end
end,0)
GM:AddInventoryItemData("cons_flame_p",		trs("c_flame_p"),			trs("c_flame_p_d"),								"models/props_c17/trappropeller_lever.mdl", 1, nil, nil, function(pl) 
	if pl:HasWeapon("weapon_zs_molotov") then pl:GiveAmmo(1, "molotov") return end
	pl:Give("weapon_zs_molotov")
end,3)
GM:AddInventoryItemData("cons_black_hole",		trs("c_bhole"),			trs("c_bhole_d"),								"models/props_c17/trappropeller_lever.mdl", 3, nil, nil, function(pl) 
	local droped = ents.Create("projectile_succubus_test")
	droped:SetPos(pl:GetPos()+Vector(0,0,70))
	droped:Spawn()
	droped:SetOwner(pl)
	--droped:SetParent(pl)
end,4)
GM:AddInventoryItemData("cons_d4",		"D4",			trs("c_d4_d"),								 {
	["d4_p1"] = { type = "Model", model = "models/phxtended/trieq2x2x2solid.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-2.435, 2.438, -4.36), angle = Angle(0, 0, 0), size = Vector(0.123, 0.123, 0.123), color = Color(13, 116, 0, 255), surpresslightning = true, material = "plastic/plasticwall001a", skin = 0, bodygroup = {} },
	["d4_p1+"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.114, -4.167, -4.41), angle = Angle(0, 0, 0), size = Vector(0.223, 0.223, 0), color = Color(27, 51, 24, 255), surpresslightning = true, material = "plastic/plasticwall001a", skin = 0, bodygroup = {} },
	["d4_p1++"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.37, 2.911, -2.547), angle = Angle(0, 0, 0), size = Vector(0.223, 0, 0.223), color = Color(27, 51, 24, 255), surpresslightning = true, material = "plastic/plasticwall001a", skin = 0, bodygroup = {} },
	["d4_p1+++"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.791, 2.61, 1.556), angle = Angle(0, 0, 0), size = Vector(0.223, 0, 0.223), color = Color(27, 51, 24, 255), surpresslightning = true, material = "plastic/plasticwall001a", skin = 0, bodygroup = {} },
	["d4_p1++++"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-2.881, -1.172, -0.716), angle = Angle(0, 0, 0), size = Vector(0, 0.323, 0.323), color = Color(27, 51, 24, 255), surpresslightning = true, material = "plastic/plasticwall001a", skin = 0, bodygroup = {} },
	["d4_p1+++++"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.389, -0.009, -4.41), angle = Angle(0, 0, 0), size = Vector(0.223, 0.223, 0), color = Color(27, 51, 24, 255), surpresslightning = true, material = "plastic/plasticwall001a", skin = 0, bodygroup = {} },
	["d4_p1++++++"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.32, -4.983, -1.441), angle = Angle(0, 0, 0), size = Vector(0.223, 0.223, 0.223), color = Color(27, 51, 24, 255), surpresslightning = true, material = "plastic/plasticwall001a", skin = 0, bodygroup = {} },
	["d4_p1+++++++"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.087, -0.071, -4.577), angle = Angle(0, 0, 0), size = Vector(0.223, 0.223, 0), color = Color(27, 51, 24, 255), surpresslightning = true, material = "plastic/plasticwall001a", skin = 0, bodygroup = {} },
	["d4_p1++++++++"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.785, -2.728, 2.274), angle = Angle(0, 0, 0), size = Vector(0.223, 0.223, 0.223), color = Color(27, 51, 24, 255), surpresslightning = true, material = "plastic/plasticwall001a", skin = 0, bodygroup = {} },
	["d4_p1+++++++++"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.131, -1.581, -1.363), angle = Angle(0, 0, 0), size = Vector(0.223, 0.223, 0.223), color = Color(27, 51, 24, 255), surpresslightning = true, material = "plastic/plasticwall001a", skin = 0, bodygroup = {} },
	["d4_p1++++++++++"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.973, -1.118, 1.82), angle = Angle(0, 0, 0), size = Vector(0.223, 0.223, 0.223), color = Color(27, 51, 24, 255), surpresslightning = true, material = "plastic/plasticwall001a", skin = 0, bodygroup = {} }
}, 3, nil, nil, function(pl) 
	for i=1,10 do
		funcofvoid(pl, "cons_d4")
	end
end,12)
GM:AddInventoryItemData("cons_d1",		"D1",			trs("c_d1_d"),								"models/props_c17/trappropeller_lever.mdl", 3, nil, nil, function(pl) 
	funcofd1(pl, "cons_d1")
end,4)
GM:AddInventoryItemData("cons_gausscard",		trs("c_gausscard"),			trs("c_gausscard_d"),								"models/props_c17/trappropeller_lever.mdl", 3, nil, nil, function(pl) 
	pl:Give("weapon_zs_gauss_card_r5")
	timer.Simple(10, function() pl:StripWeapon("weapon_zs_gauss_card_r5") end)
end,10)
GM:AddInventoryItemData("cons_sack_of_trinkets",		trs("c_sack_of_trinkets"),			trs("c_sack_of_trinkets_d"),								"models/props_c17/trappropeller_lever.mdl", 3, nil, nil, function(pl)
	local use2 = {} 
	for item,v in pairs(GAMEMODE.ZSInventoryItemData) do
		local g = table.HasValue(string.Explode("_",item), "curse")
		if item ~= nouse and !pl:HasInventoryItem(item) and string.len(item) >= 5 and !g and  (GAMEMODE.ZSInventoryItemData[item].Tier or 1) <= 3 then
			table.insert(use2, #use2 + 1,item)
		end
	end
	local bl = table.Random(use2)
	pl:AddInventoryItem(bl)
	net.Start("zs_invitem")
		net.WriteString(bl)
	net.Send(pl)
end,10)
GM:AddInventoryItemData("cons_friendship",		trs("c_friendship"),			trs("c_friendship_d"),								"models/props_c17/trappropeller_lever.mdl", 1, nil, nil, function(pl) 
	local humans = team.GetPlayers(TEAM_HUMAN)
	local tabled = {}
	local count = 0
	
	for i = 1, #humans do
	  local human = humans[i]
	  if human:Health() < human:GetMaxHealth() then
		tabled[count] = human
		count = count + 1
	  end
	end
	
	if count < 1 then return end
	
	local healed = NULL
	for i = 1, 2 do
	  local index = math.random(count)
	  local heal = tabled[index]
	
	  if healed == heal then
		tabled[index] = tabled[count]
		tabled[count] = nil
		count = count - 1
	
		index = math.random(count)
		heal = tabled[index]
	  end
	
	  if heal and heal:IsValid() then
		healed = heal
		pl:HealPlayer(heal, 20)
		heal:SetBloodArmor(heal.MaxBloodArmor + 20)
		if pl ~= heal then
		  pl:AddPoints(2)
		end
	  end
	end
end,2)
GM:AddInventoryItemData("cons_chaos",		trs("c_chaos"),			trs("c_chaos_d"),								"models/props_c17/trappropeller_lever.mdl", 3, nil, nil, function(pl) 
	local use2 = {}
	if pl.UsesChaosCard then pl:AddChargesActive(5) return end
	for item,v in pairs(GAMEMODE.ZSInventoryItemData) do
		if item ~= "cons_chaos" and item ~= "cons_wildcard" and GAMEMODE.ZSInventoryItemData[item].Bounty and GAMEMODE.ZSInventoryItemData[item].BountyNeed and string.len(item) >= 3 then
			table.insert(use2, #use2 + 1,item)
		end
	end
	pl.UsesChaosCard = true
	for i=1,5 do
		local trinket = table.Random(use2)
		net.Start("zs_t_activated")
		net.WriteString(trinket)
	net.Send(pl)
		local callback = GAMEMODE.ZSInventoryItemData[trinket].Bounty
		callback(pl)
		--print(trinket)
	end
end,5)
GM:AddInventoryItemData("cons_dust",		trs("c_dust"),			trs("c_dust_d"),								"models/props_c17/trappropeller_lever.mdl", 1, nil, nil, function(pl) 
	pl:GiveStatus("portal",10)
end,2)
GM:AddInventoryItemData("cons_pill_unk",		trs("c_pill"),			trs("c_pill_d"),								"models/props_c17/trappropeller_lever.mdl", 2, nil, nil, function(pl) 
	if math.random(1,3) ~= 1 then
		pl:TakeDamage(pl:Health()*0.25, pl, pl) 
	else 
		local melee = (pl:GetActiveWeapon() and pl:GetActiveWeapon().IsMelee or false)
		local ammo = (!melee and pl:GetResupplyAmmoType() or "scrap")
		pl:GiveAmmo((melee and 5 or 20),ammo) 
	end
end,2)
GM:AddInventoryItemData("cons_mantle",		trs("c_mantle"),			trs("c_mantle_d"),								"models/props_c17/trappropeller_lever.mdl", 2, nil, nil, function(pl) 
	pl.HolyMantle = pl.HolyMantle+1
end,3)
GM:AddInventoryItemData("cons_necronomicon",		trs("c_necronomicon"),			trs("c_necronomicon_d"),								"models/props_c17/trappropeller_lever.mdl", 2, nil, nil, function(pl) 
	for k,v in pairs(team.GetPlayers(TEAM_UNDEAD)) do
		timer.Simple(0.3, function() v:TakeSpecialDamage(250,DMG_DIRECT,pl,pl) end)
		pl:EmitSound("ambient/atmosphere/thunder1.wav", 50, 500, 0.5)
	end
	if math.random(1,100) <= 10 then pl:TakeInventoryItem("cons_necronomicon") pl:AddInventoryItem("cons_necronomicon_broke") end
end,2)
GM:AddInventoryItemData("cons_necronomicon_broke",		trs("c_necronomicon"),			trs("c_necronomicon_broke_d"),								"models/props_c17/trappropeller_lever.mdl", 2, nil, nil, function(pl) 
	local z = 0
	for k,v in pairs(team.GetPlayers(TEAM_UNDEAD)) do
		if z >= 3 then break end
		if !(v:GetZombieClassTable().Boss or v:GetZombieClassTable().DemiBoss) then
			timer.Simple(0.1, function() v:TakeSpecialDamage(250,DMG_DIRECT,pl,pl) end)
			z = z + 1
			pl:EmitSound("ambient/atmosphere/thunder1.wav", 50, 500, 0.5)
		end
	end
	if math.random(1,100) <= 10 then pl:TakeInventoryItem("cons_necronomicon_broke") end
end,1)
GM:AddInventoryItemData("cons_timer",		trs("c_timer"),			trs("c_timer_d"),								"models/props_c17/trappropeller_lever.mdl", 3, nil, nil, function(pl) 
	if GAMEMODE.ObjectiveMap then return end
	gamemode.Call(
		gamemode.Call( "GetWaveActive" ) and "SetWaveEnd" or "SetWaveStart",
		(gamemode.Call( "GetWaveActive" )  and gamemode.Call( "GetWaveEnd" ) or  gamemode.Call( "GetWaveStart" )) + (math.random(1,5) == 5 and -25 or 25)
	)
end,6)
GM:AddInventoryItemData("comp_key",		trs("c_key"),			trs("c_key_d"),								"models/props_c17/trappropeller_lever.mdl",6)
GM:AddInventoryItemData("comp_modbarrel",		trs("c_modbarrel"),			trs("c_modbarrel_d"),								"models/props_c17/trappropeller_lever.mdl")
GM:AddInventoryItemData("comp_burstmech",		trs("c_burstmech"),			trs("c_burstmech_d"),										"models/props_c17/trappropeller_lever.mdl")
GM:AddInventoryItemData("comp_basicecore",		trs("c_basicecore"),		trs("c_basicecore_d"),	"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_busthead",		trs("c_busthead"),			trs("c_busthead_d"),								"models/props_combine/breenbust.mdl")
GM:AddInventoryItemData("comp_sawblade",		trs("c_sawblade"),			trs("c_sawblade_d"),								"models/props_junk/sawblade001a.mdl")
GM:AddInventoryItemData("comp_propanecan",		trs("c_propanecan"),		trs("c_propanecan_d"),				"models/props_junk/propane_tank001a.mdl")
GM:AddInventoryItemData("comp_electrobattery",	trs("c_electrobattery"),	trs("c_electrobattery_d"),								"models/items/car_battery01.mdl")
GM:AddInventoryItemData("comp_hungrytether",	"Hungry Tether",			"A hungry tether from a devourer that comes from a devourer rib.",								"models/gibs/HGIBS_rib.mdl")
GM:AddInventoryItemData("comp_contaecore",		trs("c_contaecore"),	trs("c_contaecore_d"),							"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_pumpaction",		trs("c_pumpaction"),	trs("c_pumpaction_d"),										"models/props_c17/trappropeller_lever.mdl")
GM:AddInventoryItemData("comp_focusbarrel",		trs("c_focusbarrel"),		trs("c_focusbarrel_d"),		"models/props_c17/trappropeller_lever.mdl")
GM:AddInventoryItemData("comp_gaussframe",		"Gauss Frame",				"A highly advanced gauss frame. It's almost alien in design, making it hard to use.",			"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_metalpole",		"Metal Pole",				"Long metal pole that could be used to attack things from a distance.",							"models/props_c17/signpole001.mdl")
GM:AddInventoryItemData("comp_salleather",		"Salvaged Leather",			"Pieces of leather that are hard enough to make a nasty impact.",								"models/props_junk/shoe001.mdl")
GM:AddInventoryItemData("comp_gyroscope",		"Gyroscope",				"A metal gyroscope used to calculate orientation.",												"models/maxofs2d/hover_rings.mdl")
GM:AddInventoryItemData("comp_reciever",		trs("c_reciever"),					trs("c_reciever_d"),					"models/props_lab/reciever01b.mdl")
GM:AddInventoryItemData("comp_cpuparts",		trs("c_cpuparts"),				trs("c_cpuparts_d"),																"models/props_lab/harddrive01.mdl")
GM:AddInventoryItemData("comp_launcher",		trs("c_launcher"),			trs("c_launcher_d"),															"models/weapons/w_rocket_launcher.mdl")
GM:AddInventoryItemData("comp_launcherh",		trs("c_launcherh"),		trs("c_launcherh_d"),												"models/weapons/w_rocket_launcher.mdl")
GM:AddInventoryItemData("comp_shortblade",		trs("c_shortblade"),				trs("c_shortblade_d"),												"models/weapons/w_knife_t.mdl")
GM:AddInventoryItemData("comp_multibarrel",		trs("c_multibarrel"),		trs("c_multibarrel_d"),							"models/props_lab/pipesystem03a.mdl")
GM:AddInventoryItemData("comp_holoscope",		trs("c_holoscope"),		trs("c_holoscope_d"),												{
	["base"] = { type = "Model", model = "models/props_c17/utilityconnecter005.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.273, 1.728, -0.843), angle = Angle(74.583, 180, 0), size = Vector(2.207, 0.105, 0.316), color = Color(50, 50, 66, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} },
	["base+"] = { type = "Model", model = "models/props_c1ombine/tprotato1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.492, -1.03, 0), angle = Angle(0, -78.715, 90), size = Vector(0.03, 0.02, 0.032), color = Color(50, 50, 66, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} }
})
GM:AddInventoryItemData("comp_scoper",		"Scopy",		"Heh for classix.",												{
	["base"] = { type = "Model", model = "models/props_c17/utilityconnecter005.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.273, 1.728, -0.843), angle = Angle(74.583, 180, 0), size = Vector(2.207, 0.105, 0.316), color = Color(50, 50, 66, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} },
	["base+"] = { type = "Model", model = "models/props_combine/tprotato1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.492, -1.03, 0), angle = Angle(0, -78.715, 90), size = Vector(0.03, 0.02, 0.032), color = Color(50, 50, 66, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} }
})
local soulrec = {
	["black_core_2"] = { type = "Sprite", sprite = "effects/splashwake3", bone = "ValveBiped.Bip01_R_Hand", rel = "black_core", pos = Vector(0, 0.1, -0.201), size = { x = 7.697, y = 7.697 }, color = Color(255, 255, 0), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["black_core_2+"] = { type = "Sprite", sprite = "effects/splashwake1", bone = "ValveBiped.Bip01_R_Hand", rel = "black_core", pos = Vector(0, 0.1, -0.201), size = { x = 10, y = 10 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["black_core"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, 0), angle = Angle(0, 0, 0), size = Vector(0.349, 0.349, 0.349), color = Color(167, 23, 167), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }
}
GM:AddInventoryItemData("comp_linearactuator",	"Linear Actuator",			"A linear actuator from a shell holder. Requires a heavy base to mount properly.",				"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_pulsespool",		"Pulse Spool",				"Used to inject more pulse power to a system. Could be used to stabilise something.",			"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_flak",			"Flak Chamber",				"An internal chamber for projecting heated scrap.",												"models/weapons/w_rocket_launcher.mdl")
GM:AddInventoryItemData("comp_precision",		"Precision Chassis",		"A suite setup for rewarding precise shots on moving targets.",									"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_mommy",		"Mommy",		"Mom from Cryman.",									"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_sacred_soul",		"Sacred Soul",		"This sacred cartridge...",									"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_bloodhack",		"Bloody Hack",		"djasnndwhadjajs||daw...",									"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_ticket",		trs("c_ticket"),		trs("c_ticket_d"),									"models/props_c17/paper01.mdl")
--Осколки душ
GM:AddInventoryItemData("comp_soul_hack",		"Piece of soul(HACK)",		"Blank soul of hacks things", soulrec)
GM:AddInventoryItemData("comp_soul_melee",		"Piece of soul(MELEE)",		"Blank soul of melee things", soulrec)
GM:AddInventoryItemData("comp_soul_status",		"Piece of soul(STATUS)",		"Blank soul of status things", soulrec)
GM:AddInventoryItemData("comp_soul_health",		"Piece of soul(HEALTH)",		"Blank soul of health things", soulrec)
GM:AddInventoryItemData("comp_soul_alt_h",		"Piece of soul(ALTERNATIVE HEALTH)",		"Blank soul of ALT health things", soulrec)
GM:AddInventoryItemData("comp_soul_godlike",		"Piece of soul(GOD LIKE)",		"Blank soul of GODLIKE! things", soulrec)
GM:AddInventoryItemData("comp_soul_dosei",		"Piece of soul(DOSEI)",		"Blank soul of dosei things", soulrec)
GM:AddInventoryItemData("comp_soul_dd",		"Piece of soul(BIG MANS)",		"Blank soul of big mans things", soulrec)
GM:AddInventoryItemData("comp_soul_booms",		"Piece of soul(BOOMS)",		"Blank soul of booms things", soulrec)

GM:AddInventoryItemData("comp_soul_emm",		"Piece of Anti-Sigil",		"Ermmmm", soulrec)
GM:AddInventoryItemData("comp_soul_emm2",		"Piece of sigil???",		"Worth", soulrec)
GM:AddInventoryItemData("comp_soul_emm3",		"*23LskdNhx3796SDhnHadj",		"27^39j4nHndk0890-2=23+3nH\nsjDnhfgjgyrjb", soulrec)

-- Trinkets
local trinket, description, trinketwep
local hpveles = {
	["ammo"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 3.5, 3), angle = Angle(15.194, 80.649, 180), size = Vector(0.6, 0.6, 1.2), color = Color(145, 132, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local hpweles = {
	["ammo"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.5, 2.5, 3), angle = Angle(15.194, 80.649, 180), size = Vector(0.6, 0.6, 1.2), color = Color(145, 132, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local ammoveles = {
	["ammo"] = { type = "Model", model = "models/props/de_prodigy/ammo_can_02.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 3, -0.519), angle = Angle(0, 85.324, 101.688), size = Vector(0.25, 0.25, 0.25), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local ammoweles = {
	["ammo"] = { type = "Model", model = "models/props/de_prodigy/ammo_can_02.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 2, -1.558), angle = Angle(5.843, 82.986, 111.039), size = Vector(0.25, 0.25, 0.25), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local mveles = {
	["band++"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "band", pos = Vector(2.599, 1, 1), angle = Angle(0, -25, 0), size = Vector(0.019, 0.15, 0.15), color = Color(55, 52, 51, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["band"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 3, -1), angle = Angle(97.013, 29.221, 0), size = Vector(0.045, 0.045, 0.025), color = Color(55, 52, 51, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["band+"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "band", pos = Vector(-2.401, -1, 0.5), angle = Angle(0, 155.455, 0), size = Vector(0.019, 0.15, 0.15), color = Color(55, 52, 51, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} }
}
local mweles = {
	["band++"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "band", pos = Vector(2.599, 1, 1), angle = Angle(0, -25, 0), size = Vector(0.019, 0.15, 0.15), color = Color(55, 52, 51, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["band+"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "band", pos = Vector(-2.401, -1, 0.5), angle = Angle(0, 155.455, 0), size = Vector(0.019, 0.15, 0.15), color = Color(55, 52, 51, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["band"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.5, 2, -0.5), angle = Angle(111.039, -92.338, 97.013), size = Vector(0.045, 0.045, 0.025), color = Color(55, 52, 51, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} }
}
local pveles = {
	["perf"] = { type = "Model", model = "models/props_combine/combine_lock01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 1.557, -2.597), angle = Angle(5.843, 90, 0), size = Vector(0.25, 0.15, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local pweles = {
	["perf"] = { type = "Model", model = "models/props_combine/combine_lock01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 0.5, -2), angle = Angle(5, 90, 0), size = Vector(0.25, 0.15, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local oveles = {
	["perf"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.799, 2, -1.5), angle = Angle(5, 180, 0), size = Vector(0.05, 0.039, 0.07), color = Color(196, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local oweles = {
	["perf"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.799, 2, -1.5), angle = Angle(5, 180, 0), size = Vector(0.05, 0.039, 0.07), color = Color(196, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local develes = {
	["perf"] = { type = "Model", model = "models/props_lab/blastdoor001b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.799, 2.5, -5.715), angle = Angle(5, 180, 0), size = Vector(0.1, 0.039, 0.09), color = Color(168, 155, 0, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal", skin = 0, bodygroup = {} }
}
local deweles = {
	["perf"] = { type = "Model", model = "models/props_lab/blastdoor001b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 2, -5.715), angle = Angle(0, 180, 0), size = Vector(0.1, 0.039, 0.09), color = Color(168, 155, 0, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal", skin = 0, bodygroup = {} }
}
local supveles = {
	["perf"] = { type = "Model", model = "models/props_lab/reciever01c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.299, 2.5, -2), angle = Angle(5, 180, 92.337), size = Vector(0.2, 0.699, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local supweles = {
	["perf"] = { type = "Model", model = "models/props_lab/reciever01c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1.5, -2), angle = Angle(5, 180, 92.337), size = Vector(0.2, 0.699, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local book = {
	["perf"] = { type = "Model", model = "models/props_lab/binderblue.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1.5, -2), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local bookw = {
	["perf"] = { type = "Model", model = "models/props_lab/binderblue.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1.5, -2), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
-- some text
trinket, trinketwep = GM:AddTrinket(trs("t_lticket"), "lotteryticket", false, hpveles, hpweles, 2, trs("t_d_lticket"), nil, nil, "weapon_zs_special_trinket")
trinketwep.PermitDismantle = true
trinket, trinketwep = GM:AddTrinket(trs("t_mticket"), "mysteryticket", false, hpveles, hpweles, 5, trs("t_d_mticket"), nil, nil, "weapon_zs_special_trinket")
trinketwep.PermitDismantle = true
-- Health Trinkets

trinket, trinketwep = GM:AddTrinket(trs("t_gasmask"), "gasmask", false, hpveles, hpweles, 4, trs("t_d_gasmask"), nil, nil, "weapon_zs_special_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_POISON_DAMAGE_TAKEN_MUL, -0.1)
trinket, trinketwep = GM:AddTrinket(trs("t_healthpack"), "vitpackagei", false, hpveles, hpweles, 2, trs("t_d_healthpack"), nil, nil, "weapon_zs_defence_trinket_d")
GM:AddSkillModifier(trinket, SKILLMOD_HEALTH, 10)
GM:AddSkillModifier(trinket, SKILLMOD_HEALING_RECEIVED, 0.09)
trinketwep.PermitDismantle = true

GM:AddTrinket(trs("t_bloodgrass"), "bloodgrass", false, hpveles, hpweles, 4, trs("t_d_bloodgrass"), nil, nil, "weapon_zs_defence_trinket_d")
GM:AddTrinket(trs("t_antidevo"), "antidevo", false, hpveles, hpweles, 2, trs("t_d_antidevo"), nil, nil, "weapon_zs_defence_trinket_d")


GM:AddTrinket(trs("t_acum"), "acum", false, nil, "models/items/car_battery01.mdl", 5, trs("t_d_acum"), nil, nil, "weapon_zs_special_trinket")

trinket = GM:AddTrinket(trs("t_vbank"), "vitpackageii", false, hpveles, hpweles, 2, trs("t_d_vbank"), nil, nil, "weapon_zs_defence_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_HEALTH, 20)
GM:AddSkillModifier(trinket, SKILLMOD_BLOODARMOR_DMG_REDUCTION, -0.03)

trinket = GM:AddTrinket(trs("t_truepill"), "pills", false, hpveles, hpweles, 2, trs("t_d_truepill"), nil, 15, "weapon_zs_melee_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_HEALTH, 10)
GM:AddSkillModifier(trinket, SKILLMOD_HEALING_RECEIVED, 0.11)
--trinket = GM:AddTrinket("Damage", "damage222", false, hpveles, hpweles, 4, "+10% damage melee ")
--GM:AddWeaponModifier(trinket, WEAPON_MODIFIER_DAMAGE, 3)

trinket = GM:AddTrinket(trs("t_a_flower"), "a_flower", false, hpveles, hpweles, 5, trs("t_d_a_flower"), nil, 15, "weapon_zs_melee_trinket")

trinket = GM:AddTrinket(trs("t_richeye"), "greedeye", false, hpveles, hpweles, 3, trs("t_d_richeye"), nil, nil, "weapon_zs_special_trinket", {[1] = {
	["children"] = {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Skin"] = 0,
						["UniqueID"] = "62f09606e93a91ba4c42b4f77cfe4c0458874690b0103bd13e71fb2e47dea9f9",
						["NoLighting"] = false,
						["AimPartName"] = "",
						["IgnoreZ"] = false,
						["AimPartUID"] = "",
						["Materials"] = "",
						["Name"] = "cube025x025x025",
						["LevelOfDetail"] = 0,
						["NoTextureFiltering"] = false,
						["PositionOffset"] = Vector(1.5, 0, 0),
						["IsDisturbing"] = false,
						["EyeAngles"] = false,
						["DrawOrder"] = 0,
						["TargetEntityUID"] = "",
						["Alpha"] = 1,
						["Material"] = "models/debug/debugwhite",
						["Invert"] = false,
						["ForceObjUrl"] = false,
						["Bone"] = "head",
						["Angles"] = Angle(0, 0, 0),
						["AngleOffset"] = Angle(0, 0, 0),
						["BoneMerge"] = false,
						["Color"] = Vector(1, 1, 0),
						["Position"] = Vector(0, 0.80000001192093, 0.12999999523163),
						["ClassName"] = "model2",
						["Brightness"] = 0.6,
						["Hide"] = false,
						["NoCulling"] = false,
						["Scale"] = Vector(10.39999961853, 0.20000000298023, 0.80000001192093),
						["LegacyTransform"] = false,
						["EditorExpand"] = false,
						["Size"] = 0.025,
						["ModelModifiers"] = "",
						["Translucent"] = false,
						["BlendMode"] = "",
						["EyeTargetUID"] = "",
						["Model"] = "models/hunter/blocks/cube025x025x025.mdl",
					},
				},
			},
			["self"] = {
				["Skin"] = 0,
				["UniqueID"] = "dd8f0a0dd9a0fde373e4c04a14e0e7bd423e01745e99332ddfd985bdf9b3dacc",
				["NoLighting"] = false,
				["AimPartName"] = "",
				["IgnoreZ"] = false,
				["AimPartUID"] = "",
				["Materials"] = "",
				["Name"] = "",
				["LevelOfDetail"] = 0,
				["NoTextureFiltering"] = false,
				["PositionOffset"] = Vector(0, 0, 0),
				["IsDisturbing"] = false,
				["EyeAngles"] = false,
				["DrawOrder"] = 0,
				["TargetEntityUID"] = "",
				["Alpha"] = 1,
				["Material"] = "",
				["Invert"] = false,
				["ForceObjUrl"] = false,
				["Bone"] = "eyes",
				["Angles"] = Angle(90, 180, 180),
				["AngleOffset"] = Angle(0, 0, 0),
				["BoneMerge"] = false,
				["Color"] = Vector(1, 1, 0),
				["Position"] = Vector(1.1000000238419, 1.5, 0),
				["ClassName"] = "model2",
				["Brightness"] = 3,
				["Hide"] = false,
				["NoCulling"] = false,
				["Scale"] = Vector(0.69999998807907, 0.69999998807907, 3),
				["LegacyTransform"] = false,
				["EditorExpand"] = true,
				["Size"] = 0.025,
				["ModelModifiers"] = "",
				["Translucent"] = false,
				["BlendMode"] = "",
				["EyeTargetUID"] = "",
				["Model"] = "models/props_phx/construct/glass/glass_angle360.mdl",
			},
		},
	},
	["self"] = {
		["DrawOrder"] = 0,
		["UniqueID"] = "fac50a0ad260b8caa8cd5fa308a13bd2e41e45d2996d038a18ce7e5e1604f0e1",
		["Hide"] = false,
		["TargetEntityUID"] = "",
		["EditorExpand"] = true,
		["OwnerName"] = "self",
		["IsDisturbing"] = false,
		["Name"] = "dsadasdada2",
		["Duplicate"] = false,
		["ClassName"] = "group",
	},
}})
GM:AddSkillModifier(trinket, SKILLMOD_ENDWAVE_POINTS, 20)
GM:AddSkillModifier(trinket, SKILLMOD_ARSENAL_DISCOUNT, 0.05)

trinket = GM:AddTrinket(trs("t_bara"), "classil", true, hpveles, hpweles, 4, trs("t_d_bara"), nil, nil, "weapon_zs_shot_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_HEALTH, 60)
GM:AddSkillModifier(trinket, SKILLMOD_BLOODARMOR_DMG_REDUCTION, 0.09)
GM:AddSkillModifier(trinket, SKILLMOD_HEALING_RECEIVED, -5)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, -0.35)

trinket, trinketwep = GM:AddTrinket(trs("t_bloodpack"), "bloodpack", false, hpveles, hpweles, 2, trs("t_d_bloodpack"), nil, 15, "weapon_zs_defence_trinket_d")
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket(trs("t_bloodpacki"), "cardpackagei", false, hpveles, hpweles, 2, trs("t_d_bloodpacki"), nil, nil, "weapon_zs_defence_trinket_d")
GM:AddSkillModifier(trinket, SKILLMOD_BLOODARMOR, 20)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, 0.07)
trinketwep.PermitDismantle = true

trinket = GM:AddTrinket(trs("t_bloodpackii"), "cardpackageii", false, hpveles, hpweles, 3, trs("t_d_bloodpackii"), nil, nil, "weapon_zs_defence_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_BLOODARMOR, 20)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, 0.12)

GM:AddTrinket(trs("t_regimp"), "regenimplant", false, hpveles, hpweles, 3, trs("t_d_regimp"), nil, nil, "weapon_zs_defence_trinket")
GM:AddTrinket(trs("t_longgrip"), "longgrip", false, hpveles, hpweles, 3, trs("t_d_longgrip"), nil, nil, "weapon_zs_melee_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_RANGE_MUL, 0.10)

trinket, trinketwep = GM:AddTrinket(trs("t_bioclean"), "biocleanser", false, hpveles, hpweles, 2, trs("t_d_bioclean"), nil, nil, "weapon_zs_special_trinket")
trinketwep.PermitDismantle = true

GM:AddSkillModifier(GM:AddTrinket(trs("t_cutset"), "cutlery", false, hpveles, hpweles, nil, trs("t_d_cutset"), nil, nil, "weapon_zs_defence_trinket", "Lol"), SKILLMOD_FOODEATTIME_MUL, -0.8)
trinket, trinketwep = GM:AddTrinket(trs("t_killer"), "killer", false, hpveles, hpweles, 2, trs("t_d_killer"), nil, nil, "weapon_zs_melee_trinket_d")
GM:AddSkillModifier(trinket, SKILLMOD_BLOODARMOR, 110)
GM:AddSkillModifier(trinket, SKILLMOD_HEALTH, -50)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, 0.37)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, 0.50)
GM:AddSkillModifier(trinket, SKILLMOD_BLOODARMOR_DMG_REDUCTION, 0.21)
trinketwep.PermitDismantle = true
trinket, trinketwep = GM:AddTrinket("Status", "via", false, hpveles, hpweles, 2, "Vera Via,bloodoarmoro +50", nil, nil, "weapon_zs_melee_trinket_d")
GM:AddSkillModifier(trinket, SKILLMOD_BLOODARMOR, 50)
trinket, trinketwep = GM:AddTrinket("Status", "via1", false, hpveles, hpweles, 2, "Vera Via,bloodoarmoro +30", nil, nil, "weapon_zs_melee_trinket_d")
GM:AddSkillModifier(trinket, SKILLMOD_BLOODARMOR, 30)
trinket, trinketwep = GM:AddTrinket("Status", "via2", false, hpveles, hpweles, 2, "Vera Via,bloodoarmoro +40", nil, nil, "weapon_zs_melee_trinket_d")
GM:AddSkillModifier(trinket, SKILLMOD_BLOODARMOR, 40)
trinket, trinketwep = GM:AddTrinket("Status", "via3", false, hpveles, hpweles, 2, "Vera Via,bloodoarmoro +10", nil, nil, "weapon_zs_melee_trinket_d")
GM:AddSkillModifier(trinket, SKILLMOD_BLOODARMOR, 10)

--test

-- Hohol
trinket, trinketwep = GM:AddTrinket("Сало", "salo", false, mveles, mweles, 2, "Доигрались хохлы?")

trinketwep.PermitDismantle = true
-- Melee Trinkets

description = trs("t_d_box")
trinket = GM:AddTrinket(trs("t_box"), "boxingtraining", false, mveles, mweles, nil, description, nil, nil, "weapon_zs_melee_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_UNARMED_SWING_DELAY_MUL, -0.25)
GM:AddSkillFunction(trinket, function(pl, active) pl.BoxingTraining = active end)

trinket, trinketwep = GM:AddTrinket(trs("t_momentsup"), "momentumsupsysii", false, mveles, mweles, 2, trs("t_d_momentsup"), nil, nil, "weapon_zs_melee_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_SWING_DELAY_MUL, -0.09)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_KNOCKBACK_MUL, 0.10)
trinketwep.PermitDismantle = true

trinket = GM:AddTrinket(trs("t_momentsupi"), "momentumsupsysiii", false, mveles, mweles, 3, trs("t_d_momentsupi"), nil, nil, "weapon_zs_melee_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_SWING_DELAY_MUL, -0.13)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_KNOCKBACK_MUL, 0.12)

GM:AddSkillModifier(GM:AddTrinket(trs("t_hemoad"), "hemoadrenali", false, mveles, mweles, nil, trs("t_d_hemoad"), nil, nil, "weapon_zs_melee_trinket"), SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, 0.06)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, 0.02)

trinket = GM:AddTrinket(trs("t_hemoadi"), "hemoadrenalii", false, mveles, mweles, 3, trs("t_d_hemoadi"), nil, nil, "weapon_zs_melee_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, 0.13)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_MOVEMENTSPEED_ON_KILL, 44)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, 0.05)

trinket = GM:AddTrinket(trs("t_termia"), "flashlo", false, mveles, mweles, 3, trs("t_d_termia"), nil, nil, "weapon_zs_melee_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, 0.08)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, 0.07)
GM:AddSkillModifier(trinket, SKILLMOD_SPEED, 55)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_MOVEMENTSPEED_ON_KILL, 55)

GM:AddSkillModifier(GM:AddTrinket(trs("t_hemoadii"), "hemoadrenaliii", false, mveles, mweles, 4, trs("t_d_hemoadii"), nil, nil, "weapon_zs_melee_trinket"), SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, 0.22)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, 0.04)
GM:AddSkillModifier(GM:AddTrinket(trs("t_athermia"), "sharpkt", false, mveles, mweles, 4, trs("t_d_athermia"), nil, nil, "weapon_zs_melee_trinket"), SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, -0.09)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.05)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, -0.08)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_MOVEMENTSPEED_ON_KILL, -280)

GM:AddSkillModifier(GM:AddTrinket(trs("t_gaunt"), "powergauntlet", false, mveles, mweles, 3, trs("t_d_gaunt"), nil, nil, "weapon_zs_melee_trinket"), SKILLMOD_MELEE_POWERATTACK_MUL, 0.45)

GM:AddSkillModifier(GM:AddTrinket(trs("t_fkit"), "sharpkit", false, mveles, mweles, 2, trs("t_d_fkit"), nil, nil, "weapon_zs_melee_trinket"), SKILLMOD_MELEE_DAMAGE_MUL, 0.05)


GM:AddTrinket(trs("t_skit"), "sharpstone", false, mveles, mweles, 3, trs("t_d_skit"), nil, nil, "weapon_zs_melee_trinket")
local cursesoul = { ["black_core_2"] = { type = "Sprite", sprite = "effects/splashwake3", bone = "ValveBiped.Bip01_R_Hand", rel = "black_core", pos = Vector(0, 0.1, -0.201), size = { x = 10.697, y = 10.697 }, color = Color(139,0,255,150), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["black_core_2+"] = { type = "Sprite", sprite = "effects/splashwake1", bone = "ValveBiped.Bip01_R_Hand", rel = "black_core", pos = Vector(0, 0.1, -0.201), size = { x = 30, y = 30 }, color = Color(139,0,255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["black_core"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, 0), angle = Angle(0, 0, 0), size = Vector(0.349, 0.349, 0.349), color = Color(139,0,255, 100), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }}


--perfomance
GM:AddSkillModifier(GM:AddTrinket( trs("t_adrenaline"), "adrenaline", false, pveles, pweles, nil, trs("t_d_adrenaline"), nil, nil, "weapon_zs_special_trinket"), SKILLMOD_JUMPPOWER_MUL, 0.01)
GM:AddSkillModifier(GM:AddTrinket( trs("t_ass"), "ass", false, pveles, pweles, nil,  trs("t_d_ass"), nil, nil, "weapon_zs_special_trinket"), SKILLMOD_HEALTH, 6)
GM:AddSkillModifier(trinket, SKILLMOD_AIMSPREAD_MUL, 0.02)
trinket = GM:AddTrinket(trs("t_sarmband"), "supraband", false, pveles, pweles, 1, trs("t_d_sarmband"), nil, nil, "weapon_zs_special_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_JUMPPOWER_MUL, 0.04)
trinket = GM:AddTrinket("Engineer Gaming", "engineer", false, pveles, pweles, 1, trs("t_d_egaming"), nil, nil, "weapon_zs_special_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_DEPLOYABLE_PACKTIME_MUL, 0.12)
trinket = GM:AddTrinket("Scout Gaming", "scout", false, pveles, pweles, 2, trs("t_d_sgaming"), nil, nil, "weapon_zs_special_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_SPEED, 10)
trinket = GM:AddTrinket(trs("t_bhammer"), "brokenhammer", false, pveles, pweles, 3, trs("t_d_bhammer"), nil, nil, "weapon_zs_special_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_POINT_MULTIPLIER, -0.05)
GM:AddSkillModifier(trinket, SKILLMOD_REPAIRRATE_MUL,  0.10)

trinket = GM:AddTrinket(trs("t_flower"), "flower", false, pveles, pweles, 3, trs("t_d_flower"), nil, nil, "weapon_zs_special_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_POINT_MULTIPLIER, 0.50)
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.5)
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.5)


trinket = GM:AddTrinket(trs("t_flower_g"), "flower_g", false, pveles, pweles, 3, trs("t_d_flower_g"), nil, nil, "weapon_zs_special_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_POINT_MULTIPLIER, 1)

-- Special Trinkets
GM:AddTrinket(trs("t_otank"), "oxygentank", true, nil, {
	["base"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 3, -1), angle = Angle(180, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}, nil, trs("t_d_otank"), "oxygentank", nil, nil, "weapon_zs_special_trinket")

GM:AddSkillModifier(GM:AddTrinket(trs("t_aframe"), "acrobatframe", false, pveles, pweles, nil, trs("t_d_aframe"), nil, nil, "weapon_zs_special_trinket"), SKILLMOD_JUMPPOWER_MUL, 0.08)

trinket = GM:AddTrinket(trs("t_nightglass"), "nightvision", true, pveles, pweles, 2, trs("t_d_nightglass"), nil, nil, "weapon_zs_special_trinket_d")
GM:AddSkillModifier(trinket, SKILLMOD_DIMVISION_EFF_MUL, -0.20)
GM:AddSkillModifier(trinket, SKILLMOD_FRIGHT_DURATION_MUL, -0.20)
GM:AddSkillModifier(trinket, SKILLMOD_VISION_ALTER_DURATION_MUL, -0.2)
GM:AddSkillFunction(trinket, function(pl, active)
	if CLIENT and pl == MySelf and GAMEMODE.m_NightVision and not active then
		surface.PlaySound("items/nvg_off.wav")
		GAMEMODE.m_NightVision = false
	end
end)
trinketwep.PermitDismantle = true

trinket = GM:AddTrinket(trs("t_whole"), "portablehole", false, pveles, pweles, nil, trs("t_d_whole"), nil, nil, "weapon_zs_special_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_DEPLOYSPEED_MUL, 0.15)
GM:AddSkillModifier(trinket, SKILLMOD_RELOADSPEED_MUL, 0.03)
GM:AddSkillModifier(trinket, SKILLMOD_ARSENAL_DISCOUNT, -0.01)

trinket = GM:AddTrinket(trs("t_agility"), "pathfinder", false, pveles, pweles, 2, trs("t_d_agility"), nil, nil, "weapon_zs_special_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_BARRICADE_PHASE_SPEED_MUL, 0.55)
GM:AddSkillModifier(trinket, SKILLMOD_SIGIL_TELEPORT_MUL, -0.45)
GM:AddSkillModifier(trinket, SKILLMOD_JUMPPOWER_MUL, 0.1)

trinket = GM:AddTrinket(trs("t_store"), "store", false, pveles, pweles, 2, trs("t_d_store"), nil, nil, "weapon_zs_special_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_ARSENAL_DISCOUNT, -0.04)
trinket = GM:AddTrinket(trs("t_ustore"), "superstore", false, pveles, pweles, 2, trs("t_d_ustore"), nil, nil, "weapon_zs_special_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_ARSENAL_DISCOUNT, -0.05)
trinket = GM:AddTrinket(trs("t_credit"), "store2", false, pveles, pweles, 2, trs("t_d_credit"), nil, nil, "weapon_zs_special_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_ARSENAL_DISCOUNT, -0.03)

trinket = GM:AddTrinket(trs("t_galvanka"), "analgestic", false, pveles, pweles, 3, trs("t_d_galvanka"), nil, nil, "weapon_zs_special_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_SLOW_EFF_TAKEN_MUL, -0.50)
GM:AddSkillModifier(trinket, SKILLMOD_LOW_HEALTH_SLOW_MUL, -0.50)
GM:AddSkillModifier(trinket, SKILLMOD_KNOCKDOWN_RECOVERY_MUL, -0.20)
GM:AddSkillModifier(trinket, SKILLMOD_DEPLOYSPEED_MUL, 0.25)
trinket = GM:AddTrinket(trs("t_invalid"), "invalid", false, pveles, pweles, 3, trs("t_d_invalid"), nil, nil, "weapon_zs_craftables")
GM:AddSkillModifier(trinket, SKILLMOD_KNOCKDOWN_RECOVERY_MUL, -0.5)

trinket = GM:AddTrinket(trs("t_credit2"), "kre", false, pveles, pweles, 3, trs("t_d_credit2"), nil, nil, "weapon_zs_special_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_ARSENAL_DISCOUNT, -0.04)

GM:AddSkillModifier(GM:AddTrinket(trs("t_ammovesti"), "ammovestii", false, ammoveles, ammoweles, 2, trs("t_d_ammovesti"), nil, nil, "weapon_zs_shot_trinket"), SKILLMOD_RELOADSPEED_MUL, 0.07)
GM:AddSkillModifier(GM:AddTrinket(trs("t_ammovestii"), "ammovestiii", false, ammoveles, ammoweles, 4, trs("t_d_ammovestii"), nil, nil, "weapon_zs_shot_trinket"), SKILLMOD_RELOADSPEED_MUL, 0.11)
GM:AddSkillModifier(GM:AddTrinket(trs("t_ammovestiiii"), "sammovest", false, ammoveles, ammoweles, 4, trs("t_d_ammovestinf"), nil, nil, "weapon_zs_shot_trinket"), SKILLMOD_RELOADSPEED_MUL, 0.16)
GM:AddSkillModifier(GM:AddTrinket(trs("t_ammovestiii"), "classix", false, book, bookw, 4,trs("t_d_ammovestinf"), nil, nil, "weapon_zs_shot_trinket"), SKILLMOD_RELOADSPEED_MUL, 0.16)

GM:AddTrinket(trs("t_autor"), "autoreload", false, ammoveles, ammoweles, 2, trs("t_d_autor"), nil, nil, "weapon_zs_shot_trinket")
GM:AddTrinket(trs("t_gg_nomi"), "gg_nomi", false, ammoveles, ammoweles, 4, trs("t_d_gg_nomi"), nil, nil, "weapon_zs_shot_trinket")

-- Offensive Implants
GM:AddSkillModifier(GM:AddTrinket(trs("t_targeti"), "targetingvisori", false, oveles, oweles, nil, trs("t_d_targeti"), nil, nil, "weapon_zs_shot_trinket"), SKILLMOD_AIMSPREAD_MUL, -0.06)

GM:AddSkillModifier(GM:AddTrinket(trs("t_targetii"), "targetingvisoriii", false, oveles, oweles, 4, trs("t_d_targetii"), nil, nil, "weapon_zs_shot_trinket"), SKILLMOD_AIMSPREAD_MUL, -0.11)

GM:AddTrinket(trs("t_targetiii"), "refinedsub", false, oveles, oweles, 4, trs("t_d_targetiii"), nil, nil, "weapon_zs_shot_trinket")

trinket = GM:AddTrinket(trs("t_targetiiii"), "aimcomp", false, oveles, oweles, 3, trs("t_d_targetiiii"), nil, nil, "weapon_zs_shot_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_AIMSPREAD_MUL, -0.11)
GM:AddSkillModifier(trinket, SKILLMOD_AIM_SHAKE_MUL, -0.52)
GM:AddSkillFunction(trinket, function(pl, active) pl.TargetLocus = active end)

GM:AddSkillModifier(GM:AddTrinket(trs("t_pulsebooster"), "pulseampi", false, oveles, oweles, nil, trs("t_d_pulsebooster"), nil, nil, "weapon_zs_shot_trinket"), SKILLMOD_PULSE_WEAPON_SLOW_MUL, 0.14)

trinket = GM:AddTrinket(trs("t_pulseboosteri"), "pulseampii", false, oveles, oweles, 3, trs("t_d_pulseboosteri"), nil, nil, "weapon_zs_shot_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_PULSE_WEAPON_SLOW_MUL, 0.2)
GM:AddSkillModifier(trinket, SKILLMOD_EXP_DAMAGE_RADIUS, 0.22)

trinket = GM:AddTrinket(trs("t_pboom"), "resonance", false, oveles, oweles, 4, trs("t_d_pboom"), nil, nil, "weapon_zs_shot_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_PULSE_WEAPON_SLOW_MUL, -0.11)

trinket = GM:AddTrinket(trs("t_cryoinductor"), "cryoindu", false, oveles, oweles, 4, trs("t_d_cryoinductor"), nil, nil, "weapon_zs_shot_trinket")

trinket = GM:AddTrinket(trs("t_extendedmag"), "extendedmag", false, oveles, oweles, 3, trs("t_d_extendedmag"), nil, nil, "weapon_zs_shot_trinket")

trinket = GM:AddTrinket(trs("t_pulseboosterii"), "pulseimpedance", false, oveles, oweles, 5, trs("t_d_pulseboosterii"), nil, nil, "weapon_zs_shot_trinket")
GM:AddSkillFunction(trinket, function(pl, active) pl.PulseImpedance = active end)
GM:AddSkillModifier(trinket, SKILLMOD_PULSE_WEAPON_SLOW_MUL, 0.24)

trinket = GM:AddTrinket(trs("t_crabstompers"), "curbstompers", false, oveles, oweles, 2, trs("t_d_crabstompers"), nil, nil, "weapon_zs_shot_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL, -0.25)

GM:AddTrinket(trs("t_abbiuld"), "supasm", false, oveles, oweles, 5, trs("t_d_abbiuld"), nil, nil, "weapon_zs_shot_trinket")

trinket = GM:AddTrinket(trs("t_olymp"), "olympianframe", false, oveles, oweles, 2, trs("t_d_olymp"), nil, nil, "weapon_zs_shot_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_ENDWAVE_POINTS, 3)
GM:AddSkillModifier(trinket, SKILLMOD_PROP_CARRY_SLOW_MUL, -0.25)
GM:AddSkillModifier(trinket, SKILLMOD_WEAPON_WEIGHT_SLOW_MUL, -0.35)


-- Defensive Trinkets
trinket, trinketwep = GM:AddTrinket(trs("t_defender"), "kevlar", false, develes, deweles, 2, trs("t_d_defender"), nil, nil, "weapon_zs_defence_trinket_d")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.06)
GM:AddSkillModifier(trinket, SKILLMOD_PROJECTILE_DAMAGE_TAKEN_MUL, -0.11)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, -0.01)
trinketwep.PermitDismantle = true

trinket = GM:AddTrinket(trs("t_defenderi"), "barbedarmor", false, develes, deweles, 3, trs("t_d_defenderi"), nil, nil, "weapon_zs_defence_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_ATTACKER_DMG_REFLECT, 11)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_ATTACKER_DMG_REFLECT_PERCENT, 0.5)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.04)
GM:AddSkillModifier(trinket, SKILLMOD_ENDWAVE_POINTS, 3)

trinket = GM:AddTrinket(trs("t_antitoxin"), "antitoxinpack", false, develes, deweles, 2, trs("t_d_antitoxin"), nil, nil, "weapon_zs_defence_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_POISON_DAMAGE_TAKEN_MUL, -0.17)
GM:AddSkillModifier(trinket, SKILLMOD_POISON_SPEED_MUL, -0.4)

trinket = GM:AddTrinket(trs("t_hemostatis"), "hemostasis", false, develes, deweles, 2, trs("t_d_hemostatis"), nil, nil, "weapon_zs_defence_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_BLEED_DAMAGE_TAKEN_MUL, -0.3)
GM:AddSkillModifier(trinket, SKILLMOD_BLEED_SPEED_MUL, -0.6)

trinket = GM:AddTrinket(trs("t_defenderii"), "eodvest", false, develes, deweles, 4, trs("t_d_defenderii"), nil, nil, "weapon_zs_defence_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_EXP_DAMAGE_TAKEN_MUL, -0.35)
GM:AddSkillModifier(trinket, SKILLMOD_FIRE_DAMAGE_TAKEN_MUL, -0.50)
GM:AddSkillModifier(trinket, SKILLMOD_SELF_DAMAGE_MUL, -0.13)

trinket = GM:AddTrinket(trs("t_ffframe"), "featherfallframe", false, develes, deweles, 3, trs("t_d_ffframe"), nil, nil, "weapon_zs_defence_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_FALLDAMAGE_DAMAGE_MUL, -0.65)
GM:AddSkillModifier(trinket, SKILLMOD_FALLDAMAGE_THRESHOLD_MUL, 0.30)
GM:AddSkillModifier(trinket, SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL, -0.75)

trinket = GM:AddTrinket(trs("t_supersale"), "stopit", false, develes, deweles, 3, trs("t_d_supersale"), nil, nil, "weapon_zs_special_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_ARSENAL_DISCOUNT, -0.09)
trinket = GM:AddTrinket(trs("t_fire_ind"), "fire_ind", false, develes, deweles, 3, trs("t_d_fire_ind"), nil, nil, "weapon_zs_special_trinket")


trinketwep.PermitDismantle = true

local eicev = {
	["base"] = { type = "Model", model = "models/gibs/glass_shard04.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.339, 2.697, -2.309), angle = Angle(4.558, -34.502, -72.395), size = Vector(0.5, 0.5, 0.5), color = Color(0, 137, 255, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }
}

local eicew = {
	["base"] = { type = "Model", model = "models/gibs/glass_shard04.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.556, 2.519, -1.468), angle = Angle(0, -5.844, -75.974), size = Vector(0.5, 0.5, 0.5), color = Color(0, 137, 255, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }
}

GM:AddTrinket(trs("t_iceshield"), "iceburst", false, eicev, eicew, nil, trs("t_d_iceshield"), nil, nil, "weapon_zs_special_trinket")

GM:AddSkillModifier(GM:AddTrinket(trs("t_fdfe"), "forcedamp", false, develes, deweles, 2,trs("t_d_fdfe"), nil, nil, "weapon_zs_special_trinket"), SKILLMOD_PHYSICS_DAMAGE_TAKEN_MUL, -0.33)

GM:AddSkillFunction(GM:AddTrinket(trs("t_necro"), "necrosense", false, develes, deweles, 2, trs("t_d_necro"), nil, nil, "weapon_zs_special_trinket"), function(pl, active) pl:SetDTBool(DT_PLAYER_BOOL_NECRO, active) end)

trinket, trinketwep = GM:AddTrinket(trs("t_reactf"), "reactiveflasher", false, develes, deweles, 2, trs("t_d_reactf"), nil, nil, "weapon_zs_special_trinket_d")
trinketwep.PermitDismantle = true

trinket = GM:AddTrinket(trs("t_defenderiii"), "composite", false, develes, deweles, 4, trs("t_d_defenderiii"), nil, nil, "weapon_zs_defence_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.06)
GM:AddSkillModifier(trinket, SKILLMOD_PROJECTILE_DAMAGE_TAKEN_MUL, -0.16)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, -0.07)
trinket = GM:AddTrinket(trs("t_ttimes"), "ttimes", false, develes, deweles, 5, trs("t_d_ttimes"), nil, nil, "weapon_zs_defence_trinket")



trinket = GM:AddTrinket(trs("t_defenderiiii"), "toysite", false, develes, deweles, 4, trs("t_d_defenderiiii"), nil, nil, "weapon_zs_defence_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.06)
GM:AddSkillModifier(trinket, SKILLMOD_PROJECTILE_DAMAGE_TAKEN_MUL, -0.21)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, 0.05)

-- Support Trinkets
trinket, trinketwep = GM:AddTrinket(trs("t_arspack"), "arsenalpack", false, {
	["base"] = { type = "Model", model = "models/Items/item_item_crate.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, -1), angle = Angle(0, -90, 180), size = Vector(0.35, 0.35, 0.35), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}, {
	["base"] = { type = "Model", model = "models/Items/item_item_crate.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, -1), angle = Angle(0, -90, 180), size = Vector(0.35, 0.35, 0.35), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}, 4, trs("t_d_arspack"), "arsenalpack", 3)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket(trs("t_ammopack"), "resupplypack", true, nil, {
	["base"] = { type = "Model", model = "models/Items/ammocrate_ar2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, -1), angle = Angle(0, -90, 180), size = Vector(0.35, 0.35, 0.35), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}, 4, trs("t_d_ammopack"), "resupplypack", 3)
trinketwep.PermitDismantle = true

GM:AddTrinket(trs("t_magnet"), "magnet", true, supveles, supweles, nil, trs("t_d_magnet"), "magnet")
GM:AddTrinket(trs("t_smagnet"), "electromagnet", true, supveles, supweles, nil, trs("t_d_smagnet"), "magnet_electro")

trinket, trinketwep = GM:AddTrinket(trs("t_exoskelet"), "loadingex", false, supveles, supweles, 2, trs("t_d_exoskelet"), nil, nil, "weapon_zs_help_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_PROP_CARRY_SLOW_MUL, -0.55)
GM:AddSkillModifier(trinket, SKILLMOD_DEPLOYABLE_PACKTIME_MUL, -0.2)
GM:AddSkillModifier(trinket, SKILLMOD_ENDWAVE_POINTS, 2)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket(trs("t_blueprints"), "blueprintsi", false, supveles, supweles, 2, trs("t_d_blueprints"), nil, nil, "weapon_zs_help_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_REPAIRRATE_MUL, 0.10)
trinketwep.PermitDismantle = true

GM:AddSkillModifier(GM:AddTrinket(trs("t_ablueprints"), "blueprintsii", false, supveles, supweles, 4, trs("t_d_ablueprints"), nil, nil, "weapon_zs_help_trinket"), SKILLMOD_REPAIRRATE_MUL, 0.20)

trinket, trinketwep = GM:AddTrinket(trs("t_medi"), "processor", false, supveles, supweles, 2, trs("t_d_medi"), nil, nil, "weapon_zs_help_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.10)
GM:AddSkillModifier(trinket, SKILLMOD_MEDGUN_FIRE_DELAY_MUL, -0.6)

trinket = GM:AddTrinket(trs("t_medii"), "curativeii", false, supveles, supweles, 3, trs("t_d_medii"), nil, nil, "weapon_zs_help_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.20)
GM:AddSkillModifier(trinket, SKILLMOD_MEDGUN_FIRE_DELAY_MUL, -0.15)

trinket = GM:AddTrinket(trs("t_mediii"), "remedy", false, supveles, supweles, 3, trs("t_d_mediii"), nil, nil, "weapon_zs_help_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.3)
trinket = GM:AddTrinket(trs("t_mediiii"), "mediiii", false, supveles, supweles, 3, trs("t_d_mediiii"), nil, nil, "weapon_zs_help_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.2)

trinket = GM:AddTrinket(trs("t_deploi"), "mainsuite", false, supveles, supweles, 2, trs("t_d_deploi"), nil, nil, "weapon_zs_help_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_FIELD_RANGE_MUL, 0.1)
GM:AddSkillModifier(trinket, SKILLMOD_FIELD_DELAY_MUL, -0.07)
GM:AddSkillModifier(trinket, SKILLMOD_TURRET_RANGE_MUL, 0.1)

trinket = GM:AddTrinket(trs("t_deploii"), "controlplat", false, supveles, supweles, 2, trs("t_d_deploii"), nil, nil, "weapon_zs_help_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_CONTROLLABLE_HEALTH_MUL, 0.15)
GM:AddSkillModifier(trinket, SKILLMOD_CONTROLLABLE_SPEED_MUL, 0.15)
GM:AddSkillModifier(trinket, SKILLMOD_MANHACK_DAMAGE_MUL, 0.50)

trinket = GM:AddTrinket(trs("t_proji"), "projguide", false, supveles, supweles, 2, trs("t_d_proji"), nil, nil, "weapon_zs_shot_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_PROJ_SPEED, 1.6)

trinket = GM:AddTrinket(trs("t_projii"), "projwei", false, supveles, supweles, 2, trs("t_d_projii"), nil, nil, "weapon_zs_shot_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_PROJ_SPEED, -0.5)
GM:AddSkillModifier(trinket, SKILLMOD_PROJECTILE_DAMAGE_MUL, 0.2)

local ectov = {
	["base"] = { type = "Model", model = "models/props_junk/glassjug01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.381, 2.617, 2.062), angle = Angle(180, 12.243, 0), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base+"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 4.07), angle = Angle(180, 12.243, 0), size = Vector(0.123, 0.123, 0.085), color = Color(0, 0, 255, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }
}

local ectow = {
	["base"] = { type = "Model", model = "models/props_junk/glassjug01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.506, 1.82, 1.758), angle = Angle(-164.991, 19.691, 8.255), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["base+"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 4.07), angle = Angle(180, 12.243, 0), size = Vector(0.123, 0.123, 0.085), color = Color(0, 0, 255, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }
}

trinket = GM:AddTrinket(trs("t_chemicals"), "reachem", false, ectov, ectow, 3, trs("t_d_chemicals"), nil, nil, "weapon_zs_shot_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_EXP_DAMAGE_MUL, 0.4)
GM:AddSkillModifier(trinket, SKILLMOD_EXP_DAMAGE_RADIUS, 0.3)


trinket = GM:AddTrinket(trs("t_deploiii"), "opsmatrix", false, supveles, supweles, 4, trs("t_d_deploiii"), nil, nil, "weapon_zs_help_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_FIELD_RANGE_MUL, 0.15)
GM:AddSkillModifier(trinket, SKILLMOD_FIELD_DELAY_MUL, -0.13)
GM:AddSkillModifier(trinket, SKILLMOD_TURRET_RANGE_MUL, 0.85)
trinket = GM:AddTrinket(trs("t_hateme"), "hateome", false, supveles, supweles, 4, trs("t_d_hateme"), nil, nil, "weapon_zs_help_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_EXP_DAMAGE_TAKEN_MUL, -0.4)
GM:AddSkillModifier(trinket, SKILLMOD_EXP_DAMAGE_RADIUS, 1.8)
-- Super Trinkets
trinket = GM:AddTrinket(trs("t_smanifest"), "sman", false, supveles, supweles, 5, trs("t_d_smanifest"))
GM:AddSkillModifier(trinket, SKILLMOD_RESUPPLY_DELAY_MUL, -0.16)
trinket = GM:AddTrinket(trs("t_protutor"), "stutor", false, book, bookw, 5, trs("t_d_protutor"))
GM:AddSkillModifier(trinket, SKILLMOD_POINT_MULTIPLIER, 0.10)
trinket = GM:AddTrinket(trs("t_gstore"), "gstore", false, supveles, supweles, 5, trs("t_d_gstore"))
GM:AddSkillModifier(trinket, SKILLMOD_ARSENAL_DISCOUNT, -0.15)
trinket = GM:AddTrinket(trs("t_fblueprints"), "futureblu", false, supveles, supweles, 5, trs("t_d_fblueprints"))
GM:AddSkillModifier(trinket, SKILLMOD_REPAIRRATE_MUL, 0.30)
trinket = GM:AddTrinket(trs("t_kbook"), "knowbook", false, book, bookw, 5, trs("t_d_kbook"))
GM:AddSkillModifier(trinket,  SKILLMOD_RESUPPLY_DELAY_MUL, -0.1)
GM:AddSkillModifier(trinket, SKILLMOD_RELOADSPEED_MUL, 0.15)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_MUL, 0.15)
trinket = GM:AddTrinket(trs("t_bloodlust"), "bloodlust", false, book, bookw, 5, trs("t_d_bloodlust"))
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_POWERATTACK_MUL, 0.50)
GM:AddSkillModifier(trinket, SKILLMOD_HEALTH, -10)
trinket = GM:AddTrinket(trs("t_adbat"), "adbat", false, supveles, supweles, 5, trs("t_d_adbat"))
GM:AddSkillModifier(trinket, SKILLMOD_RELOADSPEED_PULSE_MUL, 0.33)
trinket = GM:AddTrinket(trs("t_mecharm"), "marm", false, supveles, supweles, 5, trs("t_d_mecharm"))
GM:AddSkillModifier(trinket, SKILLMOD_RELOADSPEED_MUL, 0.22)

trinket = GM:AddTrinket(trs("t_antibaracat"), "antibaracat", false, supveles, supweles, 5, trs("t_d_antibaracat"))
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.5)




--Attachment
trinket = GM:AddTrinket(trs("t_fire_at"), "fire_at", false, supveles, supweles, 2, trs("t_d_fire_at"))
--GM:AddSkillModifier(trinket, SKILLMOD_DAMAGE, -0.1)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_MUL, -0.1)
trinket = GM:AddTrinket(trs("t_pulse_at"), "pulse_at", false, supveles, supweles, 2, trs("t_d_pulse_at"))
--GM:AddSkillModifier(trinket, SKILLMOD_DAMAGE, -0.1)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_MUL, -0.1)
trinket = GM:AddTrinket(trs("t_acid_at"), "acid_at", false, supveles, supweles, 2, trs("t_d_acid_at"))
--GM:AddSkillModifier(trinket, SKILLMOD_DAMAGE, -0.1)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_MUL, -0.1)
trinket = GM:AddTrinket(trs("t_ultra_at"), "ultra_at", false, supveles, supweles, 2, trs("t_d_ultra_at"))
--GM:AddSkillModifier(trinket, SKILLMOD_DAMAGE, -0.1)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_MUL, -0.1)
trinket = GM:AddTrinket(trs("t_cham_at"), "cham_at", false, supveles, supweles, 2, trs("t_d_cham_at"))

trinket = GM:AddTrinket(trs("t_hp_up"), "hp_up", false, develes, deweles, 5, trs("t_d_hp_up"), nil, nil, "weapon_zs_special_trinket")
GM:AddSkillModifier(trinket, SKILLMOD_HEALTH, 20)

-- ???
GM:AddSkillModifier(GM:AddTrinket(trs("t_manifesti"), "acqmanifest", false, supveles, supweles, 2, trs("t_d_manifesti"), nil, nil, "weapon_zs_help_trinket"), SKILLMOD_RESUPPLY_DELAY_MUL, -0.03)
GM:AddSkillModifier(GM:AddTrinket(trs("t_manifestii"), "promanifest", false, supveles, supweles, 4, trs("t_d_manifestii"), nil, nil, "weapon_zs_help_trinket"), SKILLMOD_RESUPPLY_DELAY_MUL, -0.07)

-- Boss Trinkets



-- Starter Trinkets

trinket, trinketwep = GM:AddTrinket("Armband", "armband", false, mveles, mweles, nil, "-20% melee swing impact delay\n-2% melee damage taken\n-20% Скорости атаки\n-2% Получаемого мили урона")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_SWING_DELAY_MUL, -0.2)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.02)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Condiments", "condiments", false, supveles, supweles, nil, "+90% recovery from food\n-20% time to eat food\n -20% К времени поедания\n +90% к лечению от еды")
GM:AddSkillModifier(trinket, SKILLMOD_FOODRECOVERY_MUL, 0.90)
GM:AddSkillModifier(trinket, SKILLMOD_FOODEATTIME_MUL, -0.20)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Escape Manual", "emanual", false, develes, deweles, nil, "+90% phasing speed\n-12% low health slow intensity\n +90% К скорости передвижения в фазе\n -12% к эффективности замедления от лоу хп")
GM:AddSkillModifier(trinket, SKILLMOD_BARRICADE_PHASE_SPEED_MUL, 0.90)
GM:AddSkillModifier(trinket, SKILLMOD_LOW_HEALTH_SLOW_MUL, -0.12)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Aiming Aid", "aimaid", false, develes, deweles, nil, "+5% tighter aiming reticule\n-7% reduced effect of aim shake effects\n+5% К аккуратности стрельбы\n-6% К силе трясения экрана")
GM:AddSkillModifier(trinket, SKILLMOD_AIMSPREAD_MUL, -0.05)
GM:AddSkillModifier(trinket, SKILLMOD_AIM_SHAKE_MUL, -0.06)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Vitamin Capsules", "vitamins", false, hpveles, hpweles, nil, "+8 maximum health\n-32% poison damage taken\n +8 к макс хп\n-32% Получаемого урона от яда")
GM:AddSkillModifier(trinket, SKILLMOD_HEALTH, 8)
GM:AddSkillModifier(trinket, SKILLMOD_POISON_DAMAGE_TAKEN_MUL, -0.32)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Welfare Shield", "welfare", false, hpveles, hpweles, nil, "-12% resupply delay\n-20% self damage taken\n-12% К времени амуниции\n-20% Получаемого урона по себе")
GM:AddSkillModifier(trinket, SKILLMOD_RESUPPLY_DELAY_MUL, -0.12)
GM:AddSkillModifier(trinket, SKILLMOD_SELF_DAMAGE_MUL, -0.20)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Chemistry Set", "chemistry", false, hpveles, hpweles, nil, "+13% medic tool effectiveness\n+100% cloud bomb time\n +13% К эффективности мед иснтрументам\n+100% К времени действия облачных бомб")
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.13)
GM:AddSkillModifier(trinket, SKILLMOD_CLOUD_TIME, 1)
trinketwep.PermitDismantle = true


--Мед премия
trinket = GM:AddTrinket(trs("t_pr_gold"), "pr_gold", false, supveles, supweles, 4, trs("t_d_pr_gold"))
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.22)
trinket = GM:AddTrinket(trs("t_pr_barapaw"), "pr_barapaw", false, supveles, supweles, 4, trs("t_d_pr_barapaw"))
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.44)
trinket = GM:AddTrinket(trs("t_pr_chamomile"), "pr_chamomile", false, supveles, supweles, 4, trs("t_d_pr_chamomile"))
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.55)
trinket = GM:AddTrinket(trs("t_pr_bloodpack"), "pr_bloodpack", false, supveles, supweles, 4, trs("t_d_pr_bloodpack"))
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.32)