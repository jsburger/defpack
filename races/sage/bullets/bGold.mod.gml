#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletGold.png", 0, 7, 7)

#macro c mod_variable_get("race", "sage", "colormap");

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "GOLD";

#define bullet_area
  return -1;

#define bullet_description(power)
  return `@(color:${c.neutral})+` + string(round(15 + 15 * power)) + `% @(color:${c.reload})RELOAD SPEED#@(color:${c.neutral})+` + string(round(20 + 20 * power)) + `% @(color:${c.accuracy})ACCURACY#@(color:${c.neutral})+` + string(round(15 + 15 * power)) + `% @(color:${c.projectile_speed})PROJECTILE SPEED#@(color:${c.neutral})+` + string(round(25 + 25 * power)) + `% @(color:${c.speed})SPEED`;

#define on_take(power)
  accuracy /= 1.2 + .2 * power;
  reloadspeed += .15 + .15 * power;
  sage_projectile_speed += .15 + .15 * power;
  maxspeed += .25 + .25 * power;

#define on_lose(power)
  accuracy *= 1.2 + .2 * power;
  reloadspeed -= .15 + .15 * power;
  sage_projectile_speed -= .15 + .15 * power;
  maxspeed -= .25 + .25 * power;
