#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletInfammo.png", 2, 7, 11);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconInfammo.png", 2, 5, 5);

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $FFFF00;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "SUSTAIN";

#define bullet_ttip
  return "SHOOT FOREVER";

#define bullet_area
  return 4;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_description(power)
  return `@(color:${c.neutral})+20% TO NOT USE @(color:${c.ammo})AMMO#@(color:${c.neutral})+0.5 @(color:${c.speed})SPEED#@(color:${c.negative})-30% @(color:${c.projectile_speed})PROJECTILE SPEED`

#define on_take(power)
  maxspeed += .5;
  sage_projectile_speed -= .3;

#define on_lose(power)
  maxspeed -= .5;
  sage_projectile_speed += .3;
