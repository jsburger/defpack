#define init
global.sword = sprite_add_weapon("rapier.png",0,4)
global.slash = sprite_add("rapierslash.png",3,3,28)
global.mask = sprite_add("rapiermask.png",3,3,28)
#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define weapon_name
return "RAPIER"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return 7
#define weapon_load
return 10
#define weapon_swap
return sndSwapSword
#define weapon_auto
return 1
#define weapon_melee
return 1
#define weapon_laser_sight
return 0
#define weapon_reloaded
if wep = mod_current wepangle = 120 * sign(wepangle)
if bwep = mod_current bwepangle = 120 * sign(bwepangle)
sound_play(sndMeleeFlip)
#define weapon_fire
if "rapiers" not in self {rapiers = 1}
rapiers = ++rapiers mod 3
sound_play_pitch(sndBlackSword,random_range(1.4,1.7))
motion_add(gunangle,5+speed)
if rapiers != 1
{
	sound_play_pitch(sndEnemySlash,random_range(.8,1.2))
	wepangle = 20*wepflip
	weapon_post(-5 - 10*skill_get(13),32,0)
	with instance_create(x+lengthdir_x(5+20*skill_get(13),gunangle),y+lengthdir_y(5+20*skill_get(13),gunangle),Slash)
	{
		canfix = false
		damage = 6
		team = other.team
		creator = other
		motion_add(other.gunangle,2)
		image_angle = direction -other.wepangle
		sprite_index = global.slash
		image_yscale = other.wepflip
		mask_index = global.mask
	}
}
else
{
	sound_play_pitch(sndBlackSwordMega,random_range(1.4,1.7))
	extraspeed = 12+4*skill_get(13)
	wepangle = .1*wepflip
	weapon_post(-10 - 10*skill_get(13),15,2)
	move_contact_solid(gunangle,6)
	with instance_create(x+lengthdir_x(extraspeed+20*skill_get(13),gunangle),y+lengthdir_y(extraspeed+20*skill_get(13),gunangle),Shank)
	{
		canfix = false
		damage = 25
		team = other.team
		creator = other
		motion_add(other.gunangle,5)
		image_angle = direction
	}
}
if rapiers != 2
{
	reload+=6
}
wepangle*=-1
#define weapon_sprt
return global.sword
#define weapon_text
return choose("@bhon @whon @rhon","make some new friends")

#define step
if "extraspeed" in self && current_frame_active
{
	if extraspeed > 0
	{
	    nexthurt = current_frame + 2
		if irandom(2) != 0{instance_create(x,y,Dust)}
		canaim = false
		with instance_create(x+lengthdir_x(extraspeed+20*skill_get(13),gunangle),y+lengthdir_y(extraspeed+20*skill_get(13),gunangle),Shank){
			canfix = false
			sprite_index = mskNone
			damage = 30
			mask_index = global.sword
			image_xscale = 2
			image_yscale = 2
			creator = other
			team = other.team
			image_angle = other.gunangle
		}
		motion_add(gunangle,extraspeed)
		extraspeed--
	}
	else{extraspeed = 0;canaim = true}
}
if "rapiers" in self{if button_pressed(index,"swap") && canswap{rapiers = 1}}
