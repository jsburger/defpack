#define init
global.sprDefender 	   = sprite_add_weapon("sprites/weapons/sprDefender.png", 9, 4);
global.sprDefenderOff  = sprite_add_weapon("sprites/weapons/sprDefenderOff.png", 9, 4);
global.sprShieldBullet = sprite_add("sprites/projectiles/sprShieldBullet.png",2,10,8);

#define weapon_name
return "DEFENDER"

#define weapon_sprt
with(GameCont){
	if rad >= weapon_rads()
	    return global.sprDefender;
}
return global.sprDefenderOff
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
return 21;

#define weapon_text
return "KEEP YOUR DISTANCE";

#define weapon_fire
var _p = random_range(.8,1.2)
sound_play_pitchvol(sndEliteShielderShield,1.6*_p,.6)
sound_play_pitch(sndUltraShotgun,1.3*_p)
sound_play_pitch(sndDogGuardianLand,.4*_p)
sound_play_pitch(sndGuardianFire,.7*_p)
sound_play_pitch(sndBasicUltra,2*_p)
sound_play_pitch(sndSlugger,.8*_p)
sound_play_pitch(sndDoubleShotgun,.8*_p)
weapon_post(8,-25,26)
var i = 1;
var j = 1;
repeat(3)
{
	repeat(clamp(i,1,2))
	{
		sleep(2)
		with instance_create(x,y,CustomProjectile)
		{
			name = "Defender Bullet"
			move_contact_solid(other.gunangle,2)
			team     = other.team
			creator  = other
			typ 	 = 1
			force    = 5
			damage   = 6
			friction = 2+1.1*(i-1)
			sprite_index = global.sprShieldBullet
			mask_index   = mskHeavyBullet
			defbloom = {
                xscale : 2,
                yscale : 2,
                alpha : .1
            }
			motion_add(other.gunangle+(random_range(-1,1)* other.accuracy+13*j*(i-1)),28)
			image_angle = direction
			on_destroy = def_destroy
			on_step    = def_step
			on_wall    = def_wall
			on_hit 	   = def_hit
			on_anim    = def_anim
		}
		j *= -1
	}
	i++
}

#define def_anim
image_speed = 0
image_index = 1

#define def_step
with instances_matching_ne(projectile, "team", team){
	if distance_to_object(other) <= 11{
		sleep(4)
		sound_play_pitchvol(sndShielderDeflect,random_range(1.8,2.2),.4)
		view_shake_at(x,y,2)
		instance_destroy()
	}
}
if speed <= friction{instance_destroy()}

#define def_wall
instance_destroy()

#define def_destroy
with instance_create(x,y,BulletHit){
	sprite_index = sprGuardianBulletHit
	image_angle = other.direction + 180
}
if place_meeting(x + hspeed,y +vspeed,Wall){sound_play_hit(sndHitWall,.2)}

#define def_hit
view_shake_at(x,y,8)
projectile_hit(other, damage, force, direction)
instance_destroy()
