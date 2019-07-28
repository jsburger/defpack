#define init
global.sprFlechetteBazooka = sprite_add_weapon("sprites/weapons/sprFlechetteBazooka.png", 9, 4);
global.sprFlechetteRocket  = sprite_add("sprites\projectiles\sprFlechetteRocket.png", 0, 10, 4);
#define weapon_name
return "FLECHETTE BAZOOKA";

#define weapon_sprt
return global.sprFlechetteBazooka;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 43;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 8;

#define weapon_text
return "1179 POINTS";


#define weapon_fire
weapon_post(7,-40,16)
var _p = random_range(.8,1.2);
sound_play_pitch(sndFlare,.7*_p)
sound_play_pitch(sndUltraCrossbow,2.3*_p)
sound_play_pitch(sndRocket,.5*_p)
sound_play_pitch(sndRocketFly,1.5)
sound_play_pitchvol(sndNukeFire,2*_p,.3)
with instance_create(x+lengthdir_x(6, gunangle),y + lengthdir_y(6, gunangle),CustomProjectile){
	move_contact_solid(other.gunangle,6)
	sprite_index = global.sprFlechetteRocket
	team 		 = other.team
	creator  = other
	acc 				= other.accuracy
	friction 	  = -1.4
	image_speed = .5
	maxspeed    = 28
	damage      = 8
	immuneToDistortion = 1
	motion_set(other.gunangle + random_range(-3,3), 1)
	image_angle = direction
	on_destroy = script_ref_create(flare_destroy)
	on_step 	 = script_ref_create(flare_step)
	on_wall    = script_ref_create(flare_wall)
	on_draw 	 = flare_draw
	on_hit     = flare_hit
}

#define flare_wall
instance_destroy()

#define flare_destroy
sound_play_pitch(sndFlareExplode,.8)
sound_play_pitchvol(sndFlareExplode,1,.4)
var _dir = random(360)
repeat(6)
{
	with instance_create(x,y,Splinter)
	{
		motion_add(_dir+random_range(-20,20)*other.acc,22)
		image_angle = direction
		team = other.team
		damage = 6
		sprite_index = global.sprFlechette
		mask_index   = global.mskFlechette
		creator = other
	}
	_dir += 360/6
}
_dir = random(360)
repeat(3)
{
	instance_create(x+lengthdir_x(6,_dir),y+lengthdir_y(6,_dir),SmallExplosion)
	_dir += 360/3
}
sound_play(sndExplosionS)

#define flare_step
if irandom(3) = 0 instance_create(x+random_range(-1,1),y+random_range(-1,1),Smoke)
if irandom(1) = 0 with instance_create(x+random_range(-1,1),y+random_range(-1,1),Smoke){motion_add(other.direction-180+random_range(-2,2),1)}

#define flare_draw
if speed > 12{draw_sprite_ext(sprRocketFlame,image_index,x+lengthdir_x(4,direction-180),y+lengthdir_y(4,direction-180), image_xscale, image_yscale, image_angle, image_blend, image_alpha)}
draw_self()

#define flare_hit







































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































sleep(20)
view_shake_at(x,y,15)
projectile_hit(other,damage,4,direction);if other.my_health > 0{instance_destroy()}
