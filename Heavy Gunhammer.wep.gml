#define init
global.sprHeavyGunhammer 	  = sprite_add_weapon("sprites/sprHeavyGunhammer.png", 1, 11);
global.sprHeavyGunhammerHUD = sprite_add_weapon("sprites/sprHeavyGunhammer.png", 16, 5);
global.sprGunhammerSlash 		= sprite_add("sprites/projectiles/Gunhammer Slash.png",3,0,24)

weapon_is_melee(1)
#define weapon_name
return "HEAVY GUNHAMMER";

#define weapon_sprt
return global.sprHeavyGunhammer;

#define weapon_sprt_hud
return global.sprHeavyGunhammerHUD;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 28;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return 13;

#define weapon_melee
return 1;

#define weapon_iris
return "heavy x gunhammer"

#define weapon_text
return "ADVANCED HAMMERING";

#define weapon_fire
var p = random_range(.8,1.2)
sound_play_pitchvol(sndHammer,p,.7)
sound_play_pitch(sndShovel,.5*p)
sound_play_pitch(sndHitMetal,.8*p)
sound_play_pitch(sndAssassinAttack,1.2*p)
sleep(20)
var r = ammo[1] >= 2
weapon_post(9,35,20*(r*2+1))
var l = 20* skill_get(mut_long_arms)
with instance_create(x + lengthdir_x(l, gunangle),y + lengthdir_y(l, gunangle),Slash){
	damage = 15
	force = 12
	image_xscale *= 1.3
	image_yscale *= 1.3
	motion_add(other.gunangle, 2 + (skill_get(13) * 3))
	if r{
		sprite_index = global.sprGunhammerSlash
		damage = 22
		force = 20
	}
	else{
		sprite_index = sprHeavySlash
	}
	image_angle = direction
	team = other.team
	creator = other
	if r{
	    sound_play_pitchvol(sndSawedOffShotgun,.7*p,.7)
		sound_play_pitchvol(sndDoubleShotgun,.6*p,.7)
		sound_play_pitchvol(sndQuadMachinegun,.7*p,.7)
		sound_play_pitchvol(sndFlakExplode,.5*p,.4)
		sound_play_pitch(sndHeavyRevoler,random_range(0.8,1.2))
		sound_play_gun(sndClickBack,1,.3)
		sound_stop(sndClickBack)
    	repeat(4){
    	    if other.ammo[1] >= 2 {
    			instance_create(x+lengthdir_x(sprite_width,direction),y+lengthdir_y(sprite_width,direction),Smoke)
    			with instance_create(x,y,HeavyBullet){
    				motion_set(other.direction + random_range(-20,20)*other.creator.accuracy, 16)
    				image_angle = direction
    				creator = other.creator
    				team = other.team
    			}
    			with instance_create(x,y,Smoke){
    				motion_set(other.direction + random_range(-35,35), 2+random(5))
    			}
    			with instance_create(x,y,Shell){
    				motion_add(other.creator.gunangle-180+random_range(-20,20),4+random(3))
    				sprite_index = sprHeavyShell
    			}
    			if other.infammo = 0 {other.ammo[1] -= 2}
    		}
    	}
	}
}
wepangle = -wepangle
motion_set(gunangle,4)
