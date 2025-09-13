#define init
global.sprTripleThunderMachinegun = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprTripleThunderMachinegun.png", 6, 3);
#define weapon_name
return "TRIPLE THUNDER MACHINEGUN";

#define weapon_sprt
return global.sprTripleThunderMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 6;

#define weapon_cost
return 5;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "PRAISE THE @bTRAPEZOID";

#define sound(n)
var p = random_range(.9, 1.1),
	vol = .7;
weapon_post(6,-3,6)
sound_play_pitchvol(sndGammaGutsKill, 1.4, (.3 + .2 * skill_get(mut_laser_brain)) * vol);
sound_play_pitchvol(sndTripleMachinegun, p, vol);
if !skill_get(17) {
	sound_play_pitchvol(sndLightningRifle, 1.4 * p, vol);
}
else {
	sound_play_pitchvol(sndLightningRifleUpg,1.4 * p, vol);
}
repeat(n)mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_navy)


#define weapon_fire
	mod_script_call("mod", "defburst", "burst", 2, 3, self, script_ref_create(fire_burst))
	
#define fire_burst(_burst)
	var c = instance_is(self, FireCont) ? creator : self;
	
	if !_burst.shots_fired{
		sound(2)
		for (var i = -1; i <= 1; i+= 2){
		    with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
		    	move_contact_solid(other.gunangle,6)
		    	motion_add(other.gunangle+7*i+random_range(-2,2)*other.accuracy,10)
		    	image_angle = direction
		    	team = other.team
		    	creator = other
		    }
		}
	}
	else{
		
		sound(3)
		with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
			move_contact_solid(other.gunangle,6)
			motion_add(other.gunangle+random_range(-2,2)*other.accuracy,10)
			image_angle = direction
			team = other.team
			creator = other
		}
		with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
			move_contact_solid(other.gunangle,6)
			motion_add(other.gunangle+15 * other.accuracy+random_range(-2,2)*other.accuracy,10)
			image_angle = direction
			team = other.team
			creator = other
		}
		with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
			move_contact_solid(other.gunangle,6)
			motion_add(other.gunangle-15 * other.accuracy+random_range(-2,2)*other.accuracy,10)
			image_angle = direction
			team = other.team
			creator = other
		}
	}
	