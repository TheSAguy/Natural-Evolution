NEConfig = {}

require "config"
require "scripts.detectmod" --Detect supported Mods, currently DyTechWar and Bob's Enemies and others
require "prototypes.Vanilla_Changes.Settings"


---- Evolution Modifications ----------------------------------
if NEConfig.EvolutionFactor then
 	if NEConfig.mod.DyTechWar and NEConfig.DyTechWar_Evo_override then
		-- TIME: Only 75% of vanilla
		-- percentual increase in the evolve factor for every second (60 ticks). Default = 0.000004
		data.raw["map-settings"]["map-settings"]["enemy_evolution"].time_factor = 0.000003

		-- POLLUTION: Four times the vanilla Pollution Evolution, so don't pollute!
		-- percentual increase in the evolve factor for 1000 PU. Default = 0.000015          
		data.raw["map-settings"]["map-settings"]["enemy_evolution"].pollution_factor = 0.00006

		-- KILLING EMENY SPAWNERS: 10% of vanilla. You are going to kill a lot more bases...
		-- percentual increase in the evolve factor for every destroyed spawner. Default = 0.002
		data.raw["map-settings"]["map-settings"]["enemy_evolution"].destroy_factor = 0.0002

	end
end
---- END Evolution Modifications ----------------------------------



