#define init
global.sprHeavyClaymore = sprite_add_weapon("sprites/Heavy Claymore.png", 4, 4);
global.sprSmallGreenExplosion = sprite_add("sprites/projectiles/Small Green Explosion_strip7.png",7,12,12)

#define weapon_name
return "HEAVY CLAYMORE";

#define weapon_sprt
return global.sprHeavyClaymore;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 20;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return 11;

#define weapon_melee
return 1

#define weapon_text
return "BALLS TO THE WALL";

#define weapon_fire

sound_play(sndBlackSword)
weapon_post(8,7,12)

with instance_create(x,y,Slash)
{
	damage = 10
	creator = other
	motion_add(other.gunangle, 2 + (skill_get(13) * 3))
	image_angle = direction
	team = other.team
	image_xscale *= 1.4
	image_yscale *= 1.4
	killdistance = -random_range(-5.5,-4.1)
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
	with instance_create(x+lengthdir_x(56-killdistance,direction),y+lengthdir_y(56-killdistance,direction),GreenExplosion){hitid = [sprite_index,"Green Explosion"]}
	var _o = -30
	repeat(2){
		with instance_create(x+lengthdir_x(57,direction+ _o),y+lengthdir_y(57,direction +_o),GreenExplosion){
			sprite_index = global.sprSmallGreenExplosion
			hitid = [sprite_index,"Small Green
			Explosion"]
		}
		_o *= -1
	}
	_o = -50
	repeat(2){
		with instance_create(x+lengthdir_x(45,direction+ _o),y+lengthdir_y(45,direction +_o),GreenExplosion){
			image_xscale /= 1.5
			image_yscale /= 1.5
			sprite_index = global.sprSmallGreenExplosion
			hitid = [sprite_index,"Small Green
			Explosion"]
		}
		_o *= -1
	}
}
wepangle = -wepangle
motion_add(gunangle,5)
sound_play(sndExplosion)
