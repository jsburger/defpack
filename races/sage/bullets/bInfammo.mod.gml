#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletInfammo.png", 0, 7, 7);

#macro c mod_variable_get("race", "sage", "colormap");

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "INFAMMO";

#define bullet_area
  return 0;

#define bullet_description(power)
  return `@(color:${c.neutral})+` + string(round(2 + 2 *power)) + ` seconds @(color:${c.aqua})INFAMMO @(color:${c.neutral})PER KILL#+50% @(color:${c.speed})SPEED#@s-40% @(color:${c.projectile_speed})PROJECTILE SPEED`

#define on_take(power)
  maxspeed += .5;
  sage_projectile_speed -= .4;
  if "sage_infammo_gain" not in self {

    sage_infammo_gain = 2 + 2 * power;
  }else {

    sage_infammo_gain += 2 + 2 * power
  }

#define on_lose(power)
  sage_infammo_gain -= 2 + 2 * power;
  maxspeed -= .5;
  sage_projectile_speed += .4;

#define step
  with instances_matching_gt(Player, "sage_infammo_gain", 0) with instances_matching_le(instances_matching_ne(hitme, "team", team), "my_health", 0){

    if "sage_infammo_gain" in other{

      other.infammo = min(other.infammo + room_speed * other.sage_infammo_gain, room_speed * other.sage_infammo_gain);
    }
  }
