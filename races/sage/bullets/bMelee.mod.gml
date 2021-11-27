#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletMelee.png", 0, 7, 7);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconMelee.png", 0, 5, 5);

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $AEFF00;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "MELEE";

#define bullet_ttip
  return ["STAY CLOSE", "GET IN THERE"];

#define bullet_area
  return 0;

#define bullet_description(power)
  return `@(color:${c.neutral})+` + string(round(35 + 35 * power)) + `% @(color:${c.reload})RELOAD SPEED#@(color:${c.neutral})+1.5 @(color:${c.speed})SPEED#@s-120% @(color:${c.accuracy})ACCURACY`;

#define on_take(power)
  reloadspeed += .35 + .35 * power;
  maxspeed += 1.5;
  accuracy *= 2.2;

#define on_lose(power)
  reloadspeed -= .35 + .35 * power;
  maxspeed -= 1.5;
  accuracy /= 2.2;
