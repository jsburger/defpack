#define init
global.sprHyperThunderRifle = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprHyperThunderRifle.png", 4, 3);

#define weapon_name
return "HYPER THUNDER RIFLE"

#define weapon_sprt
return global.sprHyperThunderRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 5;

#define weapon_cost
return 10;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "ITS A LONG ONE";

#define weapon_fire

repeat (10)
{
	if (!instance_exists(self)) break;
	mod_script_call("mod","defpack tools", "shell_yeah", 180, 25, 2+random(3), c_navy)
	weapon_post(5, -10, 4);
	if !skill_get(17)sound_play_pitch(sndLightningRifle,random_range(1.3,1.5))else sound_play_pitch(sndLightningRifleUpg,random_range(1.3,1.5))
	sound_play_pitch(sndHyperRifle,random_range(.7,.9))
	sound_play_pitchvol(sndGammaGutsKill,1.4,.4+skill_get(17)*.1)
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		move_contact_solid(other.gunangle,8)
		motion_add(other.gunangle+random_range(-4,4)*other.accuracy,10)
		image_angle = direction
		team = other.team
		creator = other
	}
	wait 1;
	if !instance_exists(self)exit
}
