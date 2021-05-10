#define init
global.sprGoldenFireMachinegun = sprite_add_weapon("../../sprites/weapons/iris/fire/sprGoldenFireMachinegun.png", 4, 2);
#define weapon_name
return "GOLDEN FIRE MACHINEGUN";

#define weapon_sprt
return global.sprGoldenFireMachinegun;

#define weapon_gold
return -1;

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
return "FIERY GREED";

#define weapon_fire

weapon_post(2,-1,3)
sound_play(sndGoldMachinegun)
sound_play_pitchvol(sndSwapFlame,random_range(1.4,1.6),.7)
sound_play_pitchvol(sndIncinerator,1,.2)
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_red)
with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
	creator = other
	team = other.team
	move_contact_solid(other.gunangle,8)
	motion_set(other.gunangle + random_range(-11,11) * other.accuracy,15)
	image_angle = direction
}
