#define init
global.sprSniperPsyRifle = sprite_add_weapon("../../sprites/weapons/iris/psy/sprSniperPsyRifle.png", 5, 4);
global.sprPsyBullet 		 = sprite_add("../../sprites/projectiles/iris/psy/sprPsyMuzzle.png", 1, 8, 8);
global.sprPsyBulletHit   = sprite_add("../../sprites/projectiles/iris/psy/sprPsyBulletHit.png", 4, 8, 8);
// global.epic = 1
// mod_script_call_nc("mod","defpermissions","permission_register","weapon",mod_current,"epic","Psy Sniper Sight")

global.performanceCache = {};
global.lastTime = 0;

#macro lasercolor 14074

#define weapon_name
return "PSY SNIPER RIFLE"

#define weapon_chrg
return true;

#define weapon_sprt
return global.sprSniperPsyRifle;

#define weapon_type
return 1;

#define weapon_auto
return mod_script_call_nc("mod", "defpack tools", "sniper_weapon_auto", self)

#define weapon_load
return 20;

#define weapon_cost
return 12;

#define weapon_swap
return sndSwapMachinegun;

#define drawthing(x, y, l, ang)
var xx = lengthdir_x(l, ang), yy = lengthdir_y(l, ang)
draw_vertex(x + xx, y + yy)
draw_vertex(x - xx, y - yy);
// trace_time_bulk("drawing")


#define trace_time_bulk_start
global.performanceCache = {}
for (var i = 0; i < argument_count; i++) {
	lq_set(global.performanceCache, argument[i], 0)
}
global.lastTime = get_timer_nonsync()

#define trace_time_bulk(key)
var t = get_timer_nonsync();
lq_set(global.performanceCache, key, lq_get(global.performanceCache, key) + (t - global.lastTime))
global.lastTime = get_timer_nonsync()

#define trace_time_bulk_end
var acc = 0
for (var i = 0; i < lq_size(global.performanceCache); i += 1) {
	trace_color(lq_get_key(global.performanceCache, i) + ": " + string(lq_get_value(global.performanceCache, i)), c_gray)
	acc += lq_get_value(global.performanceCache, i)
}
trace_color("total: " + string(acc), c_gray)

#define weapon_laser_sight
with instances_matching(instances_matching(CustomObject, "name", "PsySniperCharge"), "creator", self) {
    with other {
        with mod_script_call_self("mod", "defpack tools", "sniper_fire", x, y, gunangle, team, 1 + other.charge/other.maxcharge, 1){
            draw_line_width_color(xstart, ystart, x, y, 1, 14074, 14074)
            instance_destroy()
        }
    }
    return false
}
return false;


#define weapon_reloaded
with mod_script_call("mod","defpack tools", "shell_yeah_long", 100, 8, 3+random(2),c_purple)
var _r = random_range(.8,1.2)
sound_play_pitchvol(sndSwapPistol,2*_r,.4)
sound_play_pitchvol(sndRecGlandProc,1.4*_r,1)
weapon_post(-2,-4,5)

#define weapon_area
return -1;

#define weapon_text
if !irandom(99) return "TEN THOUSAND PROGRAMMER HOURS"
return "insanity";


#define weapon_fire

with mod_script_call_self("mod", "defpack tools", "create_sniper_charge", x, y){
    name = "PsySniperCharge"
    creator = other
    team = other.team
    index = other.index
    cost = weapon_cost()
    on_fire = script_ref_create(psy_rifle_fire)
    spr_flash = global.sprPsyBullet
}

#define psy_rifle_fire
	var _ptch = random_range(-.5,.5)
	sound_play_pitch(sndHeavyRevoler,.7-_ptch/3)
	sound_play_pitch(sndCursedPickup,.6)
	sound_play_pitch(sndSniperFire,random_range(.6,.8))
	sound_play_pitch(sndHeavySlugger,1.3+_ptch/2)
	var _c = charge, _cc = charge/maxcharge;
	with creator{
		weapon_post(12,2,158)
		motion_add(gunangle -180, _c / 20)
		sleep(120)
		
		create_psy_sniper_shot(x, y, _c)
		
	}

#define create_psy_sniper_shot(x, y, _c)
	with mod_script_call("mod", "defhitscan", "create_psy_hitscan_bullet", x, y) {
		motion_set(other.gunangle, 8)
		image_angle = direction
		projectile_init(other.team, other)
		
		isSniper = true
		sight = 80
		minsight = 30
		radius = 6
		trailsize = 2
		recycle_amount = weapon_cost()
		damage = 20 + round(20*(_c/100))
		pierce = 100000
		
		return self
	}


