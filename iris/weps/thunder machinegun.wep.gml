#define init
global.sprThunderMachinegun = sprite_add_weapon("sprites/sprThunderMachinegun.png", 4, 2);
#define weapon_name
return "THUNDER MACHINEGUN";

#define weapon_sprt
return global.sprThunderMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 10;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "COMES WITH A BUMP STOCK";

#define weapon_fire

repeat(2)
{
	weapon_post(4,-3,7)
	sound_play_pitchvol(sndGammaGutsKill,1.4,.3+skill_get(17)*.2)
	sound_play(sndMachinegun)
	if !skill_get(17)sound_play_pitch(sndLightningRifle,random_range(1.3,1.5))else sound_play_pitch(sndLightningRifleUpg,random_range(1.3,1.5))
	mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_navy)
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		move_contact_solid(other.gunangle,6)
		motion_add(other.gunangle+random_range(-6,6)*other.accuracy,10)
		image_angle = direction
		team = other.team
		creator = other
	}
	wait 3
	if !instance_exists(self)exit
}
