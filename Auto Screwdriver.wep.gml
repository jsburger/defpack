#define init
global.sprAutoScrewdriver = sprite_add_weapon("sprites/sprAutoScrewdriver.png", -2, 2);

#define weapon_name
return "AUTO SCREWDRIVER";

#define weapon_sprt
return global.sprAutoScrewdriver;

#define weapon_type
return 0;

#define weapon_auto
return true;

#define weapon_load
if !skill_get("screwdriver mastery"){
    with instances_matching(CustomObject,"name","autoscrewtimer"){
    	if creator = other{
    		if timer <= 0{
    			return count+1
    		}
    		else{
    			return 2;
    		}
    	}
    	else{
    		return 2;
    		//sorry karm, but a 1 frame reload is just too fast
    		//frick you
    	}
    }
}
return 2
#define weapon_cost
return 0;

#define weapon_swap
return sndSwapSword;

#define weapon_area
return 13;

#define weapon_text
return choose("SWINGING THIS GETS TIRING","PAPER DRILL");

#define weapon_fire
weapon_post(-8,2,5)
sound_play_pitch(sndScrewdriver,random_range(.9,1.2))
wepangle = -wepangle
motion_add(gunangle, 4)
var l = 20 * skill_get(mut_long_arms)
with instance_create(x + lengthdir_x(l, gunangle), y + lengthdir_y(l, gunangle), Shank)
{
	damage = 4
	creator = other
	can_fix = true
	motion_add(other.gunangle, 2 + (skill_get(13) * 3))
	image_angle = direction
	team = other.team
	name = "autoslash"
	with instance_create(x,y,CustomObject)
	{
		count = 1
		timer  = 45
		timer2 = 30
		on_step = autoscrew_step
		creator = other.creator
		with instances_matching(CustomObject,"name","autoscrewtimer")
		{
			if creator = other.creator
			{
				if timer <= 0{other.count += count}
				other.timer = timer
				instance_destroy()
			}
		}
		timer -= current_time_scale
		name = "autoscrewtimer"
		with instances_matching(Shank,"name","autoslash")
		{
			if other.creator = creator
			{
				direction += random_range(-other.count,other.count)*creator.accuracy
				image_angle = direction
			}
		}
	}
}

#define autoscrew_step
if !instance_exists(creator){instance_destroy();exit}
if count > 30{count = 30}
if timer <=0{if irandom(abs(timer))!=0{repeat(ceil(abs(timer)/10)){instance_create(creator.x,creator.y,Sweat)}}}
timer2 -= current_time_scale
if timer2 <= 0
{
	timer2=0
	timer++
	if timer > 45{timer = 45}
	if count > 0{count--}
}
