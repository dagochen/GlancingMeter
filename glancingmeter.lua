----------------------------------------------------------------------
---  GlancingMeter (reworked for 1.13)
---  by dagochen @ Lucifron (DE-PVP)
---  Based on the original glancing meter by Billmaan & Terrordar
----------------------------------------------------------------------


----------------------------------------------------------------------
--- GLOBAL VARS
----------------------------------------------------------------------

GLANCINGMETER_VERSION = "0.7"


 swingCount = {}
 hitCount = {}
 glanceCount = {}
 critCount = {}
 missCount = {}
 hitDamage = {}
 glanceDamage = {}
 critDamage = {}
 otherDamage = {}
 dodgeCount = {}
 parryCount = {}

 OHswingCount = {}
 OHhitCount = {}
 OHglanceCount = {}
 OHcritCount = {}
 OHmissCount = {}
 OHhitDamage = {}
 OHglanceDamage = {}
 OHcritDamage = {}
 OHotherDamage = {}
 OHdodgeCount = {}
 OHparryCount = {}


local totalWhiteDmg = 0
local delta = 0
local mainhand = true

local paused = false
local minimized = false

function GlancingMeterMyDiv(arg1, arg2)
	local rVal = 0
	if (arg2 ~= 0) then
		rVal = arg1 / arg2
	end
	return rVal
end


function GlancingMeterClose()
	local f = _G["GlancingMeterMainFrame"]
	
	if (f) then
		if (f:IsVisible()) then
			paused = true
			GlancingMeterMainFrame_PausedText:Show()
			f:Hide()
			print("GlancingMeter closed. Use /gm show to display it again")
		else
			paused = false
			GlancingMeterMainFrame_PausedText:Hide()
			f:Hide()
			f:Show()
		end
	end
end

function GlancingMeterMainhand()
	mainhand = not mainhand
	GlancingMeterUpdateFrame()
end


function GlancingMeterPlus()
	playerLevel = UnitLevel("player")
	if ((63 - playerLevel) > (delta + 1)) then
		delta = delta + 1
	else
		delta = delta 
	end
	GlancingMeterUpdateFrame()
end

function GlancingMeterMinus()
	playerLevel = UnitLevel("player")
	if (playerLevel * -1) < (delta -1) then
		delta = delta -1
	else
		delta = delta 
	end
	GlancingMeterUpdateFrame()
end

function GlancingMeterPause()

	if (paused == false) then
		GlancingMeterMainFrame_PausedText:Show()
		print("GlancingMeter paused")
		paused = true
	else
		GlancingMeterMainFrame_PausedText:Hide()
		print("GlancingMeter unpaused")
		paused = false
	end
end

