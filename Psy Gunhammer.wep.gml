#define init
global.sprPsyGunhammer = sprite_add_weapon("sprites/sprPsyGunhammer.png", 2, 11);
global.slash = sprite_add("sprites/projectiles/Heavy Psy Slash.png",3,0,24);

#define weapon_name
return "PSY GUNHAMMER";

#define weapon_sprt
return global.sprPsyGunhammer;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 32;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return -1;

#define weapon_text
return "I BANISH THEE";

#define weapon_melee
return 1

#define weapon_fire

sound_play_pitch(sndShovel,random_range(1.2,1.23))
sound_play_pitch(sndHammer,random_range(.97,1.03))
weapon_post(8,8,4)
var shell = 0;
with instance_create(x,y,Slash){
	damage = 9
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
		if other.ammo[1] >=2 {
			sound_play_pitch(sndAssassinPretend,random_range(.5,.55))
			sound_play_pitch(sndSwapCursed,.4)
			sound_play_pitch(sndMachinegun,1.2)
			sprite_index = global.slash
			with mod_script_call("mod","defpack tools","create_psy_bullet",x,y){
				motion_set(other.direction + random_range(-20,20)*other.creator.accuracy, 5)
				image_angle = direction
				creator = other.creator
				team = other.team
				timer -= 5
			}
			if other.infammo = 0 {other.ammo[1] -= 2}
			shell += 1
		}
	}
}
if shell repeat(shell) mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,5), c_purple)
wepangle = -wepangle
motion_add(gunangle,5)
