--- v.4.4.0
require "defines"
require "util"
NEConfig = {}

require "config"


---- Evolution_MOD
local update_com_count = 80
local agro_area_rad = 40
local call_back_area_rad = agro_area_rad + 15
local max_unit_count = 20
----

--- Artifact Collector
local loaded
local radius = 25
local chestInventoryIndex = defines.inventory.chest
local filters = {["small-alien-artifact"] = 1,
                 ["alien-artifact"] = 1,
                 ["small-corpse"] = 1,
                 ["medium-corpse"] = 1,
                 ["big-corpse"] = 1,
                 ["berserk-corpse"] = 1,
                 ["elder-corpse"] = 1,
                 ["king-corpse"] = 1,
                 ["queen-corpse"] = 1,
				 ["alien-artifact-red"] = 1,
				 ["alien-artifact-orange"] = 1,
				 ["alien-artifact-yellow"] = 1,
				 ["alien-artifact-green"] = 1,
				 ["alien-artifact-blue"] = 1,
				 ["alien-artifact-purple"] = 1,
				 ["small-alien-artifact-red"] = 1,
				 ["small-alien-artifact-orange"] = 1,
				 ["small-alien-artifact-yellow"] = 1,
				 ["small-alien-artifact-green"] = 1,
				 ["small-alien-artifact-blue"] = 1,
				 ["small-alien-artifact-purple"] = 1
				 }

game.on_init(function() On_Load() end)
game.on_load(function() On_Load() end)

game.on_event(defines.events.on_robot_built_entity, function(event) On_Built(event) end)
game.on_event(defines.events.on_built_entity, function(event) On_Built(event) end)
game.on_event(defines.events.on_preplayer_mined_item, function(event) On_Removed(event) end)
game.on_event(defines.events.on_robot_pre_mined, function(event) On_Removed(event) end)
game.on_event(defines.events.on_entity_died, function(event) On_Removed(event) end)

game.on_event(defines.events.on_research_finished, function(event)
  if event.research.name == "Alien_Training" then
    for _, player in pairs(event.research.force.players) do
      player.insert{name="attractor-off",count=1}
    end
  end
end)

				 
function On_Load()

 local surface = game.surfaces['nauvis'] 

 -- Make sure all recipes and technologies are up to date.
	for _,player in pairs(game.players) do
	player.force.reset_recipes()
	player.force.reset_technologies()
end
 
 
---- Evolution_MOD
	if global.Evolution_MOD == nil then
      global.Evolution_MOD = {}
	end
	
	---- Alien Control Initialization ----	
	if not global.beacons then
      global.beacons = {}
	end
	if not global.minds then
      global.minds = {}
	end
	if not global.hiveminds then
      global.hiveminds = {} -- Bases / Spawners
	end

	if NEConfig.Conversion_Difficulty == Easy then
      global.minds.difficulty = 3 -- Easy difficulty
	elseif NEConfig.Conversion_Difficulty == Normal then
	  global.minds.difficulty = 5 -- Normal 
	else global.minds.difficulty = 10 -- Hard
	end

	
---- Terraforming Initialization ----	
	if not global.numTerraformingStations then
      global.numTerraformingStations = 0
	end
	
---- Expansion Initialization ----	
    if not global.Natural_Evolution_state then
		global.Natural_Evolution_state = "Peaceful"
    end
	if not global.Natural_Evolution_Timer then
		global.Natural_Evolution_Timer = 0
	end
	if not global.Natural_Evolution_Counter then
		global.Natural_Evolution_Counter = 0
	end

	--- Artifact Collector
	if not loaded then
		loaded = true
		
		if global.ArtifactCollectors ~= nil then
			game.on_event(defines.events.on_tick, ticker)
		end
	end

		--- Harder End Game
	---- Rocket Silo Initialization ----	
	if not global.RocketSiloBuilt then
      global.RocketSiloBuilt = 0
	end
 	
	
end

---------------------------------------------
function On_Built(event)
   
   --- Harder Ending Some action if you built the Rocket-silo!
  if NEConfig.HarderEndGame then
   if event.created_entity.name == "rocket-silo" then
	  	global.RocketSiloBuilt = global.RocketSiloBuilt + 1
		writeDebug("The number of Rocket Silos is: " .. global.RocketSiloBuilt)	
		-- Increase Evolution factor by 10% once a Rocket Silo is built	
			if game.evolution_factor < 0.89999 then
				game.evolution_factor = game.evolution_factor + 0.1
			else
				game.evolution_factor = 0.9999
			end  

		 -- Biters will attack the newly built Rocket Silo
		game.get_surface(1).set_multi_command({type=defines.command.attack,target=event.created_entity,distraction=defines.distraction.none},2000)
		
		game.player.print("WARNING!")
		game.player.print("Building a Rocket Silo caused a lot of noise and biter will Attack!!!")
   end
  end 

   
   --- Terraforming Station has been built
   if event.created_entity.name == "TerraformingStation" then
      global.numTerraformingStations = global.numTerraformingStations + 1
      
      global.factormultiplier = GetFactorPerTerraformingStation(global.numTerraformingStations)
	  writeDebug("The the number of Terraforming Stations: " .. global.numTerraformingStations)
	  
   end
   
   --- Alien Control Station has been built
    if event.created_entity.name == "AlienControlStation" then
		table.insert(global.beacons, event.created_entity)
	end
	
	--- Artifact Collector	

	local newCollector
	
	if event.created_entity.name == "Artifact-collector-area" then
    local surface = event.created_entity.surface
    local force = event.created_entity.force
		newCollector = surface.create_entity({name = "Artifact-collector", position = event.created_entity.position, force = force})
		event.created_entity.destroy()
		
		if global.ArtifactCollectors == nil then
			global.ArtifactCollectors = {}
			game.on_event(defines.events.on_tick, ticker)
		end
		
		table.insert(global.ArtifactCollectors, newCollector)
	end
