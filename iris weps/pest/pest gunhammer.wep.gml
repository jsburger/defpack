#define init
global.sprPestGunhammer    = sprite_add_weapon("../../sprites/weapons/iris/pest/sprPestGunhammer.png", 2, 8);//FOD THIS SPRITE FUCKIN SUCKS REMAKE THAT MF
global.sprPestGunhammerHUD = sprite_add_weapon("../../sprites/weapons/iris/pest/sprPestGunhammer.png", 11, 8);
global.slash 							 = sprite_add("../../sprites/projectiles/iris/pest/sprPestGunhammerSlash.png",3,0,24);

#define weapon_name
return "PEST GUNHAMMER";

#define weapon_sprt
return global.sprPestGunhammer;

#define weapon_sprt_hud
return global.sprPestGunhammerHUD;

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

#define weapon_text
return "SEWAGE SLASHER";

#define weapon_melee
return 1

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

var shell = 0;
var l = 20* skill_get(mut_long_arms)
with instance_create(x + lengthdir_x(l, gunangle),y + lengthdir_y(l, gunangle),Slash){
	damage = 10
	force = 7
	motion_add(other.gunangle, 2 + (skill_get(13) * 3))
	sprite_index = sprHeavySlash
	image_angle = direction
	team = other.team
	creator = other
	if r {
	    damage = 15
		force = 15
		sound_play_pitchvol(sndSawedOffShotgun,.9*p,.7)
		sound_play_pitchvol(sndDoubleShotgun,.8*p,.7)
		sound_play_pitchvol(sndTripleMachinegun,.8*p,.7)
		sound_play_pitch(sndMinigun,random_range(1.2,1.6))
		sound_play_pitch(sndToxicBoltGas,1.3)
		sprite_index = global.slash
		var _i = 0;
		repeat(4){
			_i++;
    		if other.ammo[1] >=1 {
    			instance_create(x+lengthdir_x(sprite_width,direction),y+lengthdir_y(sprite_width,direction),Smoke)
    			with mod_script_call("mod","defpack tools","create_toxic_bullet",x,y){
    				motion_set(other.direction + random_range(-9,9)*other.creator.accuracy * (_i = 1 ? .1 : 1), 16)
    				image_angle = direction
    				creator = other.creator
    				team = other.team
    			}
    			if other.infammo = 0 {other.ammo[1] -= 1}
    			shell += 1
    		}
    	}
    }
}
if shell repeat(shell) mod_script_call("mod","defpack tools", "shell_yeah", -180, 18, random_range(3,5), c_green)
wepangle = -wepangle
motion_add(gunangle,4)
