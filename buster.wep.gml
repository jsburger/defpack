#define init
global.sprBlaster 		  = sprite_add_weapon("sprites/sprBlaster.png",7,5)
global.sprBlasterRocket = sprite_add("sprites/projectiles/sprBlasterRocket.png",0,12,7)
#define weapon_name
return "BUSTER"

#define weapon_sprt
return global.sprBlaster;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 28;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 7;

#define weapon_text
return choose("WOOMY");

#define weapon_fire

sound_play_pitch(sndRocketFly,random_range(2,2.2))
sound_play_pitch(sndGrenadeShotgun,random_range(.2,.3))
sound_play_pitchvol(sndNukeFire,.8,1)
sound_play_pitch(sndRocketFly,random_range(2.6,2.8))
sound_play_pitch(sndExplosionS,random_range(0.6,0.8))
sound_play_pitchvol(sndHeavySlugger,random_range(.3,.5),1)
sound_play_pitchvol(sndSuperSlugger,random_range(.7,.8),1)
weapon_post(7,0,24)

with instance_create(x,y,CustomProjectile)
{
move_contact_solid(other.gunangle,16)
	team = other.team
	creator = other
	typ = 1
	damage = 5
	motion_add(other.gunangle+(random_range(-7,7))*other.accuracy,.1)
	friction = -1.5
	maxspeed = 14
	lifetime = 5
	image_speed = .5
	hitwalls = 0
	image_angle = direction
	repeat(5)
	{
		with instance_create(x,y,Smoke)
		{
			motion_add(other.direction+random_range(-15,15),random_range(2,3))
		}
	}
	sprite_index = global.sprBlasterRocket
	on_step 	 = blaster_step
	on_hit 		 = blaster_hit
	on_wall    = blaster_wall
	on_destroy = blaster_destroy
	on_draw    = blaster_draw
}

#define blaster_step
if speed > maxspeed speed = maxspeed
//if speed = maxspeed if lifetime>0{if lifetime = 5{sound_play_pitch(sndSniperTarget,8)};lifetime -= current_time_scale}else{instance_destroy();exit}
with instance_create(x-lengthdir_x(16+speed,other.direction),y-lengthdir_y(16+speed,other.direction),BoltTrail)
{
	image_blend = c_yellow
	image_angle = other.direction
	image_yscale = 2
	image_xscale = 12+other.speed
	if fork(){
	    while instance_exists(self){
	        image_blend = merge_color(image_blend,c_red,.1*current_time_scale)
	        wait(0)
	    }
	    exit
	}
}

#define blaster_hit
if projectile_canhit(other) = true
{
	sleep(15*other.size)
	view_shake_at(x,y,5)
	with instance_create(x,y,Smoke){image_angle = random(360)}
	projectile_hit(other,damage,speed,direction)
}
if other.size > 1 instance_destroy()

#define blaster_wall
sleep(45)
repeat(3) instance_create(x,y,Smoke)
with other {instance_create(x,y,FloorExplo);instance_destroy()}
hitwalls++
if hitwalls >= 3 instance_destroy()

#define blaster_destroy
sound_play(sndExplosion)
var i = random(360);
var j = 32;
var k = Explosion;
repeat(2)
{
	repeat(4)
	{
		instance_create(x+lengthdir_x(j,i),y+lengthdir_y(j,i),k)
		instance_create(x+lengthdir_x(random_range(j-12,j),i),y+lengthdir_y(random_range(j-12,j),i),GroundFlame)
		i += 360/4
	}
	j += 32
	k = SmallExplosion
}
sleep(30)
view_shake_at(x,y,15)

#define blaster_draw
draw_sprite_ext(sprRocketFlame,image_index,x,y,image_xscale*1.25,image_yscale,image_angle,image_blend,image_alpha)
draw_self()
