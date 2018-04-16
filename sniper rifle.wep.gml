#define init
global.sprSniperRifle = sprite_add_weapon("sprites/sprSniperRifle.png", 5, 3);
#define weapon_name
return "SNIPER RIFLE"

#define weapon_sprt
return global.sprSniperRifle ;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 43;

#define weapon_cost
return 9;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
return true;

#define weapon_reloaded
with mod_script_call("mod","defpack tools", "shell_yeah", 100, 8, 3+random(2), c_yellow)
sound_play_pitchvol(sndSwapPistol,2,.4)
sound_play_pitchvol(sndRecGlandProc,1.4,1)
weapon_post(-2,-4,5)
return -1;

#define weapon_area
return 9;

#define weapon_text
return choose("replace me please");

#define weapon_fire
var _ptch = random_range(-.5,.5)
sound_play_pitch(sndHeavyRevoler,1.5+_ptch)
sound_play_pitch(sndSniperFire,random_range(.6,.8))
sound_play_pitch(sndHeavySlugger,1.3+_ptch/2)
weapon_post(12,2,158)
motion_add(gunangle -180,1)
with instance_create(x+lengthdir_x(10,gunangle),y+lengthdir_y(10,gunangle),CustomProjectile)
{
		sleep(120)
		move_contact_solid(other.gunangle,18)
		typ = 1
		creator = other
		index = other.index
		team  = other.team
		image_yscale /= 2
		sprite_index = mskNothing
		mask_index = mskBullet1
		force = 7
		damage = 20
		dir = 0
		recycleset = 0
		dd = 0
		image_angle = other.gunangle
		direction = other.gunangle
		on_step 	 = sniper_step
		on_destroy = sniper_destroy
		on_hit 		 = void
}
with instance_create(x,y,CustomObject)
{
	move_contact_solid(other.gunangle,24)
	depth = -1
	sprite_index = sprBullet1
	image_speed = .4
	on_step = muzzle_step
	on_draw = muzzle_draw
}

#define void

#define sniper_step
do
{
	dir += 1 x += lengthdir_x(1,direction) y += lengthdir_y(1,direction)
	with instance_create(x,y,BoltTrail)
  {
    image_blend = c_yellow
    image_angle = other.direction
    image_yscale = 1.2
    image_xscale = 1
  }
	//redoing reflection code since the collision event of the reflecters doesnt work in substeps (still needs slash reflection)
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
				if my_health > 0{other.dd += my_health}
				projectile_hit(self,other.damage,other.force,other.direction)
				with other
				{
					if skill_get(16) = true{if recycleset=0{recycleset=1;instance_create(creator.x,creator.y,RecycleGland);sound_play(sndRecGlandProc);if irandom(2)!=0{if creator.ammo[1]+15 <= creator.typ_amax[1]{creator.ammo[1]+=15}else{creator.ammo[1] = creator.typ_amax[1]}}}}
					continue;
				}
			}
		}
	}
	if damage < dd{instance_destroy();exit}
	if place_meeting(x,y,Wall){instance_destroy()}
}
while instance_exists(self) and dir < 1000
instance_destroy()

#define sniper_destroy
instance_create(x,y,BulletHit)

#define muzzle_step
if image_index > 1{instance_destroy()}

#define muzzle_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.2);
draw_set_blend_mode(bm_normal);
