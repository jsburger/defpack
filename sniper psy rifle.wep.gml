#define init
global.sprSniperPsyRifle = sprite_add_weapon("sprites/sprSniperPsyRifle.png", 5, 3);
global.sprPsyBullet = sprite_add("defpack tools/Psy Bullet.png", 2, 8, 8)
#define weapon_name
return "SNIPER PSY RIFLE"

#define weapon_sprt
return global.sprSniperPsyRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 54;

#define weapon_cost
return 20;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
return true;

#define weapon_reloaded
with mod_script_call("mod","defpack tools", "shell_yeah", 100, 8, 3+random(2),c_purple)
sound_play_pitchvol(sndSwapPistol,2,.4)
sound_play_pitchvol(sndRecGlandProc,1.4,1)
weapon_post(-2,0,3)
return -1;

#define weapon_area
return -1;

#define weapon_text
return choose("replace me please");

#define weapon_fire
sound_play_pitch(sndHeavyRevoler,1.4)
sound_play_pitch(sndCursedPickup,.6)
sound_play_pitch(sndSniperFire,random_range(.6,.8))
weapon_post(12,-16,53)
motion_add(gunangle -180,1)
with instance_create(x,y,CustomObject)
{
	move_contact_solid(other.gunangle,24)
	depth = -1
	sprite_index = global.sprPsyBullet
	image_speed = .4
	on_step = muzzle_step
	on_draw = muzzle_draw
}

with mod_script_call("mod", "defpack tools", "create_psy_bullet",x+lengthdir_x(8,gunangle),y+lengthdir_y(8,gunangle))
{
		sleep(40)
		move_contact_solid(other.gunangle,20)
		typ = 1
		creator = other
		index = other.index
		team  = other.team
		image_yscale /= 2
		sprite_index = mskNothing
		mask_index = mskBullet1
		accset = false
		force = 7
		ordamage = 10
		damage = ordamage
		dir = 0
		recycleset=0
		image_angle = other.gunangle
		direction = other.gunangle+random_range(-2,2)*other.accuracy
		do
		{
			dir += 1 x += lengthdir_x(1,direction) y += lengthdir_y(1,direction)
			with instance_create(x,y,BoltTrail)
			{
				image_blend = c_fuchsia
				image_angle = other.direction
				image_yscale = 1.4
				image_xscale = 1
			}
			if instance_exists(enemy) && dir > 30
			{
				var closeboy = instance_nearest(x,y,enemy)
				if collision_line(x,y,closeboy.x,closeboy.y,Wall,0,0) < 0 && distance_to_object(closeboy) < 220 && projectile_canhit_melee(closeboy)=true{
					var _dir, spd;

					_dir = point_direction(x, y, closeboy.x, closeboy.y);
					spd = 12
					direction -= clamp(angle_difference(image_angle, _dir) * .3, -spd, spd)
					image_angle = direction
				}
			}
			with instances_matching_ne(CrystalShield, "team", other.team){if place_meeting(x,y,other){other.team = team;other.direction = point_direction(x,y,other.x,other.y);other.image_angle = other.direction;with instance_create(other.x,other.y,Deflect){image_angle = other.direction;sound_play_pitch(sndCrystalRicochet,random_range(.9,1.1))}}}
			with instances_matching_ne(PopoShield, "team", other.team){if place_meeting(x,y,other){other.team = team;other.direction = point_direction(x,y,other.x,other.y);other.image_angle = other.direction;with instance_create(other.x,other.y,Deflect){image_angle = other.direction;sound_play_pitch(sndShielderDeflect,random_range(.9,1.1))}}}
			with instances_matching_ne(Slash, "team", other.team){if place_meeting(x,y,other){other.team = team;other.direction = point_direction(x,y,other.x,other.y);other.image_angle = other.direction}}
			with instances_matching_ne(Slash, "team", other.team){if place_meeting(x,y,other){with other{instance_destroy()}}}
			with instances_matching_ne(hitme, "team", other.team)
			{
				if place_meeting(x,y,other)
				{
					if projectile_canhit_melee(other) = false
					{
						projectile_hit(self,other.damage,other.force,other.direction)
						with other
						{
							if skill_get(16) = true{if recycleset=0{recycleset=1;instance_create(creator.x,creator.y,RecycleGland);sound_play(sndRecGlandProc);if irandom(2)!=0{if creator.ammo[1]+10 <= creator.typ_amax[1]{creator.ammo[1]+=20}else{creator.ammo[1] = creator.typ_amax[1]}}}}
							damage-= other.my_health
							if damage <= 0{instance_destroy();exit}
						}
					}
				}
			}
			if place_meeting(x,y,Wall){instance_destroy();exit}
		}
		while instance_exists(self) and dir < 1000
		instance_destroy()
	}

#define muzzle_step
if image_index > 1{instance_destroy()}

#define muzzle_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.2);
draw_set_blend_mode(bm_normal);
