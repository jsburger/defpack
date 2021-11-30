#define init
  global.sprBullet = sprite_add_weapon("../../../sprites/sage/bullets/sprBulletUltra.png", 7, 7);
  global.sprBulletOff = sprite_add_weapon("../../../sprites/sage/bullets/sprBulletUltraOff.png", 7, 7);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconUltra.png", 0, 5, 5);
  global.sprUltraSpark = sprite_add("../../../sprites/sage/fx/sprBulletFXUltraActivate.png", 5, 5, 5);
  global.sprUltraSpark2 = sprite_add("../../../sprites/sage/fx/sprBulletFXUltraNoRads.png", 5, 9, 9);

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $00EA81;

#define bullet_sprite
  if (GameCont.rad <= 0) {

    return global.sprBulletOff;
  }
  return global.sprBullet;

#define bullet_name
  return "ULTRA";

#define bullet_ttip
  return "@sFROM @gRADS @sTO @yAMMO";

#define bullet_area
  return 0;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_description(power)
  return `@(color:${c.neutral})+USE @gRADS @(color:${c.neutral})AS @(color:${c.ammo})AMMO#@(color:${c.neutral})+` + string(round(50 + 50 * power)) + `% @wRELOAD SPEED @(color:${c.neutral})WHEN USING @gRADS`;

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

#define on_rads_out
  with instance_create(x, y, WepSwap) {

    with instances_matching(instances_matching(WepSwap, "creator", other), "sprite_index", global.sprUltraSpark) {

      instance_delete(self);
    }
    creator = other;
    sprite_index = global.sprUltraSpark2;
  }
  sleep(10)
  sound_play_pitchvol(sndUltraEmpty, 1 * random_range(.9, 1.1), .8);
  sound_play_pitchvol(sndUltraGrenade, .7 * random_range(.9, 1.1), .5);
  sound_play_pitchvol(sndEmpty, 1, .6);
