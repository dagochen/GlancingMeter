+++++++++++++++++
			
    GlancingMeter v0.8	
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

Explaination: 
delta: dealta means the difference in your attackskill (depends on level and weapon) and the enemy defense skill (level * 5)

### SLASH COMMANDS ###

/gm or /glancingmeter

/gm reset	resets data
/gm show	enables / disables glancingmeter
/gm pause	pause / unpause


### VERSION HISTORY ###

v1.0 (FINAL)
- cleaned up UI
- reworked calculation and tracking
- now uses seperated weaponskill and level of target
- ignores pvp data which compromised statistics before
- added button to jump to boss fights, which are also tracked seperated from lvl 63 NPCs

V0.81
- now uses difference in deapon- and defense-skill of target and player instead of level difference
- now saves data over several sessions
- added feral calculation

V0.8
- mainhand and offhand are tracked seperated now
- added parry 
- added dodge
- tracking now depends on level difference

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