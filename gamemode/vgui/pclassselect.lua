CreateClientConVar("zs_bossclass", "", true, true)
CreateClientConVar("zs_demibossclass", "", true, true)

local Window
local HoveredClassWindow

local function CreateHoveredClassWindow(classtable)
	if HoveredClassWindow and HoveredClassWindow:IsValid() then
		HoveredClassWindow:Remove()
	end

	HoveredClassWindow = vgui.Create("ClassInfo")
	HoveredClassWindow:SetSize(ScrW() * 0.5, 128)
	HoveredClassWindow:CenterHorizontal()
	HoveredClassWindow:MoveBelow(Window, 32)
	HoveredClassWindow:SetClassTable(classtable)
end

function GM:OpenClassSelect()
	if Window and Window:IsValid() then Window:Remove() end

	Window = vgui.Create("ClassSelect")
	Window:SetAlpha(0)
	Window:AlphaTo(255, 0.1)

	Window:MakePopup()

	Window:InvalidateLayout()

	PlayMenuOpenSound()
end

local PANEL = {}

PANEL.Rows = 2
local ZombieClass = ""

local bossmode = false
local demiboss = false
local var = false
local function BossTypeDoClick(self)
	if var then return end
	bossmode = not bossmode
	demiboss = false
	GAMEMODE:OpenClassSelect()
end
local function DemiBossTypeDoClick(self)
	if var then return end
	demiboss = not demiboss
	bossmode = false
	GAMEMODE:OpenClassSelect()
end
local function VarTypeDoClick(self)
	var = not var
	GAMEMODE:OpenClassSelect()
end
local function RedeemTrue12(pl)
    pl:Redeem()
end

function PANEL:Init()
	self.ClassButtons = {}

	self.ClassTypeButton = EasyButton(nil, bossmode and not demiboss and translate.Get("vgui_open_class") or translate.Get("vgui_open_class_b"), 8, 4)
	self.ClassTypeButton:SetFont("ZSHUDFontSmall")
	self.ClassTypeButton:SizeToContents()
	self.ClassTypeButton.DoClick = BossTypeDoClick

	self.DemiClassTypeButton = EasyButton(nil, demiboss and translate.Get("vgui_open_class") or translate.Get("vgui_open_class_db"), 8, 4)
	self.DemiClassTypeButton:SetFont("ZSHUDFontSmall")
	self.DemiClassTypeButton:SizeToContents()
	self.DemiClassTypeButton.DoClick = DemiBossTypeDoClick

	self.CloseButton = EasyButton(nil, "Close", 8, 4)
	self.CloseButton:SetFont("ZSHUDFontSmall")
	self.CloseButton:SizeToContents()
	self.CloseButton.DoClick = function()  var = false ZombieClass = "" Window:Remove()  end




	self.ButtonGrid = vgui.Create("DGrid", self)
	self.ButtonGrid:SetContentAlignment(5)
	self.ButtonGrid:Dock(FILL)

	local already_added = {}
	local use_better_versions = GAMEMODE:ShouldUseBetterVersionSystem()

	for i=1, #GAMEMODE.ZombieClasses do
		local classtab = GAMEMODE.ZombieClasses[GAMEMODE:GetBestAvailableZombieClass(i)]

		if classtab and not classtab.Disabled and not already_added[classtab.Index] and (!classtab.Variations or classtab.Original) and ZombieClass ~= classtab.Name and !var then
			already_added[classtab.Index] = true

			local ok
			if bossmode then
				ok = classtab.Boss and (!classtab.Hidden or GAMEMODE:GetWave()>= (classtab.Wave and classtab.Wave or 32) )
				
			
			elseif demiboss and not bossmode then
				ok = classtab.DemiBoss and not classtab.Hidden
			else
				ok = not classtab.Boss and not classtab.DemiBoss and
					(not classtab.Hidden or classtab.CanUse and classtab:CanUse(MySelf)) and
					(not GAMEMODE.ObjectiveMap or classtab.Unlocked)
			end
			

			if ok then
				if not use_better_versions or not classtab.BetterVersionOf or GAMEMODE:IsClassUnlocked(classtab.Index) then
					local button = vgui.Create("ClassButton")
					button:SetClassTable(classtab)
					button.Wave = classtab.Wave or 1

					table.insert(self.ClassButtons, button)

					self.ButtonGrid:AddItem(button)
				end
			end
		elseif classtab and not classtab.Disabled and not already_added[classtab.Index] and classtab.Variations and var and ZombieClass == classtab.Name then
			for k,v in pairs(classtab.Variations) do
					for i=1, #GAMEMODE.ZombieClasses do
						local classtab2 = GAMEMODE.ZombieClasses[GAMEMODE:GetBestAvailableZombieClass(i)]
						
				
						if classtab2 and not classtab2.Disabled and not already_added[classtab2.Index] and classtab2.Name == v or (classtab2 and classtab2.Original and ZombieClass == classtab2.Name) and not already_added[classtab2.Index] then
							already_added[classtab2.Index] = true
							already_added[classtab.Index] = true
				
							local ok
							if bossmode then
								ok = classtab2.Boss and classtab2.Hidden
							
							elseif demiboss and not bossmode then
								ok = classtab2.DemiBoss and not classtab2.Hidden
							else
								ok = not classtab2.Boss and not classtab2.DemiBoss and
									(not classtab2.Hidden) and
									(not GAMEMODE.ObjectiveMap or classtab2.Unlocked)
							end
							
				
							if ok then
								if not use_better_versions or not classtab2.BetterVersionOf or GAMEMODE:IsClassUnlocked(classtab2.Index) then
									local button = vgui.Create("ClassButton")
									button:SetClassTable(classtab2)
									button.Wave = classtab2.Wave or 1
				
									table.insert(self.ClassButtons, button)
				
									self.ButtonGrid:AddItem(button)
								end
							end
						end
					end
			end
		end
	end

	self.ButtonGrid:SortByMember("Wave")
	self:InvalidateLayout()
