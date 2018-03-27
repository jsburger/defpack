#define init
global.sprThunderRifle = sprite_add_weapon("sprites/Thunder Rifle.png", 4, 3);

#define weapon_name
return "THUNDER RIFLE"

#define weapon_sprt
return global.sprThunderRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 20;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 10;

#define weapon_text
return "FORKED LIGHTNING";

#define weapon_fire

repeat (4)
{
	sound_play(sndMachinegun)
	if !skill_get(17)sound_play_pitch(sndLightningRifle,random_range(1.4,1.6))else sound_play_pitch(sndLightningRifleUpg,random_range(1.6,1.8))
	if (!instance_exists(self)) break;
	mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_navy)
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		motion_add(other.gunangle+random_range(-4,4)*other.accuracy,8)
		image_angle = direction
		team = other.team
		creator = other
	}
	weapon_post(4, -10, 9);
	wait 2;
}
