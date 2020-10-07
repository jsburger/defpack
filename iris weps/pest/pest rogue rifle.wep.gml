#define init
global.sprPestRogueRifle = sprite_add_weapon("../../sprites/weapons/iris/pest/sprPestRogueRifle.png", 4, 2);

#define weapon_name
return "PEST ROGUE RIFLE";

#define weapon_sprt
return global.sprPestRogueRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 6;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "ALL GASSED UP";

#define weapon_fire

repeat(2){
  weapon_post(4,-8,3)
  sound_play_pitch(sndMinigun,random_range(1.2,1.5))
  sound_play_pitch(sndRogueRifle,random_range(.6,.8))
  sound_play_pitch(sndToxicBoltGas,random_range(3,3.8))
  mod_script_call("mod","defpack tools", "shell_yeah", 180, 25, random_range(2,4), c_green)
  with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x+lengthdir_x(8,gunangle),y+lengthdir_y(8,gunangle)){
      creator = other
      team = other.team
      motion_set(other.gunangle + random_range(-4,4) * other.accuracy,16)
  	image_angle = direction
  }
  wait(2)
}
