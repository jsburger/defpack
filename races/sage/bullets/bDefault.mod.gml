#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletDefault.png", 2, 7, 11);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconDefault.png", 0, 5, 5);
  
  global.effects = [
        simple_stat_effect("reloadspeed", .1, .1),
        simple_stat_effect("accuracy", .85, 1)
      ]

#define simple_stat_effect(variableName, value, scaling)
    return mod_script_call("mod", "sageeffects", "simple_stat_effect", variableName, value, scaling)

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $B98291;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "PROWESS";

#define bullet_ttip
  return `SWAP @(color:${c.spell})SPELLS @sFREQUENTLY`;

#define bullet_area
  return -1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_effects(bullet)
    return global.effects;

// #define bullet_description(power)
//   return `@(color:${c.neutral})+` + string(round(10 + 10 * power)) + `% @(color:${c.reload})RELOAD SPEED#@(color:${c.neutral})+` + string(round(15 + 15 *power)) + `% @(color:${c.accuracy})ACCURACY`;

// #define on_take(power)
//   accuracy /= 1.15 + .15 * power;
//   reloadspeed += .1 + .1 * power;

// #define on_lose(power)
//   accuracy *= 1.15 + .15 * power;
//   reloadspeed -= .1 + .1 * power;
