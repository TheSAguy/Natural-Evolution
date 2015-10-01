NEConfig = {}

require "config"
require "scripts.detectmod" --Detect supported Mods, currently DyTechWar and Bob's Enemies and others


data.raw.item["alien-artifact"].subgroup = "Materials"
--- Bob's Enemies

if NEConfig.mod.BobEnemies and NEConfig.ExtraLoot then
data:extend(
{
	  {
		type = "recipe",
		name = "alien-artifact-from-small",
		result = "alien-artifact",
		ingredients =
		{
		  {"small-alien-artifact", 100}
		},
		energy_required = 5,
		enabled = "true",
		category = "crafting"
	  },
})
end

  --- SupremeWarfare_1.0.5
if NEConfig.mod.SupremeWarfare and NEConfig.ExtraLoot then

data:extend(
{
	{
		type = "recipe",
		name = "alien-artifact",
		result= "alien-artifact",
		ingredients= { {"small-alien-artifact", 100} },
		energy_required= 5,
		enabled= "true",
		category= "crafting"
  },
  
})
end

if NEConfig.ScienceCost then

	function ChangeRecipe(Name, Ingredient1, Ingredient2, Amount)
		for k, v in pairs(data.raw["recipe"][Name].ingredients) do
			if v[1] == Ingredient1 then table.remove(data.raw["recipe"][Name].ingredients, k) end
		end
	table.insert(data.raw["recipe"][Name].ingredients,{Ingredient2, Amount})
	end

	if NEConfig.mod.DyTechCore then
		ChangeRecipe("science-pack-1", "stone-gear-wheel", "stone-gear-wheel", 2)
	end
	if not NEConfig.mod.DyTechCore then
		ChangeRecipe("science-pack-1", "iron-gear-wheel", "iron-gear-wheel", 2)
	end
	ChangeRecipe("science-pack-1", "copper-plate", "copper-plate", 2)
	ChangeRecipe("science-pack-2", "basic-transport-belt", "basic-transport-belt", 2)
	ChangeRecipe("science-pack-2", "basic-inserter", "basic-inserter", 2)
	ChangeRecipe("science-pack-3", "advanced-circuit", "advanced-circuit", 2)
	ChangeRecipe("science-pack-3", "smart-inserter", "smart-inserter", 2)
	ChangeRecipe("science-pack-3", "battery", "battery", 2)
	ChangeRecipe("science-pack-3", "steel-plate", "steel-plate", 2)
	ChangeRecipe("alien-science-pack", "alien-artifact", "alien-artifact", 2)


end



function Add_Poison_Resist(Raw,Percent)
	local Resist = {type = "poison",percent = Percent}
	for i,d in pairs(Raw) do
		if d.resistances ==nil then d.resistances={} end
		table.insert(d.resistances, Resist)
	end
end

function Add_Acid_Resist(Raw,Percent)
	local Resist = {type = "acid",percent = Percent}
	for i,d in pairs(Raw) do
		if d.resistances ==nil then d.resistances={} end
		table.insert(d.resistances, Resist)
	end
end


if NEConfig.Spawners then
	--Add resistances to entities.
	Add_Poison_Resist(data.raw["wall"],50)
	Add_Poison_Resist(data.raw["gate"],50)
	Add_Poison_Resist(data.raw["car"],50)
	Add_Poison_Resist(data.raw["electric-pole"],50)
	Add_Poison_Resist(data.raw["turret"],50)	
	Add_Poison_Resist(data.raw["ammo-turret"],50)	
	Add_Poison_Resist(data.raw["electric-turret"],50)	
	Add_Poison_Resist(data.raw["rail"],50)	
	Add_Poison_Resist(data.raw["transport-belt"],50)
	
	Add_Acid_Resist(data.raw["wall"],25)
	Add_Acid_Resist(data.raw["gate"],25)
	Add_Acid_Resist(data.raw["car"],25)
	Add_Acid_Resist(data.raw["electric-pole"],25)
	Add_Acid_Resist(data.raw["turret"],25)	
	Add_Acid_Resist(data.raw["ammo-turret"],25)	
	Add_Acid_Resist(data.raw["electric-turret"],25)	
	Add_Acid_Resist(data.raw["rail"],25)	
	Add_Acid_Resist(data.raw["transport-belt"],25)
	
	
end


