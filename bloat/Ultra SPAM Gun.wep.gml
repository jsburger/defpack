#define init
global.sprUltraSpamGun 		= sprite_add_weapon("../sprites/weapons/sprUltraSpamGun.png", 0, 2);
global.sprUltraSpamGunOff = sprite_add_weapon("../sprites/weapons/sprUltraSpamGunOff.png", 0, 2);
#define weapon_name
return "ULTRA SPAM GUN";

#define weapon_sprt
with(GameCont)
{
	if "rad" in self && rad >= 1 {return global.sprUltraSpamGun};
	else {return global.sprUltraSpamGunOff};
}

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 1;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return 24;

#define weapon_text
return choose("NOBODY IS HAPPY WITH THIS","@gULTRA @sSTALE");
#define weapon_rads
return 1

#define weapon_fire
var _p = random_range(.6, 1.3)
sound_play_pitch(sndSwapExplosive, 1.7 * _p)
sound_play_pitch(sndFrogExplode,.7 * _p)
sound_play_pitch(sndFlyFire,.7 * _p)
sound_play_pitch(sndUltraLaser,1.5 * _p)
weapon_post(random_range(-2, 2),0,12)
repeat(2){
	with instance_create(x,y,GuardianBullet){
		motion_add(other.gunangle+random_range(-180,180)*other.accuracy,2)
		creator = other
		damage *= 3
		image_angle = direction
		image_speed = .6
		team = other.team
	}
}
