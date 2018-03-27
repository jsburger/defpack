#define init
global.sprFireGunhammer = sprite_add_weapon("sprites/Fire Gunhammer.png", 1, 6); //SHOULD BE THE NORM, LOOKING GOOD
global.sprFireGunhammerSlash = sprite_add("sprites/projectiles/Heavy Fire Slash.png",3,0,24)

#define weapon_name
return "FIRE GUNHAMMER";

#define weapon_sprt
return global.sprFireGunhammer;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 22;

#define weapon_cost
return 0;

#define weapon_melee
return 1

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return 6;

#define weapon_text
return "BUT YOU STAY SO COOL";

#define weapon_fire

sound_play_pitch(sndHammer,random_range(.8,.92))
weapon_post(8,8,4)

with instance_create(x,y,Slash){
	damage = 5
	motion_add(other.gunangle, 2 + (skill_get(13) * 3))
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
	gunangle = other.gunangle
	sprite_index = sprHeavySlash
	image_angle = direction
	team = other.team
	creator = other
	right = other.right
	repeat(3){
		if other.ammo[1] >=1 {
			sound_play_pitch(sndPistol,1.2)
			sound_play_pitch(sndFlameCannon,random_range(3.8,4.1))
			 mod_script_call("mod","defpack tools", "shell_yeah", -180, 25, random_range(3,5), c_red)
			sprite_index = global.sprFireGunhammerSlash
			repeat(2)with instance_create(x+lengthdir_x(sprite_width,direction)+random_range(-2,2),y+lengthdir_y(sprite_width,direction)+random_range(-2,2),Smoke)motion_set(other.direction + random_range(-8,8), 1+random(3))
			with mod_script_call("mod","defpack tools","create_fire_bullet",x,y){
				motion_set(other.direction + random_range(-20,20)*other.creator.accuracy, 16)
				image_angle = direction
				creator = other.creator
				team = other.team
			}
			if other.infammo = 0 {other.ammo[1] -= 1}
		}
	}
}
wepangle = -wepangle
motion_add(gunangle,4)
