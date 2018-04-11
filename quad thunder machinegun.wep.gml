#define init
global.sprQuadThunderMachinegun = sprite_add_weapon("sprites/sprQuadThunderMachinegun.png", 6, 3);
#define weapon_name
return "QUAD THUNDER MACHINEGUN";

#define weapon_sprt
return global.sprQuadThunderMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 7;

#define weapon_cost
return 12;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "replace me please";

#define weapon_fire

repeat(2)
{
	weapon_post(7,-3,14)
	sound_play_pitchvol(sndGammaGutsKill,1.4,.3+skill_get(17)*.2)
	sound_play(sndQuadMachinegun)
	if !skill_get(17)sound_play_pitch(sndLightningRifle,random_range(1.3,1.5))else sound_play_pitch(sndLightningRifleUpg,random_range(1.3,1.5))
	repeat(4)mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(4), c_navy)
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		move_contact_solid(other.gunangle,6)
		motion_add(other.gunangle+random_range(-6,6)*other.accuracy,8)
		image_angle = direction
		team = other.team
		creator = other
	}
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		move_contact_solid(other.gunangle,6)
		motion_add(other.gunangle-10+random_range(-6,6)*other.accuracy,8)
		image_angle = direction
		team = other.team
		creator = other
	}
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		move_contact_solid(other.gunangle,6)
		motion_add(other.gunangle-20+random_range(-6,6)*other.accuracy,8)
		image_angle = direction
		team = other.team
		creator = other
	}
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		move_contact_solid(other.gunangle,6)
		motion_add(other.gunangle+10+random_range(-6,6)*other.accuracy,8)
		image_angle = direction
		team = other.team
		creator = other
	}
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		move_contact_solid(other.gunangle,6)
		motion_add(other.gunangle+20+random_range(-6,6)*other.accuracy,8)
		image_angle = direction
		team = other.team
		creator = other
	}
	wait 3
}
