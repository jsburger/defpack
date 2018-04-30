#define init
global.sprWonderSword = sprite_add_weapon("Wondrous Sword.png", 2, 5.5);
global.sprWonderSlash = sprite_add("Wonder Slash.png",3,-0,36)
global.mskGuardSlash = sprite_add("Guardslash.png",0,13.5,14)
global.sprFlarefire = sprite_add("Flarefire.png",5,10,10)

#define weapon_name
return "WONDERSWORD";

#define weapon_sprt
return global.sprWonderSword;

#define weapon_type
return 0;

#define weapon_auto
return false;

#define weapon_load
return 1;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return 999;

#define weapon_text
return "@yWonder @swhat @yis @sthis sword";

#define weapon_gold
return 1;

#define weapon_fire
//lmao

#define step(w)
if "wondershit" not in self{
	wondershit = [0,0]
	bwondershit = [0,0]
	//charge,tier
}
if w {
	if button_check(index,"fire") && wondershit[1]<4{
		wondershit[0]+= 2
		wepangle += .75*sign(wepangle)
		if (wondershit[0] >= 45){
			wondershit[0]-=45
			sound_play_pitch(sndCursedReminder,++wondershit[1])
			gunshine = 7
			with instance_create(x,y-15,CustomObject){
				sprite_index = global.sprFlarefire
				motion_add(90,2)
				friction = .2
				bimage_index = image_index
				image_speed = .4
				depth = -8
				on_step = flarefire_step
				on_draw = flarefire_draw
			}
		}
	}else if wondershit[1] >= 1{
		var tier = wondershit[1]
		var _x = x+lengthdir_x(20*skill_get(13),gunangle);
		var _y = y+lengthdir_y(20*skill_get(13),gunangle);
		var spd = 2+3*skill_get(13);
		if tier = 1{
			with instance_create(_x,_y,Slash){
				damage = 10
				sprite_index = global.sprWonderSlash
				motion_add(other.gunangle,spd)
				image_angle = direction
				team = other.team
				mask_index = -1
				creator = other
			}
		}
		else if tier = 2{
			with instance_create(_x,_y,Slash){
				damage = 14
				sprite_index = global.sprWonderSlash
				motion_add(other.gunangle,spd)
				image_angle = direction
				team = other.team
				mask_index = -1
				creator = other
				if fork(){
					wait(3)
					sound_play(sndExplosionS)
					instance_create(x+lengthdir_x(60,direction-20),y+lengthdir_y(60,direction-20),SmallExplosion)
					wait(1)
					sound_play(sndExplosionS)
					instance_create(x+lengthdir_x(65,direction),y+lengthdir_y(65,direction),Explosion)
					wait(1)
					sound_play(sndExplosionS)
					instance_create(x+lengthdir_x(60,direction+20),y+lengthdir_y(60,direction+20),SmallExplosion)
					exit
				}
			}
		}
		else if tier = 3{
			with instance_create(_x,_y,Slash){
				damage = 18
				sprite_index = global.sprWonderSlash
				motion_add(other.gunangle,spd)
				image_angle = direction
				team = other.team
				mask_index = -1
				creator = other
				flip = -sign(other.wepangle)
				if fork(){
					wait(3)
					var lb = 30;
					for (var i = 0; i<= 3; i++){
						sound_play(sndExplosionS)
						instance_create(x+lengthdir_x(60+lb*i,direction-20),y+lengthdir_y(60+lb*i,direction-20),SmallExplosion)
						instance_create(x+lengthdir_x(65+lb*i,direction),y+lengthdir_y(65+lb*i,direction),Explosion)
						instance_create(x+lengthdir_x(60+lb*i,direction+20),y+lengthdir_y(60+lb*i,direction+20),SmallExplosion)
						wait(1)
					}
					exit
				}
			}
		}
		else if tier = 4{

		}
		wondershit = [0,0]
		wepangle = -90 * sign(wepangle)
		sound_play_gun(sndBlackSword,.2,0)
		wkick = 9
		motion_add(gunangle,4)
	}else{
		wondershit = [0,0]
		wepangle = 90 * sign(wepangle)
	}
}

