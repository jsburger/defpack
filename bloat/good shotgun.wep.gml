#define init
global.sprGoodShotgun = sprite_add_weapon("../sprites/weapons/sprGoodShotgun.png", 4, 3);

#define weapon_name
return "GOOD SHOTGUN";

#define weapon_type
return 2;

#define weapon_cost
return 1;

#define weapon_area
return -1;

#define weapon_load
return 14;

#define weapon_auto
return false;

#define weapon_melee
return false;

#define weapon_swap
return sndSwapShotgun;

#define weapon_laser_sight
return false;

#define weapon_sprt
return global.sprGoodShotgun;

#define weapon_text
return "A STRAIGHT UPGRADE";

#define weapon_fire

weapon_post(6, 17, 0);
motion_add(gunangle -180, 2);
var _p = random_range(.8, 1.2);
sound_play_pitch(sndSawedOffShotgun, 1.3 * _p);
sound_play_pitch(sndSlugger,  .7 * _p);
sleep(30);
repeat(10)
{
  with instance_create(x, y, Bullet2)
  {
    creator = other;
    team    = other.team;
    motion_add(other.gunangle + random_range(-12, 12) * other.accuracy, random_range(17, 22));
  }
}