end


---------------------------------------------

function On_Removed(event)
	--- Terraforming Station has been removed
   if event.entity.name == "TerraformingStation" then
      
      global.numTerraformingStations = global.numTerraformingStations - 1
      global.factormultiplier = GetFactorPerTerraformingStation(global.numTerraformingStations)
   end
   
   ---- Remove Rocket Silo count
   if event.entity.name == "rocket-silo" then
         global.RocketSiloBuilt = global.RocketSiloBuilt - 1      
		 writeDebug("The number of Rocket Silos is: " .. global.RocketSiloBuilt)	
   end
    
   --- Alien Control Station has been removed
	if event.entity.name == "AlienControlStation" then
		ACS_Remove()
	end
	
end

--- Artifact Collector

function ticker()
	if global.ArtifactCollectors ~= nil then
		if global.ticks == 0 or global.ticks == nil then
			global.ticks = 59
			processCollectors()
		else
			global.ticks = global.ticks - 1
		end
	else
		game.on_event(defines.events.on_tick, nil)
	end
end

	--- Artifact Collector
function processCollectors()
	local items
	local inventory
	local belt
	
	for k,collector in pairs(global.ArtifactCollectors) do
		if collector.valid then
			items = collector.surface.find_entities_filtered({area = {{x = collector.position.x - radius, y = collector.position.y - radius}, {x = collector.position.x + radius, y = collector.position.y + radius}}, name = "item-on-ground"})
			
			if #items > 0 then
				inventory = collector.get_inventory(chestInventoryIndex)
				for _,item in pairs(items) do
				
			local stack = item.stack
				if filters[stack.name] == 1 and inventory.can_insert(stack) then
					 inventory.insert(stack)
					 item.destroy()
					 break
					end
				end
			end
		else
			table.remove(global.ArtifactCollectors, k)
			if #global.ArtifactCollectors == 0 then
				global.ArtifactCollectors = nil
			end
		end
	end
end

---- Removes the Alien Control Station ---
function ACS_Remove(index)

  if index then
    if global.beacons[index] and not global.beacons[index].valid then
      table.remove(global.beacons, index)
      return -- if an index was found and it's entity was not valid return after removing it
    end
  end
  -- if no index was provided, or an inappropriate index was provided then loop through the table

  for k,beacon in ipairs(global.beacons) do
    if not beacon.valid then
      table.remove(global.beacons,k)
      writeDebug("Alien Control Station Removed")
    end
  end
  
end

--------------- Terraforming Station Calculations ------------------------------

function GetFactorPerTerraformingStation(numTerraformingStations)
   local res = 1
   -- Calculate the total evolution reduction.
   if numTerraformingStations > 1 then
	for i = 1, numTerraformingStations do
      res = res + math.pow(0.9, i) -- Each consecutive Terraforming station is only 90% as effective.
	end
   end

   -- Return the evolution reduction per Terraforming Station.
   return res / numTerraformingStations
end



---- Each time a Terraforming Station scans a sector, reduce the evolution factor ----
game.on_event(defines.events.on_sector_scanned, function(event)
	if event.radar.name == "TerraformingStation" then
   
   			if game.evolution_factor > 0.05 then
				game.evolution_factor = game.evolution_factor - ((0.000125 * global.factormultiplier) * (1 - game.evolution_factor))
			else
				game.evolution_factor = .0001
			end 
   
		writeDebug("The current Factor Multiplier is: " .. global.factormultiplier)   
	end
end)
--------------- END Terraforming Station ------------------------------


--------------- Alien Control Station ---------------------------------

function Control_Enemies()

  local surface = game.surfaces['nauvis'] 
  
  for k,beacon in ipairs(global.beacons) do
    if beacon.valid then

      if beacon.energy > 0 then
        
		local bases = surface.find_entities_filtered{type="unit-spawner", area=Get_Bounding_Box(beacon.position, NEConfig.Spawner_Search_Distance)} --search area of thirty around each ACS for spawners
		
        if #bases > 0 then
          for i, base in ipairs(bases) do
            if base.force == (game.forces.enemy) and math.random(global.minds.difficulty*2)==1 then --easy = 16.5% chance, normal = 10%, hard = 5%
             --Convert_Base(base, false)
			 Convert_Base(base, false, beacon.force)
            end
          end
        else -- no bases in range 
       
		  for i, enemy in ipairs(surface.find_enemy_units(beacon.position, NEConfig.Unit_Search_Distance)) do --search area of ten around each ACS
		  
            if enemy.force == (game.forces.enemy) then --do only if not already controlled
              if math.random(global.minds.difficulty*2)==1 then --easy = 16.5% chance, normal = 10%, hard = 5%
                --enemy.force=game.player.force
                enemy.force=beacon.force
                enemy.set_command{type=defines.command.wander,distraction=defines.distraction.by_enemy}
                table.insert(global.minds, enemy)
                writeDebug("An Enemy has been Converted")
              end
            end
          end
        end
      else
        writeDebug("A Alien Control Station has no Power")
      end
    else
      ACS_Remove()
    end
  end
end

function Remove_Mind_Control()

   local surface = game.surfaces['nauvis'] 
  
  if global.beacons[1] then -- if there are valid beacons
    for k,mind in ipairs (global.minds) do --remove mind control from biters not in area of influence
      if not mind.valid then --first make sure the enemy is still valid, if not remove them
        table.remove(global.minds, k)
      else -- is valid
        local controlled = false --assume out of range
        if surface.find_entities_filtered{name="AlienControlStation", area=Get_Bounding_Box(mind.position, NEConfig.Unit_Search_Distance)}[1] then --a AlienControlStation is in range
          controlled = true
          break
        end
        if not controlled then mind.force=game.forces.enemy end
      end
    end
  end
