#define init
global.sprHeavyFireGunhammer 		  = sprite_add_weapon("../../sprites/weapons/iris/fire/sprHeavyFireGunhammer.png", 1, 6); //SHOULD BE THE NORM, LOOKING GOOD
global.sprHeavyFireGunhammerHUD 	= sprite_add_weapon("../../sprites/weapons/iris/fire/sprHeavyFireGunhammer.png", 12, 5);
global.sprHeavyFireGunhammerSlash = sprite_add("../../sprites/projectiles/iris/fire/sprFireGunhammerSlash.png",3,0,24)

#define weapon_name
return "HEAVY FIRE GUNHAMMER";

#define weapon_sprt
return global.sprHeavyFireGunhammer;

#define weapon_sprt_hud
return global.sprHeavyFireGunhammerHUD;

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
return "TAKE YOUR TORCH AND BURN IT";

#define weapon_fire

var r =  ammo[1] >= 2
var p = random_range(.8,1.2),
	vol = .6;
sound_play_pitchvol(sndHammer, p, .7 * vol)
sound_play_pitchvol(sndShovel, .5 * p, vol)
sound_play_pitchvol(sndHitMetal, .8 * p, vol)
sound_play_pitchvol(sndAssassinAttack, 1.2 * p, vol)
sleep(20)
weapon_post(8,20,12	*(r*2+1))
var l = 20* skill_get(mut_long_arms)
with instance_create(x + lengthdir_x(l, gunangle),y + lengthdir_y(l, gunangle),Slash){
	damage = 15
	force = 7
	motion_add(other.gunangle+random_range(-8,8*other.accuracy), 2 + (skill_get(13) * 3))
	gunangle = other.gunangle
	sprite_index = sprHeavySlash
	image_angle = direction
	team = other.team
	creator = other
	right = other.right
	if r {
		damage = 22
		force = 15
		image_xscale *= 1.3
		image_yscale *= 1.3
		sound_play_pitchvol(sndSawedOffShotgun, .7 * p, .7 * vol)
		sound_play_pitchvol(sndDoubleShotgun, .6 * p, .7 * vol)
		sound_play_pitchvol(sndQuadMachinegun, .7 * p, .7 * vol)
		sound_play_pitchvol(sndFlakExplode, .5 * p, .4 * vol)
		sound_play_pitchvol(sndFlameCannon, 3.5 * p, .4 * vol)
		sound_play_pitchvol(sndIncinerator, .7 * p, 1 * vol)
		sound_play_pitchvol(sndFlameCannonEnd, 3.5 * p, .4 * vol)
		sound_play_pitchvol(sndHeavyRevoler, random_range(0.8, 1.2), vol)
		sound_play_gun(sndClickBack, 1, .3)
		sound_stop(sndClickBack)
		sprite_index = global.sprHeavyFireGunhammerSlash
		var _i = 0;
	    repeat(4){
					_i++;
            if other.ammo[1] >=2 {
        		mod_script_call("mod","defpack tools", "shell_yeah_heavy", -180, 35, random_range(3,5), c_red)
        		repeat(2)with instance_create(x+lengthdir_x(sprite_width,direction)+random_range(-2,2),y+lengthdir_y(sprite_width,direction)+random_range(-2,2),Smoke)motion_set(other.direction + random_range(-8,8), 1+random(3))
        		with mod_script_call("mod","defpack tools","create_heavy_fire_bullet",x,y){
        			motion_set(other.direction + random_range(-30,30)*other.creator.accuracy * (_i = 1 ? .3 : 1), 20)
        			image_angle = direction
        			creator = other.creator
        			team = other.team
        		}
        		if other.infammo = 0 {other.ammo[1] -= 2}
        	}
	    }
	}
}
wepangle = -wepangle
motion_add(gunangle,4)