end

function PANEL:PerformLayout()
	if #self.ClassButtons < 8 then self.Rows = 1 end
	--if #self.ClassButtons >= 20 then self.Rows = 3 end

	local cols = math.ceil(#self.ClassButtons / self.Rows)
	local cell_size = ScrW() / cols
	cell_size = math.min(ScrW() / 7, cell_size)

	self:SetSize(ScrW(), self.Rows * cell_size)
	self:CenterHorizontal()
	self:CenterVertical(0.35)

	self.ClassTypeButton:MoveAbove(self, 16)
	self.ClassTypeButton:CenterHorizontal()

	self.DemiClassTypeButton:MoveAbove(self, 64)
	self.DemiClassTypeButton:SetSize(502, 30)
	self.DemiClassTypeButton:CenterHorizontal()

	self.CloseButton:MoveAbove(self, 16)
	self.CloseButton:CenterHorizontal(0.9)

	self.ButtonGrid:SetCols(cols)
	self.ButtonGrid:SetColWide(cell_size)
	self.ButtonGrid:SetRowHeight(cell_size)
end

function PANEL:OnRemove()
	self.ClassTypeButton:Remove()
	self.CloseButton:Remove()
	self.DemiClassTypeButton:Remove()
end

local texUpEdge = surface.GetTextureID("gui/gradient_up")
local texDownEdge = surface.GetTextureID("gui/gradient_down")
function PANEL:Paint()
	local wid, hei = self:GetSize()
	local edgesize = 16

	DisableClipping(true)
	surface.SetDrawColor(Color(0, 0, 0, 220))
	surface.DrawRect(0, 0, wid, hei)
	surface.SetTexture(texUpEdge)
	surface.DrawTexturedRect(0, -edgesize, wid, edgesize)
	surface.SetTexture(texDownEdge)
	surface.DrawTexturedRect(0, hei, wid, edgesize)
	DisableClipping(false)

	return true
end

vgui.Register("ClassSelect", PANEL, "Panel")

PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetContentAlignment(5)

	self.NameLabel = vgui.Create("DLabel", self)
	self.NameLabel:SetFont("ZSHUDFontSmaller")
	self.NameLabel:SetAlpha(170)

	self.Image = vgui.Create("DImage", self)

	self:InvalidateLayout()
end

function PANEL:PerformLayout()
	local cell_size = self:GetParent():GetColWide()

	self:SetSize(cell_size, cell_size)

	self.Image:SetSize(cell_size * 0.75, cell_size * 0.75)
	self.Image:AlignTop(8)
	self.Image:CenterHorizontal()

	self.NameLabel:SizeToContents()
	self.NameLabel:AlignBottom(8)
	self.NameLabel:CenterHorizontal()
end

function PANEL:SetClassTable(classtable)
	self.ClassTable = classtable

	local len = #translate.Get(classtable.TranslationName)

	self.NameLabel:SetText(translate.Get(classtable.TranslationName))
	self.NameLabel:SetFont(len > 15 and "ZSHUDFontTiny" or len > 11 and "ZSHUDFontSmallest" or "ZSHUDFontSmaller")

	self.Image:SetImage(classtable.Icon)
	self.Image:SetImageColor(classtable.IconColor or color_white)

	self:InvalidateLayout()
end

function PANEL:DoClick()
	if self.ClassTable then
		if self.ClassTable.Boss then
			RunConsoleCommand("zs_bossclass", self.ClassTable.Name)
			GAMEMODE:CenterNotify(translate.Format("boss_class_select", self.ClassTable.Name))
		elseif self.ClassTable.DemiBoss then
				RunConsoleCommand("zs_demibossclass", self.ClassTable.Name)
				GAMEMODE:CenterNotify(translate.Format("boss_class_select", self.ClassTable.Name))

		else
			if ((!self.ClassTable.Variations or !self.ClassTable.Original and var) or self.ClassTable.Name == ZombieClass) then
				net.Start("zs_changeclass")
					net.WriteString(self.ClassTable.Name)
					net.WriteBool(GAMEMODE.SuicideOnChangeClass)
				net.SendToServer()
				VarTypeDoClick(self)
			elseif self.ClassTable.Variations and self.ClassTable.Original and not var and self.ClassTable.Name ~= ZombieClass then
				ZombieClass = self.ClassTable.Name
				VarTypeDoClick(self)
				return
			end
		end
	end

	surface.PlaySound("buttons/button15.wav")

	Window:Remove()
	ZombieClass = ""
	var = false
	bossmode = false
	demiboss = false
end

function PANEL:Paint()
	return true
end

function PANEL:OnCursorEntered()
	self.NameLabel:SetAlpha(230)

	CreateHoveredClassWindow(self.ClassTable)
end

function PANEL:OnCursorExited()
	self.NameLabel:SetAlpha(170)

	if HoveredClassWindow and HoveredClassWindow:IsValid() and HoveredClassWindow.ClassTable == self.ClassTable then
		HoveredClassWindow:Remove()
	end
end

function PANEL:Think()
	if not self.ClassTable then return end
	
	local enabled
	if MySelf:GetZombieClass() == self.ClassTable.Index then
		enabled = 2
	elseif (self.ClassTable.Boss and !self.ClassTable.Hidden) or gamemode.Call("IsClassUnlocked", self.ClassTable.Index) or self.ClassTable.DemiBoss then
		enabled = 1
	else
		enabled = 0
	end

	if enabled ~= self.LastEnabledState then
		self.LastEnabledState = enabled
		if enabled == 2 then
			self.NameLabel:SetTextColor(COLOR_GREEN)
			self.Image:SetImageColor(self.ClassTable.IconColor or color_white)
			self.Image:SetAlpha(245)
		elseif enabled == 1 then
			self.NameLabel:SetTextColor(COLOR_GRAY)
			self.Image:SetImageColor(self.ClassTable.IconColor or color_white)
			self.Image:SetAlpha(245)
		else
			self.NameLabel:SetTextColor(COLOR_DARKRED)
			self.Image:SetImageColor(COLOR_DARKRED)
			self.Image:SetAlpha(170)
		end
		if self.ClassTable.Original then
			self.NameLabel:SetTextColor(COLOR_YELLOW)
		end
	end
end

vgui.Register("ClassButton", PANEL, "Button")

PANEL = {}

function PANEL:Init()
	self.NameLabel = vgui.Create("DLabel", self)
	self.NameLabel:SetFont("ZSHUDFontSmaller")

	self.DescLabels = self.DescLabels or {}

	self:InvalidateLayout()
end

function PANEL:SetClassTable(classtable)
	self.ClassTable = classtable

	self.NameLabel:SetText(translate.Get(classtable.TranslationName))
	if classtable.Original then
		self.NameLabel:SetTextColor(COLOR_YELLOW)
	end
	self.NameLabel:SizeToContents()

	self:CreateDescLabels()

	self:InvalidateLayout()
end

function PANEL:RemoveDescLabels()
	for _, label in pairs(self.DescLabels) do
		label:Remove()
	end

	self.DescLabels = {}
end
local function GetMaxZombieHealth(classtab)
	local lowundead = team.NumPlayers(TEAM_UNDEAD) < 4
	local healthmulti = (GAMEMODE.ObjectiveMap or GAMEMODE.ZombieEscape) and 1 or lowundead and 1.5 or 1
	local health = 0
	if classtab.Boss then
		health = classtab.Health +  (((GAMEMODE:GetWave() * 250)) * math.max(1,team.NumPlayers(TEAM_HUMAN)/2 - (team.NumPlayers(TEAM_UNDEAD)/3)))* (classtab.DynamicHealth or 1)
	elseif classtab.DemiBoss then
		health = classtab.Health + (((GAMEMODE:GetWave() * 80)) * team.NumPlayers(TEAM_HUMAN)) * (classtab.DynamicHealth or 1)
	else
		health = (classtab.Health * healthmulti) + ((GAMEMODE:GetWave() * 45) * (classtab.DynamicHealth or 1)) 
	end
	return health
end
local function GetZombieName(name)
	for i=1, #GAMEMODE.ZombieClasses do
		local classtab = GAMEMODE.ZombieClasses[GAMEMODE:GetBestAvailableZombieClass(i)]
		if classtab.Name == name then
			return translate.Get(classtab.TranslationName)
		end
	end
	return ""
end
function PANEL:CreateDescLabels()
	self:RemoveDescLabels()

	self.DescLabels = {}

	local classtable = self.ClassTable
	if not classtable or not classtable.Description then return end

	local lines = {}

	if classtable.Wave and classtable.Wave > 0 then
		table.insert(lines, translate.Format("unlocked_on_wave_x", classtable.Wave))
	end

	if classtable.BetterVersion then
		local betterclasstable = GAMEMODE.ZombieClasses[classtable.BetterVersion]
		if betterclasstable then
			table.insert(lines, translate.Format("evolves_in_to_x_on_wave_y", betterclasstable.Name, betterclasstable.Wave))
		end
	end


	table.insert(lines, " ")
	table.Add(lines, string.Explode("\n", translate.Get(classtable.Description)))

	if classtable.Help then
		table.insert(lines, " ")
		table.Add(lines, string.Explode("\n", translate.Get(classtable.Help)))
	end
	
	if classtable.SWEP then
		table.insert(lines, " ")
		table.Add(lines, string.Explode("\n", translate.Get("p_dmg")..":"..(weapons.Get(classtable.SWEP).MeleeDamage or 1)))
		table.Add(lines, string.Explode("\n", translate.Get("skill_add_health")..":"..GetMaxZombieHealth(classtable)))
		table.Add(lines, string.Explode("\n", translate.Get("skill_add_speed")..":"..classtable.Speed))
		if weapons.Get(classtable.SWEP).MeleeDamageVsProps then
			table.Add(lines, string.Explode("\n", translate.Get("p_dmg_prop")..":"..(weapons.Get(classtable.SWEP).MeleeDamageVsProps or 1)))
		end
	end
	if classtable.Variations and classtable.Original and !var then
		table.insert(lines, " ")
		table.Add(lines, string.Explode(" ", translate.Get("variations_z")))
		table.insert(lines, " ")
		for k,v in pairs(classtable.Variations) do 
			table.Add(lines, string.Explode("\n", GetZombieName(v)))
		end
	end
	for i, line in ipairs(lines) do
		local label = vgui.Create("DLabel", self)
		local notwaveone = classtable.Wave and classtable.Wave > 0

		label:SetText(line)
		if i == (notwaveone and 2 or 1) and classtable.BetterVersion then
			label:SetColor(COLOR_RORANGE)
		end
		label:SetFont(i == 1 and notwaveone and "ZSBodyTextFontBig" or "ZSBodyTextFont")
		label:SizeToContents()

		table.insert(self.DescLabels, label)
	end
end

function PANEL:PerformLayout()
	self.NameLabel:SizeToContents()
	self.NameLabel:CenterHorizontal()

	local maxw = self.NameLabel:GetWide()
	for _, label in pairs(self.DescLabels) do
		maxw = math.max(maxw, label:GetWide())
	end
	self:SetWide(maxw + 64)
	self:CenterHorizontal()

	for i, label in ipairs(self.DescLabels) do
		label:MoveBelow(self.DescLabels[i - 1] or self.NameLabel)
		label:CenterHorizontal()
	end

	local lastlabel = self.DescLabels[#self.DescLabels] or self.NameLabel
	local _, y = lastlabel:GetPos()
	self:SetTall(y + lastlabel:GetTall())
end

function PANEL:Think()
	if not Window or not Window:IsValid() or not Window:IsVisible() then
		self:Remove()
	end
end

function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "Frame", self, w, h)

	return true
end

vgui.Register("ClassInfo", PANEL, "Panel")
