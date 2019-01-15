#define init
global.sprQuadFireMachinegun = sprite_add_weapon("sprites/sprQuadFireMachinegun.png", 4, 4);
#define weapon_name
return "QUAD FIRE MACHINEGUN";

#define weapon_sprt
return global.sprQuadFireMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 3;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "WE ARE THE @rFlame";

#define weapon_fire

weapon_post(7,-1,11)
sound_play(sndQuadMachinegun)
sound_play_pitchvol(sndSwapFlame,.9,.7)
sound_play_pitchvol(sndIncinerator,1,.6)
repeat(4)mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(4), c_red)
with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
	creator = other
	team = other.team
	move_contact_solid(other.gunangle,8)
	motion_set(other.gunangle + 19 + random_range(-6,6) * other.accuracy,15)
	image_angle = direction
}
with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
	creator = other
	team = other.team
	move_contact_solid(other.gunangle,8)
	motion_set(other.gunangle + 38 * other.accuracy +random_range(-6,6) * other.accuracy,15)
	image_angle = direction
}
with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
	creator = other
	team = other.team
	move_contact_solid(other.gunangle,8)
	motion_set(other.gunangle - 19 * other.accuracy + random_range(-6,6) * other.accuracy,15)
	image_angle = direction
}
with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
	creator = other
	team = other.team
	move_contact_solid(other.gunangle,8)
	motion_set(other.gunangle - 38 * other.accuracy + random_range(-6,6) * other.accuracy,15)
	image_angle = direction
}
