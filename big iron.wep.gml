#define init
global.sprBigIron = sprite_add_weapon("sprites/sprBigIron.png", 2, 4);

#define weapon_name
return "BIG IRON"

#define weapon_sprt
return global.sprBigIron;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 17;

#define weapon_cost
return 10;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return 13;

#define weapon_text
return "BIG SNEEZE";

#define weapon_fire
weapon_post(7,30,52)
sleep(24)
var _p = random_range(.7,1.3)
sound_play_pitch(sndSlugger,1.2*_p)
sound_play_pitch(sndDoubleShotgun,.8*_p)
sound_play_pitch(sndShotgun,.8*_p)
sound_play_pitch(sndHeavyNader,1.3*_p)
sound_play_pitch(sndMachinegun,.6*_p)
repeat(6)
{
with instance_create(x,y,Shell){motion_add(other.gunangle+90+random_range(-40,40),2+random(2))}
  with create_bullet(x+lengthdir_x(24,gunangle),y+ lengthdir_y(24,gunangle)){
      on_destroy = shell_destroy
      direction = other.gunangle + random_range(-14,14)*other.accuracy;
      image_angle = direction;
      creator = other
      team = other.team
  }
}

#define create_bullet(_x,_y)
with instance_create(_x,_y,CustomProjectile){
	typ = 1
	creator = other
	team  = other.team
	image_yscale = .5
	trailscale = 1
	hyperspeed = 8
	sprite_index = mskNothing
	mask_index = mskBullet2
	force = 2
	damage = 4
	lasthit = -4
	recycle = skill_get(mut_recycle_gland)
	dir = 0
	on_end_step  = sniper_step
	on_hit 		 = void
	return id
}


#define shell_destroy
x += lengthdir_x(hyperspeed,direction)
y += lengthdir_y(hyperspeed,direction)
instance_create(x,y,BulletHit)
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

while !collision_line(x,y,x+lengthdir_x(100,direction),y+lengthdir_y(100,direction),Wall,1,1) && !collision_line(x,y,x+lengthdir_x(100,direction),y+lengthdir_y(100,direction),hitme,0,1) && dir <1000{
    x+=lengthdir_x(100,direction)
    y+=lengthdir_y(100,direction)
    dir+=100
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
	with instances_matching_ne(CustomSlash, "team", team){if place_meeting(x,y,other){with other{line()};mod_script_call(on_projectile[0],on_projectile[1],on_projectile[2]);}}
	with instances_matching_ne(hitme, "team", team)
	{
        if distance_to_object(other) <= 4{
            with other{
                if recycle && irandom(2){
                    recycle--
                    with creator ammo[1] = min(ammo[1]+1,typ_amax[1])
                    sound_play(sndRecGlandProc)
                    with instance_create(x,y,RecycleGland) image_speed *= random_range(.8,1.2)
                }
                projectile_hit_np(other,damage,force,20)
                if other.my_health >= damage*3 || --damage <= 0{
                    instance_destroy()
                    exit
                }
            }
        }
	}
    if place_meeting(x+lengthdir_x(hyperspeed,direction),y+lengthdir_y(hyperspeed,direction),Wall){
        instance_destroy()
        exit
    }
}
while instance_exists(self) and dir < 1000
instance_destroy()

#define void

#define line()
var dis = point_distance(x,y,xstart,ystart);
var ang = point_direction(x,y,xstart,ystart)+180;
var num = 20;
for var i = 0; i <= num; i++{
    with instance_create(xstart+lengthdir_x(dis/num * i,direction),ystart + lengthdir_y(dis/num * i,direction),BoltTrail){
        image_angle = other.direction
        image_yscale = other.trailscale * (i/num)
        image_xscale = dis/num
    }
}
xstart = x
ystart = y

#define muzzle_step
if image_index > 1{instance_destroy()}

#define muzzle_draw
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2.5*image_xscale, 2*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);
