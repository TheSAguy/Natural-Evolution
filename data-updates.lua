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
--[[
local new_resist = {type = "Venom", decrease = 50, percent = 100}
local exclude = {["player"]=true, ["behemoth-biter"]=true, ["behemoth-spitter"]=true}--you got the idea of how this list should be filled

for category_name, category in pairs(data.raw) do
    if category_name~='projectile' then --first filter, purely demonstrational
        for prot_name, prot in pairs(category) do
            if prot.resistances and not exclude[prot_name] then --second filter
                 table.insert(prot.resistances,new_resist)
            end
        end
    end
end

]]

