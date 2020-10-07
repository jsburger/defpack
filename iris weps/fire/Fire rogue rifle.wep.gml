#define init
global.sprFireRogueRifle = sprite_add_weapon("../../sprites/weapons/iris/fire/sprFireRogueRifle.png", 3, 4);
#define weapon_name
return "FIRE ROGUE RIFLE";

#define weapon_sprt
return global.sprFireRogueRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 4;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "OUT OF THE KETTLE";

#define weapon_fire

repeat(2){
	weapon_post(4,-8,3)
	sound_play(sndRogueRifle)
	sound_play_pitchvol(sndSwapFlame,random_range(1.4,1.6),.7)
	sound_play_pitchvol(sndIncinerator,1,.2)
	mod_script_call("mod","defpack tools", "shell_yeah", 180, 25, 2+random(2), c_red)
	with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
		creator = other
		team = other.team
		motion_set(other.gunangle + random_range(-15,15) * other.accuracy,15)
		image_angle = direction
	}
	wait(2)
}
