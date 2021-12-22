#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletRust.png", 2, 7, 11);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconRust.png", 2, 5, 5);

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $333F61;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "RUST";

#define bullet_ttip
  return "ACHING RELOADS";

#define bullet_area
  return -1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_description(power)
  return `@(color:${c.neutral})+` + string(round(35 + 35 * power)) + `% @(color:${c.accuracy})ACCURACY#@(color:${c.negative})-10% @wRELOAD SPEED`;

#define on_take(power)
  accuracy /= 1.35 + .35 * power;
  reloadspeed -= .10;

#define on_lose(power)
  accuracy *= 1.35 + .35 * power;
  reloadspeed += .10;

#define on_fire
    var _p = random_range(.9, 1.1);
    sound_play_pitchvol(sndRustyRevolver, .8 * _p, .4);