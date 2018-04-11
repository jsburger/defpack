#define init
global.sprUltraGunhammer = sprite_add_weapon("sprites/sprUltraGunhammer.png", 0, 9);
global.sprUltraGunhammerOff = sprite_add_weapon("sprites/sprUltraGunhammerOff.png", 6, 5);

#define weapon_name
return "ULTRA GUNHAMMER";

#define weapon_sprt
with(GameCont)
{
	if "rad" in self && rad >= 20 {return global.sprUltraGunhammer};
	else {return global.sprUltraGunhammerOff};
}
#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 9;

#define weapon_cost
return 0;

#define weapon_melee
return 1;

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return 20;

#define weapon_text
return "UNBELIEVABLE POWER";
#define weapon_rads
return 20

#define weapon_fire
sound_play_pitch(sndHammer,random_range(.6,.7))
sound_play_pitch(sndUltraShovel,random_range(.8,.9))
weapon_post(8,8,8)
with instance_create(x,y,Slash){
	damage = 20
	sprite_index = sprUltraSlash
	motion_add(other.gunangle, 2 + (skill_get(13) * 3))
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
	image_angle = direction
	team = other.team
	creator = other
	repeat(4){
		if other.ammo[1] >=2 {
			sound_play_pitch(sndUltraPistol,1.2)
			with instance_create(x,y,UltraShell){
				motion_set(other.direction + random_range(-20,20)*other.creator.accuracy, 18)
				image_angle = direction
				creator = other.creator
				team = other.team
			}
			repeat(2)instance_create(x+lengthdir_x(sprite_width,direction)+random_range(-2,2),y+lengthdir_y(sprite_width,direction)+random_range(-2,2),Smoke)
			with instance_create(x,y,Shell){
				motion_add(other.creator.gunangle-180+random_range(-4,4),6+random(3))
			}
			if other.infammo = 0 {other.ammo[1] -= 3}
		}
	}
}
wepangle = -wepangle
motion_add(gunangle,4)
