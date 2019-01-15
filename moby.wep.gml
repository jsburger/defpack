#define init
global.sprMoby = sprite_add_weapon("sprites/sprMoby.png", 7, 2);
global.yellow = merge_color(c_yellow, c_white, .4)

#define weapon_name
return "MOBY";

#define weapon_sprt
return global.sprMoby;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load(w)
if is_object(w) return 5-w.charge/5
return 5;

#define weapon_cost(w)
if is_object(w) && w.charge > 20 && (!instance_is(self,Player) || ammo[1] > 1) return irandom(1)
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 14;

#define weapon_text
return "HEAVY OCEAN";

#define weapon_fire(w)
if !is_object(w){
    w = {
        wep: w,
        charge : 1,
        persist : 0,
        canbloom : 1
    }
}
else{
    if "charge" in w{
        w.charge = min(w.charge + 2/w.charge, 24)
        w.persist = 5
    }
    else{
        w.charge = 1
        w.persist = 5
        w.canbloom = 1
    }
}

with instance_create(x,y,Shell){motion_add(other.gunangle+other.right*100+random(80)-40,3+random(3))}
with create_bullet(x+lengthdir_x(20,gunangle),y+ lengthdir_y(20,gunangle)){
	on_destroy = shell_destroy
	direction = other.gunangle + random_range(-20,20)*other.accuracy*sqrt(w.charge)/6;
	olddirection = direction
	image_angle = direction;
	creator = other
	team = other.team
	flashang = other.gunangle
}
if w.canbloom {
    with instance_create(x+lengthdir_x(20,gunangle),y+ lengthdir_y(20,gunangle),CustomObject){
    	depth = -1
    	sprite_index = sprBullet1
    	image_speed = .8
    	on_step = muzzle_step
    	on_draw = muzzle_draw
    	image_yscale = .5
    	image_angle = other.gunangle
    }
    w.canbloom = 0
    weapon_post(5+random_range(w.charge * .04,-w.charge * .04),-3,2)
    sound_play_pitch(sndTripleMachinegun,.7 + w.charge * .02)
    sound_play(sndMinigun)

}
wep = w

#define step(w)
if w && is_object(wep) && wep.wep = mod_current goodstep(wep)
else if !w && is_object(bwep) && bwep.wep = mod_current goodstep(bwep)

if instance_number(Shell) > 100{
    var q = instances_matching(Shell,"speed",0)
    var l = array_length(q)
    var r = random_range(11, l)
    if l > 10 repeat(10){
        instance_delete(q[(--r)])
    }
}
if instance_number(BulletHit) > 100{
    var q = instances_matching(BulletHit,"speed",0)
    var l = array_length(q)
    var r = random_range(11, l)
    if l > 10 repeat(10){
        instance_delete(q[(--r)])
    }
}


#define goodstep(w)
w.canbloom = 1
if w.persist > 0{
    w.persist-= current_time_scale
}
else if w.charge > 1{
    if random(100) <= 50 * current_time_scale with instance_create(x+lengthdir_x(16,gunangle),y+lengthdir_y(16,gunangle),Smoke) {vspeed -= random(1); image_xscale/=2;image_yscale/=2; hspeed/=2}
    w.charge = max (w.charge - current_time_scale*.5, 1)
}


#define create_bullet(_x,_y)
with instance_create(_x,_y,CustomProjectile){
	typ = 1
	creator = other
	team  = other.team
	image_yscale = .5
	hyperspeed = 8
	sprite_index = mskNothing
	olddirection = 0
	mask_index = mskBullet2
	force = 4
	damage = 2
	lasthit = -4
	dir = 0
	recycle = (skill_get(mut_recycle_gland) && !irandom(2))
	on_end_step  = sniper_step
	on_hit 		 = void
	return id
}


#define shell_destroy
instance_create(x,y,BulletHit)
line()

#define sniper_step
var dist = 0
var l = 100
var _x = lengthdir_x(l, direction), _y = lengthdir_y(l, direction)
while !collision_line(x,y,x+_x,y+_y,Wall,1,1) && !collision_line(x,y,x+_x,y+_y,hitme,0,1) && dist <1000{
    x += _x
    y += _y
    dir += l
    dist += l
}

