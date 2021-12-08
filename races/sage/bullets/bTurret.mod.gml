#define init
  global.sprBullet = sprite_add_weapon("../../../sprites/sage/bullets/sprBulletTurret.png", 7, 7);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconTurret.png", 0, 5, 5);

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $53352B;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "TURRET";

#define bullet_ttip
  return ["KILL FAST", "MOVE SLOW"];

#define bullet_area
  return 4;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_description(power)
  return `@(color:${c.neutral})+` + string(round(65 + 65 * power)) + `% @(color:${c.reload})RELOAD SPEED#@(color:${c.neutral})+@wAUTOMATIC WEAPONS#@(color:${c.negative})-3.0 @(color:${c.speed})SPEED`;

#define on_take(power)
  reloadspeed += .65 + .65 * power;
  maxspeed -= 3;
  if "sage_auto" not in self {

    sage_auto = 1;
  }else {

    sage_auto++;
  }

#define on_lose(power)
  reloadspeed -= .65 + .65 * power;
  maxspeed += 3;
  sage_auto--;

#define step
  with instances_matching_gt(instances_matching(Player, "race", "sage"), "sage_auto", 0) {

    if sage_auto > 0 {

      clicked = button_check(index, "fire");
    }
  }
