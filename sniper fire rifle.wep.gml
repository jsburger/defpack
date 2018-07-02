#define init
global.sprSniperFireRifle = sprite_add_weapon("sprites/sprSniperFireRifle.png", 5, 3);
global.sprFireBullet 			= sprite_add("defpack tools/Fire Bullet.png", 2, 8, 8);
global.sprFireBulletHit   = sprite_add("defpack tools/Fire Bullet Hit.png", 4, 8, 8);

#define weapon_name
return "SNIPER FIRE RIFLE"

#define weapon_sprt
return global.sprSniperFireRifle;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 21;

#define weapon_cost
return 30;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
with instances_matching(instances_matching(CustomObject, "name", "sniper fire charge"),"creator",self){return true}
return false;

#define weapon_reloaded
with mod_script_call("mod","defpack tools", "shell_yeah_long", 100, 8, 3+random(2),c_red)
sound_play_pitchvol(sndSwapPistol,2,.4)
sound_play_pitchvol(sndRecGlandProc,1.4,1)
weapon_post(-2,-4,5)
return -1;

#define weapon_area
return -1;

#define weapon_text
return choose("replace me please");

#define weapon_fire

with instance_create(x,y,CustomObject)
{
	name    = "sniper fire charge"
	creator = other
	charge  = 0
	acc     = other.accuracy
	charged = 1
	depth = TopCont.depth
	undef = view_pan_factor[creator.index]
	on_step 	 = snipercharge_step
	on_destroy = snipercharge_destroy
	btn = other.specfiring ? "spec" : "fire"
}

#define snipercharge_step
if !instance_exists(creator){instance_destroy();exit}
if button_check(creator.index,"swap"){creator.ammo[1] = min(creator.ammo[1] + weapon_cost(), creator.typ_amax[1]);instance_destroy();exit}
if btn = "fire" creator.reload = weapon_get_load(creator.wep)
if btn = "spec" creator.breload = weapon_get_load(creator.bwep) * array_length_1d(instances_matching(instances_matching(CustomObject, "name", "sniper charge"),"creator",creator))
charge += current_time_scale * 3.2 / acc
if charge > 100
{
	charge = 100
	if charged > 0
	{
		sound_play_pitch(sndSniperTarget,1.2)
	}
	charged = 0
}
if charged = 0
{
	with creator with instance_create(x,y,Dust)
	{
		motion_add(random(360),random_range(2,3))
	}
}
view_pan_factor[creator.index] = 2.1+charged/10
sound_play_pitchvol(sndFlameCannonLoop,10-charge/10,1)
sound_play_gun(sndFootOrgSand4,999999999999999999999999999999999999999999999999,.00001)
x = mouse_x[creator.index]
y = mouse_y[creator.index]
for (var i=0; i<maxp; i++){player_set_show_cursor(creator.index,i,0)}
if button_check(creator.index, btn) = false
{
    sound_stop(sndFlameCannonLoop)
	sound_play_gun(sndFootOrgSand4,999999999999999999999999999999999999999999999999,1)
	sound_pitch(sndNoSelect,1)
	var _ptch = random_range(-.5,.5)
	sound_play_pitch(sndHeavyRevoler,.7-_ptch/3)
	sound_play_pitch(sndSawedOffShotgun,1.8-_ptch)
	sound_play_pitch(sndSniperFire,random_range(.6,.8))
	sound_play_pitch(sndHeavySlugger,1.3+_ptch/2)
	sound_play_pitch(sndFlareExplode,1.8)
	sound_play_pitch(sndFlameCannonEnd,.7)
	sound_play_pitch(sndQuadMachinegun,.7)
	sound_play_pitch(sndSniperFire,random_range(.6,.8))
	var _c = charge
	with creator
	{
		weapon_post(12,2,158)
		motion_add(gunangle -180,_c / 20)
		with instance_create(x+lengthdir_x(10,gunangle),y+lengthdir_y(10,gunangle),CustomProjectile)
		{
				sleep(120)
				move_contact_solid(other.gunangle+random_range(-7,7)*other.accuracy,18)
				typ = 1
				creator = other
				index = other.index
				team  = other.team
				image_yscale = .5
				trailscale = 1 + (_c/110)
				hyperspeed = 4
				sprite_index = mskNothing
				mask_index = mskBullet2
				force = 7
				damage = 12 + round(28*(_c/100))
				lasthit = -4
				dir = 0
				dd = 0
				recycleset = 0
				if irandom(2)=0 recycleset = 1
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
			sprite_index = global.sprFireBullet
			image_speed = .4
			on_step = muzzle_step
			on_draw = muzzle_draw
		}
	}
	sleep(charge*3)
	instance_destroy()
}

