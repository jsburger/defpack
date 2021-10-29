#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletPrecision.png", 0, 7, 7);

#macro c mod_variable_get("race", "sage", "colormap");

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "PRECISION";

#define bullet_ttip
  return "NEVER MISS";

#define bullet_area
  return 0;

#define bullet_description(power)
  return `@(color:${c.neutral})+` + string(round(60 + 30 * power)) + `% @(color:${c.accuracy})ACCURACY#@(color:${c.neutral})+20% @(color:${c.projectile_speed})PROJECTILE SPEED`;

#define on_take(power)
  accuracy /= 1.6 + .3 * power;
  sage_projectile_speed += .2;

#define on_lose(power)
  accuracy *= 1.6 + .3 * power;
  sage_projectile_speed -= .2;
