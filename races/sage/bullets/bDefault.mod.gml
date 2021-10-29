#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletDefault.png", 0, 7, 7);

#macro c mod_variable_get("race", "sage", "colormap");

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "DEFAULT";

#define bullet_ttip
  return "SWAP @pSPELLS @sFREQUENTLY";

#define bullet_area
  return -1;

#define bullet_description(power)
  return `@(color:${c.neutral})+` + string(round(10 + 10 * power)) + `% @(color:${c.reload})RELOAD SPEED#@(color:${c.neutral})+` + string(round(15 + 15 *power)) + `% @(color:${c.accuracy})ACCURACY`;

#define on_take(power)
  accuracy /= 1.15 + .15 * power;
  reloadspeed += .1 + .1 * power;

#define on_lose(power)
  accuracy *= 1.15 + .15 * power;
  reloadspeed -= .1 + .1 * power;
