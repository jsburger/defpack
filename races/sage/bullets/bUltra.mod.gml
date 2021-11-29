#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletUltra.png", 0, 7, 7)
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconUltra.png", 0, 5, 5);
  global.sprUltraSpark = sprite_add("../../../sprites/sage/fx/sprBulletFXUltraActivate.png", 5, 5, 5);

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $00EA81;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "ULTRA";

#define bullet_ttip
  return "@sFROM @gRADS @sTO @yAMMO";

#define bullet_area
  return 0;

#define bullet_description(power)
  return `@(color:${c.neutral})+@(color:${c.ammo})AMMO @(color:${c.neutral})TO @gRADS#@(color:${c.neutral})+` + string(round(50 + 50 * power)) + `% @wRELOAD SPEED @(color:${c.neutral})WHEN USING @gRADS`;

#define on_take(power)
  if "sage_atr_reload_speed" not in self {

    sage_atr_reload_speed = .5 + .5 * power;
  }else {

    sage_atr_reload_speed += .5 + .5 * power;
  }

  sage_ammo_to_rads++;

#define on_lose(power)
  sage_atr_reload_speed -= .5 + .5 * power;
  sage_ammo_to_rads--;

#define on_rads_use
  with instance_create(x, y, WepSwap) {

    with instances_matching(instances_matching(WepSwap, "creator", other), "sprite_index", global.sprUltraSpark) {

      instance_delete(self);
    }
    creator = other;
    sprite_index = global.sprUltraSpark;
  }
  sound_play_pitchvol(sndUltraEmpty, .75 * random_range(.8, 1.2), .5);

  wait(1);
  if instance_exists(self) {

    reload *= 1 / (1 + sage_atr_reload_speed);
  }
