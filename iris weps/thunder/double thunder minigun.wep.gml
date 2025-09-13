#define init
global.sprDoubleThunderMinigun = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprDoubleThunderMinigun.png", 4, 4);
#define weapon_name
return "DOUBLE THUNDER MINIGUN";

#define weapon_sprt
return global.sprDoubleThunderMinigun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 2;

#define weapon_cost
return 6;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "THUNDERSTORM";

#define weapon_fire
	mod_script_call("mod", "defburst", "burst", 3, 3, self, script_ref_create(fire_burst))
	
#define fire_burst(_burst)
	var c = instance_is(self, FireCont) ? creator : self;
	
	motion_add(gunangle-180,2)
	weapon_post(7,-3,12)
	
	var vol = .6;
	sound_play_pitchvol(sndGammaGutsKill,1.7,(.3+skill_get(17)*.2) * vol)
	sound_play_pitchvol(sndDoubleMinigun, 1, vol)
	if !skill_get(17)
		sound_play_pitchvol(sndLightningRifle, random_range(1.2, 1.4), vol)
	else 
		sound_play_pitchvol(sndLightningRifleUpg, random_range(1.2, 1.4), vol)

	mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_navy)

	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		move_contact_solid(other.gunangle,8)
		motion_add(other.gunangle+8+random_range(-12,12)*other.accuracy,10)
		image_angle = direction
		team = c.team
		creator = c
	}
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		move_contact_solid(other.gunangle,8)
		motion_add(other.gunangle-8+random_range(-12,12)*other.accuracy,10)
		image_angle = direction
		team = c.team
		creator = c
	}
