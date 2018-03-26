#define init
global.sprGunhammer = sprite_add_weapon("Gunhammer.png", 0, 8);
global.sprGunhammerSlash = sprite_add("Gunhammer Slash.png",3,0,24)

#define weapon_name
return "GUNHAMMER";

#define weapon_sprt
return global.sprGunhammer;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 21;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return 5;

#define weapon_melee
return 1

#define weapon_text
return "BULLET BASHING";

#define weapon_fire

sound_play_pitchvol(sndHammer,random_range(.97,1.03),.7)
sound_play_pitch(sndShovel,random_range(1.2,1.23))
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
			//sound_play_pitch(sndLilHunterSniper,.3) nice energy sound
			//sound_play_pitch(sndFlakExplode,2) nice sharp swing
			//sound_play_pitch(sndFlakExplode,.6) also cool
			//sound_play_pitch(sndSuperFlakCannon,2) good shovel like swing
			//sound_play_pitch(sndDevastator,3) lazor
			sound_play_pitchvol(sndPistol,random_range(.9,1.1),1.3)
			instance_create(x+lengthdir_x(sprite_width,direction),y+lengthdir_y(sprite_width,direction),Smoke)
			with instance_create(x,y,Bullet1){
				motion_set(other.direction + random_range(-20,20)*other.creator.accuracy, 20)
				image_angle = direction
				creator = other.creator
				team = other.team
			}
			with instance_create(x,y,Shell){
				motion_add(other.creator.gunangle-180+random_range(-12,12),4+random(3))
			}
			if other.infammo = 0 {other.ammo[1] -= 1}
		}
	}
}
wepangle = -wepangle
motion_add(gunangle,4)
