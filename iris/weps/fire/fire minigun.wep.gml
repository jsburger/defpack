#define init
global.sprFireMinigun    = sprite_add_weapon("sprites/sprFireMinigun.png", 6, 1);
global.sprFireMinigunHUD = sprite_add_weapon("sprites/sprFireMinigun.png", 10, 6);

#define weapon_name
return "FIRE MINIGUN";

#define weapon_sprt
return global.sprFireMinigun;

#define weapon_sprt_hud
return global.sprFireMinigunHUD;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 1;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "FRESH OUT THE OVEN";

#define weapon_fire

weapon_post(4,-1,8)
sound_play_pitch(sndMinigun,.8)
sound_play_pitch(sndFiretrap,.8)
sound_play_pitchvol(sndIncinerator,1,.7)
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_red)
with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
	projectile_init(other.team,other)
	//move_contact_solid(other.gunangle,2)
	motion_set(other.gunangle + random_range(-22,22) * other.accuracy,15)
	image_angle = direction
}
