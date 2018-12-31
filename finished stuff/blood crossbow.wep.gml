#define init
global.sprBloodCrossbow = sprite_add_weapon("sprBloodCrossbow.png", 6, 5);
global.sprBloodBolt = sprite_add("sprBloodBolt.png",0, 2, 3);

#define weapon_name
return "BLOOD CROSSBOW"

#define weapon_sprt
return global.sprBloodCrossbow;

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define weapon_type
return 3;

#define weapon_auto
return true;

#define weapon_load
return 21;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 7;

#define weapon_text
return choose("BONE LAUNCHER","THE BONE ZONE");

#define weapon_fire
if infammo <= 0{
	if ammo[3] - 1 < 0{
		ammo[3] = 0;
		sprite_index = spr_hurt;
		image_index = 0;
		my_health --;
		sound_play(sndBloodHurt);
		lasthit = [global.sprBloodCrossbow,"Blood Crossbow"]
		sound_play(snd_hurt);
	}
	else
	{
		ammo[3] -= 1
		var _p = random_range(.8,1.2)
		sound_play_pitchvol(sndHeavyCrossbow,.8*_p,.6)
		sound_play_pitchvol(sndBloodHammer,1.2*_p,.6)
	}
}
weapon_post(5,-40,0)
with instance_create(x,y,CustomProjectile)
{
	team = other.team
	check = 0
	creator = other
	motion_add(other.gunangle,20)
	sprite_index = global.sprBloodBolt
	mask_index   = mskBullet1
	damage = 17
	with instance_create(x+hspeed*1.5,y+vspeed*1.5,BloodStreak){image_angle = other.direction}
	on_step    = b_step
	on_wall    = b_wall
	on_hit     = b_hit
	on_destroy = b_destroy
}

#define b_hit
with other
{
	if "my_health" in self
	{
		var h = my_health;
		var i = self;
		if h > 0
		{
			projectile_hit(self,other.damage,4,other.direction)
			with other if h > damage
			{
				with instance_create(i.x,i.y,BoltStick)
				{
					target = i
					sprite_index = other.sprite_index
					image_angle = other.image_angle
				}
				instance_destroy()
			}
		}
	}
}

#define b_wall
var i = other;
with instance_create(x,y,CustomObject)
{
	sound_play(sndBoltHitWall)
	target = 1
	instance_create(x,y,Dust)
	sprite_index = other.sprite_index
	image_angle = other.image_angle
	life = 30
	on_step = o_step
}
instance_destroy()

#define o_step
if life > 0 life -= current_time_scale else instance_destroy()

#define b_destroy
sound_play(sndBloodLauncherExplo)
with instance_create(x,y,MeatExplosion) team = other.team

#define b_step
with instance_create(x-hspeed- lengthdir_x(10,other.direction),y-vspeed- lengthdir_y(10,other.direction),BoltTrail)
{
image_blend = c_red
y += other.vspeed
x += other.hspeed
image_angle = point_direction(xprevious,yprevious,x,y)
image_xscale = point_distance(xprevious,yprevious,x,y)
image_yscale = 1.5
}
if skill_get(mut_bolt_marrow) = true
{
	with instances_matching_ne(hitme,"team",other.team)
	{
		var m = self;
		if distance_to_object(other) < 16
		with other
		{
			with instance_create(x+hspeed/2,y+vspeed/2,BoltTrail)
			{
				image_blend = c_red
				image_angle = point_direction(x,y,m.x-other.hspeed/2,m.y-other.vspeed/2)
				image_xscale = point_distance(x,y,m.x-other.hspeed/2,m.y-other.vspeed/2)
				image_yscale = 1.5
			}
			x = other.x-hspeed
			y = other.y-vspeed
		}
	}
}
image_angle = direction
