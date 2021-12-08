#define init
global.sprBouncerGunhammer 		= sprite_add_weapon("../../sprites/weapons/iris/bouncer/sprBouncerGunhammer.png", 2, 10);
global.sprBouncerGunhammerHUD = sprite_add_weapon("../../sprites/weapons/iris/bouncer/sprBouncerGunhammer.png", 8, 6);
global.sprGunhammerSlash   		= sprite_add("../../sprites/projectiles/iris/bouncer/sprGunhammerSlash.png",3,0,24)

#define weapon_name
return "BOUNCER GUNHAMMER";

#define weapon_sprt
return global.sprBouncerGunhammer;

#define weapon_sprt_hud
return global.sprBouncerGunhammerHUD;

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
return -1;

#define weapon_melee
return 1

#define weapon_text
return "FEELS LIKE BASEBALL";

#define weapon_fire

var p = random_range(.8,1.2)
sound_play_pitchvol(sndHammer,p,.7)
sound_play_pitch(sndShovel,.5*p)
sound_play_pitch(sndHitMetal,.8*p)
sound_play_pitch(sndAssassinAttack,1.2*p)
var r =  ammo[1] >= 1
weapon_post(8,32,18*(r*2+1))
var l = 20* skill_get(mut_long_arms)
with instance_create(x + lengthdir_x(l, gunangle),y + lengthdir_y(l, gunangle),Slash){
	damage = 8
	if r {
		damage = 15
		force = 15
		sprite_index = global.sprGunhammerSlash
	}
	else{
    	damage = 10
    	force = 7
		sprite_index = sprHeavySlash
	}
	motion_add(other.gunangle, 2 + (skill_get(13) * 3))
	image_angle = direction
	team = other.team
	creator = other
	if r{
        sound_play_pitch(sndBouncerShotgun,random_range(1.4,1.6))
        sound_play_pitch(sndBouncerBounce,random_range(.7,.9))
        sound_play_pitchvol(sndSawedOffShotgun,.9*p,.7)
        sound_play_pitchvol(sndDoubleShotgun,.8*p,.7)
        sound_play_pitchvol(sndTripleMachinegun,.8*p,.7)
        sound_play_gun(sndClickBack,1,.6)
		sound_stop(sndClickBack)
			var _i = 0;
    	repeat(4){
					_i++;
        	if other.ammo[1] >=1 {
    			instance_create(x+lengthdir_x(sprite_width,direction),y+lengthdir_y(sprite_width,direction),Smoke)
    			with instance_create(x,y,BouncerBullet){
    				motion_set(other.direction + random_range(-30,30)*other.creator.accuracy * (_i = 1 ? .1 : 1), 10)
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
}
wepangle = -wepangle
motion_add(gunangle,4)
