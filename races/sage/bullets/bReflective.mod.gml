#define init
  global.sprBullet = sprite_add_weapon("../../../sprites/sage/bullets/sprBulletBounce.png", 7, 7);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconReflective.png", 0, 5, 5);

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $00B8FC;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "BOUNCE";

#define bullet_ttip
  return "@yREFLECT";

#define bullet_area
  return 1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_description(power)
  return `@(color:${c.neutral})+` + string(ceil(3	+ 2 * power)) + ` @(color:${c.bounce})BOUNCES#@(color:${c.negative})-20% @(color:${c.projectile_speed})PROJECTILE SPEED`;

#define on_take(power)
  sage_projectile_speed -= .2;
  if "sage_bounce" not in self{

    sage_bounce = ceil(3 + 2 * sage_spell_power);
  }else{

    sage_bounce += ceil(3 + 2 * sage_spell_power);
  }

#define on_lose(power)
  sage_projectile_speed += .2;
  sage_bounce -= ceil(3 + 2 * sage_spell_power);

#define on_fire
  sound_play_pitchvol(sndBouncerSmg, random_range(.8, 1.2), .6);

#define step

  with instances_matching(Player, "race", "sage") {

    if "sage_bounce" in self {

      var _s = id;
      with instances_matching(projectile, "creator", _s) {

        if "sage_no_bounce" in self {exit}
        if "sage_check_bounce" not in self {

          sage_check_bounce = true;

          // if "bounce" or "bounces" are defined as a variable it will give that projectile bounce
          // if "sage_no_bounce" is defined it will not use sages custom bounce event for bouncing, use this for melee attacks
          if "bounce" not in self || instance_is(self, BouncerBullet) {

            sage_bounce = creator.sage_bounce;
          }else {

            bounce +=  creator.sage_bounce;
          }
          if "bounces" in self {

            bounces =  creator.sage_bounce;
          }
        }
      }
    }
  }