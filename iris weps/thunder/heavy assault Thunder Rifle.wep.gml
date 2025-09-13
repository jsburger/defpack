#define init
global.sprHeavyAssaultThunderRifle = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprHeavyThunderAssaultRifle.png", 4, 4);
#define weapon_name
return "HEAVY THUNDER ASSAULT RIFLE";

#define weapon_sprt
return global.sprHeavyAssaultThunderRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 11;

#define weapon_cost
return 6;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "STORM'S COMING";

#define weapon_fire
	mod_script_call("mod", "defburst", "burst", 4, 2, self, script_ref_create(fire_burst))
	
#define fire_burst(_burst)
	var c = instance_is(self, FireCont) ? creator : self;
		
	weapon_post(4,-8,3)
	
	var _p = random_range(.8,1.2),
		vol = .6,
		skillvol = vol * (.3 + skill_get(mut_laser_brain) * .2);
	sound_play_pitchvol(sndGammaGutsKill, 1.6 * _p, skillvol)
	sound_play_pitchvol(sndLightningCannonLoop, 15 *_p, skillvol)
	sound_play_pitchvol(sndPistol, .8 * _p, vol)
	sound_play_pitchvol(sndHeavySlugger, 1.4 *_p, vol)
	if !skill_get(mut_laser_brain) {
		sound_play_pitchvol(sndLightningCannon, 1.5 * _p, vol)
		sound_play_pitchvol(sndLightningShotgun, .7 * _p, .6 * vol)
	}
	else {
		sound_play_pitchvol(sndLightningCannonUpg, 1.5 *_p, vol)
		sound_play_pitchvol(sndLightningShotgunUpg, .7 * _p, .6 * vol)
	}
	
	mod_script_call("mod","defpack tools", "shell_yeah_heavy", 180, 25, 2+random(2), c_navy)
	with mod_script_call("mod", "defpack tools", "create_heavy_lightning_bullet",x,y){
		motion_add(other.gunangle+random_range(-4,4)*other.accuracy,14)
		image_angle = direction
		team = c.team
		creator = c
	}
