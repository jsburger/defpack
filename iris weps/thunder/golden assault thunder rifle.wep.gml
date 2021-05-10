#define init
global.sprGoldenAssaultThunderRifle = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprGoldenAssaultThunderRifle.png", 4, 3);

#define weapon_name
return "GOLDEN THUNDER ASSAULT RIFLE"

#define weapon_sprt
return global.sprGoldenAssaultThunderRifle;

#define weapon_gold
return -1;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 14;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "A GOOD CONDUCTOR";

#define weapon_fire

repeat(4){
    mod_script_call("mod","defpack tools", "shell_yeah", 180, 25, 2+random(2), c_navy)
	weapon_post(4, -6, 4);
	if !skill_get(17)sound_play_pitch(sndLightningRifle,random_range(1.4,1.6))else sound_play_pitch(sndLightningRifleUpg,random_range(1.6,1.8))
	sound_play_pitch(sndGoldMachinegun,random_range(.7,.9))
	sound_play_pitchvol(sndGammaGutsKill,1.4,.3+skill_get(17)*.2)
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		motion_add(other.gunangle+random_range(-4,4)*other.accuracy,10)
		image_angle = direction
		team = other.team
		creator = other
	}
    wait(2)
    if !instance_exists(self)exit
}