#define snipercharge_destroy
view_pan_factor[creator.index] = undefined
//stealing from burg like a cool kid B)
for (var i=0; i<maxp; i++){player_set_show_cursor(creator.index,i,1)}

#define void

#define sniper_step
do
{
	dir += hyperspeed
	if random(2) < 1 *current_time_scale{with instance_create(x,y,Flame){team = other.team{motion_add(random(360),(other.trailscale*10-13)/1.5)}}}
	x += lengthdir_x(hyperspeed,direction)
	y += lengthdir_y(hyperspeed,direction)
	//redoing reflection code since the collision event of the reflecters doesnt work in substeps (still needs slash reflection)
	with instances_matching_ne([CrystalShield,PopoShield], "team", team){if place_meeting(x,y,other){with other{line()};other.team = team;other.direction = point_direction(x,y,other.x,other.y);other.image_angle = other.direction;with instance_create(other.x,other.y,Deflect){image_angle = other.direction;sound_play_pitch(sndCrystalRicochet,random_range(.9,1.1))}}}
	with instances_matching_ne([EnergySlash,Slash,EnemySlash,EnergyHammerSlash,BloodSlash,GuitarSlash], "team", team){if place_meeting(x,y,other){with other{line()};other.team = team;other.direction = direction ;other.image_angle = other.direction}}
	with instances_matching_ne([Shank,EnergyShank], "team", team){if place_meeting(x,y,other){with other{instance_destroy();exit}}}
	with instances_matching_ne(CustomSlash, "team", team){if place_meeting(x,y,other){mod_script_call(on_projectile[0],on_projectile[1],on_projectile[2]);with other{line()};}}
	if dd > 0 dd -= hyperspeed
	if dd <= 0
	with instances_matching_ne(hitme, "team", team)
	{
		if distance_to_object(other) <= other.trailscale * 3
		{
			if other.lasthit != self
			{
				projectile_hit(self,other.damage,other.force,other.direction)
				with other
				{
					lasthit = other
					dd += 20
					view_shake_at(x,y,12)
					sleep(20)
					if skill_get(16) = true && recycleset = 0{
					    recycleset = 1;
					    instance_create(creator.x,creator.y,RecycleGland);
					    sound_play(sndRecGlandProc);
					    creator.ammo[1] = min(creator.ammo[1] + weapon_cost(), creator.typ_amax[1])
				    }
				}
			}
		}
	}
	if place_meeting(x,y,Wall){instance_destroy()}
}
while instance_exists(self) and dir < 1000
instance_destroy()

#define line()
var dis = point_distance(x,y,xstart,ystart) + 1;
var num = 20;
for var i = 0; i <= num; i++{
    with instance_create(xstart+lengthdir_x(dis/num * i,direction),ystart + lengthdir_y(dis/num * i,direction),BoltTrail){
        image_blend = c_white
        image_angle = other.direction
        image_yscale = other.trailscale * (i/num)
        image_xscale = dis/num
    }
}
xstart = x
ystart = y

#define sniper_destroy
with instance_create(x,y,BulletHit){sprite_index = global.sprFireBulletHit}
var dis = point_distance(x,y,xstart,ystart) + 1;
var num = 20;
for var i = 0; i <= num; i++{
    with instance_create(xstart+lengthdir_x(dis/num * i,direction),ystart + lengthdir_y(dis/num * i,direction),BoltTrail){
        image_blend = c_white
        image_angle = other.direction
        image_yscale = other.trailscale * (i/num)
        image_xscale = dis/num
    }
}

#define muzzle_step
if image_index > 1{instance_destroy()}

#define muzzle_draw
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 3*image_xscale, 3*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);
