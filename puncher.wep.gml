#define init

#define weapon_name
return "PUNCHER"
#define weapon_type
return 4
#define weapon_cost
return 4
#define weapon_area
return 11
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
			sound_play(sndRocket)
			weapon_post(2,5,4)
			with instance_create(x,y,CustomProjectile){
				move_contact_solid(other.gunangle,6)
				name = "Puncher Rocket"
				sprite_index = sprRocket
				team = other.team
				creator = other
				motion_set(other.gunangle + random_range(-5,5)*i,1)
				image_angle = direction
				on_destroy = puncherdie
				on_step = puncherstep
				on_draw = puncherdraw
			}
			wait(3)
		}
	}
	exit
}
#define weapon_sprt
return sprBazooka
#define weapon_text
return "god i love bazookas"

#define puncherdraw
draw_self()
draw_sprite_ext(sprRocketFlame,-1,x,y,1,1,image_angle,c_white,image_alpha)

#define puncherstep
if !random(2) instance_create(x,y,Smoke)
speed += current_time_scale *.7

#define puncherdie
sound_play(sndExplosion)
instance_create(x,y,Explosion)
for (var i = 1;i < 4; i++){
	instance_create(x+lengthdir_x(16*i,direction),y+lengthdir_y(16*i,direction),SmallExplosion)
}