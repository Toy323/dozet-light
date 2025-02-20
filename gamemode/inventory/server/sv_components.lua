GM.WorldConversions = {}
GM.StarterTrinkets = {
	"trinket_armband",
	"trinket_condiments",
	"trinket_emanual",
	"trinket_aimaid",
	"trinket_vitamins",
	"trinket_welfare",
	"trinket_chemistry"
	
}
GM.GetActiveTrinkets = {
	"cons_pill_unk",
	"cons_void",
	"cons_mantle",
	"cons_necronomicon",
	"cons_chaos",
	"cons_d4",
	"cons_d1",
	"cons_dust",
	"cons_friendship",
	"cons_gausscard",
	"cons_timer",
	"cons_flame_p",
	"cons_minos",
	"cons_sack_of_trinkets",
	'cons_grandma_vase',
	"cons_black_hole",
	"cons_xmas_goodness"
}


GM.MedPremium = {
	"trinket_pr_gold",
	"trinket_pr_barapaw",
	"trinket_pr_chamomile",
	"trinket_pr_bloodpack",
	"trinket_soulmedical"
}



function GM:AddWorldPropConversionRecipe(model, result)
	local datatab = {Result = result, Index = wcindex}
	self.WorldConversions[model] = datatab
	self.WorldConversions[#self.WorldConversions + 1] = datatab
end

GM:AddWorldPropConversionRecipe("models/props_combine/breenbust.mdl", 		"comp_busthead")
GM:AddWorldPropConversionRecipe("models/props_junk/sawblade001a.mdl", 		"comp_sawblade")
GM:AddWorldPropConversionRecipe("models/props_junk/propane_tank001a.mdl", 	"comp_propanecan")
GM:AddWorldPropConversionRecipe("models/items/car_battery01.mdl", 			"comp_electrobattery")
GM:AddWorldPropConversionRecipe("models/props_lab/reciever01b.mdl", 		"comp_reciever")
GM:AddWorldPropConversionRecipe("models/props_lab/harddrive01.mdl", 		"comp_cpuparts")
