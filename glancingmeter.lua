----------------------------------------------------------------------
---  GlancingMeter (reworked for 1.13)
---  by dagochen @ Lucifron (DE-PVP)
---  Based on the original glancing meter by Billmaan & Terrordar
----------------------------------------------------------------------


----------------------------------------------------------------------
--- GLOBAL VARS
----------------------------------------------------------------------

GLANCINGMETER_VERSION = "1.0"


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



local mainhand = 0
local mb, mm, _ , _ = UnitAttackBothHands("player");
local ws = mb + mm
local level = UnitLevel("player")

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
	mainhand = 0
	GlancingMeterUpdateFrame()
end

function GlancingMeterOffhand()
	mainhand = 1
	GlancingMeterUpdateFrame()
end

function GlancingMeterLevelBoss()
	level = 64
	GlancingMeterUpdateFrame()
end

function GlancingMeterSkillMY()
	
	local feralForm = GetShapeshiftForm(false)
	local _, _, classIndex = UnitClass("player")
	local playerLevel = UnitLevel("player")
	local mainBase, mainMod, offBase, offMod = UnitAttackBothHands("player");
	local mainHandWeaponSkill = mainBase + mainMod
	local offHandWeaponSkill = offBase + offMod
	if (classIndex == 11 and feralForm > 0) then
		mainHandWeaponSkill = playerLevel * 5
		offHandWeaponSkill = playerLevel * 5
	end
	if (mainhand == 1) then
		ws  = offHandWeaponSkill
	else
		ws = mainHandWeaponSkill
	end
	GlancingMeterUpdateFrame()
end

function GlancingMeterSkillPlus()
	
	if (ws < 320) then
		ws = ws + 1
	end

	GlancingMeterUpdateFrame()
end

function GlancingMeterSkillMinus()
	
	if (ws > 1) then
		ws = ws - 1
	end
	GlancingMeterUpdateFrame()
end


function GlancingMeterLevelPlus()
	
	if (level < 64) then
		level = level + 1
	end

	GlancingMeterUpdateFrame()
end

function GlancingMeterLevelMinus()
	
	if (level > 1) then
		level = level - 1
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

	local glanceDmg, hitDmg, critDmg, glanceCnt, hitCnt, critCnt, swingCnt, otherDmg, missCnt, dodgeCnt, parryCnt
	local totalWhiteDmg = 0
	local ind = mainhand .. ";" .. ws .. ";" .. level
	
	if (swingCount[ind] ~= nil) then
		swingCnt = swingCount[ind]
	else
		swingCnt = 0
	end

	if (hitCount[ind] ~= nil) then
		hitCnt = hitCount[ind]
	else
		hitCnt = 0
	end

	if (critCount[ind] ~= nil) then
		critCnt = critCount[ind]
	else
		critCnt = 0
	end

	if (hitDamage[ind] ~= nil) then
		hitDmg = hitDamage[ind]
	else
		hitDmg = 0
	end

	if (critDamage[ind] ~= nil) then
		critDmg = critDamage[ind]
	else
		critDmg = 0
	end
	
	if (glanceCount[ind] ~= nil) then
		glanceCnt = glanceCount[ind]
	else
		glanceCnt = 0
	end
	
	if (glanceDamage[ind] ~= nil) then
		glanceDmg = glanceDamage[ind]
	else
		glanceDmg = 0
	end

	if (otherDamage[ind] ~= nil) then
		otherDmg = otherDamage[ind]
	else
		otherDmg = 0
	end

	if (missCount[ind] ~= nil) then
		missCnt = missCount[ind]
	else
		missCnt = 0
	end
	

	if (dodgeCount[ind] ~= nil) then
		dodgeCnt = dodgeCount[ind]
	else
		dodgeCnt = 0
	end
	

	if (parryCount[ind] ~= nil) then
		parryCnt = parryCount[ind]
	else
		parryCnt = 0
	end
	

	totalWhiteDmg = glanceDmg + hitDmg + critDmg
	avgHit = GlancingMeterMyDiv(hitDmg, hitCnt)
	avgCrit = GlancingMeterMyDiv(critDmg, critCnt)
	avgGlance = GlancingMeterMyDiv(glanceDmg, glanceCnt)

	whiteDmgLost = (avgHit - avgGlance) * glanceCnt

	lostOnTotal = GlancingMeterMyDiv(100 * whiteDmgLost, ( whiteDmgLost + otherDmg + totalWhiteDmg))
	if (lostOnTotal < 0.0) then 
		lostOnTotal = 0.0
	end
	
	glanceOnHit = GlancingMeterMyDiv(100 * avgGlance, avgHit)

	if(minimized == false) then

		GlancingMeterMainFrame_HitCountText:SetText(hitCnt)
		tempString = string.format("%.1f", GlancingMeterMyDiv(100 * hitCnt, swingCnt))
		GlancingMeterMainFrame_HitPercentText:SetText(tempString)
		tempString = string.format("%.1f", avgHit)
		GlancingMeterMainFrame_HitAvgText:SetText(tempString)
		GlancingMeterMainFrame_HitTotText:SetText(hitDmg)

		GlancingMeterMainFrame_GlancCountText:SetText(glanceCnt)
		tempString = string.format("%.1f", GlancingMeterMyDiv(100 * glanceCnt, swingCnt))
		GlancingMeterMainFrame_GlancPercentText:SetText(tempString)
		tempString = string.format("%.1f", avgGlance)
		GlancingMeterMainFrame_GlancAvgText:SetText(tempString)
		GlancingMeterMainFrame_GlancTotText:SetText(glanceDmg)

		GlancingMeterMainFrame_CritCountText:SetText(critCnt)
		tempString = string.format("%.1f", GlancingMeterMyDiv(100 * critCnt, swingCnt))
		GlancingMeterMainFrame_CritPercentText:SetText(tempString)
		tempString = string.format("%.1f", avgCrit)
		GlancingMeterMainFrame_CritAvgText:SetText(tempString)
		GlancingMeterMainFrame_CritTotText:SetText(critDmg)

		GlancingMeterMainFrame_MissCountText:SetText(missCnt)
		tempString = string.format("%.1f", GlancingMeterMyDiv(100 * missCnt, swingCnt))
		GlancingMeterMainFrame_MissPercentText:SetText(tempString)

		GlancingMeterMainFrame_DodgeCountText:SetText(dodgeCnt)
		tempString = string.format("%.1f", GlancingMeterMyDiv(100 * dodgeCnt, swingCnt))
		GlancingMeterMainFrame_DodgePercentText:SetText(tempString)
		
		GlancingMeterMainFrame_ParryCountText:SetText(parryCnt)
		tempString = string.format("%.1f", GlancingMeterMyDiv(100 * parryCnt, swingCnt))
		GlancingMeterMainFrame_ParryPercentText:SetText(tempString)

		GlancingMeterMainFrame_TotCountText:SetText(swingCnt)
		GlancingMeterMainFrame_TotTotText:SetText(totalWhiteDmg)

		GlancingMeterMainFrame_OtherDmgText:SetText(otherDmg)

		tempString = string.format("%.1f", glanceOnHit)
		GlancingMeterMainFrame_GlanceOnHitText:SetText(tempString)

	end

	tempString = string.format("%.2f%%", lostOnTotal)
	GlancingMeterMainFrame_LossText:SetText(tempString)

	if (level <= 63) then
		tempString = " " .. level
	else
		tempString = " Boss"
	end
		
	GlancingMeterMainFrame_LevelText:SetText(tempString)
	
	tempString = " " .. ws
	GlancingMeterMainFrame_WSText:SetText(tempString)
	
	if (mainhand == 0) then
		tempString = " Mainhand"
	end
	if (mainhand == 1) then
		tempString = " Offhand"
	end

	GlancingMeterMainFrame_MainhandText:SetText(tempString)

