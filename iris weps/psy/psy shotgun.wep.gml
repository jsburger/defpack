#define init
global.sprPsyShotgun = sprite_add_weapon("../../sprites/weapons/iris/psy/sprPsyShotgun.png", 4, 2);

#define weapon_name
return "PSY SHOTGUN";

#define weapon_sprt
return global.sprPsyShotgun;

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
return choose("NO MATTER THE DEVIATION");

#define weapon_fire
var p = random_range(.8,1.2)
weapon_post(4,-11,2)
sound_play_pitch(sndPistol,.7*p)
sound_play_pitch(sndSwapCursed,.7*p)
sound_play_pitch(sndCursedReminder,1.2*p)
sound_play_pitchvol(sndBouncerShotgun,.6*p,.4)
sound_play_pitchvol(sndQuadMachinegun,.6*p,.8)
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,5), c_purple)
var h = 110
var i = -h/2 -h/14
repeat(7)
{
	i += h/7
with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
		creator = other
		move_contact_solid(other.gunangle,5)
		team = other.team
		motion_add(other.gunangle+i*other.accuracy+random_range(-1,1),8)
		image_angle = direction
}
}
