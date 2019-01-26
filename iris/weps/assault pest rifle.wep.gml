#define init
global.sprAssaultPestRifle = sprite_add_weapon("sprites/sprAssaultPestRifle.png", 4, 3);

#define weapon_name
return "ASSAULT PEST RIFLE";

#define weapon_sprt
return global.sprAssaultPestRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 11;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "TRIPLE CAPSULE TANK";

#define weapon_fire

repeat(3)
{
  weapon_post(5,-3,6)
  sound_play_pitch(sndMachinegun,random_range(1.2,1.5))
  sound_play_pitch(sndMinigun,random_range(1.2,1.5))
  sound_play_pitch(sndPistol,random_range(.6,.8))
  sound_play_pitch(sndToxicBoltGas,random_range(3,3.8))
  mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,5), c_green)
  with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x+lengthdir_x(8,gunangle),y+lengthdir_y(8,gunangle)){
      creator = other
      team = other.team
      motion_set(other.gunangle + random_range(-1,1) * other.accuracy,10)
  	image_angle = direction
  }
  wait(2)
  if !instance_exists(self){exit}
}
