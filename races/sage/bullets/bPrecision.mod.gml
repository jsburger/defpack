#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletPrecision.png", 2, 7, 11);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconPrecision.png", 2, 5, 5);

  global.effects = [
        simple_stat_effect("accuracy", .3, 1),
        effect_instance_named("projectileSpeed", .25, 0),
      ]

#define bullet_effects(bullet)
    return global.effects

#define simple_stat_effect(variableName, value, scaling)
    return mod_script_call("mod", "sageeffects", "simple_stat_effect", variableName, value, scaling)

#define effect_instance_named(effectName, value, scaling)
    return mod_script_call("mod", "sageeffects", "effect_instance_create", value, scaling, effectName)


#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $2079D8;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "PRECISION";

#define bullet_ttip
  return ["NEVER MISS", "::AIRSTREAM RIFLING EX-8831", "::MATCHING PREVIOUS METRICS"];

#define bullet_area
  return 1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

// #define bullet_description(power)
//   return `@(color:${c.neutral})+` + string(round(170 + 150 * power)) + `% @(color:${c.accuracy})ACCURACY#@(color:${c.neutral})+25% @(color:${c.projectile_speed})PROJECTILE SPEED`;

// #define on_take(power)
//   accuracy /= 1.7 + 1.5 * power;
//   sage_projectile_speed += .25;

// #define on_lose(power)
//   accuracy *= 1.7 + 1.5 * power;
//   sage_projectile_speed -= .25;
