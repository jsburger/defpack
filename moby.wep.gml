#define init
global.sprMoby = sprite_add_weapon("sprites/weapons/sprMoby.png", 7, 2);
global.yellow = merge_color(c_yellow, c_white, .4)

#macro maxchrg 24

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

#define nts_weapon_examine
return{
    "d": "Ball bearings keep the barrel spinning for a bit after firing. ",
}


#define weapon_text
return "HEAVY OCEAN";

#define charge_base
return {
    maxcharge : maxchrg - 1,
    charge : 0,
    style : 0,
    width : 12,
    power : 1
}

#define weapon_fire(w)
if !is_object(w){
    w = {
        wep: w,
        charge : 1,
        persist : 0,
        canbloom : 1,
        defcharge : charge_base()
    }
    wep = w
}
else{
    var q = lq_defget(w, "charge", 1)
    w.charge = min(q + 2/q, maxchrg)
    w.persist = 15
}

with instance_create(x,y,Shell){motion_add(other.gunangle+other.right*100+random(80)-40,3+random(3))}

with create_bullet(x+lengthdir_x(20,gunangle),y+ lengthdir_y(20,gunangle)){
	on_destroy = shell_destroy
	direction = other.gunangle + random_range(-20,20)*other.accuracy*sqrt(w.charge)/6;
	olddirection = direction
	image_angle = direction;
	creator = other
	team = other.team
}

if lq_defget(w, "canbloom", 1){
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
    sound_play_pitch(sndTripleMachinegun,(.7 + w.charge * .02)*random_range(.95,1.05))
    sound_play(sndMinigun)
    sound_play_gun(sndClickBack, 0, 1 - (w.charge/(maxchrg*1.5)))
    sound_stop(sndClickBack)
}

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
    w.charge = max (w.charge - current_time_scale*.25, 1)
}
if lq_get(w, "defcharge") == undefined{
    w.defcharge = charge_base()
}
w.defcharge.charge = w.charge - 1


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
	damage = 3
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
	if instance_exists(q) and projectile_canhit_np(q) and q.mask_index != mskNone and q.my_health > 0{
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

#define muzzle_step
if image_index+.01 >= 1{instance_destroy()}

#define muzzle_draw
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2.5*image_xscale, 2*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);
