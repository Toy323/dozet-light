local colBG = Color( 10, 10, 10, 252 )
local colBGH = Color( 200, 200, 200, 5 )
local blur = Material( "pp/blurscreen" )
local categorycolors = {
	[ 1 ] = { COLOR_RED, COLOR_DARKRED },
	[ 2 ] = { COLOR_BLUE, COLOR_DARKBLUE },
	[ 3 ] = { COLOR_YELLOW, Color(75,67,1) },
	[4] = {Color(41,39,182),Color(99,173,233)}
}
local function TrinketPanelPaint( self, w, h )
	if categorycolors[ self.Category ] then
		draw.RoundedBox( 2, 0, 0, w, h, ( self.Depressed or self.On) and Color(80,80,80) or categorycolors[self.Category][1]   )
	end

	draw.RoundedBox( 2, 2, 2, w - 4, h - 4, colBG )
	if self.On or self.Hovered  then
		draw.RoundedBox( 2, 2, 2, w - 4, h - 4, colBGH )
	end

	if self.SWEP then
		draw.SimpleText( self.SWEP.PrintName, "ZSHUDFontTiny", w/2, h/4, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
		--local txt = self.SWEP.Description 

		--draw.DrawText( txt, "ZSBodyTextFontBig", w/2.2, h/3, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER)	
	end

	return true
end
local function ItemPanelDoClick(self)
	net.Start("zs_bounty_add")
	net.WriteString(self.Item)
	net.SendToServer()
	self.Owner:Close()

end
local function InventoryAdd( item, category, i, self)
	local screenscale = BetterScreenScale()
	local grid = GAMEMODE:GetInventoryItemType( item )


	if grid then
		local itempan = vgui.Create("DButton", self)
		itempan:SetText( "" )
		itempan.Paint = TrinketPanelPaint

		itempan.Owner = self
		itempan.Item = item
		itempan.SWEP =  GAMEMODE.ZSInventoryItemData[ item ]
		itempan.DoClick = ItemPanelDoClick
		itempan.Category = category
		itempan:Center()
		itempan:SetSize(250 * screenscale,400 * screenscale)
		itempan:SetPos(300 * screenscale * i - 200 * screenscale,itempan:GetY()-180*screenscale)

		local desc = vgui.Create("DLabel", itempan)
		desc:SetSize(250 * screenscale,400 * screenscale)
		desc:SetFont("ZSHUDFontTiny")
		desc:SetWrap(true)

		desc:SetText(itempan.SWEP.Description)

		local mdlframe = vgui.Create("DPanel", itempan)
		mdlframe:SizeToContents()
		mdlframe:Center()
		mdlframe:SetPos(400 * screenscale * i,screenscale*0.5)
		mdlframe:SetMouseInputEnabled( false )
		mdlframe.Paint = function() end

		local trintier = EasyLabel( itempan, translate.Get("w_tier")..GAMEMODE.ZSInventoryItemData[item].Tier, "ZSHUDFontSmaller", COLOR_WHITE )
		trintier:CenterHorizontal( 0.9 )
		trintier:CenterVertical( 0.9 )
		

		
		local icon = category == INVCAT_WEAPONS and item or GAMEMODE.ZSInventoryItemData[item].Icon or "weapon_zs_trinket"
		local kitbl = killicon.Get((category ~= INVCAT_COMPONENTS) and icon or "weapon_zs_craftables")
		if kitbl then
			GAMEMODE:AttachKillicon(kitbl, itempan, mdlframe)
		end
		
	end
end
local d = {"headshoter", "ind_buffer",  "ultra_at", "pearl","broken_world"}
function GM:OpenBounty(table2)
	local scr = BetterScreenScale()
    local panel = vgui.Create("DFrame")
    panel:SetSize(1000*scr, 500*scr)
    panel:SetTitle("Select bounty")
    panel:Center()
    panel:MakePopup()
	panel:SetDraggable(false)

	if !table2 then
		table2 = d 
	end
	for i=1,3 do
		InventoryAdd("trinket_"..table2[i],INVCAT_TRINKETS,i,panel)
	end

   	--local difficultyLabel = vgui.Create("DLabel", panel)
    --difficultyLabel:SetPos(25*scr, -100*scr)
   	--difficultyLabel:SetSize(500*scr, 460*scr)
	--difficultyLabel:SetWrap(true)

	--difficultyLabel:SetText(translate.Get("something_new"))

	--check = vgui.Create("DCheckBoxLabel", panel)
	----check:SetText(translate.Get("op_dont_show"))
---	check:SetConVar("zs_dont_show")
	--check:SizeToContents()
	--check:SetPos(350*scr,480*scr)

end