function GlancingMeterUpdateFrame()
	
	if (mainhand) then
		local index = delta

		totalWhiteDmg = glanceDamage[index] + hitDamage[index] + critDamage[index]
		avgHit = GlancingMeterMyDiv(hitDamage[index], hitCount[index])
		avgCrit = GlancingMeterMyDiv(critDamage[index], critCount[index])
		avgGlance = GlancingMeterMyDiv(glanceDamage[index], glanceCount[index])

		whiteDmgLost = (avgHit - avgGlance) * glanceCount[index]

		lostOnTotal = GlancingMeterMyDiv(100 * whiteDmgLost, ( whiteDmgLost + otherDamage[index] + totalWhiteDmg))
		if (lostOnTotal < 0.0) then 
			lostOnTotal = 0.0
		end
		
		glanceOnHit = GlancingMeterMyDiv(100 * avgGlance, avgHit)

		if(minimized == false) then

			GlancingMeterMainFrame_HitCountText:SetText(hitCount[index])
			tempString = string.format("%.1f", GlancingMeterMyDiv(100*hitCount[index], swingCount[index]))
			GlancingMeterMainFrame_HitPercentText:SetText(tempString)
			tempString = string.format("%.1f", avgHit)
			GlancingMeterMainFrame_HitAvgText:SetText(tempString)
			GlancingMeterMainFrame_HitTotText:SetText(hitDamage[index])

			GlancingMeterMainFrame_GlancCountText:SetText(glanceCount[index])
			tempString = string.format("%.1f", GlancingMeterMyDiv(100*glanceCount[index], swingCount[index]))
			GlancingMeterMainFrame_GlancPercentText:SetText(tempString)
			tempString = string.format("%.1f", avgGlance)
			GlancingMeterMainFrame_GlancAvgText:SetText(tempString)
			GlancingMeterMainFrame_GlancTotText:SetText(glanceDamage[index])

			GlancingMeterMainFrame_CritCountText:SetText(critCount[index])
			tempString = string.format("%.1f", GlancingMeterMyDiv(100*critCount[index], swingCount[index]))
			GlancingMeterMainFrame_CritPercentText:SetText(tempString)
			tempString = string.format("%.1f", avgCrit)
			GlancingMeterMainFrame_CritAvgText:SetText(tempString)
			GlancingMeterMainFrame_CritTotText:SetText(critDamage[index])

			GlancingMeterMainFrame_MissCountText:SetText(missCount[index])
			tempString = string.format("%.1f", GlancingMeterMyDiv(100*missCount[index], swingCount[index]))
			GlancingMeterMainFrame_MissPercentText:SetText(tempString)

			GlancingMeterMainFrame_DodgeCountText:SetText(dodgeCount[index])
			tempString = string.format("%.1f", GlancingMeterMyDiv(100*dodgeCount[index], swingCount[index]))
			GlancingMeterMainFrame_DodgePercentText:SetText(tempString)
			
			GlancingMeterMainFrame_ParryCountText:SetText(parryCount[index])
			tempString = string.format("%.1f", GlancingMeterMyDiv(100*parryCount[index], swingCount[index]))
			GlancingMeterMainFrame_ParryPercentText:SetText(tempString)

			GlancingMeterMainFrame_TotCountText:SetText(swingCount[index])
			GlancingMeterMainFrame_TotTotText:SetText(totalWhiteDmg)

			GlancingMeterMainFrame_OtherDmgText:SetText(otherDamage[index])

			tempString = string.format("%.1f", glanceOnHit)
			GlancingMeterMainFrame_GlanceOnHitText:SetText(tempString)

		end

		tempString = string.format("%.2f%%", lostOnTotal)
		GlancingMeterMainFrame_LossText:SetText(tempString)

		

	else
		
		local index = delta

		totalWhiteDmg = OHglanceDamage[index] + OHhitDamage[index] + OHcritDamage[index]
		avgHit = GlancingMeterMyDiv(OHhitDamage[index], OHhitCount[index])
		avgCrit = GlancingMeterMyDiv(OHcritDamage[index], OHcritCount[index])
		avgGlance = GlancingMeterMyDiv(OHglanceDamage[index], OHglanceCount[index])

		whiteDmgLost = (avgHit - avgGlance) * OHglanceCount[index]

		lostOnTotal = GlancingMeterMyDiv(100 * whiteDmgLost, ( whiteDmgLost + OHotherDamage[index] + totalWhiteDmg))
		if (lostOnTotal < 0.0) then 
			lostOnTotal = 0.0
		end
		
		glanceOnHit = GlancingMeterMyDiv(100 * avgGlance, avgHit)

		if(minimized == false) then

			GlancingMeterMainFrame_HitCountText:SetText(OHhitCount[index])
			tempString = string.format("%.1f", GlancingMeterMyDiv(100*OHhitCount[index], OHswingCount[index]))
			GlancingMeterMainFrame_HitPercentText:SetText(tempString)
			tempString = string.format("%.1f", avgHit)
			GlancingMeterMainFrame_HitAvgText:SetText(tempString)
			GlancingMeterMainFrame_HitTotText:SetText(OHhitDamage[index])

			GlancingMeterMainFrame_GlancCountText:SetText(OHglanceCount[index])
			tempString = string.format("%.1f", GlancingMeterMyDiv(100*OHglanceCount[index], OHswingCount[index]))
			GlancingMeterMainFrame_GlancPercentText:SetText(tempString)
			tempString = string.format("%.1f", avgGlance)
			GlancingMeterMainFrame_GlancAvgText:SetText(tempString)
			GlancingMeterMainFrame_GlancTotText:SetText(OHglanceDamage[index])

			GlancingMeterMainFrame_CritCountText:SetText(OHcritCount[index])
			tempString = string.format("%.1f", GlancingMeterMyDiv(100*OHcritCount[index], OHswingCount[index]))
			GlancingMeterMainFrame_CritPercentText:SetText(tempString)
			tempString = string.format("%.1f", avgCrit)
			GlancingMeterMainFrame_CritAvgText:SetText(tempString)
			GlancingMeterMainFrame_CritTotText:SetText(OHcritDamage[index])

			GlancingMeterMainFrame_MissCountText:SetText(OHmissCount[index])
			tempString = string.format("%.1f", GlancingMeterMyDiv(100*OHmissCount[index], OHswingCount[index]))
			GlancingMeterMainFrame_MissPercentText:SetText(tempString)

			GlancingMeterMainFrame_DodgeCountText:SetText(OHdodgeCount[index])
			tempString = string.format("%.1f", GlancingMeterMyDiv(100*OHdodgeCount[index], OHswingCount[index]))
			GlancingMeterMainFrame_DodgePercentText:SetText(tempString)
			
			GlancingMeterMainFrame_ParryCountText:SetText(OHparryCount[index])
			tempString = string.format("%.1f", GlancingMeterMyDiv(100*OHparryCount[index], OHswingCount[index]))
			GlancingMeterMainFrame_ParryPercentText:SetText(tempString)

			GlancingMeterMainFrame_TotCountText:SetText(OHswingCount[index])
			GlancingMeterMainFrame_TotTotText:SetText(totalWhiteDmg)

			GlancingMeterMainFrame_OtherDmgText:SetText(OHotherDamage[index])

			tempString = string.format("%.1f", glanceOnHit)
			GlancingMeterMainFrame_GlanceOnHitText:SetText(tempString)

		end

		tempString = string.format("%.2f%%", lostOnTotal)
		GlancingMeterMainFrame_LossText:SetText(tempString)

		
	
	end

	tempString = delta
	if (delta > 0) then
		tempString = "+" .. delta
	end
	
	GlancingMeterMainFrame_DeltaText:SetText(tempString)

	
	if (mainhand) then
		tempString = "MH"
	else
		tempString = "OH"
	end
	
	GlancingMeterMainFrame_MainhandText:SetText(tempString)


