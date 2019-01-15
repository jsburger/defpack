#define init
global.sprUltraGunhammer = sprite_add_weapon("sprites/sprUltraGunhammer.png", 0, 9);
global.sprUltraGunhammerOff = sprite_add_weapon("sprites/sprUltraGunhammerOff.png",0, 9);

#define weapon_name
return "ULTRA GUNHAMMER";

#define weapon_sprt
with(GameCont)
{
	if "rad" in self && rad >= 24 {return global.sprUltraGunhammer};
}
return global.sprUltraGunhammerOff
#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 16;

#define weapon_cost
return 0;

#define weapon_melee
return 1;

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return 24;

#define weapon_text
return "UNBELIEVABLE POWER";
#define weapon_rads
return 24

#define weapon_fire
var p = random_range(.8,1.2)
sound_play_pitchvol(sndHammer,p,.7)
sound_play_pitch(sndShovel,.5*p)
sound_play_pitch(sndHitMetal,.8*p)
sound_play_pitch(sndAssassinAttack,1.2*p)
sound_play_pitch(sndUltraShovel,random_range(.8,.9))
if ammo[1] >=3 var r = 1 else var r = 0
weapon_post(8,35,22*(r*2+1))

with instance_create(x,y,Slash){
	damage = 15
	force = 12
	sprite_index = sprUltraSlash
	motion_add(other.gunangle, 2 + (skill_get(13) * 3))
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
	image_angle = direction
	team = other.team
	creator = other
	repeat(4){
		if other.ammo[1] >=3 {
			damage = 22
			force = 20
			sound_play_pitchvol(sndUltraPistol,1.,.7)
			sound_play_pitchvol(sndSawedOffShotgun,.9*p,.7)
			sound_play_pitchvol(sndDoubleShotgun,.8*p,.7)
			sound_play_pitchvol(sndTripleMachinegun,.8*p,.7)
			with instance_create(x,y,UltraShell){
				motion_set(other.direction + random_range(-20,20)*other.creator.accuracy, 18)
				image_angle = direction
				creator = other.creator
				team = other.team
			}
			repeat(2)instance_create(x+lengthdir_x(sprite_width,direction)+random_range(-2,2),y+lengthdir_y(sprite_width,direction)+random_range(-2,2),Smoke)
			with instance_create(x,y,Shell){
				motion_add(other.creator.gunangle-180+random_range(-4,4),6+random(3))
			}
			if other.infammo = 0 {other.ammo[1] -= 3}
		}
	}
}
wepangle = -wepangle
motion_add(gunangle,4)
