#define init
global.sprMillimata = sprite_add_weapon("sprites/sprMillimata.png", 3, 4);

#define weapon_name
return "MILLIMATA"

#define weapon_sprt
return global.sprMillimata;

#define weapon_type
return 3;

#define weapon_auto
return false;

#define weapon_load
return 17;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 9;

#define weapon_text
return "FANCY ME A VOODOO DOLL";

#define weapon_fire
var i = 0;
repeat(6)
{
	motion_add(gunangle-180,1)//anything higher has unreasonable amount of knockback, its quite cool
	i++
	sound_play_pitch(sndSplinterPistol,random_range(.6,.8))
	sound_play_pitch(sndSplinterGun,random_range(.6,.8))
	sound_play_pitch(sndSuperSplinterGun,random_range(.6,.8))
	sound_play_pitch(sndDoubleMinigun,random_range(.7,.9))
	sound_play_pitch(sndHeavyCrossbow,random_range(.7,.9))
	weapon_post(7,21,24)
	with instance_create(x,y,Splinter)
	{
		move_contact_solid(point_direction(x,y,x+lengthdir_x(1,other.gunangle+40),y+lengthdir_y(1,other.gunangle+40)),6)
		team = other.team
		motion_add(other.gunangle+random_range(-2,2)*other.accuracy+i*other.accuracy,20)
		image_angle = direction
		creator = other
	}
	with instance_create(x,y,Splinter)
	{
		move_contact_solid(point_direction(x,y,x+lengthdir_x(1,other.gunangle-40),y+lengthdir_y(1,other.gunangle-40)),6)
		team = other.team
		motion_add(other.gunangle+random_range(-2,2)*other.accuracy-i*other.accuracy,20)
		image_angle = direction
		creator = other
	}
	wait(1)
	if !instance_exists(self) exit;
}
