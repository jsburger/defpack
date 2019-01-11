#define init
global.sprBlaster 		  = sprite_add_weapon("sprites/sprBlaster.png",7,5)
global.sprBlasterBomb   = sprite_add("sprites/projectiles/sprBlasterBomb.png",4,12,12) //"ROCKET"
return "BUSTER"
#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)
#define weapon_sprt
return global.sprBlaster;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 28;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 11;

#define weapon_text
return "WOOMY";

#define weapon_fire
var _p = random_range(.8,1.2)
sound_play_pitch(sndRocketFly,2.1*_p)
sound_play_pitch(sndGrenadeShotgun,.7*_p)
sound_play_pitch(sndHeavyNader,1.7*_p)
sound_play_pitchvol(sndHeavySlugger,.6*_p,1)
weapon_post(9,-60,24)
sleep(10)
with instance_create(x,y,CustomProjectile)
{
  move_contact_solid(other.gunangle,16)
	team = other.team
	creator = other
	typ = 1
	damage = 2
	if instance_is(other, Player){
		var _x = mouse_x[other.index];
		var _y = mouse_y[other.index];
		motion_add(point_direction(x,y,_x,_y) + random_range(-5,5) * other.accuracy,max(sqrt(point_distance(_x,_y,x,y)),10))
	}else{
		motion_add(other.gunangle,10)
	}
	friction = .5
	maxspeed = 14
	lifetime = 5
	image_speed = .5
	image_angle = direction
	if current_frame_active repeat(5)
	{
		with instance_create(x,y,Smoke)
		{
			motion_add(other.direction+random_range(-15,15),random_range(2,3))
		}
	}
	sprite_index = global.sprBlasterBomb
	on_step 	 = blaster_step
	on_hit 		 = blaster_hit
	on_wall    = blaster_wall
	on_destroy = blaster_destroy
}

#define blaster_step
if speed > maxspeed speed = maxspeed
image_angle += speed * 2 * current_time_scale
if irandom(1) && current_frame_active with instance_create(x+lengthdir_x(-sprite_get_height(sprite_index)/2.2,image_angle-90),y+lengthdir_y(-sprite_get_height(sprite_index)/2.2,image_angle-90),Smoke){image_xscale = .75;image_yscale = .75;motion_add(90,2)}
//if speed = maxspeed if lifetime>0{if lifetime = 5{sound_play_pitch(sndSniperTarget,8)};lifetime -= current_time_scale}else{instance_destroy();exit}
if speed <= friction instance_destroy()

#define blaster_hit
if current_frame_active {
	sleep(9*min(other.size,4))
	view_shake_at(x,y,6)
	with instance_create(x,y,Smoke){image_angle = random(360)}
	projectile_hit(other,damage,speed,direction)
}

#define blaster_wall
sleep(12)
repeat(3) instance_create(x,y,Smoke)
move_bounce_solid(false)
speed *= .6
sound_play_pitchvol(sndGrenadeHitWall,random_range(.5,.7),.8)

#define blaster_destroy
instance_create(x,y,SmallExplosion)
sound_play(sndExplosion)
var i = random(360);
var j = 24;
var k = Explosion;
repeat(2)
{
	repeat(4)
	{
		instance_create(x+lengthdir_x(j,i),y+lengthdir_y(j,i),k)
		i += 360/4
	}
	j += 32
	k = SmallExplosion
}
sleep(30)
view_shake_at(x,y,15)
instance_create(x,y,GroundFlame)