var _x = lengthdir_x(hyperspeed,direction), _y = lengthdir_y(hyperspeed,direction);
var shields = instances_matching_ne([CrystalShield,PopoShield], "team", team),
    slashes = instances_matching_ne([EnergySlash,Slash,EnemySlash,EnergyHammerSlash,BloodSlash,GuitarSlash], "team", team),
    shanks = instances_matching_ne([Shank,EnergyShank], "team", team),
    customslashes = instances_matching_ne(CustomSlash, "team", team)

do
{
    dir += hyperspeed
	dist += hyperspeed
	x += _x
	y += _y
	with shields {if place_meeting(x,y,other){with other{line()};other.team = team;other.direction = point_direction(x,y,other.x,other.y);other.image_angle = other.direction;with instance_create(other.x,other.y,Deflect){image_angle = other.direction;sound_play_pitch(sndCrystalRicochet,random_range(.9,1.1))}}}
	with slashes {if place_meeting(x,y,other){with other{line()};other.team = team;other.direction = direction ;other.image_angle = other.direction}}
	with shanks {if place_meeting(x,y,other){with other{instance_destroy();exit}}}
	with customslashes {if place_meeting(x,y,other){with other{line()};mod_script_call(on_projectile[0],on_projectile[1],on_projectile[2]);}}
	if direction != olddirection{
	    olddirection = direction
	    _x = lengthdir_x(hyperspeed,direction);
	    _y = lengthdir_y(hyperspeed,direction);
	    var shields = instances_matching_ne([CrystalShield,PopoShield], "team", team),
            slashes = instances_matching_ne([EnergySlash,Slash,EnemySlash,EnergyHammerSlash,BloodSlash,GuitarSlash], "team", team),
            shanks = instances_matching_ne([Shank,EnergyShank], "team", team),
            customslashes = instances_matching_ne(CustomSlash, "team", team)
	}

	var q = collision_point(x,y,hitme,0,0)
	if instance_exists(q) and projectile_canhit_np(q) and q.mask_index != mskNone{
	    if recycle{
	        instance_create(x,y,RecycleGland)
		    sound_play(sndRecGlandProc)
		    with creator{
		        ammo[1] = min(ammo[1]+1,typ_amax[1])
		    }
	    }
	    projectile_hit(q, damage, force, direction)
	    instance_destroy()
	    exit
	}
	/*with instances_matching_ne(hitme, "team", team)
	{
		if distance_to_object(other) <= 4
		{
			if other.recycle{
			    instance_create(x,y,RecycleGland)
			    sound_play(sndRecGlandProc)
			    with other.creator{
			        ammo[1] = min(ammo[1]+1,typ_amax[1])
			    }
			}
			with other{
			    projectile_hit(other,damage,force,direction)
			    instance_destroy()
			    exit
			}
		}
	}*/
    if place_meeting(x+_x,y+_y,Wall){
        instance_destroy()
        exit
    }
}
while instance_exists(self) and dist < 1000
instance_destroy()

#define void

#define line()
var w = floor((random_range(.34,1))*3)/3
with instance_create(xstart,ystart,BoltTrail){
    image_xscale = other.dir/random_range(1.75, 4)
    image_angle = other.direction
    image_yscale = w/2
}
xstart = x
ystart = y
with instance_create(x,y,BoltTrail){
    image_xscale = -other.dir/random_range(3,5)
    image_angle = other.direction
    image_yscale = w

}
dir = 0
/*var dis = point_distance(x,y,xstart,ystart) + 1;
var num = 20;
for var i = 0; i <= num; i++{
    
    with instance_create(xstart+lengthdir_x(dis/num * i,direction),ystart + lengthdir_y(dis/num * i,direction),BoltTrail){
        image_angle = other.direction
        image_yscale = floor(random(other.trailscale)*3)/3 * (i/num)
        image_xscale = dis/num
    }
}*/

#define muzzle_step
if image_index+.01 >= 1{instance_destroy()}

#define muzzle_draw
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2.5*image_xscale, 2*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);
