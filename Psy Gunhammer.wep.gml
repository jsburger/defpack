#define init
global.sprPsyGunhammer = sprite_add_weapon("sprites/sprPsyGunhammer.png", 2, 11);
global.slash = sprite_add("sprites/projectiles/Heavy Psy Slash.png",3,0,24);

#define weapon_name
return "PSY GUNHAMMER";

#define weapon_sprt
return global.sprPsyGunhammer;

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

if ammo[1] >=1 var r = 1 else var r = 0
var p = random_range(.8,1.2)
sound_play_pitchvol(sndHammer,p,.7)
sound_play_pitch(sndShovel,.5*p)
sound_play_pitch(sndHitMetal,.8*p)
sound_play_pitch(sndAssassinAttack,1.2*p)
weapon_post(8,20,12	*(r*2+1))
var shell = 0;
with instance_create(x,y,Slash){
	damage = 10
	force = 7
	motion_add(other.gunangle, 2 + (skill_get(13) * 3))
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
	sprite_index = sprHeavySlash
	image_angle = direction
	team = other.team
	creator = other
	repeat(4){
		if other.ammo[1] >=1 {
			damage = 20
			force = 15
			sound_play_pitch(sndAssassinPretend,random_range(.5,.55))
			sound_play_pitch(sndSwapCursed,.4)
			sound_play_pitchvol(sndSawedOffShotgun,.9*p,.7)
			sound_play_pitchvol(sndDoubleShotgun,.8*p,.7)
			sound_play_pitchvol(sndTripleMachinegun,.8*p,.7)
			sprite_index = global.slash
			with mod_script_call("mod","defpack tools","create_psy_bullet",x,y){
				motion_set(other.direction + random_range(-20,20)*other.creator.accuracy, 8)
				image_angle = direction
				maxspeed = 8
				creator = other.creator
				team = other.team
				timer -= 5
			}
			if other.infammo = 0 {other.ammo[1] -= 1}
			shell += 1
		}
	}
}
if shell repeat(shell) mod_script_call("mod","defpack tools", "shell_yeah", -180, 35, random_range(3,5), c_purple)
wepangle = -wepangle
motion_add(gunangle,5)
