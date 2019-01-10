#define init
global.sprPuncher 			= sprite_add_weapon("sprites/sprPuncher.png",11,3)
global.sprPuncherRocket = sprite_add("sprites/projectiles/sprPuncherRocket.png",0,6,6)
#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)
#define weapon_name
return "PUNCHER"
#define weapon_type
return 4
#define weapon_cost
return 3
#define weapon_area
return 7
#define weapon_load
return 27
#define weapon_swap
return sndSwapExplosive
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire
if fork(){
	for (var i = 0;i < 3; i++){
		if instance_exists(self){
			sleep(12);
			sound_play_pitchvol(sndHeavySlugger,random_range(.7,.8),1)
			sound_play_pitchvol(sndSuperSlugger,random_range(.7,.8),1)
			sound_play_pitchvol(sndNukeFire,.8,1)
			weapon_post(6,7,22)
			with instance_create(x,y,CustomProjectile){
				move_contact_solid(other.gunangle,8)
				name = "Puncher Rocket"
				sprite_index = global.sprPuncherRocket
				team = other.team
				creator = other
				damage = 15
				motion_set(other.gunangle + random_range(-4-(i),4+(i)) * other.accuracy,1)
				extradir = random_range(.10,.25) * -sign(other.gunangle - direction) * other.accuracy * i
				repeat(2){with instance_create(x,y,Smoke){speed = random_range(3,5);direction = other.direction+random_range(-5,5)}}
				image_angle = direction
				on_destroy  = puncherdie
				on_step 	= puncherstep
				on_end_step = puncherendstep
				on_draw 	= puncherdraw
			}
			wait(3)
		}
	}
	sound_play(sndRocketFly)
	exit
}
#define weapon_sprt
return global.sprPuncher

#define weapon_text
return "breaking through"

#define puncherdraw
draw_self()
draw_sprite_ext(sprRocketFlame,-1,x,y,1,1,image_angle,c_white,image_alpha)

#define puncherendstep
with instance_create(x,y,BoltTrail)
{
	image_blend = c_yellow
	image_angle = point_direction(x,y,other.xprevious, other.yprevious)
	image_xscale = point_distance(x,y,other.xprevious, other.yprevious)
	image_yscale = 1.4
	if fork(){
	    while instance_exists(self){
	        image_blend = merge_color(image_blend,c_red,.1*current_time_scale)
	        wait(0)
	    }
	    exit
	}
}

#define puncherstep
if current_frame_active && !irandom(2) instance_create(x,y,Smoke)
direction += extradir*current_time_scale
speed += current_time_scale *.7
image_angle = direction
if speed >= 30 speed = 30

#define puncherdie
sound_play(sndExplosion)
instance_create(x,y,Explosion)
for (var i = 1;i <= 3; i++){
	instance_create(x+lengthdir_x(18*i,direction),y+lengthdir_y(18*i,direction),SmallExplosion)
}
//instance_create(x+lengthdir_x(16*4,direction),y+lengthdir_y(16*4,direction),SmallExplosion)
/*instance_create(x+lengthdir_x(16,direction),y+lengthdir_y(16,direction),SmallExplosion)
instance_create(x+lengthdir_x(-16,direction),y+lengthdir_y(16,direction),SmallExplosion)
instance_create(x+lengthdir_x(16,direction),y+lengthdir_y(-16,direction),SmallExplosion)
instance_create(x+lengthdir_x(-16,direction),y+lengthdir_y(-16,direction),SmallExplosion)
*/
