#define init
global.sprThunderShotgun = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprThunderShotgun.png", 4, 3);

#define weapon_name
return "THUNDER SHOTGUN";

#define weapon_sprt
return global.sprThunderShotgun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 15;

#define weapon_cost
return 12;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return choose("SHOCKWAVE");

#define weapon_fire
	mod_script_call("mod", "defburst", "burst", 2, 4, self, script_ref_create(fire_burst))
	
#define fire_burst(_burst)
	var c = instance_is(self, FireCont) ? creator : self,
		h = !_burst.shots_fired ? 10 : 80,
		i = -h/2 - h/14
		
	var _p = random_range(.8,1.2),
		vol = .6;
	weapon_post(4,-11,2)
	sound_play_pitchvol(sndQuadMachinegun,.8*_p,.7 * vol)
	sound_play_pitchvol(sndBouncerShotgun,.6*_p,.6 * vol)
	sound_play_pitchvol(sndGammaGutsKill,1.2*_p,(.3+skill_get(17)*.2) * vol);
	if !skill_get(17){ 
		sound_play_pitchvol(sndLightningRifle,1.5*_p, vol)
	}
	else {
		sound_play_pitchvol(sndLightningRifleUpg,1.5*_p, vol)
	}
	mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,5), c_navy)
	repeat(7) {
		i += h/7
		with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
			creator = c
			move_contact_solid(other.gunangle,5)
			team = c.team
			motion_add(other.gunangle+i*other.accuracy+random_range(-3,3),16)
			image_angle = direction
		}
	}
