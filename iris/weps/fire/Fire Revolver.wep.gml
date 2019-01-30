#define init
global.sprFireRevolver = sprite_add_weapon("sprites/sprFireRevolver.png", -2, 2);
#define weapon_name
return "FIRE REVOLVER";

#define weapon_sprt
return global.sprFireRevolver;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 4;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "OUT OF THE KETTLE";

#define weapon_fire

weapon_post(2,-1,3)
sound_play(sndPistol)
sound_play_pitchvol(sndSwapFlame,random_range(1.4,1.6),.7)
sound_play_pitchvol(sndIncinerator,1,.2)
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_red)
with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
	creator = other
	team = other.team
	motion_set(other.gunangle + random_range(-12,12) * other.accuracy,15)
	image_angle = direction
}
