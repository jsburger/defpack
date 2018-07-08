#define init
global.sprChainsaw = sprite_add_weapon("sprites/sprChainsaw.png",0,3)
#define weapon_name
return "CHAINSAW"
#define weapon_type
return 4
#define weapon_cost
return 1
#define weapon_area
if !irandom(1) return 1;
else return -1;
#define weapon_load
return 8
#define weapon_swap
return sndSwapMotorized
#define weapon_auto
return true;
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire
with instance_create(x,y,CustomObject)
{
	creator = other
	team    = other.team
	name    = "chainsaw burst"
	ammo    = 8
	timer   = current_time_scale
	on_step = chainsaw_step
}

#define chainsaw_step
if !instance_exists(creator){instance_destroy();exit}
//if timer > 0{timer -= current_time_scale}else
//{
	//timer = current_time_scale
	if ammo > 0
	{
		ammo--
		with instance_create(creator.x+lengthdir_x(6+(6*skill_get(13)),creator.gunangle),creator.y+lengthdir_y(6+(6*skill_get(13)),creator.gunangle),CustomProjectile)
		{
			with other.creator
			{
				sound_play_pitch(sndJackHammer,random_range(1.6,1.8))
				weapon_post(-6 - (6*skill_get(13)),6,0)
			}
			instance_create(x+lengthdir_x(6+(6*skill_get(13)),other.creator.gunangle),y+lengthdir_y(6+(6*skill_get(13)),other.creator.gunangle),Smoke)
			sprite_index = mskNone
			canfix = false
			force = 0
			damage = 1
			mask_index = global.sprChainsaw
			creator = other
			team = other.team
			image_angle = other.creator.gunangle
			with instances_matching_ne(projectile,"team",other.team)
			{
				if place_meeting(x,y,other){instance_destroy()}
			}
			on_hit        = chainsawshank_hit
			on_step       = chainsawshank_step
			on_anim       = anim_destroy
		}
		if ammo <= 0{instance_destroy();exit}
	}
//}

#define chainsawshank_hit
if projectile_canhit(other) = true
{
	instance_create((other.x+x)/2,(other.y+y)/2,AllyDamage)
	projectile_hit(other,damage,force,direction)
}
#define weapon_sprt
return global.sprChainsaw
#define weapon_text
return "SLAY"
#define anim_destroy
instance_destroy()
#define chainsawshank_step
