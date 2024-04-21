#define init
global.sprHorrorShotgun = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprHorrorShotgunOn.png", 3, 2);

#define weapon_name
return "GAMMA SHOTGUN";

#define weapon_sprt
return global.sprHorrorShotgun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 18;

#define weapon_cost
return 6;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return choose("THE PROTOTYPE");

#define weapon_fire
var p = random_range(.8,1.2)
weapon_post(4,-11,2)
sound_play_pitchvol(sndTripleMachinegun,1.4*p,.5)
sound_play_pitchvol(sndQuadMachinegun,.8*p,.5)
sound_play_pitch(sndUltraPistol,1.7*p)
sound_play_pitchvol(sndBouncerShotgun,1.4*p,.4)
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,5), c_lime)
var h = 120
var i = -h/2 -h/28
repeat(14)
{
	i += h/14
with mod_script_call("mod", "defpack tools", "create_gamma_bullet",x,y){
		creator = other
		move_contact_solid(other.gunangle,5)
		team = other.team
		motion_add(other.gunangle+i*other.accuracy+random_range(-1,1),14 + irandom(2))
		image_angle = direction
}
}