---- Spawner Modifications ----------------------------------------
if NEConfig.Spawners then
	
	-- If you're using DyTech, I will not adjust the values of the Spawners, but use DyTech's values.
	if not NEConfig.mod.DyTechWar then
		
	-- Biter Spawner Adjustments
		data.raw["unit-spawner"]["biter-spawner"].max_count_of_owned_units = 30
		data.raw["unit-spawner"]["biter-spawner"].max_friends_around_to_spawn = 40
		data.raw["unit-spawner"]["biter-spawner"].spawning_cooldown = {300, 150}
		data.raw["unit-spawner"]["biter-spawner"].max_health = 2500
		data.raw["unit-spawner"]["biter-spawner"].spawning_radius = 25
		data.raw["unit-spawner"]["biter-spawner"].spawning_spacing = 2
		--data.raw["unit-spawner"]["biter-spawner"].max_spawn_shift = 0.65
		--data.raw["unit-spawner"]["biter-spawner"].pollution_cooldown = 8

		-- Spitter Spawner Adjustments
		data.raw["unit-spawner"]["spitter-spawner"].max_count_of_owned_units = 20
		data.raw["unit-spawner"]["spitter-spawner"].max_friends_around_to_spawn = 30
		data.raw["unit-spawner"]["spitter-spawner"].spawning_cooldown = {400, 180}
		data.raw["unit-spawner"]["spitter-spawner"].max_health = 3500
		data.raw["unit-spawner"]["spitter-spawner"].spawning_radius = 20
		data.raw["unit-spawner"]["spitter-spawner"].spawning_spacing = 2
		--data.raw["unit-spawner"]["spitter-spawner"].max_spawn_shift = 0.65
		--data.raw["unit-spawner"]["spitter-spawner"].pollution_cooldown = 8

	end
	
	-- Bob's Enemies Modifications
	if NEConfig.mod.BobEnemies and NEConfig.mod.DyTechWar then

	-- Bob's Biter Spawner Adjustments
	data.raw["unit-spawner"]["bob-biter-spawner"].max_count_of_owned_units = data.raw["unit-spawner"]["biter-spawner"].max_count_of_owned_units
	data.raw["unit-spawner"]["bob-biter-spawner"].max_friends_around_to_spawn = data.raw["unit-spawner"]["biter-spawner"].max_friends_around_to_spawn
	data.raw["unit-spawner"]["bob-biter-spawner"].spawning_cooldown = data.raw["unit-spawner"]["biter-spawner"].spawning_cooldown
	data.raw["unit-spawner"]["bob-biter-spawner"].max_health = data.raw["unit-spawner"]["biter-spawner"].max_health
	data.raw["unit-spawner"]["bob-biter-spawner"].spawning_radius = data.raw["unit-spawner"]["biter-spawner"].spawning_radius
	data.raw["unit-spawner"]["bob-biter-spawner"].spawning_spacing = data.raw["unit-spawner"]["biter-spawner"].spawning_spacing
	data.raw["unit-spawner"]["bob-biter-spawner"].max_spawn_shift = data.raw["unit-spawner"]["biter-spawner"].max_spawn_shift
	data.raw["unit-spawner"]["bob-biter-spawner"].pollution_absorbtion_proportional = data.raw["unit-spawner"]["biter-spawner"].pollution_absorbtion_proportional
	data.raw["unit-spawner"]["bob-biter-spawner"].pollution_absorbtion_absolute = data.raw["unit-spawner"]["biter-spawner"].pollution_absorbtion_absolute


	-- Bob's Spitter Spawner Adjustments
	data.raw["unit-spawner"]["bob-spitter-spawner"].max_count_of_owned_units = data.raw["unit-spawner"]["spitter-spawner"].max_count_of_owned_units
	data.raw["unit-spawner"]["bob-spitter-spawner"].max_friends_around_to_spawn = data.raw["unit-spawner"]["spitter-spawner"].max_friends_around_to_spawn
	data.raw["unit-spawner"]["bob-spitter-spawner"].spawning_cooldown = data.raw["unit-spawner"]["spitter-spawner"].spawning_cooldown
	data.raw["unit-spawner"]["bob-spitter-spawner"].max_health = data.raw["unit-spawner"]["spitter-spawner"].max_health
	data.raw["unit-spawner"]["bob-spitter-spawner"].spawning_radius = data.raw["unit-spawner"]["spitter-spawner"].spawning_radius
	data.raw["unit-spawner"]["bob-spitter-spawner"].spawning_spacing = data.raw["unit-spawner"]["spitter-spawner"].spawning_spacing
	data.raw["unit-spawner"]["bob-spitter-spawner"].max_spawn_shift = data.raw["unit-spawner"]["spitter-spawner"].max_spawn_shift
	data.raw["unit-spawner"]["bob-spitter-spawner"].pollution_absorbtion_proportional = data.raw["unit-spawner"]["spitter-spawner"].pollution_absorbtion_proportional
	data.raw["unit-spawner"]["bob-spitter-spawner"].pollution_absorbtion_absolute = data.raw["unit-spawner"]["spitter-spawner"].pollution_absorbtion_absolute


	
	
	elseif NEConfig.mod.BobEnemies and not NEConfig.mod.DyTechWar then

	-- Bob's Biter Spawner Adjustments
	data.raw["unit-spawner"]["bob-biter-spawner"].max_count_of_owned_units = 30
	data.raw["unit-spawner"]["bob-biter-spawner"].max_friends_around_to_spawn = 20
	data.raw["unit-spawner"]["bob-biter-spawner"].spawning_cooldown = {500, 150}
	data.raw["unit-spawner"]["bob-biter-spawner"].max_health = 2500
	data.raw["unit-spawner"]["bob-biter-spawner"].spawning_radius = 25
	data.raw["unit-spawner"]["bob-biter-spawner"].spawning_spacing = 2
	--data.raw["unit-spawner"]["bob-biter-spawner"].max_spawn_shift = 0.65
	--data.raw["unit-spawner"]["bob-biter-spawner"].pollution_cooldown = 8

	-- Bob's Spitter Spawner Adjustments
	data.raw["unit-spawner"]["bob-spitter-spawner"].max_count_of_owned_units = 20
	data.raw["unit-spawner"]["bob-spitter-spawner"].max_friends_around_to_spawn = 15
	data.raw["unit-spawner"]["bob-spitter-spawner"].spawning_cooldown = {600, 180}
	data.raw["unit-spawner"]["bob-spitter-spawner"].max_health = 3500
	data.raw["unit-spawner"]["bob-spitter-spawner"].spawning_radius = 20
	data.raw["unit-spawner"]["bob-spitter-spawner"].spawning_spacing = 2
	--data.raw["unit-spawner"]["bob-spitter-spawner"].max_spawn_shift = 0.65
	--data.raw["unit-spawner"]["bob-spitter-spawner"].pollution_cooldown = 8

	end