end

function GlancingMeterReset()
	
	for i=-59, 62 do
		hitCount[i] = 0
		glanceCount[i] = 0
		critCount[i] = 0
		missCount[i] = 0
		hitDamage[i] = 0
		glanceDamage[i] = 0
		critDamage[i] = 0
		swingCount[i] = 0
		dodgeCount[i] = 0
		parryCount[i] = 0
		otherDamage[i] = 0

		OHhitCount[i] = 0
		OHglanceCount[i] = 0
		OHcritCount[i] = 0
		OHmissCount[i] = 0
		OHhitDamage[i] = 0
		OHglanceDamage[i] = 0
		OHcritDamage[i] = 0
		OHswingCount[i] = 0
		OHdodgeCount[i] = 0
		OHparryCount[i] = 0
		OHotherDamage[i] = 0
	  end
	delta = 0
	GlancingMeterUpdateFrame()
	print("GlancingMeter data reset")

end

function GlancingMeterMinimize()

	
	
 	local f = _G["GlancingMeterMainFrame"]


	if(minimized == false) then
		f:SetHeight(30)
		f:SetWidth(230)
		minimized = true

		-- makes text invisible
		GlancingMeterMainFrame_HitCountText:Hide()
		GlancingMeterMainFrame_HitPercentText:Hide()
		GlancingMeterMainFrame_HitAvgText:Hide()
		GlancingMeterMainFrame_HitTotText:Hide()
		GlancingMeterMainFrame_GlancCountText:Hide()
		GlancingMeterMainFrame_GlancPercentText:Hide()
		GlancingMeterMainFrame_GlancAvgText:Hide()
		GlancingMeterMainFrame_GlancTotText:Hide()
		GlancingMeterMainFrame_CritCountText:Hide()
		GlancingMeterMainFrame_CritPercentText:Hide()
		GlancingMeterMainFrame_CritAvgText:Hide()
		GlancingMeterMainFrame_CritTotText:Hide()
		GlancingMeterMainFrame_MissCountText:Hide()
		GlancingMeterMainFrame_MissPercentText:Hide()
		GlancingMeterMainFrame_TotCountText:Hide()
		GlancingMeterMainFrame_TotTotText:Hide()
		GlancingMeterMainFrame_OtherDmgText:Hide()
		GlancingMeterMainFrame_GlanceOnHitText:Hide()
		GlancingMeterMainFrame_DeltaText:Hide()
		GlancingMeterMainFrame_MainhandText:Hide()
		GlancingMeterMainFrame_DodgeCountText:Hide()
		GlancingMeterMainFrame_DodgePercentText:Hide()
		GlancingMeterMainFrame_ParryCountText:Hide()
		GlancingMeterMainFrame_ParryPercentText:Hide()


		GlancingMeterMainFrame_CountLabelText:Hide()
		GlancingMeterMainFrame_PercentLabelText:Hide()
		GlancingMeterMainFrame_AvgLabelText:Hide()
		GlancingMeterMainFrame_TotLabelText:Hide()
		GlancingMeterMainFrame_HitLabelText:Hide()
		GlancingMeterMainFrame_GlanceLabelText:Hide()
		GlancingMeterMainFrame_CritLabelText:Hide()
		GlancingMeterMainFrame_MissLabelText:Hide()
		GlancingMeterMainFrame_TotDmgLabelText:Hide()
		GlancingMeterMainFrame_OtherDmgLabelText:Hide()
		GlancingMeterMainFrame_GlanceOnHitLabelText:Hide()
		GlancingMeterMainFrame_DeltaLabelText:Hide()
		GlancingMeterMainFrame_MainhandLabelText:Hide()
		GlancingMeterMainFrame_DodgeLabelText:Hide()
		GlancingMeterMainFrame_ParryLabelText:Hide()
		

	else   
		f:SetHeight(200)
		f:SetWidth(230)
		minimized = false

		-- makes text visible
		GlancingMeterMainFrame_HitCountText:Show()
		GlancingMeterMainFrame_HitPercentText:Show()
		GlancingMeterMainFrame_HitAvgText:Show()
		GlancingMeterMainFrame_HitTotText:Show()
		GlancingMeterMainFrame_GlancCountText:Show()
		GlancingMeterMainFrame_GlancPercentText:Show()
		GlancingMeterMainFrame_GlancAvgText:Show()
		GlancingMeterMainFrame_GlancTotText:Show()
		GlancingMeterMainFrame_CritCountText:Show()
		GlancingMeterMainFrame_CritPercentText:Show()
		GlancingMeterMainFrame_CritAvgText:Show()
		GlancingMeterMainFrame_CritTotText:Show()
		GlancingMeterMainFrame_MissCountText:Show()
		GlancingMeterMainFrame_MissPercentText:Show()
		GlancingMeterMainFrame_TotCountText:Show()
		GlancingMeterMainFrame_TotTotText:Show()
		GlancingMeterMainFrame_OtherDmgText:Show()
		GlancingMeterMainFrame_GlanceOnHitText:Show()
		GlancingMeterMainFrame_DeltaText:Show()
		GlancingMeterMainFrame_MainhandText:Show()
		GlancingMeterMainFrame_DodgeCountText:Show()
		GlancingMeterMainFrame_DodgePercentText:Show()
		GlancingMeterMainFrame_ParryCountText:Show()
		GlancingMeterMainFrame_ParryPercentText:Show()
		
		GlancingMeterMainFrame_CountLabelText:Show()
		GlancingMeterMainFrame_PercentLabelText:Show()
		GlancingMeterMainFrame_AvgLabelText:Show()
		GlancingMeterMainFrame_TotLabelText:Show()
		GlancingMeterMainFrame_HitLabelText:Show()
		GlancingMeterMainFrame_GlanceLabelText:Show()
		GlancingMeterMainFrame_CritLabelText:Show()
		GlancingMeterMainFrame_MissLabelText:Show()
		GlancingMeterMainFrame_TotDmgLabelText:Show()
		GlancingMeterMainFrame_OtherDmgLabelText:Show()
		GlancingMeterMainFrame_GlanceOnHitLabelText:Show()
		GlancingMeterMainFrame_DeltaLabelText:Show()
		GlancingMeterMainFrame_MainhandLabelText:Show()
		GlancingMeterMainFrame_DodgeLabelText:Show()
		GlancingMeterMainFrame_ParryLabelText:Show()

		GlancingMeterUpdateFrame()

	end

