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
	

	--- Attractors
	{
		type = "recipe",
		name = "attractor-on2",
		enabled = "false",
		ingredients =
		{
		  {"iron-plate", 1},
		},
		result = "attractor-on",
		energy_required = 0.5,
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

	
})