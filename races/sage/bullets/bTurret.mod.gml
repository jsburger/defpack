#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletTurret.png", 0, 7, 7);

#macro c mod_variable_get("race", "sage", "colormap");

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "TURRET";

#define bullet_area
  return 0;

#define bullet_description(power)
  return `@(color:${c.neutral})+` + string(round(65 + 65 * power)) + `% @(color:${c.reload})RELOAD SPEED#@(color:${c.neutral})+@wAUTOMATIC WEAPONS#@s-3 @(color:${c.speed})SPEED`;

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
