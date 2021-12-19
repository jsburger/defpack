#define init
  global.sprBullet = sprite_add_weapon("../../../sprites/sage/bullets/sprBulletCursed.png", 7, 7);
  global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconCursed.png", 0, 5, 5);

#macro c mod_variable_get("race", "sage", "colormap");

#define fairy_sprite
  return global.sprFairy;

#define fairy_color
  return $FF3DAE;

#define bullet_sprite
  return global.sprBullet;

#define bullet_name
  return "CURSED";

#define bullet_ttip
  return `A FOREIGN POWER`;

#define bullet_area
  return -1;

#define bullet_swap
  var _p = random_range(.9, 1.1);
  // why is this soudn so quiet compared to the others
  sound_play_pitch(sndSwapCursed,  1.2 * _p);
  sound_play_pitchvol(sndSwapHammer,   .6 * _p, .5);
  sound_play_pitchvol(sndSwapShotgun, 1.2 * _p, .9);
  sound_play_pitchvol(sndCrossReload, 1.4 * _p, .9);

#define bullet_description(power)
  return `@(color:${c.neutral})NYI`;

#define on_take(power)
#define on_lose(power)
#define on_fire
    var _p = random_range(.9, 1.1);
    var _s = sound_play_pitchvol(sndCursedPickup, 1 * _p, 1);
    audio_sound_set_track_position(_s, .25);
    
#define step
  with instances_matching(Player, "race", "sage") {

    if (spellBullets[0] = mod_current) {

      if (irandom(6) <= current_time_scale) {

        with instance_create(fairy.x + random_range(-sprite_get_width(fairy.sprite_back), sprite_get_width(fairy.sprite_back)) / 16 + fairy.creator.hspeed, fairy.y - sprite_get_height(fairy.sprite_back) / 32 * random_range(.8, 1), Curse) {depth = -12}
      }
    }
  }
