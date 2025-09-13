#define init
global.sprGoldenThunderPistol = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprGoldenThunderPistol.png", -3, 2);
#define weapon_name
return "GOLDEN THUNDER PISTOL";

#define weapon_sprt
return global.sprGoldenThunderPistol;

#define weapon_gold
return -1;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 8;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "@yGILDED @sTAZER";

#define weapon_fire
	mod_script_call("mod", "defburst", "burst", 2, 3, self, script_ref_create(fire_burst))
	
#define fire_burst(_burst)
	var c = instance_is(self, FireCont) ? creator : self;
	
	weapon_post(2,-3,2)
	var vol = .6;
	sound_play_pitchvol(sndGammaGutsKill,1.6,(.3+skill_get(17)*.2) * vol)
	sound_play_pitchvol(sndGoldPistol, 1, vol)
	if skill_get(mut_laser_brain)
		sound_play_pitchvol(sndLightningRifleUpg, random_range(1.6,1.8), vol)
	else
		sound_play_pitchvol(sndLightningRifle,random_range(1.4,1.6), vol)
	
	mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_navy)
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		motion_add(other.gunangle+random_range(-4,4)*other.accuracy,10)
		image_angle = direction
		team = other.team
		creator = c
	}