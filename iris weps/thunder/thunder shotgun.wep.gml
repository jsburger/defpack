#define init
global.sprThunderShotgun = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprThunderShotgun.png", 4, 3);

#define weapon_name
return "THUNDER SHOTGUN";

#define weapon_sprt
return global.sprThunderShotgun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 15;

#define weapon_cost
return 12;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return choose("SHOCKWAVE");

#define weapon_fire
var h = 10
var i = -h/2 -h/14

repeat(2)
{
	var _p = random_range(.8,1.2)
	weapon_post(4,-11,2)
	sound_play_pitchvol(sndQuadMachinegun,.8*_p,.7)
	sound_play_pitchvol(sndBouncerShotgun,.6*_p,.6)
	sound_play_pitchvol(sndGammaGutsKill,1.2*_p,.3+skill_get(17)*.2)
	if !skill_get(17)sound_play_pitch(sndLightningRifle,1.5*_p)else sound_play_pitch(sndLightningRifleUpg,1.5*_p)
	mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,5), c_navy)
	repeat(7) {
		i += h/7
		with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
			creator = other
			move_contact_solid(other.gunangle,5)
			team = other.team
			motion_add(other.gunangle+i*other.accuracy+random_range(-3,3),16)
			image_angle = direction
		}
	}
	wait 4
	if !instance_exists(self) exit
	h = 80
	i = -h/2 -h/14
}
