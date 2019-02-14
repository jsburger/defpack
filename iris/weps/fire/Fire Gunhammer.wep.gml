#define init
global.sprFireGunhammer 		 = sprite_add_weapon("sprites/sprFireGunhammer.png", 1, 6); //SHOULD BE THE NORM, LOOKING GOOD
global.sprFireGunhammerHUD 	 = sprite_add_weapon("sprites/sprFireGunhammer.png", 12, 5);
global.sprFireGunhammerSlash = sprite_add("sprites/projectiles/sprFireGunhammerSlash.png",3,0,24)

#define weapon_name
return "FIRE GUNHAMMER";

#define weapon_sprt
return global.sprFireGunhammer;

#define weapon_sprt_hud
return global.sprFireGunhammerHUD;

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
return -1;

#define weapon_text
return "THE BURNING TORCH";

#define weapon_fire

var r = ammo[1] >= 1
var p = random_range(.8,1.2)
sound_play_pitchvol(sndHammer,p,.7)
sound_play_pitch(sndShovel,.5*p)
sound_play_pitch(sndHitMetal,.8*p)
sound_play_pitch(sndAssassinAttack,1.2*p)
sound_play_gun(sndClickBack,1,.6)
sound_stop(sndClickBack)
weapon_post(8,20,12	*(r*2+1))
var l = 20* skill_get(mut_long_arms)
with instance_create(x + lengthdir_x(l, gunangle),y + lengthdir_y(l, gunangle),Slash){
	damage = 10
	force = 7
	motion_add(other.gunangle+random_range(-8,8*other.accuracy), 2 + (skill_get(13) * 3))
	gunangle = other.gunangle
	sprite_index = sprHeavySlash
	image_angle = direction
	team = other.team
	creator = other
	right = other.right
	if r {
	    sound_play_pitchvol(sndSawedOffShotgun,.9*p,.7)
		sound_play_pitchvol(sndDoubleFireShotgun,.8*p,.7)
		sound_play_pitchvol(sndTripleMachinegun,.8*p,.7)
		sound_play_pitchvol(sndFlameCannon,3.8*p,.7)
		sprite_index = global.sprFireGunhammerSlash
		sound_play_gun(sndClickBack,1,.6)
		sound_stop(sndClickBack)
	    repeat(4){
    	    if other.ammo[1] >=1 {
    			mod_script_call("mod","defpack tools", "shell_yeah", -180, 35, random_range(3,5), c_red)
    			damage = 15
    			force = 15
    			repeat(2)with instance_create(x+lengthdir_x(sprite_width,direction)+random_range(-2,2),y+lengthdir_y(sprite_width,direction)+random_range(-2,2),Smoke)motion_set(other.direction + random_range(-8,8), 1+random(3))
    			with mod_script_call("mod","defpack tools","create_fire_bullet",x,y){
    				motion_set(other.direction + random_range(-30,30)*other.creator.accuracy, 16)
    				image_angle = direction
    				creator = other.creator
    				team = other.team
    			}
    			if other.infammo = 0 {other.ammo[1] -= 1}
    		}
    	}
	}
}
wepangle = -wepangle
motion_add(gunangle,4)
