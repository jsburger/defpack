#define init
global.sprBone = sprite_add_weapon("sprites/sprBone.png",0,2)
#define weapon_name
return "BONE"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
if !irandom(2) return 3;
else return -1;
#define weapon_load
return 10
#define weapon_swap
return sndSwapSword
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire
sound_play_pitch(sndScrewdriver,random_range(.6,.8))
sound_play_pitch(sndBloodHammer,random_range(1.6,2.2))
weapon_post(-12 - (20*skill_get(13)),6,0)
with instance_create(x+lengthdir_x(12+(20*skill_get(13)),gunangle),y+lengthdir_y(12+(20*skill_get(13)),gunangle),Shank){
	sprite_index = mskNone
	damage = 8
	mask_index = global.sprBone
	image_xscale = 1.5
	image_yscale = 1.5
	creator = other
	team = other.team
	image_angle = other.gunangle
	direction = image_angle
	canfix = false
	with instance_create(x,y,BloodStreak)
	{
		image_angle = other.image_angle
	}
	on_hit = bone_hit
}
#define weapon_sprt
return global.sprBone
#define weapon_text
return "RIPPER"
#define bone_hit
if team != other.team
{
	if projectile_canhit_melee(other) = true
	{
		sleep(5000)
		projectile_hit(other,damage,4,direction)
	}
}
