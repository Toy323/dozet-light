INC_SERVER()

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	if ent:IsValid() then
		local noknockdown = true
		if CurTime() >= (ent.NextKnockdown or 0) then
			noknockdown = false
			ent.NextKnockdown = CurTime() + 7
		end
		ent:ThrowFromPositionSetZ(trace.StartPos, ent:IsPlayer() and 500 or 1000, nil, noknockdown)
	end

	self.BaseClass.ApplyMeleeDamage(self, ent, trace, damage)
end
