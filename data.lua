NEConfig = {}

require "config"
require "scripts.detectmod" --Detect supported Mods, currently DyTechWar and Bob's Enemies


require("prototypes.Technology.technology")
require("prototypes.Item-Groups.item-groups")
require("prototypes.Categories.recipe-category")
---------------------------------------------------------------


	--- Alien_Hatchery
	
require("prototypes.Alien_Hatchery.entity")
require("prototypes.Alien_Hatchery.item")
require("prototypes.Alien_Hatchery.recipe")
require("prototypes.Alien_Hatchery.biters")
require("prototypes.Alien_Hatchery.spawner")
require("prototypes.Alien_Hatchery.spitters")
require("prototypes.Alien_Hatchery.worms")
---------------------------------------------------------------

	--- Item Collector

require("prototypes.Artifact_Collector.entity")
require("prototypes.Artifact_Collector.item")
require("prototypes.Artifact_Collector.recipe")
---------------------------------------------------------------

	--- Alien Control Station

require("prototypes.Alien_Control_Station.entity")
require("prototypes.Alien_Control_Station.item")
require("prototypes.Alien_Control_Station.recipe")
---------------------------------------------------------------

    --- Terraforming Station
	
require("prototypes.Terraforming_Station.entity")
require("prototypes.Terraforming_Station.item")
require("prototypes.Terraforming_Station.recipe")
---------------------------------------------------------------

	--- Thumper

require("prototypes.Thumper.entity")
require("prototypes.Thumper.item")
require("prototypes.Thumper.recipe")
---------------------------------------------------------------


    --- Other - Building Materials, Attractors,  Biological Damage & Ammo

require("prototypes.Other.item")
require("prototypes.Other.recipe")
require("prototypes.Other.damage-type")
---------------------------------------------------------------