end

function GlancingMeterReset()

	hitCount = {}
	glanceCount = {}
	critCount = {}
	missCount = {}
	hitDamage = {}
	glanceDamage = {}
	critDamage = {}
	swingCount = {}
	dodgeCount = {}
	parryCount = {}
	otherDamage = {}

	level = UnitLevel("player")
	mainhand = 0
	local mb, mm, _ , _ = UnitAttackBothHands("player");
	ws = mb + mm
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
		GlancingMeterMainFrame_LevelText:Hide()
		GlancingMeterMainFrame_WSText:Hide()
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
		GlancingMeterMainFrame_LevelLabelText:Hide()
		GlancingMeterMainFrame_WSLabelText:Hide()
		GlancingMeterMainFrame_MainhandLabelText:Hide()
		GlancingMeterMainFrame_DodgeLabelText:Hide()
		GlancingMeterMainFrame_ParryLabelText:Hide()
		
		GlancingMeterMainFrame_GlancingMeterMYSkillButton:Hide()
		GlancingMeterMainFrame_GlancingMeterPlusSkillButton:Hide()
		GlancingMeterMainFrame_GlancingMeterMinusSkillButton:Hide()
		GlancingMeterMainFrame_GlancingMeterMinusLevelButton:Hide()
		GlancingMeterMainFrame_GlancingMeterLevelBOSSButton:Hide()
		GlancingMeterMainFrame_GlancingMeterPlusLevelButton:Hide()
		GlancingMeterMainFrame_GlancingMeterMainhandButton:Hide()
		GlancingMeterMainFrame_GlancingMeterOffhandButton:Hide()
	else   
		f:SetHeight(240)
		f:SetWidth(220)
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
		GlancingMeterMainFrame_LevelText:Show()
		GlancingMeterMainFrame_WSText:Show()
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
		GlancingMeterMainFrame_LevelLabelText:Show()
		GlancingMeterMainFrame_WSLabelText:Show()
		GlancingMeterMainFrame_MainhandLabelText:Show()
		GlancingMeterMainFrame_DodgeLabelText:Show()
		GlancingMeterMainFrame_ParryLabelText:Show()

		GlancingMeterMainFrame_GlancingMeterMYSkillButton:Show()
		GlancingMeterMainFrame_GlancingMeterPlusSkillButton:Show()
		GlancingMeterMainFrame_GlancingMeterMinusSkillButton:Show()
		GlancingMeterMainFrame_GlancingMeterMinusLevelButton:Show()
		GlancingMeterMainFrame_GlancingMeterLevelBOSSButton:Show()
		GlancingMeterMainFrame_GlancingMeterPlusLevelButton:Show()
		GlancingMeterMainFrame_GlancingMeterMainhandButton:Show()
		GlancingMeterMainFrame_GlancingMeterOffhandButton:Show()
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

