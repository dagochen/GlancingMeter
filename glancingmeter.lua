----------------------------------------------------------------------
---  GlancingMeter (reworked for 1.13)
---  by dagochen @ Lucifron (DE-PVP)
---  Based on the original glancing meter by Billmaan & Terrordar
----------------------------------------------------------------------


----------------------------------------------------------------------
--- GLOBAL VARS
----------------------------------------------------------------------

GLANCINGMETER_VERSION = "0.7"

local swingCount = 0
local hitCount = 0
local glanceCount = 0
local critCount = 0
local missCount = 0
local hitDamage = 0
local glanceDamage = 0
local critDamage = 0
local otherDamage = 0
local totalWhiteDmg = 0

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

	totalWhiteDmg = glanceDamage + hitDamage + critDamage
	avgHit = GlancingMeterMyDiv(hitDamage, hitCount)
	avgCrit = GlancingMeterMyDiv(critDamage, critCount)
	avgGlance = GlancingMeterMyDiv(glanceDamage, glanceCount)

	whiteDmgLost = (avgHit - avgGlance) * glanceCount

	lostOnTotal = GlancingMeterMyDiv(100 * whiteDmgLost, ( whiteDmgLost + otherDamage + totalWhiteDmg ) )
	if (lostOnTotal < 0.0) then 
		lostOnTotal = 0.0
	end
	
	glanceOnHit = GlancingMeterMyDiv(100 * avgGlance, avgHit )

	if(minimized == false) then

		GlancingMeterMainFrame_HitCountText:SetText(hitCount)
		tempString = string.format("%.1f", GlancingMeterMyDiv(100*hitCount, swingCount))
		GlancingMeterMainFrame_HitPercentText:SetText(tempString)
		tempString = string.format("%.1f", avgHit)
		GlancingMeterMainFrame_HitAvgText:SetText(tempString)
		GlancingMeterMainFrame_HitTotText:SetText(hitDamage)

		GlancingMeterMainFrame_GlancCountText:SetText(glanceCount)
		tempString = string.format("%.1f", GlancingMeterMyDiv(100*glanceCount, swingCount))
		GlancingMeterMainFrame_GlancPercentText:SetText(tempString)
		tempString = string.format("%.1f", avgGlance)
		GlancingMeterMainFrame_GlancAvgText:SetText(tempString)
		GlancingMeterMainFrame_GlancTotText:SetText(glanceDamage)

		GlancingMeterMainFrame_CritCountText:SetText(critCount)
		tempString = string.format("%.1f", GlancingMeterMyDiv(100*critCount, swingCount))
		GlancingMeterMainFrame_CritPercentText:SetText(tempString)
		tempString = string.format("%.1f", avgCrit)
		GlancingMeterMainFrame_CritAvgText:SetText(tempString)
		GlancingMeterMainFrame_CritTotText:SetText(critDamage)

		GlancingMeterMainFrame_MissCountText:SetText(missCount)
		tempString = string.format("%.1f", GlancingMeterMyDiv(100*missCount, swingCount))
		GlancingMeterMainFrame_MissPercentText:SetText(tempString)

		GlancingMeterMainFrame_TotCountText:SetText(swingCount)
		GlancingMeterMainFrame_TotTotText:SetText(totalWhiteDmg)

		GlancingMeterMainFrame_OtherDmgText:SetText(otherDamage)

		tempString = string.format("%.1f", glanceOnHit)
		GlancingMeterMainFrame_GlanceOnHitText:SetText(tempString)

	end

	tempString = string.format("%.2f%%", lostOnTotal)
	GlancingMeterMainFrame_LossText:SetText(tempString)

end

function GlancingMeterReset()
		
	hitCount = 0
	glanceCount = 0
	critCount = 0
	missCount = 0
	hitDamage = 0
	glanceDamage = 0
	critDamage = 0
	swingCount = 0
	otherDamage = 0
	GlancingMeterUpdateFrame()
	print("GlancingMeter data reset")

end

function GlancingMeterMinimize()

	
	
 	local f = _G["GlancingMeterMainFrame"]


	if(minimized == false) then
		f:SetHeight(30)
		f:SetWidth(175)
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

	else   
		f:SetHeight(180)
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
			local time, subEvent, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = CombatLogGetCurrentEventInfo() 
			
			if (subEvent == "SWING_DAMAGE") then
				local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12,  CombatLogGetCurrentEventInfo())
				swingCount = swingCount + 1
				if (critical) then
					critDamage = critDamage + amount
					critCount = critCount + 1
				end
				if (glancing) then
					glanceDamage = glanceDamage + amount
					glanceCount = glanceCount + 1
				end
				if (not glancing and not critical) then
					hitCount = hitCount + 1
					hitDamage = hitDamage + amount
				end
			end

			if (subEvent == "SPELL_DAMAGE") then
				local amount = select(15,  CombatLogGetCurrentEventInfo())
				otherDamage = otherDamage + amount; 
			end

			if (subEvent == "SWING_MISSED") then
				local missType = select(12,  CombatLogGetCurrentEventInfo())
				if (missType == "MISS") then
					swingCount = swingCount + 1
					missCount = missCount + 1 
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
