#define init
global.sprGoldenGunhammer = sprite_add_weapon("sprites/sprGoldenGunhammer.png", 0, 8);
global.sprGunhammerSlash = sprite_add("sprites/projectiles/Gunhammer Slash.png",3,0,24)

#define weapon_gold
return 1;

#define weapon_name
return "GOLDEN GUNHAMMER";

#define weapon_sprt
return global.sprGoldenGunhammer;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 21;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapGold;

#define weapon_area
return 17;

#define weapon_text
return "ALL @yBLING";

#define weapon_melee
return 1;

#define weapon_fire

sound_play_pitch(sndShovel,random_range(1.2,1.23))
sound_play_pitch(sndGoldWrench,random_range(.97,1.03))
sound_play_pitch(sndHammer,random_range(.97,1.03))
weapon_post(8,10,4)

with instance_create(x,y,Slash){
	damage = 6
	if other.ammo[1] >=1
	{
		sprite_index = global.sprGunhammerSlash
	}else{
		sprite_index = sprHeavySlash
	}
	motion_add(other.gunangle, 2 + (skill_get(13) * 3))
	if skill_get(13) {
			x += 4 *hspeed;
			y += 4 *vspeed
		}
	image_angle = direction
	team = other.team
	creator = other
	repeat(4){
		if other.ammo[1] >=1 {
			with instance_create(x,y,Bullet1){
				sound_play_pitch(sndMachinegun,1.2)
				motion_set(other.direction + random_range(-10,10)*other.creator.accuracy, 20)
				image_angle = direction
				creator = other.creator
				team = other.team
			}
			with instance_create(x,y,Shell){
				motion_add(other.creator.gunangle+other.creator.right*100+random(50)-25,2+random(5))
			}
			if other.infammo = 0 {other.ammo[1] -= 1}
		}
	}
}
wepangle = -wepangle
motion_add(gunangle,4)
