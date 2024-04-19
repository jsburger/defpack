#define init
global.sprGoldenFireRevolver = sprite_add_weapon("../../sprites/weapons/iris/fire/sprGoldenFireRevolver.png", -2, 2);
#define weapon_name
return "GOLDEN FIRE REVOLVER";

#define weapon_sprt
return global.sprGoldenFireRevolver;

#define weapon_gold
return -1;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 3;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "INTO THE POT";

#define weapon_fire

weapon_post(2,-1,3)
var pitch = random_range(.8, 1.2),
	vol = .8;
sound_play_pitchvol(sndGoldPistol, pitch, vol)
sound_play_pitchvol(sndSwapFlame, random_range(1.4, 1.6), .7 * vol)
sound_play_pitchvol(sndIncinerator, 1 * pitch, .2 * vol)
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_red)
with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
	creator = other
	team = other.team
	motion_set(other.gunangle + random_range(-12,12) * other.accuracy,15)
	image_angle = direction
}
