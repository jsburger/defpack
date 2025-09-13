#define init
global.sprQuadThunderMachinegun = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprQuadThunderMachinegun.png", 6, 3);
#define weapon_name
return "QUAD THUNDER MACHINEGUN";

#define weapon_sprt
return global.sprQuadThunderMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 4;

#define weapon_cost
return 5;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return choose("WAVES OF POWER","QUADRUPOLE");

#define sound(n)
weapon_post(7,-5,5)
var vol = .7;
sound_play_pitchvol(sndGammaGutsKill, 1.4, (.3 + .2 * skill_get(mut_laser_brain)) * vol)
sound_play_pitchvol(sndQuadMachinegun, 1, vol)
if !skill_get(17) {
    sound_play_pitchvol(sndLightningRifle, random_range(1.3, 1.5), vol)
}
else {
    sound_play_pitchvol(sndLightningRifleUpg,random_range(1.3,1.5), vol)
}
repeat(n) {
    mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(4), c_navy)
}
#define weapon_fire
	with mod_script_call("mod", "defburst", "burst", 5, 1, self, script_ref_create(fire_burst)) {
		if "wepflip" in other {
			flip = other.wepflip;
		}
		else flip = choose(-1, 1);
	}

#define fire_burst(_burst)
	var c = instance_is(self, FireCont) ? creator : self,
	    flip = _burst.flip;

    sound(1)
       
    with mod_script_call("mod", "defpack tools", "create_lightning_bullet", x, y) {
    	move_contact_solid(other.gunangle, 6)
    	motion_add(other.gunangle - (10 * other.accuracy * (_burst.shots_fired - (_burst.base_ammo - 1)/2)) * flip + random_range(-2, 2) * other.accuracy, 10)
    	image_angle = direction
    	team = other.team
    	creator = c
    }