end
---- END Spawner Modifications ----------------------------------------


--- Adjust N.E. to DyTech War
if NEConfig.mod.DyTechWar then


	-- Natural Evolution Biter Spawner Adjustment to DyTech War
	data.raw["unit-spawner"]["Natural_Evolution_Biter-Spawner"].max_count_of_owned_units = data.raw["unit-spawner"]["biter-spawner"].max_count_of_owned_units
	data.raw["unit-spawner"]["Natural_Evolution_Biter-Spawner"].max_friends_around_to_spawn = data.raw["unit-spawner"]["biter-spawner"].max_friends_around_to_spawn
	data.raw["unit-spawner"]["Natural_Evolution_Biter-Spawner"].spawning_cooldown = data.raw["unit-spawner"]["biter-spawner"].spawning_cooldown
	data.raw["unit-spawner"]["Natural_Evolution_Biter-Spawner"].max_health = data.raw["unit-spawner"]["biter-spawner"].max_health
	data.raw["unit-spawner"]["Natural_Evolution_Biter-Spawner"].spawning_radius = data.raw["unit-spawner"]["biter-spawner"].spawning_radius
	data.raw["unit-spawner"]["Natural_Evolution_Biter-Spawner"].spawning_spacing = data.raw["unit-spawner"]["biter-spawner"].spawning_spacing
	data.raw["unit-spawner"]["Natural_Evolution_Biter-Spawner"].max_spawn_shift = data.raw["unit-spawner"]["biter-spawner"].max_spawn_shift
	data.raw["unit-spawner"]["Natural_Evolution_Biter-Spawner"].pollution_absorbtion_proportional = data.raw["unit-spawner"]["biter-spawner"].pollution_absorbtion_proportional
	data.raw["unit-spawner"]["Natural_Evolution_Biter-Spawner"].pollution_absorbtion_absolute = data.raw["unit-spawner"]["biter-spawner"].pollution_absorbtion_absolute


	-- Natural Evolution Spitter Spawner Adjustment to DyTech
	data.raw["unit-spawner"]["Natural_Evolution_Spitter-Spawner"].max_count_of_owned_units = data.raw["unit-spawner"]["spitter-spawner"].max_count_of_owned_units
	data.raw["unit-spawner"]["Natural_Evolution_Spitter-Spawner"].max_friends_around_to_spawn = data.raw["unit-spawner"]["spitter-spawner"].max_friends_around_to_spawn
	data.raw["unit-spawner"]["Natural_Evolution_Spitter-Spawner"].spawning_cooldown = data.raw["unit-spawner"]["spitter-spawner"].spawning_cooldown
	data.raw["unit-spawner"]["Natural_Evolution_Spitter-Spawner"].max_health = data.raw["unit-spawner"]["spitter-spawner"].max_health
	data.raw["unit-spawner"]["Natural_Evolution_Spitter-Spawner"].spawning_radius = data.raw["unit-spawner"]["spitter-spawner"].spawning_radius
	data.raw["unit-spawner"]["Natural_Evolution_Spitter-Spawner"].spawning_spacing = data.raw["unit-spawner"]["spitter-spawner"].spawning_spacing
	data.raw["unit-spawner"]["Natural_Evolution_Spitter-Spawner"].max_spawn_shift = data.raw["unit-spawner"]["spitter-spawner"].max_spawn_shift
	data.raw["unit-spawner"]["Natural_Evolution_Spitter-Spawner"].pollution_absorbtion_proportional = data.raw["unit-spawner"]["spitter-spawner"].pollution_absorbtion_proportional
	data.raw["unit-spawner"]["Natural_Evolution_Spitter-Spawner"].pollution_absorbtion_absolute = data.raw["unit-spawner"]["spitter-spawner"].pollution_absorbtion_absolute


