#define init
global.sprUltraSpamGun = sprite_add_weapon("sprites/Ultra SPAM Gun.png", 0, 0);
global.sprUltraSpamGunOff = sprite_add_weapon("sprites/Ultra SPAM Gun Off.png", 0, 0);
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
return 20;

#define weapon_text
return choose("NOBODY IS HAPPY WITH THIS","@gULTRA @sSTALE");
#define weapon_rads
return 1

#define weapon_fire
sound_play(sndPistol)
weapon_post(0,0,6)
repeat(2){
	with instance_create(x,y,GuardianBullet){
		motion_add(random(359),2)
		creator = other
		damage *= 3
		image_angle = direction
		image_speed = .6
		team = other.team
	}
}