function initialize(index)
	if (swingCount[index] == nil) then
		swingCount[index] = 0
	else
		return
	end

	if (hitCount[index] == nil) then
		hitCount[index] = 0
	end

	if (critCount[index] == nil) then
		 critCount[index] = 0
	end

	if (hitDamage[index] == nil) then
		 hitDamage[index] = 0
	end

	if (critDamage[index] == nil) then
		critDamage[index] = 0
	end
	
	if (glanceCount[index] == nil) then
		glanceCount[index] = 0
	end
	
	if (glanceDamage[index] == nil) then
		glanceDamage[index] = 0
	end

	if (otherDamage[index] == nil) then
		otherDamage[index] = 0
	end

	if (missCount[index] == nil) then
		 missCount[index] = 0
	end

	if (dodgeCount[index] == nil) then
		dodgeCount[index] = 0
	end

	if (parryCount[index] == nil) then
	 	parryCount[index] = 0
	end
end

function GlancingMeterOnEvent(self, event)
	
	
	if( paused == false ) then
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local timestamp, subEvent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo() 
			local feralForm = GetShapeshiftForm(false)
			local _, _, classIndex = UnitClass("player")
			local playerGUID = UnitGUID("player")
			local playerLevel = UnitLevel("player")
			local targetLevel = UnitLevel("target")
			local isPlayer = UnitPlayerControlled("target")
			
			if (isPlayer) then
				return
			end

			local mainBase, mainMod, offBase, offMod = UnitAttackBothHands("player");
			local mainHandWeaponSkill = mainBase + mainMod
			local offHandWeaponSkill = offBase + offMod
			if (classIndex == 11 and feralForm > 0) then
				mainHandWeaponSkill = playerLevel * 5
				offHandWeaponSkill = playerLevel * 5
			end
			local mh = 0
			local ind = mh .. ";" .. mainHandWeaponSkill .. ";" .. targetLevel
			initialize(ind)
			initialize("1" .. ";" .. offHandWeaponSkill .. ";" .. targetLevel)
			if (subEvent == "SWING_DAMAGE" and (sourceGUID == playerGUID)) then
				local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12,  CombatLogGetCurrentEventInfo())
				if (isOffHand) then
					mh = 1
					ind = mh .. ";" ..offHandWeaponSkill .. ";" .. targetLevel
				end
				swingCount[ind] = swingCount[ind] + 1
				
				if (critical) then
					critDamage[ind] = critDamage[ind] + amount
					critCount[ind] = critCount[ind] + 1
				end
				if (glancing) then
					glanceDamage[ind] = glanceDamage[ind] + amount
					glanceCount[ind] = glanceCount[ind] + 1
				end
				if (not glancing and not critical) then
					hitCount[ind] = hitCount[ind] + 1
					hitDamage[ind] = hitDamage[ind] + amount
				end
			end

			if (subEvent == "SPELL_DAMAGE" and (sourceGUID == playerGUID)) then
				local amount = select(15,  CombatLogGetCurrentEventInfo())
				otherDamage[0 .. ";" .. mainHandWeaponSkill .. ";" .. targetLevel] = otherDamage[0 .. ";" .. mainHandWeaponSkill .. ";" .. targetLevel] + amount
				otherDamage[1 .. ";" .. offHandWeaponSkill .. ";" .. targetLevel] = otherDamage[1 .. ";" .. offHandWeaponSkill .. ";" .. targetLevel] + amount
			end

			if (subEvent == "SWING_MISSED" and (sourceGUID == playerGUID)) then
				local missType, isOffHand = select(12,  CombatLogGetCurrentEventInfo())
				if (isOffHand) then
					mh = 1
					ind = mh .. ";" .. offHandWeaponSkill .. ";" .. targetLevel
				end
				if (missType == "MISS") then
					swingCount[ind] = swingCount[ind] + 1
					missCount[ind] = missCount[ind] + 1 
				end	
				if (missType == "DODGE") then
					swingCount[ind] = swingCount[ind] + 1
					dodgeCount[ind] = dodgeCount[ind] + 1 
				end
				if (missType == "PARRY") then
					swingCount[ind] = swingCount[ind] + 1
					parryCount[ind] = parryCount[ind] + 1 
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
