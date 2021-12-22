#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletGold.png", 2, 7, 11);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconGold.png", 2, 5, 5);

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $3AA7CB;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "GOLD";

#define bullet_ttip
    //"EFFICIENCY VASTLY INCREASED"
  return ["VALUABLE @yBULLETS", "@yAURUM @sEMULATION COMPLETE.#HIGHER PRESENCE DETECTED."];

#define bullet_area
  return -1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapGold, _p, .8);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_description(power)
  return `@(color:${c.neutral})+${reloadBoost(power) * 100}% @(color:${c.reload})RELOAD SPEED#@(color:${c.neutral})+${accuracyBoost(power) * 100}% @(color:${c.accuracy})ACCURACY#@(color:${c.neutral})+${projectileBoost(power) * 100}% @(color:${c.projectile_speed})PROJECTILE SPEED#@(color:${c.neutral})+${speedBoost} @(color:${c.speed})SPEED`;

#macro spellBoost (1 + spellPower)
#define reloadBoost(spellPower)
    return .15 * spellBoost
#define projectileBoost(spellPower)
    return .15 * spellBoost
#define accuracyBoost(spellPower)
    return .25 * spellBoost
#macro speedBoost .5

#define on_take(power)
  accuracy /= 1 + accuracyBoost(power)
  reloadspeed += reloadBoost(power)
  sage_projectile_speed += projectileBoost(power);
  maxspeed += speedBoost;

#define on_lose(power)
  accuracy *= 1 + accuracyBoost(power)
  reloadspeed -= reloadBoost(power);
  sage_projectile_speed -= projectileBoost(power);
  maxspeed -= speedBoost;
  
#define on_fire
    if(wep != wep_golden_crossbow) {
    
        var _p = random_range(.9, 1.1);
        var _s = sound_play_pitchvol(sndGoldCrossbow, 1 * _p, 1.2);
        audio_sound_set_track_position(_s, .07);
    }

#define on_step
    if (spellBullets[0] = mod_current) {

      if (irandom(29) <= current_time_scale) {

        with instance_create(fairy.goalX + random_range(-sprite_get_width(fairy.sprite_back), sprite_get_width(fairy.sprite_back)) / 10, fairy.goalY + random_range(-sprite_get_height(fairy.sprite_back), sprite_get_width(fairy.sprite_back)) / 10, CaveSparkle) {depth = -10 - irandom(1)}
      }
    }