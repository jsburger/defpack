#define init
global.sprMillimata = sprite_add_weapon("sprites/weapons/sprMillimata.png", 3, 4);

#define weapon_name
return "MILLIMATA"

#define weapon_sprt
return global.sprMillimata;

#define weapon_type
return 3;

#define weapon_auto
return false;

#define weapon_load
return 19;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 10;

#define weapon_text
return "WHO NEEDS VOODOO";

#define nts_weapon_examine
return{
    "d": "An oversized splinter gun. #Reserved for only the most dangerous of prey. ",
}


#define weapon_fire
	mod_script_call("mod", "defburst", "burst", 7, 1, self, script_ref_create(fire_burst))

#define fire_burst(burst)
	
	motion_add(gunangle-180,1)//anything higher has unreasonable amount of knockback, its quite cool
	var p = random_range(.8,1.2),
		vol = .5;
	sound_play_pitchvol(sndSplinterPistol, .7*p, vol)
	sound_play_pitchvol(sndSeekerPistol,  .75*p, vol)
	sound_play_pitchvol(sndSplinterGun,    .7*p, vol)
	sound_play_pitchvol(sndHeavyCrossbow,  .5*p, vol)
	sound_play_pitchvol(sndDoubleMinigun,  .8*p, vol)
	weapon_post(7,6,8)
	var n = (burst.shots_fired + 1) * 1.5;
	with instance_create(x, y, Splinter)
	{
		move_contact_solid(point_direction(x,y,x+lengthdir_x(1,other.gunangle+40),y+lengthdir_y(1,other.gunangle+40)),6)
		team = other.team
		motion_add(other.gunangle + (random_range(-2, 2) + n) * other.accuracy,20)
		image_angle = direction
		creator = other
	}
	with instance_create(x,y,Splinter)
	{
		move_contact_solid(point_direction(x,y,x+lengthdir_x(1,other.gunangle-40),y+lengthdir_y(1,other.gunangle-40)),6)
		team = other.team
		motion_add(other.gunangle + (random_range(-2, 2) - n ) * other.accuracy, 20)
		image_angle = direction
		creator = other
	}
