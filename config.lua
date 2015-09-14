local NE = NEConfig
--[[---------------------------------------------------------------------------
------------------------------------- Credits ---------------------------------
-------------------------------------------------------------------------------

L0771 - For his help given to me to start this MOD.
AlyxDeLunar - For his MOD Dynamic Expansion that I’ve used in my MOD.
Albatrosv13 - For his MOD Alien Temple that I’ve used in my MOD.
FreeER - For his MOD Mind Control that I’ve used in my MOD.
Darkshadow1809  - For his Evolution MOD .
DOSorDIE and SpeedyBrain - Item/Corpse Collector Mod.
ThaPear, SpeedyBrain & Semvoz,  Billw & Orzelek   - Coding help!
YuokiTani - Art!! 
DySoch - DyTech and Bobingabout - Bob's Mods - Learned a lot from looking at your amazing work. 


---------------------------------------------------------------------------
---------------------------------------------------------------------------
------------------------ On / Off Toggles ---------------------------------
---------------------------------------------------------------------------
--- true = On / Yes
--- false = Off / No
---------------------------------------------------------------------------]]

NE.ExtraLoot = true --Extra Loot from Aliens (small-alien-artifact)

NE.ScienceCost = true --Doubles the cost of Science Bottles, so you need to go look for some more resources...

NE.HarderEndGame = true --Gets a lot harder once you build a rocket silo

NE.EvolutionFactor = true 
-- Do you want to use the new Evolution rate settings of:
-- TIME: Only 75% of vanilla. From 0.000004 to 0.000003
-- POLLUTION: Quadruple the vanilla Pollution Evolution, so don't pollute! From 0.00003 to 0.00006
-- KILLING EMENY SPAWNERS: 10% of Vanilla for killing Enemy Spawners. From 0.002 to 0.0002
NE.DyTechWar_Evo_override = false
-- If true, will use DyTech Evolution Factor values and not Natural Evolution's values.
-- DyTech's values are linear, meaning at Difficulty 1 all 3 values are 1/4 of Vanilla and at Difficulty 5 they are 5x higher than vanilla's. 
-- N.E. on the other hand has a higher Pollution penalty, but lower Time and Killing Spawner values.


NE.Spawners = true 
-- Do you want tweaks made to the spawners - Mainly more units around the spawners 
-- More units around the spawners 
-- Vanilla Spawners will be higher than currently.
-- Bob's be higher and will be be adjusted to match DyTech's it you're playing with DyTech
-- Currently not adjusting DyTech, until tested a little more 


NE.BiterSpitter = true 
-- Do you want tweaks made to the games biter & spitters
-- Lower Pollution levels before attacking.
-- New Enemy Units
-- Adjusted Resistances of units


NE.Expansion = true 
-- Do you want this mod to manage biter/spitter expansion. 
-- A tiered approach that gets a lot more difficult at higher evolution rates.



--- Alien_Control_Station settings
NE.Spawner_Search_Distance = 30 -- Radius
NE.Unit_Search_Distance = 20 -- Radius
NE.Conversion_Difficulty = Hard  -- Easy , Normal or Hard
-- Spawner Conversion: Easy = 16.5% chance, Normal = 10%, Hard = 5%
-- Unit Conversion: Easy = 16.5% chance, Normal = 10%, Hard = 5%


----------------------------- END -------------------------------------------

NE.QCCode = false
-- Used for QC
-- Displays messages used for checking my code



