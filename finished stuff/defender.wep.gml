#define init
global.sprDefender 	   = sprite_add_weapon("sprDefender.png", 9, 4);
global.sprDefenderOff  = sprite_add_weapon("sprDefenderOff.png", 9, 4);
global.sprShieldBullet = sprite_add("sprShieldBullet.png",2,10,8);

#define weapon_name
return "DEFENDER"

#define weapon_sprt
with(GameCont)
{
	if "rad" in self && rad >= 3 {return global.sprDefender};
	else {return global.sprDefenderOff};
}
#define weapon_melee
return false;

#define weapon_type
return 0;

#define weapon_rads
return 12;

#define weapon_auto
return false;

#define weapon_load
return 21;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 15;

#define weapon_text
return "KEEP YOUR DISTANCE";

#define weapon_fire
sound_play_pitch(sndEliteShielderShield,random_range(1.4,1.8))
sound_play_pitch(sndUltraShotgun,random_range(1.2,1.5))
sound_play_pitch(sndDogGuardianLand,random_range(.3,.5))
sound_play_pitch(sndGuardianFire,random_range(.6,.8))
weapon_post(8,-5,18)
var i = 1;
var j = 1;
repeat(3)
{
	repeat(clamp(i,1,2))
	{
		with instance_create(x,y,CustomSlash)
		{
			move_contact_solid(other.gunangle,2)
			team     = other.team
			typ 		 = 1
			force    = 5
			damage   = 6
			friction = 2+1.1*(i-1)
			pierce   = 3 + GameCont.loops
			sprite_index = global.sprShieldBullet
			motion_add(other.gunangle+(random_range(-1,1)* other.accuracy+13*j*(i-1)),28)
			image_angle = direction
			on_projectile = def_projectile
			on_destroy 		= def_destroy
			on_step 			= def_step
			on_draw 			= def_draw
			on_wall 			= def_wall
			on_hit 			  = def_hit
		}
		j *= -1
	}
	i++
}

#define def_step
if image_index = 1{image_speed = 0}
if speed <= friction{instance_destroy()}

#define def_wall
instance_destroy()

#define def_destroy
with instance_create(x,y,BulletHit)
{
	sprite_index = sprGuardianBulletHit
	image_angle = other.direction + 180
}
if place_meeting(x + hspeed,y +vspeed,Wall){sound_play_hit(sndHitWall,.2)}

#define def_projectile
if !instance_exists(self){instance_destroy();exit}
if team != other.team
{
	with other{instance_destroy()}
	pierce--
	if pierce < 0{instance_destroy()}
}

#define def_hit
projectile_hit(other, damage, force, direction)
instance_destroy()

#define def_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale+(1-image_index)*.5, 2*image_yscale, image_angle+(1-image_index)*.5, image_blend, 0.1+(1-image_index)*1.6);
draw_set_blend_mode(bm_normal);
