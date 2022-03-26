#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletSoda.png", 2, 7, 11);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconSoda.png", 0, 5, 5);

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $B98291;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "BOTTLE";

#define bullet_ttip
  return `POTENTIAL`;

#define bullet_area
  return -1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_description(power)
  return `@(color:${c.neutral})FILL IT`;

#define on_take(power)
#define on_lose(power)
