#define init
global.sprToxicGunhammer = sprite_add_weapon("Toxic Gunhammer.png", 4, 8);
global.slash = sprite_add("Heavy Toxic Slash.png",3,0,24);

#define weapon_name
return "TOXIC GUNHAMMER";

#define weapon_sprt
return global.sprToxicGunhammer;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 22;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return 5;

#define weapon_text
return "SEWAGE SLASHER";

#define weapon_melee
return 1

#define weapon_fire

sound_play_pitch(sndHammer,random_range(.97,1.03))
weapon_post(8,8,4)
var shell = 0;
with instance_create(x,y,Slash){
	damage = 7
	motion_add(other.gunangle, 2 + (skill_get(13) * 3))
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
	sprite_index = sprHeavySlash
	image_angle = direction
	team = other.team
	creator = other
	repeat(3){
		if other.ammo[1] >=1 {
			sound_play_pitch(sndPistol,random_range(1.2,1.6))
			sound_play_pitch(sndToxicBoltGas,1.6)
			sprite_index = global.slash
			with mod_script_call("mod","defpack tools","create_toxic_bullet",x,y){
				motion_set(other.direction + random_range(-20,20)*other.creator.accuracy, 10)
				image_angle = direction
				creator = other.creator
				team = other.team
			}
			if other.infammo = 0 {other.ammo[1] -= 1}
			shell += 1
		}
	}
}
if shell repeat(shell) mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,5), c_lime)
wepangle = -wepangle
motion_add(gunangle,4)
