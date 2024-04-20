#define init
global.sprPestShotgun = sprite_add_weapon("../../sprites/weapons/iris/pest/sprPestShotgun.png", 3, 2);

#define weapon_name
return "PEST SHOTGUN";

#define weapon_sprt
return global.sprPestShotgun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 21;

#define weapon_cost
return 6;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return choose("COUGH");

#define weapon_fire
var p = random_range(.8,1.2)
weapon_post(4,-11,2)
var vol = .8
sound_play_pitchvol(sndTripleMachinegun,.7*p,.5 * vol)
sound_play_pitchvol(sndQuadMachinegun,.7*p,.5 * vol)
sound_play_pitchvol(sndToxicBoltGas,.7*p, 1 * vol)
sound_play_pitchvol(sndSwapFlame,.8*p,.7 * vol)
sound_play_pitchvol(sndBouncerShotgun,.6*p,.4 * vol)
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,5), c_green)
var h = 50
var i = -h/2 -h/14
repeat(7)
{
	i += h/7
with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x,y){
		creator = other
		move_contact_solid(other.gunangle,5)
		team = other.team
		motion_add(other.gunangle+i*other.accuracy+random_range(-1,1),16)
		image_angle = direction
}
}
