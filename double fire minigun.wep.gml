#define init
global.sprDoubleFireMinigun = sprite_add_weapon("sprites/sprDoubleFireMinigun.png", 4, 2);
#define weapon_name
return "DOUBLE FIRE MINIGUN";

#define weapon_sprt
return global.sprDoubleFireMinigun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 1;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "BOIL THEM ALIVE";

#define weapon_fire

weapon_post(7,-1,12)
sound_play_pitch(sndMinigun,.8)
sound_play_pitch(sndFiretrap,.5)
motion_add(gunangle,-1)
sound_play_pitchvol(sndIncinerator,.8,.8)
repeat(2)mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_red)
with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
	creator = other
	team = other.team
	move_contact_solid(other.gunangle,6)
	motion_set(other.gunangle - 25 * other.accuracy + random_range(-16,16) * other.accuracy,15)
	image_angle = direction
}
with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
	creator = other
	team = other.team
	move_contact_solid(other.gunangle,6)
	motion_set(other.gunangle + 25 * other.accuracy + random_range(-16,16) * other.accuracy,15)
	image_angle = direction
}
