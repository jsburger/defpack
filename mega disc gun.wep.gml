#define init
global.sprMegaDiscGun    = sprite_add_weapon("sprites/sprMegaDiscGun.png",5,9);

#define weapon_name
return "MEGA DISC GUN"

#define weapon_type
return 3;

#define weapon_cost
return 3;

#define weapon_area
return 8;

#define weapon_load
return 50;

#define weapon_swap
return sndSwapBow;

#define weapon_auto
return true;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_fire
weapon_post(12,-80,25)
sleep(20)
motion_add(gunangle-180,3)
var _p = random_range(.8,1.2);
sound_play_pitch(sndDiscgun,.7*_p)
sound_play_pitchvol(sndDiscHit,.5*_p,.8)
sound_play_pitchvol(sndDiscDie,.4,.8*_p)
with mod_script_call("mod","defpack tools","create_megadisc",x,y)
{
  move_contact_solid(other.gunangle,14)
  creator = other
  team    = other.team
  motion_add(other.gunangle+random_range(-6,6),5)
  maxspeed = speed
}
image_angle = direction

#define weapon_sprt
return global.sprMegaDiscGun;

#define weapon_text
return "watch out"