//fuck steroids
if race = "steroids" && !w{
	if button_check(index,"spec"){
		bwondershit[0]++
		bwepangle += .5*sign(bwepangle)
		if !(floor(bwondershit[0]) mod 45){
			sound_play_pitch(sndCursedReminder,++bwondershit[1])
			gunshine = 7
			with instance_create(x,y-10,CustomObject){
				sprite_index = global.sprFlarefire
				motion_add(90,1)
				friction = .2
				bimage_index = image_index
				image_speed = .4
				depth = -8
				on_step = flarefire_step
				on_draw = flarefire_draw
			}
		}
	}else if bwondershit[0] > 20{
		var tier = bwondershit[1]
		if tier = 0{
			with instance_create(x,y,Slash){
				sprite_index = global.sprWonderSlash
				team = other.team
				creator = other.creator
			}
		}
		else if tier = 1{

		}
		else if tier = 2{

		}
		else if tier = 3{

		}
		bwepangle = -90 * sign(bwepangle)
		sound_play_gun(sndBlackSword,.2,0)
		bwkick = 9
		motion_add(gunangle,4)
	}
}

#define wondercharge_step
if !instance_exists(creator){instance_delete(self);exit}
if button_check(creator.index,"fire") {
	x = creator.x
	y = creator.y
	creator.reload = weapon_get_load(creator.wep)
	if tier < 3{
		creator.wepangle += .5*sign(creator.wepangle)
		charge += 1
		if !(floor(charge) mod 45){
			sound_play_pitch(sndCursedReminder,++tier)
			creator.gunshine = 7
			with instance_create(x,y-10,CustomObject){
				sprite_index = global.sprFlarefire
				motion_add(90,1)
				friction = .2
				bimage_index = image_index
				image_speed = .4
				depth = -8
				on_step = flarefire_step
				on_draw = flarefire_draw
			}
		}
	}
}
else
{
	creator.wepangle = -90 * sign(creator.wepangle)
	sound_play_gun(sndBlackSword,.2,0)
	wkick = 9
	with creator{motion_add(gunangle,4)}
	if tier = 0{
		with instance_create(x,y,Slash){
			sprite_index = global.sprWonderSlash
			team = other.team
			creator = other.creator
		}
	}
	else if tier = 1{

	}
	else if tier = 2{

	}
	else if tier = 3{

	}
	instance_destroy()
}


#define flarefire_step
if image_index < bimage_index{instance_destroy();exit}
bimage_index = image_index

#define flarefire_draw
draw_sprite_ext(sprite_index, image_index, x, y, .8*image_xscale, .8*image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 1.5*image_xscale, 1.5*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);
/*
sound_play(sndScrewdriver)
wkick = 9
wepangle = -wepangle
motion_add(gunangle, 4)
with instance_create(x+lengthdir_x(12,gunangle),y+lengthdir_y(12,direction),CustomProjectile)
{
	damage = 50
	force = 30
	name = "Sweetspot"
	parent = noone
	creator = other
	sprite_index = global.mskGuardSlash
	mask_index = global.mskGuardSlash
	image_alpha = 0
	depth -= 1
	direction = other.gunangle
	image_angle = direction
	team = other.team
	on_step = sweetspot_step
	on_wall = actually_nothing
	on_hit = sweetspot_hit
	on_draw = sweetspot_draw
}
wait(1)
with instance_create(x+lengthdir_x(6,gunangle),y+lengthdir_y(6,gunangle),Slash)
{
	with CustomProjectile
	{
		if ("name" in self && name = "Sweetspot")
		if parent = noone{parent = other}
	}
	damage = 30
	image_xscale = .88
	image_yscale = .88
	creator = other
	sprite_index = global.sprWonderSlash
	mask_index = mskMegaSlash
	motion_add(other.gunangle, 6 + (skill_get(13) * 3))
	image_angle = direction
	team = other.team
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
}

#define sweetspot_step
if instance_exists(parent)
{
	if  parent != noone
	{
		x = parent.x+lengthdir_x(12,direction)
		y = parent.y+lengthdir_y(12,direction)
		direction = parent.direction
		iamge_angle = direction
	}
}
else{instance_destroy();exit}
speed = 0

#define sweetspot_hit
if other.sprite_index != other.spr_hurt{projectile_hit(other, damage, force, direction)};
//instance_create(other.x,other.y,SmallExplosion)
repeat(5)with instance_create(x+random_range(-14,14),y+random_range(-14,14),FireFly){image_blend = c_red}

#define sweetspot_draw
draw_self()
draw_sprite_ext(global.sprWonderSlash,image_index,x,y,1,1,image_angle,c_white,1)
#define actually_nothing
