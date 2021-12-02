#define init
  global.sprBullet = sprite_add_weapon("../../../sprites/sage/bullets/sprBulletGold.png", 7, 7)
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconGold.png", 0, 5, 5);

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
  return "VALUABLE @yBULLETS";

#define bullet_area
  return -1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapGold, _p, .8);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_description(power)
  return `@(color:${c.neutral})+` + string(round(15 + 15 * power)) + `% @(color:${c.reload})RELOAD SPEED#@(color:${c.neutral})+` + string(round(20 + 20 * power)) + `% @(color:${c.accuracy})ACCURACY#@(color:${c.neutral})+` + string(round(15 + 15 * power)) + `% @(color:${c.projectile_speed})PROJECTILE SPEED#@(color:${c.neutral})+` + string(round(25 + 25 * power)) + `% @(color:${c.speed})SPEED`;

#define on_take(power)
  accuracy /= 1.2 + .2 * power;
  reloadspeed += .15 + .15 * power;
  sage_projectile_speed += .15 + .15 * power;
  maxspeed += .25 + .25 * power;

#define on_lose(power)
  accuracy *= 1.2 + .2 * power;
  reloadspeed -= .15 + .15 * power;
  sage_projectile_speed -= .15 + .15 * power;
  maxspeed -= .25 + .25 * power;

#define step
  with instances_matching(Player, "race", "sage") {

    if (spellBullets[0] = mod_current) {

      if (irandom(34) <= current_time_scale) {

        instance_create(fairy.goalX + random_range(-sprite_get_width(fairy.sprite_back) / 2, sprite_get_width(fairy.sprite_back) / 2) * .7, fairy.goalY + random_range(-sprite_get_height(fairy.sprite_back) / 2, sprite_get_width(fairy.sprite_back) / 2) * .7, CaveSparkle)
      }
    }
  }