#define psy_rifle_fire_old
var _ptch = random_range(-.5,.5)
sound_play_pitch(sndHeavyRevoler,.7-_ptch/3)
sound_play_pitch(sndCursedPickup,.6)
sound_play_pitch(sndSniperFire,random_range(.6,.8))
sound_play_pitch(sndHeavySlugger,1.3+_ptch/2)
var _c = charge, _cc = charge/maxcharge;
with creator{
	weapon_post(12,2,158)
	motion_add(gunangle -180,_c / 20)
	sleep(120)
	with instance_create(x+lengthdir_x(10,gunangle),y+lengthdir_y(10,gunangle),CustomProjectile){
		move_contact_solid(other.gunangle,18)
		typ = 1
		creator = other
		team  = other.team
		image_yscale = .5
		trailscale = 1 + (_c/110)
		hyperspeed = 8
		sprite_index = mskNothing
		mask_index = mskBullet2
		force = 7
		damage = 20 + round(20*(_c/100))
		lasthit = -4
		dir = 0
		recycleset = 0
		image_angle = other.gunangle
		direction = other.gunangle
		bangle = direction
		on_end_step = sniper_step
		on_destroy  = sniper_destroy
		on_hit 	    = void
	}
}
sleep(charge*3)


#define void

#define sniper_step
var trails = [];
var shields = instances_matching_ne([CrystalShield,PopoShield], "team", team),
    slashes = instances_matching_ne([EnergySlash,Slash,EnemySlash,EnergyHammerSlash,BloodSlash,GuitarSlash], "team", team),
    shanks = instances_matching_ne([Shank,EnergyShank], "team", team),
    customslashes = instances_matching_ne(CustomSlash, "team", team),
    enemies = instances_matching_ne(hitme, "team", team),
    olddirection = direction;

do
{
	dir += hyperspeed
	x += lengthdir_x(hyperspeed,direction)
	y += lengthdir_y(hyperspeed,direction)
	olddirection = direction
	with shields {if place_meeting(x,y,other){other.team = team;other.direction = point_direction(x,y,other.x,other.y);other.image_angle = other.direction;with instance_create(other.x,other.y,Deflect){image_angle = other.direction;sound_play_pitch(sndCrystalRicochet,random_range(.9,1.1))}}}
	with slashes {if place_meeting(x,y,other){other.team = team;other.direction = direction ;other.image_angle = other.direction}}
	with shanks  {if place_meeting(x,y,other){with other{instance_destroy();exit}}}
	with customslashes {if place_meeting(x,y,other){mod_script_call_self(on_projectile[0],on_projectile[1],on_projectile[2]);}}
	if direction != olddirection{
	    bangle = direction
        var shields = instances_matching_ne([CrystalShield,PopoShield], "team", team),
            slashes = instances_matching_ne([EnergySlash,Slash,EnemySlash,EnergyHammerSlash,BloodSlash,GuitarSlash], "team", team),
            shanks = instances_matching_ne([Shank,EnergyShank], "team", team),
            customslashes = instances_matching_ne(CustomSlash, "team", team),
            enemies = instances_matching_ne(hitme, "team", team);
	}

	var q = instance_nearest_matching_ne(x,y,hitme,"team",team);
	var reset = 1;
    var cap = 3*hyperspeed;
	if instance_exists(q){
	    if !collision_line(x - lengthdir_x(hyperspeed,direction),y - lengthdir_y(hyperspeed,direction),q.x,q.y,Wall,1,1){
            var ang1 = point_direction(x,y,q.x,q.y),
                ang2 = angle_difference(direction,ang1);
            if abs(ang2) < 90{
                direction -= clamp(ang2,-cap,cap)
                reset = 0
            }
	    }
	}
	if reset{
	    direction -= clamp(angle_difference(direction,bangle),-cap,cap)
	}
	with instance_create(x,y,BoltTrail){
	    image_xscale = other.hyperspeed
	    image_yscale = other.trailscale
	    image_blend = c_fuchsia
	    image_angle = other.direction
	    array_push(trails,id)
	}

	with enemies{
		if mask_index != mskNone and distance_to_object(other) <= other.trailscale * 3 and other.lasthit != id{
			with other{
                projectile_hit(other,damage,force,direction)
                lasthit = other
                view_shake_at(x,y,12)
                sleep(20)
                if skill_get(16) = true && recycleset < weapon_cost() and !irandom(1){
				    recycleset += 2;
				    instance_create(x,y,RecycleGland);
				    sound_play(sndRecGlandProc);
				    creator.ammo[1] = min(creator.ammo[1] + 2, creator.typ_amax[1])
			    }
			}
		}
	}
	if place_meeting(x,y,Wall){instance_destroy()}
}
while instance_exists(self) and dir < 1000
instance_destroy()
var a = array_length(trails);
for var i = 0; i < a; i++{
    with trails[i]{
        image_yscale *= i/a
    }
}


#define instance_nearest_matching_ne(_x,_y,obj,varname,value)
var num = instance_number(obj),
    man = instance_nearest(_x,_y,obj),
    mans = [],
    n = 0,
    found = -4;
if instance_exists(obj){
    while ++n <= num && variable_instance_get(man,varname) = value || (instance_is(man,prop) && !instance_is(man,Generator)){
        man.x += 10000
        array_push(mans,man)
        man = instance_nearest(_x,_y,obj)
    }
    if variable_instance_get(man,varname) != value && (!instance_is(man,prop) || instance_is(man,Generator)) found = man
    with mans x-= 10000
}
return found


#define sniper_destroy
with instance_create(x,y,BulletHit) sprite_index = global.sprPsyBulletHit
