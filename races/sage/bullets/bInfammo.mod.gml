#define init
  global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletInfammo.png", 2, 7, 11);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconInfammo.png", 2, 5, 5);

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $FFFF00;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "SUSTAIN";

#define bullet_ttip
  return ["SHOOT FOREVER", "DECREASE IN POWDER QUALITY DETECTED.#FURTHER WORK REQUIRED."];

#define bullet_area
  return 4;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_description(spellPower)
  return `@(color:${c.neutral})+${get_save_chance(spellPower) * 100}% TO NOT USE @(color:${c.ammo})AMMO#@(color:${c.neutral})+0.5 @(color:${c.speed})SPEED#@(color:${c.negative})-30% @(color:${c.projectile_speed})PROJECTILE SPEED`

#define on_take(spellPower)
  maxspeed += .5;
  sage_projectile_speed -= .3;
  if "sage_sustain_chance" not in self sage_sustain_chance = 0
  sage_sustain_chance += get_save_chance(spellPower)

#define on_lose(spellPower)
  maxspeed -= .5;
  sage_projectile_speed += .3;
  sage_sustain_chance -= get_save_chance(spellPower)

#define get_save_chance(spellPower)
    return .25 * (1 + spellPower)
    
#define on_pre_shoot(spellPower, shootEvent)
    if (random(1) <= sage_sustain_chance) {
        if !lq_exists(shootEvent, "infammo_restore") {
            shootEvent.infammo_restore = infammo
            shootEvent.infammo_restore_valid = true
        }
        infammo = -1
        with instance_create(x + lengthdir_x(7, gunangle), y + lengthdir_y(7, gunangle), CaveSparkle) {
            image_blend = fairy_color()
            depth = other.depth -1
            image_speed *= 1.5
            image_angle = random(360)
            x += random_range(-3, 3)
            y += random_range(-3, 3)
        }
    }

#define on_post_shoot(spellPower, shootEvent)
    if lq_exists(shootEvent, "infammo_restore") {
        if shootEvent.infammo_restore_valid {
            infammo = shootEvent.infammo_restore
            shootEvent.infammo_restore_valid = false
        }
        else {
            infammo = 0
        }
    }