end

function Convert_Base(base, died, newforce)
  
  local surface = game.surfaces['nauvis'] 
  local enemies=Get_Bounding_Box(base.position, NEConfig.Unit_Search_Distance)
  local units={}
  local hives={}
  local worms={}
  local count=0
  local count_worms=0
  local count_spawners=0
  local count_units=0
  enemies = surface.find_entities(enemies)
  for i, enemy in ipairs(enemies) do
    if enemy.type=="turret" and enemy.force == (game.forces.enemy) then
      table.insert(worms, enemy)
    elseif enemy.type=="unit-spawner" then
      table.insert(hives, enemy)
    elseif enemy.type=="unit" then
     table.insert(units, enemy)
    end
  end

  count=#units+#hives+#worms
  count_worms=#worms
  count_spawners=#hives
  count_units=#units
  
  if count~=0 then -- prevent empty random interval	
	writeDebug("The number of Worms/Turrets in Range: " .. count_worms)	
	writeDebug("The number of Spawners in Range: " .. count_spawners)	
	writeDebug("The number of Units in Range: " .. count_units)	
  end
  
  if count~=0 and math.random(1+math.sqrt(count))==1 then

    if died then 
	  table.insert(global.hiveminds, game.create_entity{name=base.name, position=base.position, force=game.newforce}) 
	end
	for _, worm in pairs(worms) do 

	  worm.force=newforce 
	  writeDebug("Turret/Worm Converted") 
	end
    for _, hive in pairs(hives) do 

	  hive.force=newforce  
	  table.insert(global.hiveminds, hive) 
	  writeDebug("Spawner Converted") 
	end
    for _, unit in pairs(units) do

	  unit.force=newforce
      unit.set_command{type=defines.command.wander, distraction=defines.distraction.by_enemy}
      -- remove mind controlled biters in range from the minds table
      -- so they aren't converted back into enemies when wandering away from the beacon
      for i, controlled in ipairs(global.minds) do
          if unit == (controlled) then
          table.remove(global.minds, i)
          break
        end
      end
    end
  end
end


function Get_Bounding_Box(position, radius)
	return {{position.x-radius, position.y-radius}, {position.x+radius,position.y+radius}}
end

--------------- END Alien Control Station ------------------------------



game.on_event(defines.events.on_tick, function(event)

 -- check for biters within Alien Control Station's range
	if (game.tick % (60 * 6) == 0) and global.beacons[1] then

		Remove_Mind_Control() --free out of range biters
		Control_Enemies() --control newly in range biters

	end

	--	Evolution_MOD
	
	if event.tick % update_com_count == 0 then
		for index, player in ipairs(game.players) do
			if player.character then
				UpdateUnitsCommands(index)		
			end
		end
	end
	
--------------- Expansion ----------------------------------------------
	if NEConfig.Expansion then	
		if (game.tick % (60 * 60)  == 0) and (game.evolution_factor >= .005) and (global.Natural_Evolution_state == "Peaceful") then
				
			local expansionChance = math.random(math.floor((game.evolution_factor * 100) + global.Natural_Evolution_Counter), math.floor((game.evolution_factor * 100) + 100))

			-- For Early game, has about a 25% change to start Evolution
			if expansionChance >= 75 and expansionChance < 100 then
				Natural_Evolution_SetExpansionLevel("Awakening")
				
				
			-- Evolution Factor = 1% - 9%:
			elseif expansionChance >= 100 and expansionChance < 110 then
				Natural_Evolution_SetExpansionLevel("Phase 1")
				if game.evolution_factor >.1 and global.Natural_Evolution_Counter < 10 then
				global.Natural_Evolution_Counter = global.Natural_Evolution_Counter + 1
				end
				
			-- Evolution Factor = 10% - 19%:
			elseif expansionChance >= 110 and expansionChance < 120 then
				Natural_Evolution_SetExpansionLevel("Phase 2")
				if game.evolution_factor >.2 and global.Natural_Evolution_Counter < 15 then
				global.Natural_Evolution_Counter = global.Natural_Evolution_Counter + 1
				end
				
			-- Evolution Factor = 20% - 29%:
			elseif expansionChance >= 120 and expansionChance < 130 then
				Natural_Evolution_SetExpansionLevel("Phase 3")
				if game.evolution_factor >.3 and global.Natural_Evolution_Counter < 20 then
				global.Natural_Evolution_Counter = global.Natural_Evolution_Counter + 1
				end
			
			-- Evolution Factor = 30% - 39%:
			elseif expansionChance >= 130 and expansionChance < 140 then
				Natural_Evolution_SetExpansionLevel("Phase 4")
				if game.evolution_factor >.4 and global.Natural_Evolution_Counter < 25 then
				global.Natural_Evolution_Counter = global.Natural_Evolution_Counter + 1
				end
				
			-- Evolution Factor = 40% - 49%:
			elseif expansionChance >= 140 and expansionChance < 150 then
				Natural_Evolution_SetExpansionLevel("Phase 5")
				if game.evolution_factor >.5 and global.Natural_Evolution_Counter < 30 then
				global.Natural_Evolution_Counter = global.Natural_Evolution_Counter + 1
				end
				
			-- Evolution Factor = 50% - 59%:
			elseif expansionChance >= 150 and expansionChance < 160 then
				Natural_Evolution_SetExpansionLevel("Phase 6")
				if game.evolution_factor >.6 and global.Natural_Evolution_Counter < 35 then
				global.Natural_Evolution_Counter = global.Natural_Evolution_Counter + 1
				end
				
			-- Evolution Factor = 60% - 69%:
			elseif expansionChance >= 160 and expansionChance < 170 then
				Natural_Evolution_SetExpansionLevel("Phase 7")
				if game.evolution_factor >.7 and global.Natural_Evolution_Counter < 40 then
				global.Natural_Evolution_Counter = global.Natural_Evolution_Counter + 1
				end
				
			-- Evolution Factor = 70% - 79%:
			elseif expansionChance >= 170 and expansionChance < 180 then
				Natural_Evolution_SetExpansionLevel("Phase 8")
				if game.evolution_factor >.7 and global.Natural_Evolution_Counter < 45 then
				global.Natural_Evolution_Counter = global.Natural_Evolution_Counter + 1
				end
			
			-- Evolution Factor = 80% - 89%:
			elseif expansionChance >= 180 and expansionChance < 190 then
				Natural_Evolution_SetExpansionLevel("Phase 9")
				if game.evolution_factor >.8 and global.Natural_Evolution_Counter < 50 then
				global.Natural_Evolution_Counter = global.Natural_Evolution_Counter + 1
				end
				
			-- Evolution Factor = 90% - 98%:
			elseif expansionChance >= 190 and expansionChance < 199 then
				Natural_Evolution_SetExpansionLevel("Phase 10")
				if game.evolution_factor >.9 and global.Natural_Evolution_Counter < 50 then
				global.Natural_Evolution_Counter = global.Natural_Evolution_Counter + 1
				end
			
			-- Evolution Factor = 99% - 100%:						
			elseif expansionChance >= 199 and expansionChance <= 200 then
				Natural_Evolution_SetExpansionLevel("Armageddon")
			end
			
			writeDebug("The Expansion Chance is: " .. expansionChance)	
			writeDebug("The Natural_Evolution Counter is: " .. global.Natural_Evolution_Counter)	

		end

			if global.Natural_Evolution_state ~= "Peaceful" then
				if global.Natural_Evolution_Timer > 0 then
					global.Natural_Evolution_Timer = global.Natural_Evolution_Timer - 1
				else
					Natural_Evolution_SetExpansionLevel("Peaceful")
				end
				
			end
	
	end
 
end)

