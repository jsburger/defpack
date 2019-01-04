#define init
global.spyBullet = sprite_add("sprites/projectiles/Spy Bullet.png",2,8,8)
global.spyArm = sprite_add("sprites/projectiles/spy arm.png",1,0,3)
global.spyHand = sprite_add("sprites/projectiles/spy hand.png",1,0,4)
global.gun = sprite_add_weapon("sprites/spy revolver.png",2,2)
global.hit = sprite_add("sprites/projectiles/spy bullet hit.png",4,8,8)
global.crit = sprite_add("sprites/sprCritIndicator.png",0,11,14)

#define weapon_name
return "SPY REVOLVER";

#define weapon_type
return 1;

#define weapon_cost
return 4;

#define weapon_area
//50% reduced chance to spawn, i think
if !irandom(1) return 11;
else return -1;

#define weapon_load
return round(.58 * room_speed * current_time_scale) //this however is the revolver RoF
//return 24; //.8s which is the swing period of the TF2 spy knife

#define weapon_swap
return sndSwapPistol

#define weapon_auto
return 0;

#define weapon_fire
weapon_post(4,-3,45)
var _p = random_range(.8,1.2);
sound_play_pitchvol(sndSlugger,.8*_p,.8);
sound_play_pitchvol(sndPistol,.7*_p,.8);
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_yellow)
with instance_create(x + lengthdir_x(6,gunangle),y + lengthdir_y(6,gunangle),CustomProjectile){
	motion_set(other.gunangle,3)
	mask_index = mskBullet1
	on_step = spy_step
	on_anim = spy_anim
	on_draw = spy_draw
	on_destroy = spy_die
	sprite_index = global.spyBullet
	team = other.team
	creator = other
	image_angle = direction
	target = -4
	ogdirection = direction
	handscale = 0
	image_speed = -1
	canstab = 1
	stabsremaining = 3
}

#define weapon_sprt
return global.gun

#define weapon_text
return choose("oops i meant psy","damn typos","psy among us");

#define spy_anim
image_speed = 0

#define spy_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 1.75*image_xscale, 1.75*image_yscale, image_angle, image_blend, image_alpha * .2);
draw_set_blend_mode(bm_normal);
if instance_exists(target) && handscale > 0{
	draw_sprite_ext(global.spyArm, 0, x, y, handscale, 1, point_direction(x,y,targx,targy), image_blend, 1.0);
	draw_sprite_ext(global.spyHand, 0, x + lengthdir_x(handscale,point_direction(x,y,targx,targy)), y + lengthdir_y(handscale,point_direction(x,y,targx,targy)), 1, 1, point_direction(x,y,targx,targy), image_blend, 1.0);
	draw_set_blend_mode(bm_add);
	draw_sprite_ext(global.spyArm, 0, x, y, handscale, 1.75, point_direction(x,y,targx,targy), image_blend, 0.2);
	draw_sprite_ext(global.spyHand, 0, x + lengthdir_x(handscale,point_direction(x,y,targx,targy)), y + lengthdir_y(handscale,point_direction(x,y,targx,targy)), 1.75, 1.75, point_direction(x,y,targx,targy), image_blend, .2);
	draw_set_blend_mode(bm_normal);
}

#define spy_step
if handscale = 0 {
    if image_alpha > .2 image_alpha -= .04 * current_time_scale
}
with instance_nearest(x,y,enemy) if distance_to_object(other) <= 64{
	with other {
		motion_add(point_direction(other.x,other.y,x,y),5/distance_to_object(other) + .1)
		if (angle_difference(point_direction(x,y,other.x,other.y),ogdirection) > 110 || angle_difference(point_direction(x,y,other.x,other.y),ogdirection) < -110) && canstab = 1 && stabsremaining > 0{
			target = other
			handscale = distance_to_object(target) + 10
			targx = target.x
			targy = target.y
			canstab = 0
			stabsremaining -=1
			image_alpha = 1
			with other if "my_health" in self{
				with instance_create(x,y,CustomObject)
				{
					depth = TopCont.depth - 1
					sprite_index = global.crit
					s = 1.4
					sf = .12
					startc = c_lime
					endc   = c_red
					vspeed = -.4
					lifetime = 60 // 2 seconds
					image_xscale = s
					image_yscale = s
					on_step = crit_step
				}
				view_shake_max_at(x,y,200)
    		    sleep(30)
    		    sound_play_pitchvol(sndHammerHeadEnd,random_range(1.23,1.33),20)
    		    sound_play_pitchvol(sndBasicUltra,random_range(0.9,1.1),20)
    		    sound_play_pitch(sndCoopUltraA,random_range(3.8,4.05))
				with other projectile_hit(other, other.my_health);
			}
		}
	}
}
if handscale > 0 {
	handscale -= 1/5* handscale * current_time_scale
	if handscale < 5 {
		handscale = 0
		canstab = 1
	}
}
motion_add(ogdirection,current_time_scale)
speed = 3
image_angle = direction

#define spy_die
with instance_create(x,y,BulletHit){
	sprite_index = global.hit
	image_angle = other.direction + 180
}
if place_meeting(x + hspeed,y +vspeed,Wall){sound_play_pitchvol(sndHitWall,1,100/distance_to_object(creator))}

#define crit_step
image_blend = merge_color(endc,startc,lifetime/60)
image_alpha = lifetime/60
if sf != 0{s += sf;sf -= .043}
if s < 1{s = 1;sf = 0}
image_xscale = s
image_yscale = s
if lifetime > 0 lifetime -= current_time_scale else instance_destroy()
