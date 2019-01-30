#define init
global.sprHyperPestRifle = sprite_add_weapon("sprites/sprHyperPestRifle.png", 6, 4);

#define weapon_name
return "HYPER PEST RIFLE";

#define weapon_sprt
return global.sprHyperPestRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 6;

#define weapon_cost
return 5;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "KEEP THE CLOUDS AWAY";

#define weapon_fire

repeat(5)
{
  weapon_post(5,-3,4)
  sound_play_pitch(sndHyperRifle,random_range(1.2,1.5))
  //sound_play_pitch(sndToxicLauncher,random_range(3,5)) smart gun sound yes?
  sound_play_pitch(sndToxicBoltGas,random_range(3,3.8))
  mod_script_call("mod","defpack tools", "shell_yeah", 180, 20, random_range(1,4), c_green)
  with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x+lengthdir_x(8,gunangle),y+lengthdir_y(8,gunangle)){
      creator = other
      team = other.team
      motion_set(other.gunangle + random_range(-2,2) * other.accuracy,12)
  	image_angle = direction
  }
  wait(1)
  if !instance_exists(self) exit
}
