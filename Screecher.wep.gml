#define init
global.sprScreecher = sprite_add_weapon("sprites/sprScreecher.png", 2, 4);

#define weapon_name
return "SCREECHER"

#define weapon_sprt
return global.sprScreecher;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 16;

#define weapon_cost
return 5;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 14;

#define weapon_melee
return 0;

#define weapon_text
return "MAGIC REFLECTION";

#define weapon_fire
sound_play_pitch(sndScorpionFireStart,1.5)
sound_play_pitch(sndToxicBoltGas,1.7)
sound_play_pitch(sndUltraGrenade,1.6)
sound_play_pitch(sndUltraShotgun,.6)
sound_play_pitch(sndHyperLauncher,random_range(.1,.2))
weapon_post(6,0,1)
repeat(8){with instance_create(x,y,Dust){motion_add(other.gunangle+random_range(-4,4),random_range(4,10));flag = "true";team = other.team;mask_index = mskBullet1}}
with instance_create(x,y,CustomSlash)
{
	my_health = 0
	creator = other
	name = "big bubble"
	team = other.team
	move_contact_solid(other.gunangle,16)
	motion_add(other.gunangle+random_range(-8,8)*other.accuracy,9)
	mask_index = sprGrenade
	sprite_index = sprTrapFire
	image_speed = 0
	image_xscale = 4
	image_yscale = 4
	on_step 	 	  = bubble_step
	on_wall 	 	  = bubble_wall
	on_step 	    = bubble_step
	on_hit        = bubble_hit
	on_projectile = bubble_projectile
	on_destroy 		= bubble_destroy
}

#define bubble_wall
move_bounce_solid(false)
if speed < 20 speed += 6

#define bubble_step
if speed > 4{speed -= .5*current_time_scale}

#define bubble_projectile
my_health += other.damage
with other instance_destroy()

#define bubble_hit
if projectile_canhit(other) = true{projectile_hit(other,min(round(my_health/10),1),6,direction)}

#define bubble_destroy
repeat(min(round(my_health/10),1)-1)
{
	with instance_create(x,y,Bullet2)
	{
		creator = other.creator
		team = other.team
		motion_add(random(360),random_range(7,12))
		image_angle = direction
	}
}
