#define init
global.sprHeavyBouncerGunhammer     = sprite_add_weapon("../../sprites/weapons/iris/bouncer/sprHeavyBouncerGunhammer.png", 2, 11);
global.sprHeavyBouncerGunhammerHUD  = sprite_add_weapon("../../sprites/weapons/iris/bouncer/sprHeavyBouncerGunhammer.png", 11, 5);
global.slash 							          = sprite_add("../../sprites/projectiles/iris/bouncer/sprGunhammerSlash.png",3,0,24);

#define weapon_name
return "HEAVY BOUNCER GUNHAMMER";

#define weapon_sprt
return global.sprHeavyBouncerGunhammer;

#define weapon_sprt_hud
return global.sprHeavyBouncerGunhammerHUD;

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
return -1;

#define weapon_text
return "REBOUNCE";

#define weapon_melee
return 1

#define weapon_fire

var r = (ammo[1] >= 2)
var _p = random_range(.8,1.2)
sound_play_pitchvol(sndHammer,_p,.7)
sound_play_pitch(sndShovel,.5*_p)
sound_play_pitch(sndHitMetal,.8*_p)
sound_play_pitch(sndAssassinAttack,1.2*_p)
sleep(20)
weapon_post(8,20,12	*(r*2+1))
var shell = 0;
var l = 20* skill_get(mut_long_arms)
with instance_create(x + lengthdir_x(l, gunangle),y + lengthdir_y(l, gunangle),Slash){
	image_xscale *= 1.3
	image_yscale *= 1.3
	damage = 10
	force = 7
	motion_add(other.gunangle, 2 + (skill_get(13) * 3))
	sprite_index = sprHeavySlash
	image_angle = direction
	team = other.team
	creator = other
	if r {
	    damage = 20
		force = 15
		sound_play_pitchvol(sndSawedOffShotgun,.9*_p,.7)
		sound_play_pitchvol(sndDoubleShotgun,.8*_p,.7)
		sound_play_pitchvol(sndTripleMachinegun,.8*_p,.7)
		sound_play_gun(sndClickBack,1,.3)
		sound_stop(sndClickBack)
			var _i = 0;
    	repeat(min(other.ammo[1]/2, 4)){
			_i++;
			sprite_index = global.slash
			with mod_script_call("mod","defpack tools","create_heavy_bouncer_bullet",x,y){
				motion_set(other.direction + random_range(-15,15)*other.creator.accuracy * (_i = 1 ? .1 : 1), 10)
				image_angle = direction
				creator = other.creator
				team = other.team
			}
			if other.infammo = 0 {other.ammo[1] -= 2}
			shell += 1
		}
	}
}
if shell repeat(shell) mod_script_call("mod","defpack tools", "shell_yeah_heavy", -180, 35, random_range(3,5), c_yellow)
wepangle = -wepangle
motion_add(gunangle,5)
