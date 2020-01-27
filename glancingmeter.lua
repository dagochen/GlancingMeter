----------------------------------------------------------------------
---  GlancingMeter (reworked for 1.13)
---  by dagochen @ Lucifron (DE-PVP)
---  Based on the original glancing meter by Billmaan & Terrordar
----------------------------------------------------------------------


----------------------------------------------------------------------
--- GLOBAL VARS
----------------------------------------------------------------------

GLANCINGMETER_VERSION = "0.8"


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



local totalWhiteDmg = 0
local delta = 0
local mainhand = 0

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
	mainhand = (mainhand + 1) % 2
	GlancingMeterUpdateFrame()
end




function GlancingMeterPlus()
	if (320 > (delta + 1)) then
		delta = delta + 1
	else
		delta = delta 
	end
	GlancingMeterUpdateFrame()
end

function GlancingMeterMinus()
	if (-320 < (delta - 1)) then
		delta = delta - 1
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

		local ind = delta
		totalWhiteDmg = glanceDamage[ind][mainhand] + hitDamage[ind][mainhand] + critDamage[ind][mainhand]
		avgHit = GlancingMeterMyDiv(hitDamage[ind][mainhand], hitCount[ind][mainhand])
		avgCrit = GlancingMeterMyDiv(critDamage[ind][mainhand], critCount[ind][mainhand])
		avgGlance = GlancingMeterMyDiv(glanceDamage[ind][mainhand], glanceCount[ind][mainhand])

		whiteDmgLost = (avgHit - avgGlance) * glanceCount[ind][mainhand]

		lostOnTotal = GlancingMeterMyDiv(100 * whiteDmgLost, ( whiteDmgLost + otherDamage[ind][mainhand] + totalWhiteDmg))
		if (lostOnTotal < 0.0) then 
			lostOnTotal = 0.0
		end
		
		glanceOnHit = GlancingMeterMyDiv(100 * avgGlance, avgHit)

		if(minimized == false) then

			GlancingMeterMainFrame_HitCountText:SetText(hitCount[ind][mainhand])
			tempString = string.format("%.1f", GlancingMeterMyDiv(100*hitCount[ind][mainhand], swingCount[ind][mainhand]))
			GlancingMeterMainFrame_HitPercentText:SetText(tempString)
			tempString = string.format("%.1f", avgHit)
			GlancingMeterMainFrame_HitAvgText:SetText(tempString)
			GlancingMeterMainFrame_HitTotText:SetText(hitDamage[ind][mainhand])

			GlancingMeterMainFrame_GlancCountText:SetText(glanceCount[ind][mainhand])
			tempString = string.format("%.1f", GlancingMeterMyDiv(100*glanceCount[ind][mainhand], swingCount[ind][mainhand]))
			GlancingMeterMainFrame_GlancPercentText:SetText(tempString)
			tempString = string.format("%.1f", avgGlance)
			GlancingMeterMainFrame_GlancAvgText:SetText(tempString)
			GlancingMeterMainFrame_GlancTotText:SetText(glanceDamage[ind][mainhand])

			GlancingMeterMainFrame_CritCountText:SetText(critCount[ind][mainhand])
			tempString = string.format("%.1f", GlancingMeterMyDiv(100*critCount[ind][mainhand], swingCount[ind][mainhand]))
			GlancingMeterMainFrame_CritPercentText:SetText(tempString)
			tempString = string.format("%.1f", avgCrit)
			GlancingMeterMainFrame_CritAvgText:SetText(tempString)
			GlancingMeterMainFrame_CritTotText:SetText(critDamage[ind][mainhand])

			GlancingMeterMainFrame_MissCountText:SetText(missCount[ind][mainhand])
			tempString = string.format("%.1f", GlancingMeterMyDiv(100*missCount[ind][mainhand], swingCount[ind][mainhand]))
			GlancingMeterMainFrame_MissPercentText:SetText(tempString)

			GlancingMeterMainFrame_DodgeCountText:SetText(dodgeCount[ind][mainhand])
			tempString = string.format("%.1f", GlancingMeterMyDiv(100*dodgeCount[ind][mainhand], swingCount[ind][mainhand]))
			GlancingMeterMainFrame_DodgePercentText:SetText(tempString)
			
			GlancingMeterMainFrame_ParryCountText:SetText(parryCount[ind][mainhand])
			tempString = string.format("%.1f", GlancingMeterMyDiv(100*parryCount[ind][mainhand], swingCount[ind][mainhand]))
			GlancingMeterMainFrame_ParryPercentText:SetText(tempString)

			GlancingMeterMainFrame_TotCountText:SetText(swingCount[ind][mainhand])
			GlancingMeterMainFrame_TotTotText:SetText(totalWhiteDmg)

			GlancingMeterMainFrame_OtherDmgText:SetText(otherDamage[ind][mainhand])

			tempString = string.format("%.1f", glanceOnHit)
			GlancingMeterMainFrame_GlanceOnHitText:SetText(tempString)

		end

		tempString = string.format("%.2f%%", lostOnTotal)
		GlancingMeterMainFrame_LossText:SetText(tempString)

		

	tempString = delta
	if (delta > 0) then
		tempString = "+" .. delta
	end
	
	GlancingMeterMainFrame_DeltaText:SetText(tempString)
	
	if (mainhand == 0) then
		tempString = "MH"
	else
		tempString = "OH"
	end
	GlancingMeterMainFrame_MainhandText:SetText(tempString)


