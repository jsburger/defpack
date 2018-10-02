#define init
global.spr = sprite_add_weapon("tankcannon.png",4,2)

#define weapon_name
return "TANK CANNON";

#define weapon_sprt
if instance_is(self,Player) if array_length_1d(instances_matching(CustomHitme,"driver",id)) return mskNone
return global.spr;

#define weapon_sprt_hud
return global.spr;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 25;

#define weapon_cost
return 2;

#define weapon_swap
return -1;

#define weapon_area
return -1;

#define weapon_text
return "HOLY SHIT THERES A TANK";

#define weapon_fire
sound_play(sndRocket)
weapon_post(4,-12,4)
with create_bullet(x+lengthdir_x(24,gunangle),y+ lengthdir_y(24,gunangle) - 5){
    on_destroy = shell_destroy
    direction = other.gunangle;
    image_angle = other.gunangle;
    creator = other
    team = other.team
    hyperspeed = 8
}


#define create_bullet(_x,_y)
with instance_create(_x,_y,CustomProjectile){
	typ = 1
	creator = other
	team  = other.team
	image_yscale = .5
	trailscale = 1
	hyperspeed = 4
	sprite_index = mskNothing
	mask_index = mskBullet2
	force = 2
	damage = 3
	lasthit = -4
	dir = 0
	on_end_step 	 = sniper_step
	on_hit 		 = void
	return id
}


#define shell_destroy
x += lengthdir_x(hyperspeed,direction)
y += lengthdir_y(hyperspeed,direction)
instance_create(x,y,Explosion)
repeat(3) instance_create(x,y,SmallExplosion)
sound_play(sndExplosionL)
line()

#define sniper_step
with instance_create(x,y,CustomObject)
{
	depth = -1
	sprite_index = sprBullet1
	image_speed = .9
	on_step = muzzle_step
	on_draw = muzzle_draw
	image_yscale = .5
	image_angle = other.direction
}

do
{
	dir += hyperspeed
	x += lengthdir_x(hyperspeed,direction)
	y += lengthdir_y(hyperspeed,direction)
	//redoing reflection code since the collision event of the reflecters doesnt work in substeps (still needs slash reflection)
	with instances_matching_ne([CrystalShield,PopoShield], "team", team){if place_meeting(x,y,other){with other{line()};other.team = team;other.direction = point_direction(x,y,other.x,other.y);other.image_angle = other.direction;with instance_create(other.x,other.y,Deflect){image_angle = other.direction;sound_play_pitch(sndCrystalRicochet,random_range(.9,1.1))}}}
	with instances_matching_ne([EnergySlash,Slash,EnemySlash,EnergyHammerSlash,BloodSlash,GuitarSlash], "team", team){if place_meeting(x,y,other){with other{line()};other.team = team;other.direction = direction ;other.image_angle = other.direction}}
	with instances_matching_ne([Shank,EnergyShank], "team", team){if place_meeting(x,y,other){with other{instance_destroy();exit}}}
	with instances_matching_ne(CustomSlash, "team", team){if place_meeting(x,y,other){mod_script_call(on_projectile[0],on_projectile[1],on_projectile[2]);with other{line()};}}
	with instances_matching_ne(hitme, "team", team)
	{
		if distance_to_object(other) <= 4
		{
			with other
			{
			    projectile_hit(other,damage,force,direction)
			    instance_destroy()
			    exit
			}
		}
	}
	if place_meeting(x,y,Wall){instance_destroy()}
}
while instance_exists(self) and dir < 1000
instance_destroy()

#define void

#define line()
var dis = point_distance(x,y,xstart,ystart) + 1;
var num = 20;
for var i = 0; i <= num; i++{
        with instance_create(xstart+lengthdir_x(dis/num * i,direction),ystart + lengthdir_y(dis/num * i,direction),BoltTrail){
            image_angle = other.direction
            image_yscale = random(other.trailscale) * (i/num)
            image_xscale = dis/num
        }
}
xstart = x
ystart = y

#define muzzle_step
if image_index > 1{instance_destroy()}

#define muzzle_draw
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 1.5*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);