if NEConfig.Expansion then
	
	function Natural_Evolution_SetExpansionLevel(Expansion_State)
		Expansion_State = Expansion_State or "Peaceful"
		
		if Expansion_State == "Peaceful" then
			game.map_settings.enemy_expansion.enabled = false
			global.Natural_Evolution_Timer = 0
			
			-- Each time a Phase is triggered, the Evolution Factor is decreased slightly, just during the Phase.
			if game.evolution_factor > 0.05 then
			
				if global.Natural_Evolution_state == "Awakening" then
					game.evolution_factor = game.evolution_factor		
				elseif global.Natural_Evolution_state == "Phase 1" then
					game.evolution_factor = game.evolution_factor - (0.00012 * (1 - game.evolution_factor))
				elseif global.Natural_Evolution_state == "Phase 2" then
					game.evolution_factor = game.evolution_factor - (0.00012 * (1 - game.evolution_factor))
				elseif global.Natural_Evolution_state == "Phase 3" then
					game.evolution_factor = game.evolution_factor - (0.00012 * (1 - game.evolution_factor))
				elseif global.Natural_Evolution_state == "Phase 4" then
					game.evolution_factor = game.evolution_factor - (0.00012 * (1 - game.evolution_factor))			
				elseif global.Natural_Evolution_state == "Phase 5" then
					game.evolution_factor = game.evolution_factor - (0.00012 * (1 - game.evolution_factor))
				elseif global.Natural_Evolution_state == "Phase 6" then
					game.evolution_factor = game.evolution_factor - (0.00012 * (1 - game.evolution_factor))
				elseif global.Natural_Evolution_state == "Phase 7" then
					game.evolution_factor = game.evolution_factor - (0.00012 * (1 - game.evolution_factor))
				elseif global.Natural_Evolution_state == "Phase 8" then
					game.evolution_factor = game.evolution_factor - (0.00012 * (1 - game.evolution_factor))
				elseif global.Natural_Evolution_state == "Phase 9" then
					game.evolution_factor = game.evolution_factor - (0.00012 * (1 - game.evolution_factor))
				elseif global.Natural_Evolution_state == "Phase 10" then
					game.evolution_factor = game.evolution_factor - (0.00012 * (1 - game.evolution_factor))
				elseif global.Natural_Evolution_state == "Armageddon" then
					game.evolution_factor = game.evolution_factor - (0.00012 * (1 - game.evolution_factor))
				end
						
			end
		
		-- Defines the values for the different Evolution States.
		elseif Expansion_State == "Awakening" then
			game.map_settings.enemy_expansion.enabled = true
			global.Natural_Evolution_Timer = math.random(2 * 3600, 4 * 3600)
			game.map_settings.enemy_expansion.min_base_spacing = 3
			game.map_settings.enemy_expansion.max_expansion_distance = 5
			game.map_settings.enemy_expansion.min_player_base_distance = 15
			game.map_settings.enemy_expansion.settler_group_min_size = 2 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.settler_group_max_size = 4 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.min_expansion_cooldown = 60 * 60
			game.map_settings.enemy_expansion.max_expansion_cooldown = 120 * 60
				---
			game.map_settings.unit_group.min_group_gathering_time = math.floor(global.Natural_Evolution_Timer / 2)
			game.map_settings.unit_group.max_group_gathering_time = global.Natural_Evolution_Timer
			game.map_settings.unit_group.max_wait_time_for_late_members = math.floor(global.Natural_Evolution_Timer / 4)
			game.map_settings.unit_group.max_group_radius = 20.0
			game.map_settings.unit_group.min_group_radius = 5.0
			game.map_settings.unit_group.max_member_speedup_when_behind = 1.4
				
		
		elseif Expansion_State == "Phase 1" then
			----- Harder Ending
			if global.RocketSiloBuilt > 0 then
				if game.evolution_factor < 0.9899 then
					game.evolution_factor = game.evolution_factor + 0.1
				else
				game.evolution_factor = 0.99999
				end  	
				---- Attack the player, since you have a silo built
				game.get_surface(1).set_multi_command({type=defines.command.attack,target=game.player.character,distraction=defines.distraction.none},100)
				
			end  
			-----
			game.map_settings.enemy_expansion.enabled = true
			global.Natural_Evolution_Timer = math.random(2 * 3600, 4 * 3600)
			game.map_settings.enemy_expansion.min_base_spacing = 5
			game.map_settings.enemy_expansion.max_expansion_distance = 6
			game.map_settings.enemy_expansion.min_player_base_distance = 10
			game.map_settings.enemy_expansion.settler_group_min_size = 2 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.settler_group_max_size = 4 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.min_expansion_cooldown = 40 * 60
			game.map_settings.enemy_expansion.max_expansion_cooldown = 60 * 60
				---
			game.map_settings.unit_group.min_group_gathering_time = math.floor(global.Natural_Evolution_Timer / 2)
			game.map_settings.unit_group.max_group_gathering_time = global.Natural_Evolution_Timer
			game.map_settings.unit_group.max_wait_time_for_late_members = math.floor(global.Natural_Evolution_Timer / 4)
			game.map_settings.unit_group.max_group_radius = 30.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.min_group_radius = 5.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.max_member_speedup_when_behind = 1.4 + (global.Natural_Evolution_Counter / 10)

				
		elseif Expansion_State == "Phase 2" then
			----- Harder Ending
			if global.RocketSiloBuilt > 0 then
				if game.evolution_factor < 0.9899 then
					game.evolution_factor = game.evolution_factor + 0.1
				else
				game.evolution_factor = 0.99999
				end  	
				---- Attack the player, since you have a silo built
				game.get_surface(1).set_multi_command({type=defines.command.attack,target=game.player.character,distraction=defines.distraction.none},200)
				
			end  
			-----
			game.map_settings.enemy_expansion.enabled = true
			global.Natural_Evolution_Timer = math.random(2 * 3600, 4 * 3600)
			game.map_settings.enemy_expansion.min_base_spacing = 5
			game.map_settings.enemy_expansion.max_expansion_distance = 8
			game.map_settings.enemy_expansion.min_player_base_distance = 9
			game.map_settings.enemy_expansion.settler_group_min_size = 4 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.settler_group_max_size = 7 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.min_expansion_cooldown = 24 * 60
			game.map_settings.enemy_expansion.max_expansion_cooldown = 30 * 60
				---
			game.map_settings.unit_group.min_group_gathering_time = math.floor(global.Natural_Evolution_Timer / 2)
			game.map_settings.unit_group.max_group_gathering_time = global.Natural_Evolution_Timer
			game.map_settings.unit_group.max_wait_time_for_late_members = math.floor(global.Natural_Evolution_Timer / 4)
			game.map_settings.unit_group.max_group_radius = 30.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.min_group_radius = 5.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.max_member_speedup_when_behind = 1.4 + (global.Natural_Evolution_Counter / 10)

				
		elseif Expansion_State == "Phase 3" then
			----- Harder Ending
			if global.RocketSiloBuilt > 0 then
				if game.evolution_factor < 0.9899 then
					game.evolution_factor = game.evolution_factor + 0.05
				else
				game.evolution_factor = 0.99999
				end  	
				---- Attack the player, since you have a silo built
				game.get_surface(1).set_multi_command({type=defines.command.attack,target=game.player.character,distraction=defines.distraction.none},400)
				
			end   
			-----
			game.map_settings.enemy_expansion.enabled = true
			global.Natural_Evolution_Timer = math.random(3 * 3600, 5 * 3600)
			game.map_settings.enemy_expansion.min_base_spacing = 5
			game.map_settings.enemy_expansion.max_expansion_distance = 10
			game.map_settings.enemy_expansion.min_player_base_distance = 8
			game.map_settings.enemy_expansion.settler_group_min_size = 6 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.settler_group_max_size = 10 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.min_expansion_cooldown = 20 * 60
			game.map_settings.enemy_expansion.max_expansion_cooldown = 30 * 60
				---
			game.map_settings.unit_group.min_group_gathering_time = math.floor(global.Natural_Evolution_Timer / 2)
			game.map_settings.unit_group.max_group_gathering_time = global.Natural_Evolution_Timer
			game.map_settings.unit_group.max_wait_time_for_late_members = math.floor(global.Natural_Evolution_Timer / 4)
			game.map_settings.unit_group.max_group_radius = 30.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.min_group_radius = 5.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.max_member_speedup_when_behind = 1.4 + (global.Natural_Evolution_Counter / 10)


		elseif Expansion_State == "Phase 4" then
			----- Harder Ending
			if global.RocketSiloBuilt > 0 then
				if game.evolution_factor < 0.9899 then
					game.evolution_factor = game.evolution_factor + 0.05
				else
				game.evolution_factor = 0.99999
				end  	
				---- Attack the player, since you have a silo built
				game.get_surface(1).set_multi_command({type=defines.command.attack,target=game.player.character,distraction=defines.distraction.none},500)
				
			end   
			-----
			game.map_settings.enemy_expansion.enabled = true
			global.Natural_Evolution_Timer = math.random(4 * 3600, 6 * 3600)
			game.map_settings.enemy_expansion.min_base_spacing = 5
			game.map_settings.enemy_expansion.max_expansion_distance = 12
			game.map_settings.enemy_expansion.min_player_base_distance = 8
			game.map_settings.enemy_expansion.settler_group_min_size = 8 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.settler_group_max_size = 13 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.min_expansion_cooldown = 20 * 60
			game.map_settings.enemy_expansion.max_expansion_cooldown = 24 * 60
				---
			game.map_settings.unit_group.min_group_gathering_time = math.floor(global.Natural_Evolution_Timer / 2)
			game.map_settings.unit_group.max_group_gathering_time = global.Natural_Evolution_Timer
			game.map_settings.unit_group.max_wait_time_for_late_members = math.floor(global.Natural_Evolution_Timer / 4)
			game.map_settings.unit_group.max_group_radius = 30.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.min_group_radius = 5.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.max_member_speedup_when_behind = 1.4 + (global.Natural_Evolution_Counter / 10)

				
		elseif Expansion_State == "Phase 5" then
			----- Harder Ending
			if global.RocketSiloBuilt > 0 then
				if game.evolution_factor < 0.9899 then
					game.evolution_factor = game.evolution_factor + 0.025
				else
				game.evolution_factor = 0.99999
				end  	
				---- Attack the player, since you have a silo built
				game.get_surface(1).set_multi_command({type=defines.command.attack,target=game.player.character,distraction=defines.distraction.none},600)
				
			end  
			-----
			game.map_settings.enemy_expansion.enabled = true
			global.Natural_Evolution_Timer = math.random(4 * 3600, 6 * 3600)
			game.map_settings.enemy_expansion.min_base_spacing = 4
			game.map_settings.enemy_expansion.max_expansion_distance = 14
			game.map_settings.enemy_expansion.min_player_base_distance = 7
			game.map_settings.enemy_expansion.settler_group_min_size = 10 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.settler_group_max_size = 16 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.min_expansion_cooldown = 20 * 60
			game.map_settings.enemy_expansion.max_expansion_cooldown = 20 * 60
				---
			game.map_settings.unit_group.min_group_gathering_time = math.floor(global.Natural_Evolution_Timer / 2)
			game.map_settings.unit_group.max_group_gathering_time = global.Natural_Evolution_Timer
			game.map_settings.unit_group.max_wait_time_for_late_members = math.floor(global.Natural_Evolution_Timer / 4)				
			game.map_settings.unit_group.max_group_radius = 30.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.min_group_radius = 5.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.max_member_speedup_when_behind = 1.4 + (global.Natural_Evolution_Counter / 10)

				
		elseif Expansion_State == "Phase 6" then
			----- Harder Ending
			if global.RocketSiloBuilt > 0 then
				if game.evolution_factor < 0.9899 then
					game.evolution_factor = game.evolution_factor + 0.025
				else
				game.evolution_factor = 0.99999
				end  	
				---- Attack the player, since you have a silo built
				game.get_surface(1).set_multi_command({type=defines.command.attack,target=game.player.character,distraction=defines.distraction.none},700)
				
			end  
			-----
			game.map_settings.enemy_expansion.enabled = true
			global.Natural_Evolution_Timer = math.random(4 * 3600, 7 * 3600)
			game.map_settings.enemy_expansion.min_base_spacing = 4
			game.map_settings.enemy_expansion.max_expansion_distance = 16
			game.map_settings.enemy_expansion.min_player_base_distance = 6
			game.map_settings.enemy_expansion.settler_group_min_size = 12 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.settler_group_max_size = 19 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.min_expansion_cooldown = 15 * 60
			game.map_settings.enemy_expansion.max_expansion_cooldown = 20 * 60
				---
			game.map_settings.unit_group.min_group_gathering_time = math.floor(global.Natural_Evolution_Timer / 2)
			game.map_settings.unit_group.max_group_gathering_time = global.Natural_Evolution_Timer
			game.map_settings.unit_group.max_wait_time_for_late_members = math.floor(global.Natural_Evolution_Timer / 4)
			game.map_settings.unit_group.max_group_radius = 30.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.min_group_radius = 5.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.max_member_speedup_when_behind = 1.4 + (global.Natural_Evolution_Counter / 10)

				
		elseif Expansion_State == "Phase 7" then
			----- Harder Ending
			if global.RocketSiloBuilt > 0 then
				if game.evolution_factor < 0.9899 then
					game.evolution_factor = game.evolution_factor + 0.015
				else
				game.evolution_factor = 0.99999
				end  	
				---- Attack the player, since you have a silo built
				game.get_surface(1).set_multi_command({type=defines.command.attack,target=game.player.character,distraction=defines.distraction.none},800)
				
			end  
			-----
			game.map_settings.enemy_expansion.enabled = true
			global.Natural_Evolution_Timer = math.random(5 * 3600, 7 * 3600)
			game.map_settings.enemy_expansion.min_base_spacing = 4
			game.map_settings.enemy_expansion.max_expansion_distance = 18
			game.map_settings.enemy_expansion.min_player_base_distance = 5
			game.map_settings.enemy_expansion.settler_group_min_size = 14 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.settler_group_max_size = 22 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.min_expansion_cooldown = 15 * 60
			game.map_settings.enemy_expansion.max_expansion_cooldown = 20 * 60
				---
			game.map_settings.unit_group.min_group_gathering_time = math.floor(global.Natural_Evolution_Timer / 2)
			game.map_settings.unit_group.max_group_gathering_time = global.Natural_Evolution_Timer
			game.map_settings.unit_group.max_wait_time_for_late_members = math.floor(global.Natural_Evolution_Timer / 4)
			game.map_settings.unit_group.max_group_radius = 30.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.min_group_radius = 5.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.max_member_speedup_when_behind = 1.4 + (global.Natural_Evolution_Counter / 10)

				
		elseif Expansion_State == "Phase 8" then
			----- Harder Ending
			if global.RocketSiloBuilt > 0 then
				if game.evolution_factor < 0.9899 then
					game.evolution_factor = game.evolution_factor + 0.015
				else
				game.evolution_factor = 0.99999
				end  	
				---- Attack the player, since you have a silo built
				game.get_surface(1).set_multi_command({type=defines.command.attack,target=game.player.character,distraction=defines.distraction.none},900)
				
			end  
			-----
			game.map_settings.enemy_expansion.enabled = true
			global.Natural_Evolution_Timer = math.random(5 * 3600, 7 * 3600)
			game.map_settings.enemy_expansion.min_base_spacing = 4
			game.map_settings.enemy_expansion.max_expansion_distance = 20
			game.map_settings.enemy_expansion.min_player_base_distance = 4
			game.map_settings.enemy_expansion.settler_group_min_size = 16 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.settler_group_max_size = 25 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.min_expansion_cooldown = 15 * 60
			game.map_settings.enemy_expansion.max_expansion_cooldown = 20 * 60
				---
			game.map_settings.unit_group.min_group_gathering_time = math.floor(global.Natural_Evolution_Timer / 2)
			game.map_settings.unit_group.max_group_gathering_time = global.Natural_Evolution_Timer
			game.map_settings.unit_group.max_wait_time_for_late_members = math.floor(global.Natural_Evolution_Timer / 4)
			game.map_settings.unit_group.max_group_radius = 30.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.min_group_radius = 5.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.max_member_speedup_when_behind = 1.4 + (global.Natural_Evolution_Counter / 10)


		elseif Expansion_State == "Phase 9" then
			----- Harder Ending
			if global.RocketSiloBuilt > 0 then
				if game.evolution_factor < 0.9899 then
					game.evolution_factor = game.evolution_factor + 0.01
				else
				game.evolution_factor = 0.99999
				end  	
				---- Attack the player, since you have a silo built
				game.get_surface(1).set_multi_command({type=defines.command.attack,target=game.player.character,distraction=defines.distraction.none},1000)
				
			end  
			-----
			game.map_settings.enemy_expansion.enabled = true
			global.Natural_Evolution_Timer = math.random(5 * 3600, 8 * 3600)
			game.map_settings.enemy_expansion.min_base_spacing = 3
			game.map_settings.enemy_expansion.max_expansion_distance = 22
			game.map_settings.enemy_expansion.min_player_base_distance = 3
			game.map_settings.enemy_expansion.settler_group_min_size = 18 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.settler_group_max_size = 28 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.min_expansion_cooldown = 15 * 60
			game.map_settings.enemy_expansion.max_expansion_cooldown = 20 * 60
				---
			game.map_settings.unit_group.min_group_gathering_time = math.floor(global.Natural_Evolution_Timer / 2)
			game.map_settings.unit_group.max_group_gathering_time = global.Natural_Evolution_Timer
			game.map_settings.unit_group.max_wait_time_for_late_members = math.floor(global.Natural_Evolution_Timer / 4)
			game.map_settings.unit_group.max_group_radius = 30.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.min_group_radius = 5.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.max_member_speedup_when_behind = 1.4 + (global.Natural_Evolution_Counter / 10)


		elseif Expansion_State == "Phase 10" then
			----- Harder Ending
			if global.RocketSiloBuilt > 0 then
				if game.evolution_factor < 0.9899 then
					game.evolution_factor = game.evolution_factor + 0.01
				else
				game.evolution_factor = 0.99999
				end  	
				---- Attack the player, since you have a silo built
				game.get_surface(1).set_multi_command({type=defines.command.attack,target=game.player.character,distraction=defines.distraction.none},2000)
				
			end  
			-----
			game.map_settings.enemy_expansion.enabled = true
			global.Natural_Evolution_Timer = math.random(6 * 3600, 8 * 3600)
			game.map_settings.enemy_expansion.min_base_spacing = 3
			game.map_settings.enemy_expansion.max_expansion_distance = 30
			game.map_settings.enemy_expansion.min_player_base_distance = 0
			game.map_settings.enemy_expansion.settler_group_min_size = 30 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.settler_group_max_size = 75 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.min_expansion_cooldown = 15 * 60
			game.map_settings.enemy_expansion.max_expansion_cooldown = 20 * 60
					---
			game.map_settings.unit_group.min_group_gathering_time = math.floor(global.Natural_Evolution_Timer / 2)
			game.map_settings.unit_group.max_group_gathering_time = global.Natural_Evolution_Timer
			game.map_settings.unit_group.max_wait_time_for_late_members = math.floor(global.Natural_Evolution_Timer / 4)
			game.map_settings.unit_group.max_group_radius = 30.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.min_group_radius = 5.0 + (global.Natural_Evolution_Counter / 2)
			game.map_settings.unit_group.max_member_speedup_when_behind = 1.4 + (global.Natural_Evolution_Counter / 10)

			
		
		elseif Expansion_State == "Armageddon" then
			--- During Armageddon state the player will be attached regardless of Silo built or not.
			game.get_surface(1).set_multi_command({type=defines.command.attack,target=game.player.character,distraction=defines.distraction.none},2000)
			game.map_settings.enemy_expansion.enabled = true					 
			global.Natural_Evolution_Timer = math.random(6 * 3600, 8 * 3600)
			game.map_settings.enemy_expansion.min_base_spacing = 2
			game.map_settings.enemy_expansion.max_expansion_distance = 50
			game.map_settings.enemy_expansion.min_player_base_distance = 0
			game.map_settings.enemy_expansion.settler_group_min_size = 100 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.settler_group_max_size = 200 + global.Natural_Evolution_Counter
			game.map_settings.enemy_expansion.min_expansion_cooldown = 8 * 60
			game.map_settings.enemy_expansion.max_expansion_cooldown = 15 * 60
				---
			game.map_settings.unit_group.min_group_gathering_time = math.floor(global.Natural_Evolution_Timer / 2)
			game.map_settings.unit_group.max_group_gathering_time = global.Natural_Evolution_Timer
			game.map_settings.unit_group.max_wait_time_for_late_members = math.floor(global.Natural_Evolution_Timer / 4)
			game.map_settings.unit_group.max_group_radius = 30.0 + (global.Natural_Evolution_Counter / 1)
			game.map_settings.unit_group.min_group_radius = 5.0 + (global.Natural_Evolution_Counter / 1)
			game.map_settings.unit_group.max_member_speedup_when_behind = 1.4 + (global.Natural_Evolution_Counter / 5)
		
		end

				
		if Expansion_State ~= "Peaceful" then
		writeDebug("Expansion state set to: " .. Expansion_State)	
		writeDebug("The Max Group Radius is: " .. game.map_settings.unit_group.max_group_radius)
		writeDebug("The Min Group Gathering time is: " .. game.map_settings.unit_group.min_group_gathering_time)
		writeDebug("The Max Group Gathering time and N.E. Timer is: " .. game.map_settings.unit_group.max_group_gathering_time)
		writeDebug("The wait for late member time is: " .. game.map_settings.unit_group.max_wait_time_for_late_members)
		end
		
			
	end