end

function GlancingMeterHandleSlashCommand(arg)

	if (arg == "reset") then
		GlancingMeterReset()
	elseif (arg == "show") then
		GlancingMeterClose()
	elseif (arg == "pause") then
		GlancingMeterPause()
	else 
		print("GlancingMeter v" .. GLANCINGMETER_VERSION)
		print("/gm reset  = reset data")
		print("/gm show = hide/unhide frame")
		print("/gm pause = pause/unpause parsing")
	end

end


function GlancingMeterOnEvent(self, event)
	
	
	if( paused == false ) then
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local timestamp, subEvent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo() 
			local playerGUID = UnitGUID("player")
			local index = UnitLevel("target") - UnitLevel("player")
			if (subEvent == "SWING_DAMAGE" and (sourceGUID == playerGUID)) then
				local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12,  CombatLogGetCurrentEventInfo())
				if (isOffHand) then
					OHswingCount[index] = OHswingCount[index]  + 1
				else
					swingCount[index] = swingCount[index] + 1
				end
				if (critical) then
					if (isOffHand) then
						OHcritDamage[index] = OHcritDamage[index] + amount
						OHcritCount[index] = OHcritCount[index] + 1
					else
						critDamage[index] = critDamage[index] + amount
						critCount[index] = critCount[index] + 1
					end
				end
				if (glancing) then
					if (isOffHand) then
						OHglanceDamage[index] = OHglanceDamage[index] + amount
						OHglanceCount[index] = OHglanceCount[index] + 1			
					else
						glanceDamage[index] = glanceDamage[index] + amount
						glanceCount[index] = glanceCount[index] + 1
					end
				end
				if (not glancing and not critical) then
					if (isOffHand) then
						OHhitCount[index] = OHhitCount[index] + 1
						OHhitDamage[index] = OHhitDamage[index] + amount
					else
						hitCount[index] = hitCount[index] + 1
						hitDamage[index] = hitDamage[index] + amount
					end
				end
			end

			if (subEvent == "SPELL_DAMAGE" and (sourceGUID == playerGUID)) then
				local amount = select(15,  CombatLogGetCurrentEventInfo())
				otherDamage[index] = otherDamage[index] + amount
				OHotherDamage[index] = OHotherDamage[index] + amount
			end

			if (subEvent == "SWING_MISSED" and (sourceGUID == playerGUID)) then
				local missType, isOffHand = select(12,  CombatLogGetCurrentEventInfo())
				if (missType == "MISS") then
					if (isOffHand) then
						OHswingCount[index] = OHswingCount[index] + 1
						OHmissCount[index] = OHmissCount[index] + 1 
					else
						swingCount[index] = swingCount[index] + 1
						missCount[index] = missCount[index] + 1 
					end
				end	
				if (missType == "DODGE") then
					if (isOffHand) then
						OHswingCount[index] = swingCount[index] + 1
						OHdodgeCount[index] = dodgeCount[index] + 1					
					else
						swingCount[index] = swingCount[index] + 1
						dodgeCount[index] = dodgeCount[index] + 1 
					end
				end
				if (missType == "PARRY") then
					if (isOffHand) then
						OHswingCount[index] = swingCount[index] + 1
						OHparryCount[index] = parryCount[index] + 1
					else
						swingCount[index] = swingCount[index] + 1
						parryCount[index] = parryCount[index] + 1 
					end
				end
			end

		end
		GlancingMeterUpdateFrame()
	end
end
		

function GlancingMeterOnLoad(self)
		
	self:RegisterForDrag("LeftButton")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	
	SLASH_GLANCINGMETER1 = "/glancingmeter"
	SLASH_GLANCINGMETER2 = "/gm"
	SlashCmdList["GLANCINGMETER"] = GlancingMeterHandleSlashCommand

	print("GlancingMeter loaded")

	GlancingMeterReset()
end
