#define init
global.sprThunderRogueRifle = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprThunderRogueRifle.png", 3, 2);
#define weapon_name
return "THUNDER ROGUE RIFLE";

#define weapon_sprt
return global.sprThunderRogueRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 8;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "TAZER THEM";

#define weapon_fire

repeat(3)
{
	weapon_post(4,-8,3)
	sound_play_pitchvol(sndGammaGutsKill,1.6,.3+skill_get(17)*.2)
	sound_play(sndRogueRifle)
	if !skill_get(17)sound_play_pitch(sndLightningRifle,random_range(1.4,1.6))else sound_play_pitch(sndLightningRifleUpg,random_range(1.6,1.8))
	mod_script_call("mod","defpack tools", "shell_yeah", 180, 25, 2+random(2), c_navy)
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		motion_add(other.gunangle+random_range(-7,7)*other.accuracy,10)
		image_angle = direction
		team = other.team
		creator = other
	}
	wait 2
	if !instance_exists(self)exit
}