--------------- END Expansion ------------------------------
end

---- Evolution_MOD
function UpdateUnitsCommands(player_index)
	local player = game.players[player_index].character
	local pos = player.position
    local aggression_area = {{pos.x - agro_area_rad, pos.y - agro_area_rad}, {pos.x + agro_area_rad, pos.y + agro_area_rad}}
	if not player.surface.valid then return end
	local targets = player.surface.find_entities(aggression_area)
	local min_dist = agro_area_rad + 10;
	local closest_index = -1
	local surface = player.surface
	
	for index, target in ipairs(targets) do
		if target.health then
			if target.force == game.forces.enemy and target.type ~= "turret" and target.type ~= "unit" then
				local dist = GetDistance(target.position, pos)			
				if min_dist > dist then
					min_dist = dist
					closest_index = index
				end
			end
		end
	end
	
	local unit_count = 0
	if closest_index == -1 then
		
		local attOn = game.players[player_index].get_item_count("attractor-on") 
		local attOff = game.players[player_index].get_item_count("attractor-off") 
		local lastState = nil
		if global.Evolution_MOD[game.players[player_index].name] and global.Evolution_MOD[game.players[player_index].name].lastState then
			lastState = global.Evolution_MOD[game.players[player_index].name].lastState
		else
			if global.Evolution_MOD[game.players[player_index].name] == nil then
				global.Evolution_MOD[game.players[player_index].name] = {}
			end
			global.Evolution_MOD[game.players[player_index].name].lastState = nil
		end
		
		if attOn > 0 and attOff == 0 then
			if attOn > 1 then
				game.players[player_index].remove_item({name="attractor-on", count=(attOn - 1)})
			end
			lastState = "on"
		elseif attOn == 0 and attOff > 0 then
			if attOff > 1 then
				game.players[player_index].remove_item({name="attractor-off", count=(attOff - 1)})
			end
			lastState = "off"
		elseif attOn > 0 and attOff > 0 then
			if lastState ~= nil and lastState == "off" then
				game.players[player_index].remove_item({name="attractor-off", count=attOff})
				if attOn > 1 then
					game.players[player_index].remove_item({name="attractor-on", count=(attOn - 1)})
				end
				lastState = "on"
			else
				game.players[player_index].remove_item({name="attractor-on", count=attOn})
				if attOn > 1 then
					game.players[player_index].remove_item({name="attractor-on", count=(attOn - 1)})
				end
				lastState = "off"
			end
		else
			lastState = "off"
		end
		global.Evolution_MOD[game.players[player_index].name].lastState = lastState
		
		if lastState == "off" then return end
		local call_back_area = {{pos.x -  call_back_area_rad, pos.y -  call_back_area_rad}, {pos.x +  call_back_area_rad, pos.y +  call_back_area_rad}}
		local biters = surface.find_entities_filtered{area = call_back_area, type = "unit"}
		for index, biter in ipairs(biters) do
			if biter.force == (player.force) then
				biter.set_command({type = defines.command.go_to_location, destination = pos, radius = 10, distraction = defines.distraction.byanything});	
				unit_count = unit_count + 1
				
			end
			if unit_count > max_unit_count then return end
		end	
	else
		local call_back_area = {{pos.x -  call_back_area_rad, pos.y -  call_back_area_rad}, {pos.x +  call_back_area_rad, pos.y +  call_back_area_rad}}
		local biters = player.surface.find_entities_filtered{area = call_back_area, type = "unit"}
		for index, biter in ipairs(biters) do
			if biter.force == player.force then
				biter.set_command({type = defines.command.attack, target = targets[closest_index], distraction = defines.distraction.byanything});
				unit_count = unit_count + 1					
			end
			if unit_count > max_unit_count then return end
		end	
	end
end

function GetDistance(pos1 , pos2)
	return math.sqrt((pos1.x - pos2.x)^2 + (pos1.y - pos2.y)^2)
end


--- DeBug Messages 
function writeDebug(message)
  if NEConfig.QCCode then game.player.print(tostring(message)) end
end
