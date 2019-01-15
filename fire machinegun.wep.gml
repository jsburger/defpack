#define init
global.sprFireMachinegun = sprite_add_weapon("sprites/sprFireMachinegun.png", 2, 0);
#define weapon_name
return "FIRE MACHINEGUN";

#define weapon_sprt
return global.sprFireMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 4;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "PASSIONATE MACHINEGUN";

#define weapon_fire

weapon_post(2,-1,3)
sound_play(sndMachinegun)
sound_play_pitchvol(sndSwapFlame,random_range(1.4,1.6),.7)
sound_play_pitchvol(sndIncinerator,1,.2)
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_red)
with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
	creator = other
	team = other.team
	move_contact_solid(other.gunangle,8)
	motion_set(other.gunangle + random_range(-16,16) * other.accuracy,15)
	image_angle = direction
}
