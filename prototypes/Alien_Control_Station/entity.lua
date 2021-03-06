


data:extend({

 
	---- Alien Control Station
  {
    type = "radar",
    name = "AlienControlStation",
    icon = "__Natural-Evolution__/graphics/icons/AlienControlStation.png",
    flags = {"placeable-neutral", "placeable-player", "player-creation"},   
	minable = {hardness = 0.8, mining_time = 1.5, result = "Building_Materials"},
	--- NOTE, when mined, you will lose the Alien artifacts! ----
    max_health = 250,
    corpse = "big-remnants",
	dying_explosion = "medium-explosion",
    resistances = 
    {
      {
        type = "fire",
        percent = 70
      }
    },
    collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    energy_per_sector = "15MJ",
    max_distance_of_nearby_sector_revealed = 5,
    max_distance_of_sector_revealed = 15,
    energy_per_nearby_scan = "250kJ",
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input"
    },
    energy_usage = "500kW",
	pictures =
    {
      filename = "__Natural-Evolution__/graphics/entity/AlienControlStation.png",
		priority = "high",
		width = 128,
		height = 128,
		axially_symmetrical = false,
		apply_projection = false,
		direction_count = 16,
		line_length = 4,
	  shift = {0.225, -0.3},
    },
  },

})
