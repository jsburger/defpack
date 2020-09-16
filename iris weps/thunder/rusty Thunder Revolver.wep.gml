#define init
global.sprRustyThunderPistol = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprRustyThunderPistol.png", -3, 2);
#define weapon_name
return "RUSTY THUNDER PISTOL";

#define weapon_sprt
return global.sprRustyThunderPistol;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 21;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "LITTLE @bSPARKS";

#define weapon_fire

repeat(2)
{
	weapon_post(2,-3,2)
	sound_play_pitchvol(sndGammaGutsKill,1.6,.3+skill_get(17)*.2)
	sound_play(sndRustyRevolver)
	if !skill_get(17)sound_play_pitch(sndLightningRifle,random_range(1.4,1.6))else sound_play_pitch(sndLightningRifleUpg,random_range(1.6,1.8))
	mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_navy)
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		motion_add(other.gunangle,10)
		image_angle = direction
		team = other.team
		creator = other
	}
	wait 5
	if !instance_exists(self)exit
}
