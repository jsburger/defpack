#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletWarp.png", 0, 7, 7);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconWarp.png", 0, 4, 5);

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $FF721F;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "HYPER";

#define bullet_ttip
  return "HYPER @yBULLETS";

#define bullet_area
  return 0;

#define bullet_description(power)
  return `@(color:${c.neutral})+` + string(2 + ceil(3 * power)) + ` @(color:${c.speed})HYPERSPEED#@(color:${c.neutral})+25% @(color:${c.accuracy})ACCURACY`;

#define on_take(power)
  sage_projectile_speed *= 1 - .35; // this one is hidden pssst
  if "sage_hitscan_strength" not in self {
    sage_hitscan_strength = 2 + ceil(3 * power);
  }else {

    sage_hitscan_strength += 2 + ceil(3 * power);
  }
  accuracy *= .75;

#define on_lose(power)
  sage_projectile_speed /= 1 - .35; // this one is hidden pssst
  sage_hitscan_strength -= 2 + ceil(3 * power);
  accuracy /= .75;

#define step
  with instances_matching(Player, "race", "sage") {

    if "sage_hitscan_strength" in self {

      var _s = id;
      with instances_matching(projectile, "creator", _s) {


        sage_check_hitscan = true;

        // Flames are laggy if you hyperseed them so they get extra speed instead
        if instance_is(self, Flame) {

          if "sage_flame_epic" not in self {

            sage_flame_epic = true;
            speed += 4 + 2 * ultra_get("sage", 1);
          }
        }

        // define sage_no_hitscan to exclude this from running hitscan
        if creator.sage_hitscan_strength > 0 && "sage_no_hitscan" not in self && !instance_is(self, Flame) && !instance_is(self, Laser) && !instance_is(self, Lightning) {

          sageHitscan = creator.sage_hitscan_strength;
          mod_script_call("race", "sage", "run_hitscan", self, sageHitscan);
        }
      }
    }
  }
