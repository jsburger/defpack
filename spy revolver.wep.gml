#define init
global.spyBullet = sprite_add("Spy Bullet.png",2,8,8)
global.spyArm = sprite_add("spy arm.png",1,0,3)
global.spyHand = sprite_add("spy hand.png",1,0,4)
global.gun = sprite_add_weapon("spy revolver.png",2,2)
global.hit = sprite_add("spy bullet hit.png",4,8,8)
#define weapon_name
return "SPY REVOLVER";

#define weapon_type
return 1;

#define weapon_cost
return 2;

#define weapon_area
//50% reduced chance to spawn, i think
if !irandom(1) return 11;
else return -1;

#define weapon_load
return 24; //.8s which is the swing period of the TF2 spy knife

#define weapon_swap
return sndSwapPistol

#define weapon_auto
return 0;

#define weapon_fire
weapon_post(2,-3,3)
sound_play(sndPistol);
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_blue)
with instance_create(x + lengthdir_x(6,gunangle),y + lengthdir_y(6,gunangle),CustomProjectile){
	motion_set(other.gunangle,3)
	mask_index = mskBullet1
	on_step = spy_step
	on_draw = spy_draw
	on_destroy = spy_die
	sprite_index = global.spyBullet
	team = other.team
	creator = other
	image_angle = direction
	ogdirection = direction
	handscale = 0
	canstab = 1
	stabsremaining = 3
}

#define weapon_sprt
return global.gun

#define weapon_text
return choose("oops i meant psy","damn typos","psy among us");

#define spy_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 1.75*image_xscale, 1.75*image_yscale, image_angle, image_blend, 0.2);
draw_set_blend_mode(bm_normal);
if "target" in self && handscale > 0{
	draw_sprite_ext(global.spyArm, 0, x, y, handscale, 1, point_direction(x,y,targx,targy), image_blend, 1.0);
	draw_sprite_ext(global.spyHand, 0, x + lengthdir_x(handscale,point_direction(x,y,targx,targy)), y + lengthdir_y(handscale,point_direction(x,y,targx,targy)), 1, 1, point_direction(x,y,targx,targy), image_blend, 1.0);
	draw_set_blend_mode(bm_add);
	draw_sprite_ext(global.spyArm, 0, x, y, handscale, 1.75, point_direction(x,y,targx,targy), image_blend, 0.2);
	draw_sprite_ext(global.spyHand, 0, x + lengthdir_x(handscale,point_direction(x,y,targx,targy)), y + lengthdir_y(handscale,point_direction(x,y,targx,targy)), 1.75, 1.75, point_direction(x,y,targx,targy), image_blend, .2);
	draw_set_blend_mode(bm_normal);
}

#define spy_step
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
			with other if "my_health" in self{
				projectile_hit(self, my_health);
			}
		}
	}
}
if handscale > 0 {
	handscale -= 1/5* handscale
	if handscale < 5 {
		handscale = 0
		canstab = 1
	}
}
motion_add(ogdirection,1)
speed = 3
image_angle = direction
if image_index = 1{
	image_speed = 0
}

#define spy_die
with instance_create(x,y,BulletHit){
	sprite_index = global.hit
	image_angle = other.direction + 180
}
if place_meeting(x + hspeed,y +vspeed,Wall){sound_play_pitchvol(sndHitWall,1,100/distance_to_object(creator))}
