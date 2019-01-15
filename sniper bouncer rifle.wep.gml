#define init
global.sprSniperBouncerRifle = sprite_add_weapon("sprites/sprSniperBouncerRifle.png", 6, 2);
#define weapon_name
return "SNIPER BOUNCER RIFLE"

#define weapon_chrg
return true;

#define weapon_sprt
return global.sprSniperBouncerRifle;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 20;

#define weapon_cost
return 20;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
with instances_matching(instances_matching(CustomObject, "name", "sniper bouncer charge"),"creator",self){return true}
return false;

#define weapon_reloaded
with mod_script_call("mod","defpack tools", "shell_yeah_long", 100, 8, 3+random(2), c_yellow)
var _r = random_range(.8,1.2)
sound_play_pitchvol(sndSwapPistol,2*_r,.4)
sound_play_pitchvol(sndRecGlandProc,1.4*_r,1)
weapon_post(-3,0,3)

#define weapon_area
return -1;

#define weapon_text
return choose("BEWARE THE RICOCHET");

#define weapon_fire

with instance_create(x,y,CustomObject)
{
	name    = "sniper bouncer charge"
	creator = other
	charge  = 0
	acc     = other.accuracy
	charged = 1
	holdtime = 5 * 30
	depth = TopCont.depth
	index = creator.index
	undef = view_pan_factor[index]
	on_step 	 = snipercharge_step
	on_destroy = snipercharge_destroy
	on_cleanup = snipercharge_destroy
	btn = other.specfiring ? "spec" : "fire"
}

#define snipercharge_step
var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
if !instance_exists(creator){instance_destroy();exit}
if button_check(index,"swap"){creator.ammo[1] = min(creator.ammo[1] + weapon_cost(), creator.typ_amax[1]);instance_destroy();exit}
if btn = "fire" creator.reload = weapon_get_load(creator.wep)
if btn = "spec"{
    if creator.race = "steroids"
        creator.breload = weapon_get_load(creator.bwep)
    else
        creator.reload = max(weapon_get_load(creator.wep) * array_length_1d(instances_matching(instances_matching(instances_matching(CustomObject, "name", name),"creator",creator),"btn",btn)), creator.reload)
}
charge += timescale * 1.6 / acc
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
	if holdtime >= 60 {var _m = 5}else{var _m = 3}
	if current_frame mod _m < current_time_scale creator.gunshine = 1
	with creator with instance_create(x,y,Dust)
	{
		motion_add(random(360),random_range(2,3))
	}
	holdtime -= timescale
}
view_pan_factor[index] = 2.1+charged/10
sound_play_pitchvol(sndFlameCannonLoop,10-charge/10,1)
sound_play_gun(sndFootOrgSand4,999999999999999999999999999999999999999999999999,.00001)
x = mouse_x[index]
y = mouse_y[index]
for (var i=0; i<maxp; i++){player_set_show_cursor(index,i,0)}
if button_check(index, btn) = false || holdtime <= 0
{
    sound_stop(sndFlameCannonLoop)
	sound_play_gun(sndFootOrgSand4,999999999999999999999999999999999999999999999999,1)
	sound_pitch(sndNoSelect,1)
	var _ptch = random_range(-.5,.5)
	sound_play_pitch(sndHeavyRevoler,.7-_ptch/3)
	sound_play_pitch(sndSawedOffShotgun,1.8-_ptch)
	sound_play_pitch(sndSniperFire,random_range(.6,.8))
	sound_play_pitch(sndBouncerSmg,random_range(.8,1.2))
	sound_play_pitch(sndBouncerShotgun,random_range(.8,1.2))
	sound_play_pitch(sndHeavySlugger,1.3+_ptch/2)
	var _c = charge
	with creator
	{
		weapon_post(12,2,158)
		motion_add(gunangle -180,_c / 20)
		with instance_create(x+lengthdir_x(10,gunangle),y+lengthdir_y(10,gunangle),CustomProjectile)
		{
			name = "hyper bouncer"
			move_contact_solid(other.gunangle,18)
			typ = 1
			creator = other
			index = other.index
			team  = other.team
			trailscale = .5+_c/2500
			trailsize = 0
			hyperspeed = 8
			sprite_index = mskNothing
			mask_index = mskBullet1
			force = 7
			damage = 40
			lasthit = -4
			dir = 0
			dd = 0
			bounce = 2 + round(_c/100)*2
			recycleset = (irandom(2)==0)
			image_angle = other.gunangle
			motion_set(other.gunangle,8)
			on_end_step 	 = sniper_step
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
	}
	sleep(charge*3)
	instance_destroy()
}

#define snipercharge_destroy
view_pan_factor[index] = undefined
for (var i=0; i<maxp; i++){player_set_show_cursor(index,i,1)}

#define void

#define sniper_step
do
{
	dir += speed
	if bounce >= 0{
    	if place_meeting(x+hspeed,y,Wall){
    	    line()
            hspeed*=-1
            bounce--
    	}
    	if place_meeting(x,y+vspeed,Wall){
    	    line()
            vspeed*=-1
            bounce--
    	}
    	x+=hspeed
    	y+=vspeed
	}
    else{
        instance_destroy()
        exit
    }
	with instances_matching_ne([CrystalShield,PopoShield], "team", team){if place_meeting(x,y,other){with other{line()};other.team = team;other.direction = point_direction(x,y,other.x,other.y);other.image_angle = other.direction;with instance_create(other.x,other.y,Deflect){image_angle = other.direction;sound_play_pitch(sndCrystalRicochet,random_range(.9,1.1))}}}
	with instances_matching_ne([EnergySlash,Slash,EnemySlash,EnergyHammerSlash,BloodSlash,GuitarSlash], "team", team){if place_meeting(x,y,other){with other{line()};other.team = team;other.direction = direction ;other.image_angle = other.direction}}
	with instances_matching_ne([Shank,EnergyShank], "team", team){if place_meeting(x,y,other){with other{instance_destroy();exit}}}
	with instances_matching_ne(CustomSlash, "team", team){if place_meeting(x,y,other){mod_script_call(on_projectile[0],on_projectile[1],on_projectile[2]);with other{line()};}}
	with instances_matching_ne(hitme, "team", team)
	{
		if distance_to_object(other) <= 5
		{
			if other.lasthit != self
			{
				with other
				{
				    projectile_hit(other,damage,force,direction)
					lasthit = other
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
while instance_exists(self) and dir < 3000
instance_destroy()

#define line()
var dis = point_distance(x,y,xstart,ystart) + 1;
var num = 20;
for var i = 0; i < num; i++{
    with instance_create(xstart+lengthdir_x(dis/num * i,direction),ystart + lengthdir_y(dis/num * i,direction),BoltTrail){
        image_blend = c_yellow
        image_angle = other.direction
        image_yscale = other.trailscale * (i/num) + other.trailsize
        image_xscale = dis/num
    }
}
trailsize+= trailscale
xstart = x
ystart = y

#define sniper_destroy
instance_create(x,y,BulletHit)
line()

#define muzzle_step
if image_index > 1{instance_destroy()}

#define muzzle_draw
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 3*image_xscale, 3*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);
