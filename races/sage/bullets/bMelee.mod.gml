#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletMelee.png", 2, 7, 11);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconMelee.png", 2, 5, 5);


  global.effects = [
        simple_stat_effect("reloadspeed", .25, .25),
        simple_stat_effect("maxspeed", 1.5, 0),
        simple_stat_effect("accuracy", 2.5, 0)
      ]


#define simple_stat_effect(variableName, value, scaling)
    return mod_script_call("mod", "sageeffects", "simple_stat_effect", variableName, value, scaling)

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $AEFF00;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "RUSH";

#define bullet_ttip
  return ["STAY CLOSE", "GET IN THERE", "SUBSONIC EVASION OPTIMIZED.#PRECISION LOSS DETECTED."];

#define bullet_area
  return 4;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_effects(bullet)
    return global.effects

// #define bullet_description(power)
//   return `@(color:${c.neutral})+` + string(round(25 + 25 * power)) + `% @(color:${c.reload})RELOAD SPEED#@(color:${c.neutral})+1.5 @(color:${c.speed})SPEED#@(color:${c.negative})-150% @(color:${c.accuracy})ACCURACY`;

// #define on_take(power)
//   reloadspeed += .25 + .25 * power;
//   maxspeed += 1.5;
//   accuracy *= 2.5;

// #define on_lose(power)
//   reloadspeed -= .25 + .25 * power;
//   maxspeed -= 1.5;
//   accuracy /= 2.5;
