#define init
global.sprAssaultThunderRifle = sprite_add_weapon("sprites/sprAssaultThunderRifle.png", 4, 3);

#define weapon_name
return "ASSAULT THUNDER RIFLE"

#define weapon_sprt
return global.sprAssaultThunderRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 17;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "FORKED LIGHTNING";

#define weapon_fire

repeat(4){
    mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_navy)
	weapon_post(4, -6, 4);
	if !skill_get(17)sound_play_pitch(sndLightningRifle,random_range(1.4,1.6))else sound_play_pitch(sndLightningRifleUpg,random_range(1.6,1.8))
	sound_play_pitch(sndMachinegun,random_range(.7,.9))
	sound_play_pitchvol(sndGammaGutsKill,1.4,.3+skill_get(17)*.2)
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		motion_add(other.gunangle+random_range(-4,4)*other.accuracy,10)
		image_angle = direction
		team = other.team
		creator = other
	}
    wait(3)
    if !instance_exists(self)exit
}
