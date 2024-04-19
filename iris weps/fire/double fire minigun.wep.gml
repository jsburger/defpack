#define init
global.sprDoubleFireMinigun    = sprite_add_weapon("../../sprites/weapons/iris/fire/sprDoubleFireMinigun.png", 10, 2);
global.sprDoubleFireMinigunHUD = sprite_add_weapon("../../sprites/weapons/iris/fire/sprDoubleFireMinigun.png", 14, 7);

#define weapon_name
return "DOUBLE FIRE MINIGUN";

#define weapon_sprt
return global.sprDoubleFireMinigun;

#define weapon_sprt_hud
return global.sprDoubleFireMinigunHUD;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return .6;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "BOIL THEM ALIVE";

#define weapon_fire

weapon_post(5,-1,12)
var vol = .6;
sound_play_pitchvol(sndMinigun, .8, vol)
sound_play_pitchvol(sndFiretrap, .5, vol)
sound_play_pitchvol(sndIncinerator, .8, .8 * vol)
motion_add(gunangle,-1)
repeat(2)mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_red)
with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
	projectile_init(other.team,other)
	move_contact_solid(other.gunangle,6)
	motion_set(other.gunangle - 25 * other.accuracy + random_range(-16,16) * other.accuracy,15)
	image_angle = direction
}
with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
	projectile_init(other.team,other)
	move_contact_solid(other.gunangle,6)
	motion_set(other.gunangle + 25 * other.accuracy + random_range(-16,16) * other.accuracy,15)
	image_angle = direction
}
