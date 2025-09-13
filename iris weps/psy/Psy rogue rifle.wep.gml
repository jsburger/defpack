	#define init
global.sprPsyRogueRifle = sprite_add_weapon("../../sprites/weapons/iris/psy/sprPsyRogueRifle.png", 3, 3);

#define weapon_name
return "PSY ROGUE RIFLE";

#define weapon_sprt
return global.sprPsyRogueRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 6;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "TURN YOUR BACKS";


#define weapon_fire
	mod_script_call("mod", "defburst", "burst", 2, 2, self, script_ref_create(fire_burst))
	
#define fire_burst
	var c = instance_is(self, FireCont) ? creator : self;
	
	weapon_post(4,-6,2)
	sound_play(sndRogueRifle)
	sound_play_pitch(sndSwapCursed,random_range(1.3,1.6))
	mod_script_call("mod","defpack tools", "shell_yeah", 180, 25, random_range(2,4), c_purple)
	with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
		creator = c
		move_contact_solid(other.gunangle,5)
		team = c.team
		motion_add(other.gunangle+random_range(-8,8)*other.accuracy,8)
		image_angle = direction
	}
