#define init
global.sprHeavyThunderMachinegun = sprite_add_weapon("sprites/sprHeavyThunderMachinegun.png", 3, 2);
#define weapon_name
return "HEAVY THUNDER MACHINEGUN";

#define weapon_sprt
return global.sprHeavyThunderMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 16;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "CHAIN LIGHTNING";

#define weapon_fire

repeat(2)
{
	weapon_post(4,-8,3)
	var _p = random_range(.8,1.2)
	sound_play_pitchvol(sndGammaGutsKill,1.6*_p,.3+skill_get(17)*.2)
	sound_play_pitchvol(sndLightningCannonLoop,15*_p,.3+skill_get(17)*.2)
	sound_play_pitch(sndPistol,.8*_p)
	sound_play_pitch(sndHeavyMachinegun,.8*_p)
	if !skill_get(17)sound_play_pitch(sndLightningCannon,1.2*_p)else sound_play_pitch(sndLightningCannonUpg,1.2*_p)
	if !skill_get(17)sound_play_pitchvol(sndLightningShotgun,.6*_p,.6)else sound_play_pitchvol(sndLightningShotgunUpg,.6*_p,.6)
	mod_script_call("mod","defpack tools", "shell_yeah_heavy", 100, 25, 2+random(3), c_navy)
	with mod_script_call("mod", "defpack tools", "create_heavy_lightning_bullet",x,y){
		motion_add(other.gunangle+random_range(-5,5)*other.accuracy,14)
		image_angle = direction
		team = other.team
		creator = other
	}
	wait 4
	if !instance_exists(self)exit
}
