#define init
global.sprGunhammer 	 = sprite_add_weapon("sprites/weapons/sprGunhammer.png", 0, 8);
global.sprGunhammerHUD 	 = sprite_add_weapon("sprites/weapons/sprGunhammer.png", 11, 5);
global.sprGunhammerSlash = sprite_add("sprites/projectiles/sprGunhammerSlash.png",3,0,24)

#define weapon_name
return "GUNHAMMER";

#define weapon_sprt
return global.sprGunhammer;

#define weapon_sprt_hud
return global.sprGunhammerHUD;

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
return 7;

#define weapon_melee
return 1

#define weapon_iris
return "x gunhammer"

#define weapon_text
return "BULLET BASHING";

#define nts_weapon_examine
return{
    "d": "A melee weapon that fires bullets. #Works without bullets too, just not as well. ",
}
#define weapon_fire

var p = random_range(.8,1.2)
sound_play_pitchvol(sndHammer,p,.7)
sound_play_pitch(sndShovel,.5*p)
sound_play_pitch(sndHitMetal,.8*p)
sound_play_pitch(sndAssassinAttack,1.2*p)
if ammo[1] >=1 var r = 1 else var r = 0
weapon_post(8,25,15*(r*2+1))
var l = 20* skill_get(mut_long_arms)
with instance_create(x + lengthdir_x(l, gunangle),y + lengthdir_y(l, gunangle),Slash){
	if r = true
	{
		sprite_index = global.sprGunhammerSlash
		damage = 15
		force = 15
	}else{
		sprite_index = sprHeavySlash
		damage = 10
		force = 7
	}
	motion_add(other.gunangle, 2 + (skill_get(13) * 3))
	image_angle = direction
	team = other.team
	creator = other
	if other.ammo[1] >=1 {
	repeat(4){
			//sound_play_pitch(sndLilHunterSniper,.3) nice energy sound
			//sound_play_pitch(sndFlakExplode,2) nice sharp swing
			//sound_play_pitch(sndFlakExplode,.6) also cool
			//sound_play_pitch(sndSuperFlakCannon,2) good shovel like swing
			//sound_play_pitch(sndDevastator,3) lazor
			sound_play_pitchvol(sndSawedOffShotgun,.9*p,.7)
			sound_play_pitchvol(sndDoubleShotgun,.8*p,.7)
			sound_play_pitchvol(sndTripleMachinegun,.8*p,.7)
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
		sound_play_gun(sndClickBack,1,.6)
		sound_stop(sndClickBack)
	}
}
wepangle = -wepangle
motion_add(gunangle,4)
