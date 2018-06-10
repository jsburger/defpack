#define init
global.sprMarker 		 = sprite_add_weapon("sprites/sprMarker.png", 3, 2);
global.sprMarkerBolt = sprite_add("sprites/projectiles/sprMarkerBolt.png",2,-2,3)
#define weapon_name
return "MARKER"

#define weapon_sprt
return global.sprMarker;

#define weapon_type
return 3;

#define weapon_auto
return false;

#define weapon_load
return 7; //34

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 9;

#define weapon_text
return "replace me please";

#define weapon_fire
weapon_post(5,21,21)
sound_play_pitch(sndUltraCrossbow,random_range(3,4))
sound_play_pitch(sndHeavyCrossbow,random_range(2,3))
sound_play_pitch(sndSeekerPistol,random_range(1.6,2))
with instance_create(x,y,Bolt)
{
	name = "marker bolt"
	damage = 6
	team = other.team
	creator = other
	sprite_index = global.sprMarkerBolt
	motion_add(other.gunangle+random_range(-2,2),24)
	image_angle = direction
}

#define step
	with BoltStick
	{
		if sprite_index = global.sprMarkerBolt
		if "target" in self and instance_exists(target)
		{
			name = "marker bolt"
			if target.speed > .5 target.speed = .5
			tar_width  = sprite_get_width(target.sprite_index)
			tar_height = sprite_get_height(target.sprite_index)
			if "spawn" not in self
			{
				with instance_create(x,y,CustomObject)
				{
					tar_width  = other.tar_width
					tar_height = other.tar_height
					team   = 2
					ammo   = 20
					timer  = room_speed * 1.5
					target = other.target
					on_step = volley_step
				}
				spawn = 1
			}
		}
	}

#define volley_step
if instance_exists(target)
{
	x = target.x
	y = target.y
}
timer--
if timer <= 0
{
	ammo--
	repeat(2) with instance_create(x+random_range(-tar_width/2,tar_width/2),y+random_range(-tar_height/2,0),CustomProjectile)
	{
		name = "volley arrow"
		depth = TopCont.depth -1
		sprite_index = sprBolt
		mask_index   = mskNothing
		image_index  = 1
		image_speed  = 0
		direction    = random(360)
		force = 0
		damage = 3
		team = other.team
		z = irandom_range(300,350)
		on_step = rainarrow_step
		on_draw = rainarrow_draw
	}
}
else sound_play_pitch(sndEnemySlash,1-timer/300)
if ammo <= 0 instance_destroy()

#define rainarrow_step
z -= current_time_scale*20
if z <= 25 {mask_index = mskBolt;depth = TopCont.depth+1}
if z < 0
{
	instance_create(x,y,Dust)
	sound_play_pitch(sndBoltHitWall,random_range(.8,1.2))
	sound_play_pitch(sndHitWall,random_range(.8,1.2))
	instance_destroy()
}

#define rainarrow_draw
draw_sprite_ext(sprite_index,image_index,x,y-z,image_xscale,image_yscale,270,image_blend,image_index)
