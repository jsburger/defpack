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
	damage = 14
	creator = other
	motion_add(other.gunangle, 2 + (skill_get(13) * 3))
	image_angle = direction
	team = other.team
	image_xscale *= 1.2
	image_yscale *= 1.3
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
	var swang = sign(other.wepangle);
	if fork(){
		var dist = 40
		wait(3)
		with instance_create(x+lengthdir_x(dist,direction),y+lengthdir_y(dist,direction),GreenExplosion){hitid = [sprite_index,"Green Explosion"]}
		sound_play(sndExplosion)
		var _o = -30 *swang
		wait(1)
		dist -= 7
		repeat(2){
			with instance_create(x+lengthdir_x(dist,direction+ _o),y+lengthdir_y(dist,direction +_o),GreenExplosion){
				sprite_index = global.sprSmallGreenExplosion
				mask_index = mskSmallExplosion
				hitid = [sprite_index,"Small Green
				Explosion"]
			}
			_o *= -1
		}
		sound_play(sndExplosionS)
		dist += 5
		_o = -50 * swang
		wait(1)
		repeat(2){
			with instance_create(x+lengthdir_x(dist,direction+ _o),y+lengthdir_y(dist,direction +_o),GreenExplosion){
				image_xscale /= 1.5
				image_yscale /= 1.5
				sprite_index = global.sprSmallGreenExplosion
				mask_index = mskSmallExplosion
				hitid = [sprite_index,"Small Green
				Explosion"]
			}
			_o *= -1
		}
		sound_play(sndExplosionS)
		exit
	}
}
wepangle = -wepangle
motion_add(gunangle,5)
sound_play(sndExplosion)
