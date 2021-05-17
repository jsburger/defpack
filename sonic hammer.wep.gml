#define init
global.sprSonicHammer = sprite_add_weapon("sprites/weapons/sprSonicHammer.png", 3, 12);

#define weapon_name
return "SONIC HAMMER";

#define weapon_type
return 4;

#define weapon_cost
return 2;

#define weapon_area
return 6;

#define weapon_load
return 36;

#define weapon_swap
return sndSwapHammer;

#define weapon_auto
return false;

#define weapon_melee
return true;

#define weapon_laser_sight
return false;

#define weapon_sprt
return global.sprSonicHammer;

#define nts_weapon_examine
return{
    "d": "A repurposed boombox. #Uses a powerful base sound to launch enemies. ",
}

#define weapon_text
return "TURN UP THE BASE";

#define weapon_fire
wepangle = -wepangle
weapon_post(-7, -25, 6);
sleep(10);

var _p = random_range(.8, 1.2);
sound_play_pitchvol(sndHammer, .8 * _p, 1);
sound_play_pitchvol(sndUltraShovel, 1.6 * _p, 1);
sound_play_pitchvol(sndHyperLauncher, .7 * _p, 1);
sound_play_pitchvol(sndHyperSlugger, .7 * _p, 1);
sound_play_pitchvol(sndBouncerSmg, .3 * _p, 1);

with instance_create(x, y, CustomSlash)
{

  dontwait = true
  image_speed = .5;
  creator = other;
  team    = other.team;
  damage = 0;
  force = 28;
  canwallhit = true
  dontwait = true
  motion_add(creator.gunangle + random_range(-4, 4) * creator.accuracy, 3 + skill_get(mut_long_arms) * 4);
  superforce     = force;
  superdirection = direction;
  sprite_index = sprHeavySlash;
  mask_index   = mskSlash;
  image_angle = direction;
  fx_sleep = 40;
  fx_shake = 15;
  on_hit = script_ref_create_ext("mod", "defpack tools", "sonic_hit");
}
