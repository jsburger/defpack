#define init
global.sprShard = sprite_add_weapon("sprites/sprShard.png",0,3);
global.sprShardShank = sprite_add("sprites/projectiles/sprShardShank.png",2,0,8);
global.mskShardShank = sprite_add("sprites/projectiles/mskShardShank.png",2,0,8);

#define weapon_sprt
return global.sprShard;

#define weapon_name
return "SHARD"

#define weapon_type
return 0;

#define weapon_cost
return 0;

#define weapon_area
return -1;

#define weapon_load
return 6;

#define weapon_swap
return sndSwapSword;

#define weapon_auto
return false;

#define weapon_melee
return true;

#define weapon_laser_sight
return false;

#define weapon_text
return "BROKEN"

#define weapon_reloaded

#define weapon_fire
weapon_post(-6,-4,3);
var _pitch = random_range(.8,1.2);
sound_play_pitch(sndScrewdriver,1.4*_pitch);
sound_play_pitch(sndBlackSword,1.5);
sound_play_pitch(sndLaserCrystalHit,1.4*_pitch);
sound_play_pitchvol(sndJungleAssassinAttack,1.6*_pitch,.45);
sleep(30); //yes this is supposed to give you a very slight amount of reaction time
with instance_create(x,y,Shank)
{
  sprite_index = global.sprShardShank;
  mask_index   = global.mskShardShank;
  creator = other;
  team    = other.team;
  canfix  = false;
  damage  = 4;
  force   = 3;
  image_xscale /= 1.25;
  motion_add(other.gunangle+random_range(-10,10)*other.accuracy,3+skill_get(13)*2)
  image_angle = direction;
}
wepangle = -wepangle
