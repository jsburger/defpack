#define init
global.sprSniperBouncerRifle = sprite_add_weapon("sprites/sprSniperBouncerRifle.png", 6, 2);
#define weapon_name
return "SNIPER BOUNCER RIFLE"

#define weapon_sprt
return global.sprSniperBouncerRifle;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 43;

#define weapon_cost
return 25;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
return true;

#define weapon_reloaded
with mod_script_call("mod","defpack tools", "shell_yeah_long", 100, 8, 3+random(2), c_yellow)
sound_play_pitchvol(sndSwapPistol,2,.4)
sound_play_pitchvol(sndRecGlandProc,1.4,1)
weapon_post(-3,0,3)
return -1;

#define weapon_area
return 9;

#define weapon_text
return choose("replace me please");

#define weapon_fire
sound_play_pitch(sndHeavyRevoler,1.7)
sound_play_pitch(sndSniperFire,random_range(.6,.8))
sound_play_pitch(sndHeavyNader,random_range(.6,.8))
sound_play_pitch(sndBouncerShotgun,random_range(.9,1.2))
weapon_post(12,-16,53)
with instance_create(x+lengthdir_x(10,gunangle),y+lengthdir_y(10,gunangle),CustomProjectile)
{
	sleep(40)
	move_contact_solid(other.gunangle,18)
	typ = 1
	creator = other
	index = other.index
	team  = other.team
	trailscale = .5
	trailsize = 0
	hyperspeed = 8
	sprite_index = mskNothing
	mask_index = mskBullet1
	force = 7
	damage = 40
	lasthit = -4
	dir = 0
	dd = 0
	bounce = 2
	recycleset = (irandom(2)==0)
	image_angle = other.gunangle
	motion_set(other.gunangle,8)
	on_step 	 = sniper_step
	on_destroy = sniper_destroy
	on_hit 		 = void
}
with instance_create(x,y,CustomObject)
{
	move_contact_solid(other.gunangle,24)
	depth = -1
	sprite_index = sprBouncerBullet
	image_speed = .4
	on_step = muzzle_step
	on_draw = muzzle_draw
}


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
	if dd > 0 dd -= hyperspeed
	if dd <= 0
	with instances_matching_ne(hitme, "team", team)
	{
		if distance_to_object(other) <= 5
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
