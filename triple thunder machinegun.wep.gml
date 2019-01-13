#define init
global.sprTripleThunderMachinegun = sprite_add_weapon("sprites/sprTripleThunderMachinegun.png", 6, 3);
#define weapon_name
return "TRIPLE THUNDER MACHINEGUN";

#define weapon_sprt
return global.sprTripleThunderMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 7;

#define weapon_cost
return 6;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "PRAISE THE @bTRAPEZOID";

#define sound(n)
weapon_post(6,-3,6)
sound_play_pitchvol(sndGammaGutsKill,1.4,.3+skill_get(17)*.2)
sound_play(sndTripleMachinegun)
if !skill_get(17)sound_play_pitch(sndLightningRifle,random_range(1.3,1.5))else sound_play_pitch(sndLightningRifleUpg,random_range(1.3,1.5))
repeat(n)mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_navy)


#define weapon_fire
sound(2)
for var i = -1; i <= 1; i+= 2{
    with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
    	move_contact_solid(other.gunangle,6)
    	motion_add(other.gunangle+7*i+random_range(-2,2)*other.accuracy,10)
    	image_angle = direction
    	team = other.team
    	creator = other
    }
}
wait(3)
if !instance_exists(self) exit
sound(3)
{
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		move_contact_solid(other.gunangle,6)
		motion_add(other.gunangle+random_range(-2,2)*other.accuracy,10)
		image_angle = direction
		team = other.team
		creator = other
	}
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		move_contact_solid(other.gunangle,6)
		motion_add(other.gunangle+15+random_range(-2,2)*other.accuracy,10)
		image_angle = direction
		team = other.team
		creator = other
	}
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		move_contact_solid(other.gunangle,6)
		motion_add(other.gunangle-15+random_range(-2,2)*other.accuracy,10)
		image_angle = direction
		team = other.team
		creator = other
	}
}
