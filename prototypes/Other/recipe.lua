data:extend({
  
		
		---- Building Materials
	{
      type = "recipe",
		  name = "Building_Materials",
		  enabled = "false",
		  ingredients = 
		  {
			--{"iron-plate", 1},
			{"advanced-circuit", 15},
			{"stone-brick", 50},       
			{"steel-plate", 10}, 
		  },
		  result = "Building_Materials"
	},
	
	{
		type = "recipe",
		name = "attractor-on",
		enabled = "false",
		ingredients =
		{
		  {"attractor-off", 1},
		},
		result = "attractor-on",
		energy_required = 0.5,
	},
  
	{
		type = "recipe",
		name = "attractor-off",
		enabled = "false",
		ingredients =
		{
		  {"attractor-on", 1},
		},
		result = "attractor-off",
		energy_required = 0.5,
	},
	
	--- Biological Bullet
	{
		type = "recipe",
		name = "Biological-bullet-magazine",
		enabled = false,
		energy_required = 5,
		ingredients =
		{
		  {"alien-artifact", 1},
		  {"piercing-bullet-magazine", 5},
		},
		result = "Biological-bullet-magazine",
		result_count = 5
  },
	
})