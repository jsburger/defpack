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
return 17;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 21;

#define weapon_text
return "KEEP YOUR DISTANCE";

#define nts_weapon_examine
return{
    "d": "A close-ranged powerhouse of both damage and protection. #It used to be the weapon of choice for the Palace's last line of defense. ",
}
#define weapon_fire
var _p = random_range(.8,1.2);
sound_play_pitchvol(sndEliteShielderShield,1.3*_p,.6)
sound_play_pitch(sndUltraShotgun,1.3*_p)
sound_play_pitch(sndExplosionS,.6*_p)
sound_play_pitch(sndBasicUltra,1.8*_p)
sound_play_pitch(sndHyperSlugger,.7*_p)
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
			typ 	   = 1
			force    = 5
			damage   = 12
			lifetime = 3;
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
		view_shake_max_at(x,y,2)
		instance_destroy()
	}
}
if speed <= friction{
	lifetime -= current_time_scale;
	if lifetime <= 0{
		instance_destroy()
	}
}

#define def_wall
instance_destroy()

#define def_destroy
with instance_create(x,y,BulletHit){
	sprite_index = sprGuardianBulletHit
	image_angle = other.direction + 180
}
if place_meeting(x + hspeed,y +vspeed,Wall){sound_play_hit(sndHitWall,.2)}

#define def_hit
view_shake_max_at(x, y, 8)
sleep(10)
if projectile_canhit_melee(other) = true projectile_hit(other, damage, force, direction)
//instance_destroy()
