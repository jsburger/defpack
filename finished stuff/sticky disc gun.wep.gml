#define init
global.sprStickyDiscGun = sprite_add_weapon("sprStickyDiscGun.png",1,3)
#define weapon_name
return "STICKY DISC GUN"
#define weapon_type
return 3
#define weapon_cost
return 2
#define weapon_area
return 9
#define weapon_load
return 14
#define weapon_swap
return sndSwapBow
#define weapon_auto
return true
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_sprt
return global.sprStickyDiscGun
#define weapon_text
return "DAMAGE OVER TIME"
#define weapon_fire
weapon_post(5,-30,0)
var _p = random_range(.8,1.2)
sound_play_pitch(sndDiscHit,1.3*_p)
sound_play_pitch(sndDiscBounce,.7*_p)
sound_play_pitchvol(sndSuperDiscGun,3*_p,.4)
sound_play_gun(sndDiscgun, 0.2, 0.3);
with mod_script_call("mod","defpack tools","create_stickydisc",x,y)
{
  creator = other
  motion_add(other.gunangle+random_range(-8,8)*other.accuracy,4)
  image_angle = direction
  orspeed = speed
}
