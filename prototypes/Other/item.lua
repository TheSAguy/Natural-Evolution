data:extend({

  
  	---- Building Materials
	{
		type = "item",
		name = "Building_Materials",
		icon = "__Natural-Evolution__/graphics/icons/Building_Materials.png",
		flags = {"goes-to-main-inventory"},
		subgroup = "Materials",
		order = "b[Building_Materials]",
		stack_size = 10
	},
	
		
	--- Attractor
	{
		type = "item",
		name = "attractor-on",
		icon = "__Natural-Evolution__/graphics/entity/attractor_on.png",
		flags = {"goes-to-quickbar"},
		subgroup = "Tools",
		order = "a[attractor-on]",
		stack_size = 1
	},
  	{
		type = "item",
		name = "attractor-off",
		icon = "__Natural-Evolution__/graphics/entity/attractor_off.png",
		flags = {"goes-to-quickbar"},
		subgroup = "Tools",
		order = "b[attractor-off]",
		stack_size = 1
	},

	--- Biological Bullet
	{
		type = "ammo",
		name = "Biological-bullet-magazine",
		icon = "__base__/graphics/icons/piercing-bullet-magazine.png",
		flags = {"goes-to-main-inventory"},
		ammo_type =
		{
		  category = "bullet",
		  action =
		  {
			type = "direct",
			action_delivery =
			{
			  type = "instant",
			  source_effects =
			  {
				  type = "create-explosion",
				  entity_name = "explosion-gunshot"
			  },
			  target_effects =
			  {
				{
				  type = "create-entity",
				  entity_name = "explosion-hit"
				},
				{
				  type = "damage",
				  damage = { amount = 25 , type = "fire"}
				}
			  }
			}
		  }
		},
		magazine_size = 10,
		subgroup = "ammo",
		order = "a[basic-clips]-b[piercing-bullet-magazine]-c[Biological-bullet-magazine]",
		stack_size = 100
  },
})
