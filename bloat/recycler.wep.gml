#define init
global.sprRecycler = sprite_add_weapon("../sprites/weapons/sprRecycler.png", 2, 4);
global.mskbrush = sprite_add_weapon("../sprites/projectiles/mskToothbrush.png",20,0)
global.sprToothbrushShank = sprite_add("../sprites/projectiles/sprHexNeedleShank.png", 5, -6, 4);

#define weapon_name
return "RECYCLER"
#define weapon_type
return 0;
#define weapon_cost
return 0;
#define weapon_area
return 6;
#define weapon_load
return 23;
#define weapon_swap
return sndSwapHammer
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire
var _pitch = random_range(.8, 1.2)
sound_play_pitch(sndWrench, 1.5 * _pitch)
sound_play_pitch(sndScrewdriver, .8 * _pitch)

weapon_post(-6 - (20*skill_get(13)),9,0)
with instance_create(x+lengthdir_x(6+(20*skill_get(13)),gunangle),y+lengthdir_y(6+(20*skill_get(13)),gunangle),Shank){
	sprite_index = mskNone
	damage = 12;
	canfix = false
	if skill_get(13) mask_index = global.mskbrush else mask_index = global.sprRecycler
	creator = other
	team = other.team
	image_angle = other.gunangle
	direction = image_angle
	with instance_create(x, y, Wind){
		sprite_index = global.sprToothbrushShank;
		image_angle = other.image_angle;
		depth -= 1;
	}
}
#define step
var _active = ((wep = mod_current) || (bwep = mod_current && race = "steroids"));
if _active{
	var _r = 16,
	    _c = self,
	    _d = _r *.4;
	with instances_matching_ne(projectile, "team", other.team){
		if point_in_circle(x, y, _c.x + lengthdir_x(_d, _c.gunangle), _c.y + lengthdir_y(_d, _c.gunangle), _r){
			with _c{
				if ammo[1] < typ_amax[1]{
					ammo[1]++;
					instance_create(other.x, other.y, RecycleGland);
					sound_play(sndRecGlandProc);
					sleep(5);
					motion_add(gunangle - 180, other.force / 2)
				}
			}
			instance_destroy();
		}
	}
}

#define weapon_sprt
return global.sprRecycler
#define weapon_text
return "REUSE"
#define nts_weapon_examine
return{
	"eyes" : "By sheer force of will you turn projectiles back to ammo. "
}
