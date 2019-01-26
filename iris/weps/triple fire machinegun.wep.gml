#define init
global.sprTripleFireMachinegun = sprite_add_weapon("sprites/sprTripleFireMachinegun.png", 4, 4);
#define weapon_name
return "TRIPLE FIRE MACHINEGUN";

#define weapon_sprt
return global.sprTripleFireMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 3;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "WE ARE THE @rFire";

#define weapon_fire

weapon_post(4,-1,7)
sound_play(sndTripleMachinegun)
sound_play_pitchvol(sndSwapFlame,.9,.7)
sound_play_pitchvol(sndIncinerator,1,.2)
repeat(3)mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_red)
with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
	creator = other
	team = other.team
	move_contact_solid(other.gunangle,8)
	motion_set(other.gunangle + random_range(-6,6) * other.accuracy,15)
	image_angle = direction
}
with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
	creator = other
	team = other.team
	move_contact_solid(other.gunangle,8)
	motion_set(other.gunangle + 33 * other.accuracy +random_range(-6,6) * other.accuracy,15)
	image_angle = direction
}
with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
	creator = other
	team = other.team
	move_contact_solid(other.gunangle,8)
	motion_set(other.gunangle - 33 * other.accuracy + random_range(-6,6) * other.accuracy,15)
	image_angle = direction
}
