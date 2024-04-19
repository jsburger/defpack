#define init
global.sprHeavyFireRevolver = sprite_add_weapon("../../sprites/weapons/iris/fire/sprHeavyFirePistol.png", -2, 2);
#define weapon_name
return "HEAVY FIRE REVOLVER";

#define weapon_sprt
return global.sprHeavyFireRevolver;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 4;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "INTO THE FIRE";

#define weapon_fire

weapon_post(4,-7,3)
var p = random_range(.8,1.2),
	vol = .8;
sound_play_pitchvol(sndHeavyRevoler, .9 * p, .8 * vol)
sound_play_pitchvol(sndSwapFlame, .8 * p, .7 * vol)
sound_play_pitchvol(sndIncinerator, p, .6 * vol)
sound_play_pitchvol(sndFlameCannonEnd, .8 * p, .4 * vol)
mod_script_call("mod","defpack tools", "shell_yeah_heavy", 100, 25, 2+random(3), c_red)
with mod_script_call("mod", "defpack tools", "create_heavy_fire_bullet",x,y){
	creator = other
	team = other.team
	motion_set(other.gunangle + random_range(-12,12) * other.accuracy,16)
	image_angle = direction
}
