
---- Biter Attack Function
function Biter_Melee_Attack(damagevalue, damagevalue2)
  return
  {
    category = "melee",
    target_type = "entity",
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "damage",
          damage = { amount = damagevalue , type = "physical"}
        },
		{
          type = "damage",
          damage = { amount = damagevalue2 , type = "Venom"}
        }
      }
    }
  }
end

---- Biter Attack Function - Normal Biter
function Biter_Melee_Attack_Healthy(damagevalue, damagevalue2)
  return
  {
    category = "melee",
    target_type = "entity",
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "damage",
          damage = { amount = damagevalue , type = "physical"}
        },
		{
          type = "damage",
          damage = { amount = damagevalue2 , type = "Venom"}
        }
      }
    }
  }
end


---- Biter Attack Function - Infected Biter
function Biter_Melee_Attack_Infected(damagevalue, damagevalue2)
  return
  {
    category = "melee",
    target_type = "entity",
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "damage",
          damage = { amount = damagevalue2 , type = "physical"}
        },
		{
          type = "damage",
          damage = { amount = damagevalue , type = "poison"}
        },
		{
          type = "damage",
          damage = { amount = damagevalue2 , type = "Venom"}
        }
      }
    }
  }
end


---- Biter Attack Function - Mutated Biter
function Biter_Melee_Attack_Mutated(damagevalue, damagevalue2)
  return
  {
    category = "melee",
    target_type = "entity",
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "damage",
          damage = { amount = damagevalue2 , type = "physical"}
        },
		{
          type = "damage",
          damage = { amount = damagevalue , type = "acid"}
        },
		{
          type = "damage",
          damage = { amount = damagevalue2 , type = "Venom"}
        }
      }
    }
  }
end




function spitterattackparametersFire(data)
  return
  {
    type = "projectile",
    ammo_category = "rocket",
    cooldown = data.cooldown,
    range = data.range,
    projectile_creation_distance = 1.9,
    damage_modifier = data.damage_modifier,
    warmup = 30,
    ammo_type =
    {
      category = "biological",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "berserker-projectile",
          starting_speed = 0.5
        }
      }
    },
    sound = make_spitter_roars(0.75),
    animation = spitterattackanimation(data.scale, data.tint),
  }
end

function spitterattackparametersLaser(data)
  return
  {
    type = "projectile",
    ammo_category = "rocket",
    cooldown = data.cooldown,
    range = data.range,
    projectile_creation_distance = 1.9,
    damage_modifier = data.damage_modifier,
    warmup = 30,
    ammo_type =
    {
      category = "biological",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "elder-projectile",
          starting_speed = 2.5
        }
      }
    },
    sound = make_spitter_roars(0.75),
    animation = spitterattackanimation(data.scale, data.tint),
  }
end

function spitterattackparametersAcid(data)
  return
  {
    type = "projectile",
    ammo_category = "rocket",
    cooldown = data.cooldown,
    range = data.range,
    projectile_creation_distance = 1.9,
    damage_modifier = data.damage_modifier,
    warmup = 30,
    ammo_type =
    {
      category = "biological",
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "projectile",
          projectile = "king-projectile",
          starting_speed = 2.5
        }
      }
    },
    sound = make_spitter_roars(0.75),
    animation = spitterattackanimation(data.scale, data.tint),
  }
end