end


---- Biter & Spitter Modifications --------------------------------
if NEConfig.Spawners then
	

	-- Vanilla Unit Adjustments
	data.raw["unit"]["small-biter"].resistances = Resistances.Small_Biter
	data.raw["unit"]["small-biter"].max_health = Health.Small_Biter

	data.raw["unit"]["medium-biter"].resistances = Resistances.Medium_Biter
	data.raw["unit"]["medium-biter"].max_health = Health.Medium_Biter
	data.raw["unit"]["medium-biter"].pollution_to_join_attack = 800

	data.raw["unit"]["big-biter"].resistances = Resistances.Big_Biter
	data.raw["unit"]["big-biter"].max_health = Health.Big_Biter
	data.raw["unit"]["big-biter"].pollution_to_join_attack = 1000

	data.raw["unit"]["behemoth-biter"].resistances = Resistances.Behemoth_Biter
	data.raw["unit"]["behemoth-biter"].max_health = Health.Behemoth_Biter
	data.raw["unit"]["behemoth-biter"].pollution_to_join_attack = 2500



	data.raw["unit"]["small-spitter"].resistances = Resistances.Small_Spitter
	data.raw["unit"]["small-spitter"].max_health = Health.Small_Spitter

	data.raw["unit"]["medium-spitter"].resistances = Resistances.Medium_Spitter
	data.raw["unit"]["medium-spitter"].max_health = Health.Medium_Spitter

	data.raw["unit"]["big-spitter"].resistances = Resistances.Big_Spitter
	data.raw["unit"]["big-spitter"].max_health = Health.Big_Spitter
	data.raw["unit"]["big-spitter"].pollution_to_join_attack = 1200

	data.raw["unit"]["behemoth-spitter"].resistances = Resistances.Behemoth_Spitter
	data.raw["unit"]["behemoth-spitter"].max_health = Health.Behemoth_Spitter
	data.raw["unit"]["behemoth-spitter"].pollution_to_join_attack = 5000


-- Bob's Enemies Modifications
	if NEConfig.mod.BobEnemies then

		data.raw["unit"]["bob-bigger-biter"].pollution_to_join_attack = 1000
		data.raw["unit"]["bob-biggest-biter"].pollution_to_join_attack = 2500
		data.raw["unit"]["bob-fire-biter"].pollution_to_join_attack = 5000
		data.raw["unit"]["bob-bigger-spitter"].pollution_to_join_attack = 1000
		data.raw["unit"]["bob-biggest-spitter"].pollution_to_join_attack = 2500
		data.raw["unit"]["bob-poison-spitter"].pollution_to_join_attack = 5000

		if NEConfig.Spawners and not NEConfig.mod.DyTechWar then
			require "prototypes.Vanilla_Changes.Bobs_Spawners"				
		end

		
	end


---- END Biter & Spitter Modifications --------------------------------

-------- New Units
	if not NEConfig.mod.DyTechWar then
		require "prototypes.Vanilla_Changes.New_Biter_Units"
		require "prototypes.Vanilla_Changes.Biter_Evolution"
		require "prototypes.Vanilla_Changes.New_Spitter_Units"
		require "prototypes.Vanilla_Changes.Spitter_Evolution"
	
	end
		
end
		
		--- Extra Loot
if NEConfig.ExtraLoot then
	require("prototypes.Extra_Loot.item")
	require("prototypes.Extra_Loot.recipe")
	require("prototypes.Extra_Loot.extra_loot")
end

---------------------------------------------------------------
