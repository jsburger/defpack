#define init
  global.sprBullet = sprite_add_weapon("../../../sprites/sage/bullets/sprBulletSplit.png", 7, 7);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconSplit.png", 0, 5, 5);

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $59A819;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "SPLIT";

#define bullet_ttip
  return ["DUPLICATION TECHNOLOGY"];

#define bullet_area
  return 0;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_description(power)
  return `@(color:${c.neutral})+` + string(ceil(1 + 1 * power)) + ` @(color:${c.projectile})PROJECTILE` + (ceil(1 + 1 * power) = 1 ? "" : "S") + ` @(color:${c.neutral})fired#+` + string(round(100 + 100 * power)) +  `% @(color:${c.ammo})AMMO COST`;

#define on_take(power)
  if "sage_projectiles" not in self {

    sage_projectiles = ceil(1 + 1 * power);
  }else {

    sage_projectiles += ceil(1 + 1 * power);
  }
  sage_ammo_cost += ceil(1 + 1 * power);

#define on_lose(power)
  sage_projectiles -= ceil(1 + 1 * power);
  sage_ammo_cost -= ceil(1 + 1 * power);

#define step

  with instances_matching_ge(Player, "sage_projectiles", 1) {
  var     a = sage_spell_power,
      angle = (27 + 7 * a) * accuracy,
     amount = ceil(2 + a);

  for(var _i = 0; _i < amount; _i++) {

    with instances_matching(instances_matching_ne(projectile, "sage_no_split", amount), "creator", self) {

      if "sage_no_split" not in self {

        sage_no_split = 1;
      }else {

        sage_no_split++;
      }

      // Special split case for lasers because they dont want to cooperate on their own:
      if instance_is(self, Laser) {

        with instance_create(xstart, ystart, Laser) {

          alarm0 = 1;
          team = other.team;
          creator = other.creator;
          image_angle = other.image_angle -angle + _i * angle + angle / 2 * (1 - a);
          direction = image_angle;
          sageCheck = other.sageCheck
          sage_no_split = amount;
        }
      }else with(instance_copy(false)) {

        sage_no_split = amount;
        if !instance_is(self, Lightning) {

          image_angle += -angle + _i * angle + angle / 2 * (1 - a);
          direction   += -angle + _i * angle + angle / 2 * (1 - a);
        }
      }

      if sage_no_split = amount instance_delete(self);
    }
  }
}
