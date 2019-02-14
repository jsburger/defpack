#define init
global.sprPsyGunhammer 		 = sprite_add_weapon("sprites/sprPsyGunhammer.png", 2, 11);
global.sprPsyGunhammerHUD  = sprite_add_weapon("sprites/sprPsyGunhammer.png", 11, 5);
global.slash 							 = sprite_add("sprites/projectiles/sprPsyGunhammerSlash.png",3,0,24);

#define weapon_name
return "PSY GUNHAMMER";

#define weapon_sprt
return global.sprPsyGunhammer;

#define weapon_sprt_hud
return global.sprPsyGunhammerHUD;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 32;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return -1;

#define weapon_text
return "I BANISH THEE";

#define weapon_melee
return 1

#define weapon_fire

var r = ammo[1] >= 1
var p = random_range(.8,1.2)
sound_play_pitchvol(sndHammer,p,.7)
sound_play_pitch(sndShovel,.5*p)
sound_play_pitch(sndHitMetal,.8*p)
sound_play_pitch(sndAssassinAttack,1.2*p)
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
	if r{
   		damage = 15
		force = 15
		sound_play_pitch(sndAssassinPretend,random_range(.5,.55))
		sound_play_pitch(sndSwapCursed,.4)
		sound_play_pitchvol(sndSawedOffShotgun,.9*p,.7)
		sound_play_pitchvol(sndDoubleShotgun,.8*p,.7)
		sound_play_pitchvol(sndTripleMachinegun,.8*p,.7)
		sprite_index = global.slash
		sound_play_gun(sndClickBack,1,.6)
    	sound_stop(sndClickBack)
        repeat(4){
        	if other.ammo[1] >=1 {
        		with mod_script_call("mod","defpack tools","create_psy_bullet",x,y){
        			motion_set(other.direction + random_range(-20,20)*other.creator.accuracy, 8)
        			image_angle = direction
        			creator = other.creator
        			team = other.team
        			timer -= 5
        		}
        		if other.infammo = 0 {other.ammo[1] -= 1}
        		shell += 1
        	}
        }
	}
}
if shell repeat(shell) mod_script_call("mod","defpack tools", "shell_yeah", -180, 35, random_range(3,5), c_purple)
wepangle = -wepangle
motion_add(gunangle,5)
