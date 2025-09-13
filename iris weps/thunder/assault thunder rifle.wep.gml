#define init
global.sprAssaultThunderRifle = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprAssaultThunderRifle.png", 4, 3);

#define weapon_name
return "THUNDER ASSAULT RIFLE"

#define weapon_sprt
return global.sprAssaultThunderRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 13;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "FORKED LIGHTNING";

#define weapon_fire
	mod_script_call("mod", "defburst", "burst", 4, 2, self, script_ref_create(fire_burst))
	
#define fire_burst(_burst)
	var c = instance_is(self, FireCont) ? creator : self;
	
    mod_script_call("mod","defpack tools", "shell_yeah", 180, 25, 2+random(2), c_navy)
	weapon_post(4, -6, 4);
	var vol = .6;
	if skill_get(mut_laser_brain)
		sound_play_pitchvol(sndLightningRifleUpg, random_range(1.6,1.8), vol)
	else
		sound_play_pitchvol(sndLightningRifle,random_range(1.4,1.6), vol)
	sound_play_pitchvol(sndMachinegun,random_range(.7,.9), vol)
	sound_play_pitchvol(sndGammaGutsKill, 1.4, (.3 + .2 * skill_get(mut_laser_brain)) * vol)
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		motion_add(other.gunangle+random_range(-4,4)*other.accuracy,10)
		image_angle = direction
		team = c.team
		creator = c
	}
