#define init
global.sprSniperThunderRifle = sprite_add_weapon("sprites/sprSniperThunderRifle.png", 5, 3);
global.sprLightningBullet = sprite_add("defpack tools/Lightning Bullet.png", 2, 8, 8)
#define weapon_name
return "SNIPER THUNDER RIFLE"

#define weapon_sprt
return global.sprSniperThunderRifle ;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 52;

#define weapon_cost
return 30;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
return true;

#define weapon_reloaded
repeat(2)with mod_script_call("mod","defpack tools", "shell_yeah", 100, 8, 3+random(2), c_navy)
sound_play_pitchvol(sndSwapPistol,2,.4)
sound_play_pitchvol(sndRecGlandProc,1.4,1)
sound_play_pitchvol(sndLightningReload,1,.5)
weapon_post(-2,-4,5)
return -1;

#define weapon_area
return -1;

#define weapon_text
return choose("replace me please");

#define weapon_fire
repeat(2)
{
	if fork()
	{
	var _ptch = random_range(-.5,.5)
	sound_play_pitch(sndHeavyMachinegun,1.7+_ptch)
	sound_play_pitch(sndLightningRifleUpg,random_range(1.8,2.1))
	sound_play_pitchvol(sndGammaGutsKill,random_range(1.8,2.1),1*skill_get(17))
	sound_play_pitch(sndSniperFire,random_range(.6,.8))
	sound_play_pitchvol(sndHeavySlugger,1.3+_ptch/2,.3)
	weapon_post(12,2,158)
	motion_add(gunangle -180,1)
	with instance_create(x,y,CustomObject)
	{
		move_contact_solid(other.gunangle,24)
		depth = -1
		sprite_index = global.sprLightningBullet
		image_speed = .4
		on_draw = muzzle_draw
		on_step = muzzle_step
	}
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x+lengthdir_x(8,gunangle),y+lengthdir_y(8,gunangle))
	{
			sleep(40)
			move_contact_solid(other.gunangle,20)
			typ = 1
			creator = other
			index = other.index
			team  = other.team
			image_yscale /= 2
			hitscan = true
			sprite_index = mskNothing
			mask_index = mskBullet1
			force = 7
			damage = 15
			dir = 0
			dd = 0
			recycleset=0
			image_angle = other.gunangle
			direction = other.gunangle+random_range(-3,3)*other.accuracy
			do
			{
				dir += 1 x += lengthdir_x(1,direction) y += lengthdir_y(1,direction)
				with instance_create(x,y,BoltTrail)
				{
					image_blend = c_blue
					image_angle = other.direction
					image_yscale = 1.2+skill_get(17)*.2
					image_xscale = 1
				}
				if random(21) < 1*current_time_scale
				{
					with instance_create(x,y,Lightning)
					{
							image_angle = random(360)
							team = other.team
							creator = other.creator
							ammo = choose(1,2)
							alarm0 = 1
							visible = 0
							with instance_create(x,y,LightningSpawn){image_angle = other.image_angle}
						}
				}
				//redoing reflection code since the collision event on the reflecters doesnt work in substeps (still needs slash reflection)
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
				if place_meeting(x,y,Wall){instance_destroy();exit}
			}
			while instance_exists(self) and dir < 1000
			instance_destroy()
		}
	}
	wait(7)
}

#define muzzle_step
if image_index > 1{instance_destroy()}

#define muzzle_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.2);
draw_set_blend_mode(bm_normal);
