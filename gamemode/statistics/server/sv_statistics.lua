GM.StatTracking = {}

local stattrack = GM.StatTracking
stattrack.Folder = "stat_tracking"
stattrack.BlackList = false

STATTRACK_TYPE_WEAPON = 1
STATTRACK_TYPE_ZOMBIECLASS = 2
STATTRACK_TYPE_ROUND = 3
STATTRACK_TYPE_SKILL = 4

local ttypetblnames = {
	[STATTRACK_TYPE_WEAPON] = "Weapon",
	[STATTRACK_TYPE_ZOMBIECLASS] = "ZombieClass",
	[STATTRACK_TYPE_ROUND] = "Game",
	[STATTRACK_TYPE_SKILL] = "Skill",
}

function stattrack:GetTypeTbl(ttype)
	return ttypetblnames[ttype] .. "Data"
end

function stattrack:GetTrackTypeStatFile(ttype)
	return self.Folder.."/".. string.lower(ttypetblnames[ttype]) .."s.txt"
end

for num, ttype in pairs(ttypetblnames) do
	local typenam = stattrack:GetTypeTbl(num)
	stattrack[typenam] = {}

	if file.Exists(stattrack:GetTrackTypeStatFile(num), "DATA") then
		stattrack[typenam] = Deserialize(file.Read(stattrack:GetTrackTypeStatFile(num), "DATA"))
		stattrack[typenam] = stattrack[typenam].Ser
	end
end

function stattrack:SafeElementUpdateCreate(type, elem, key, value)
	local typenam = self:GetTypeTbl(type)
	if not self[typenam][elem] then self[typenam][elem] = {} end

	self[typenam][elem][key] = value
end

function stattrack:ElementRead(type, elem, key)
	local typenam = self:GetTypeTbl(type)
	if not self[typenam][elem] then return end

	return self[typenam][elem][key]
end

function stattrack:IncreaseElementKV(type, elem, key, incr)
	if self.BlackList then return end

	self:SafeElementUpdateCreate(type, elem, key, (self:ElementRead(type, elem, key) or 0) + incr)
end

function stattrack:SaveStatTrackingFiles()
	for num, ttype in pairs(ttypetblnames) do
		file.Write(stattrack:GetTrackTypeStatFile(num), Serialize({Ser = self[self:GetTypeTbl(num)]}))
	end
end

