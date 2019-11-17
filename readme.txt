+++++++++++++++++
			
    GlancingMeter v0.7	
              by 
          dagochen @ Lucifron (DE-PVP)
	based on 1.12 Version created by Terrordar
			
+++++++++++++++++

### WHAT DOES GlancingMeter DO? ###

GlancingMeter is a simple addon that collects data about glancing blows and damage loss caused by them. It parses combat events and tries to estimate the damage loss. 

### WHAT ARE GLANCING BLOWS? ###

Long story short when you hit a mob that is has a higher level than yours, you have a 20-40% to hit with a glancing blow. A glancing blow cannot crit and does a reduced amount of damage. You can mitigate the damage reduction using +skill gear. 

For a more detailed explanation you can take a look at:

http://www.wowwiki.com/index.php?title=Formulas:Weapon_Skill

### HOW TO READ THE DMG LOSS VALUE ###

The loss value in the top-left corner is the main information of GlancingMeter. It is a percentage value that indicates how much glancing blows affect your damage output. The lower this value is, the less your damage output is affected by glancing blows. In other words a low value of dmg loss indicates that your damage is at full potential. A value of 0.0% means that your are getting no glancing blows or glancing blows are not reducing your damage.

### SLASH COMMANDS ###

/gm or /glancingmeter

/gm reset	resets data
/gm show	enables / disables glancingmeter
/gm pause	pause / unpause


### VERSION HISTORY ###

V0.7
- reworked for the 1.13.2 client
- removed libs
- now uses CombatLogGetCurrentEventInfo

V0.6

- GlancingMeter now uses ParsingLib to parse combat events. This makes GlancingMeter lighter and compatible with all localizations
- Gui restyling. interface is now smaller and clearer
- added option to pause / unpause combat parsing
- when closed, glancing meter will automatically pause itself to free some system resources
- damage loss can be no more negative (a negative dmg loss is meaningless)
- updated documentation

v0.5
- First release