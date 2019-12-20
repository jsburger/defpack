#define init
global.sprBuster 		      = sprite_add_weapon("sprites/weapons/sprBuster.png",7,5)
global.sprBusterBomb      = sprite_add("sprites/projectiles/sprBusterBomb.png",4,12,12) //"ROCKET"
global.sprBusterBombBlink = sprite_add("sprites/projectiles/sprBusterBombBlink.png",2,7,6)
return "BUSTER"
#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)
#define weapon_sprt
return global.sprBuster;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 28;

#define weapon_chrg
return 1;

#define weapon_cost
return 3;

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
sound_play_pitchvol(sndNadeReload,.6*_p,2)
weapon_post(9,-60,24)
sleep(10)
with instance_create(x,y,CustomProjectile){
    name = "bomb"
    btn = other.specfiring ? "spec" : "fire"
    move_contact_solid(other.gunangle,16)
    team = other.team
    creator = other
    typ = 1
    damage = 2
    force  = 6
	if instance_is(other, Player){
		var _x = mouse_x[other.index];
		var _y = mouse_y[other.index];
		motion_add(point_direction(x,y,_x,_y) + random_range(-5,5) * other.accuracy,/*max(sqrt(point_distance(_x,_y,x,y)),10)*/15)
	}else{
		motion_add(other.gunangle,10)
	}
	friction = .4
	lifetime = 5 * 30
	defcharge = {
	    maxcharge: lifetime,
	    charge: lifetime,
	    width: 10,
	    style: 0,
	    power : 1
	}
	image_speed = .5
	image_angle = direction
	if current_frame_active repeat(5){
		with instance_create(x,y,Smoke){
			motion_add(other.direction+random_range(-15,15),random_range(2,3))
		}
	}
	sprite_index = global.sprBusterBomb
    mask_index   = sprDiscTrail
	on_step 	 = buster_step
	on_hit 		 = buster_hit
	on_wall      = buster_wall
	on_destroy   = buster_destroy
    on_draw      = buster_draw
}

#define buster_step
if !instance_exists(creator){instance_destroy();exit}else{with creator{weapon_post(3,-20,0)}}
image_angle += speed * 3 * current_time_scale
if current_frame_active{
    with instance_create(x+lengthdir_x(-sprite_get_height(sprite_index)/2.2,image_angle-90),y+lengthdir_y(-sprite_get_height(sprite_index)/2.2,image_angle-90),Smoke){
        image_xscale = .5;
        image_yscale = .5;
        motion_add(90,2)
    }
}
lifetime -= current_time_scale
defcharge.charge = lifetime
if lifetime <= 30 and image_index mod 2 <= current_time_scale{
    defcharge.blinked = 1
}
if lifetime <= 0{
    instance_destroy()
    exit
}
if !button_check(creator.index,btn) && lifetime <= (5 * 30 - 6){
    sleep(50)
    instance_destroy()
    exit
}

#define buster_hit
if current_frame_active {
	sleep(50)
	view_shake_at(x,y,6)
	with instance_create(x,y,Smoke){image_angle = random(360)}
	projectile_hit(other,damage,force + speed,direction)
}

#define buster_wall
sleep(12)
if lifetime > 30 * 3 lifetime = 30 * 3
repeat(3) instance_create(x,y,Smoke)
move_bounce_solid(false)
speed *= .6
sound_play_pitchvol(sndGrenadeHitWall,random_range(.5,.7),.8)

#define buster_destroy
instance_create(x,y,SmallExplosion)
sound_play_pitch(sndExplosionL, .8)
sound_play_pitch(sndExplosionS, .8)
var i = random(360);
var j = 24;
var k = Explosion;
repeat(2){
	repeat(4){
		instance_create(x+lengthdir_x(j,i),y+lengthdir_y(j,i),k)
		i += 360/4
	}
	j += 32
	k = SmallExplosion
}
sleep(20)
view_shake_at(x,y,15)
instance_create(x,y,GroundFlame)

#define buster_draw
draw_self()
if lifetime <= 30{
  draw_sprite_ext(global.sprBusterBombBlink,image_index,x,y,image_xscale,image_yscale,image_angle,image_blend,image_alpha)
}
