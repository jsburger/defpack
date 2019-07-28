#define init
global.sprHeavyFireMachinegun = sprite_add_weapon("../../sprites/weapons/iris/fire/sprHeavyFireMachinegun.png", 5, 3);
#define weapon_name
return "HEAVY FIRE MACHINEGUN";

#define weapon_sprt
return global.sprHeavyFireMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 4;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "INTO THE FLAMES";

#define weapon_fire

weapon_post(4,-7,3)
var p = random_range(.8,1.2)
sound_play_pitchvol(sndHeavyMachinegun,1.4*p,.8)
sound_play_pitchvol(sndSwapFlame,.8*p,.7)
sound_play_pitchvol(sndIncinerator,p,.6)
sound_play_pitchvol(sndFlameCannonEnd,.8*p,.4)
sleep(20)
mod_script_call("mod","defpack tools", "shell_yeah_heavy", 100, 25, 2+random(3), c_red)
with mod_script_call("mod", "defpack tools", "create_heavy_fire_bullet",x,y){
	creator = other
	team = other.team
	move_contact_solid(other.gunangle,6)
	motion_set(other.gunangle + random_range(-15,15) * other.accuracy,16)
	image_angle = direction
}