end

function GlancingMeterReset()
	
	for i=-320, 320 do
		hitCount[i] = {}
		glanceCount[i] = {}
		critCount[i] = {}
		missCount[i] = {}
		hitDamage[i] = {}
		glanceDamage[i] = {}
		critDamage[i] = {}
		swingCount[i] = {}
		dodgeCount[i] = {}
		parryCount[i] = {}
		otherDamage[i] = {}

		for j = 0,1 do
			hitCount[i][j] = 0
			glanceCount[i][j] = 0
			critCount[i][j] = 0
			missCount[i][j] = 0
			hitDamage[i][j] = 0
			glanceDamage[i][j] = 0
			critDamage[i][j] = 0
			swingCount[i][j] = 0
			dodgeCount[i][j] = 0
			parryCount[i][j] = 0
			otherDamage[i][j] = 0
		end
	end
	delta = 0
	mainhand = 0
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
			local feralForm = GetShapeshiftForm(false);
			local _, _, classIndex = UnitClass("player");
			local playerGUID = UnitGUID("player")
			local baseDefense = (UnitLevel("target") * 5);
			local mainBase, mainMod, offBase, offMod = UnitAttackBothHands("player");
			local mainHandWeaponSkill = mainBase + mainMod
			local offHandWeaponSkill = offBase + offMod
			if (classIndex == 11 and feralForm > 0) then
				mainHandWeaponSkill = UnitLevel("player") * 5
			end
			local mh = 0
			local ind = baseDefense - mainHandWeaponSkill
			if (subEvent == "SWING_DAMAGE" and (sourceGUID == playerGUID)) then
				local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12,  CombatLogGetCurrentEventInfo())
				if (isOffHand) then
					mh = 1
					ind = baseDefense - offHandWeaponSkill
				end
				swingCount[ind][mh] = swingCount[ind][mh] + 1
				
				if (critical) then
					critDamage[ind][mh] = critDamage[ind][mh] + amount
					critCount[ind][mh] = critCount[ind][mh] + 1
				end
				if (glancing) then
					glanceDamage[ind][mh] = glanceDamage[ind][mh] + amount
					glanceCount[ind][mh] = glanceCount[ind][mh] + 1
				end
				if (not glancing and not critical) then
					hitCount[ind][mh] = hitCount[ind][mh] + 1
					hitDamage[ind][mh] = hitDamage[ind][mh] + amount
				end
			end

			if (subEvent == "SPELL_DAMAGE" and (sourceGUID == playerGUID)) then
				local amount = select(15,  CombatLogGetCurrentEventInfo())
				otherDamage[ind][0] = otherDamage[ind][0] + amount
				otherDamage[ind][1] = otherDamage[ind][1] + amount
			end

			if (subEvent == "SWING_MISSED" and (sourceGUID == playerGUID)) then
				local missType, isOffHand = select(12,  CombatLogGetCurrentEventInfo())
				if (isOffHand) then
					mh = 1
					ind = baseDefense - offHandWeaponSkill
				end
				if (missType == "MISS") then
					swingCount[ind][mh] = swingCount[ind][mh] + 1
					missCount[ind][mh] = missCount[ind][mh] + 1 
				end	
				if (missType == "DODGE") then
					swingCount[ind][mh] = swingCount[ind][mh] + 1
					dodgeCount[ind][mh] = dodgeCount[ind][mh] + 1 
				end
				if (missType == "PARRY") then
					swingCount[ind][mh] = swingCount[ind][mh] + 1
					parryCount[ind][mh] = parryCount[ind][mh] + 1 
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
