#define init
global.lasertank = sprite_add("LaserTank.png",14,11,7)

// /gml mod_script_call("mod","laser tank","tank_create",mouse_x,mouse_y)
#define tank_create(_x,_y)
var tank = instance_create(_x,_y,CustomHitme);
with tank{
	sprite_index = global.lasertank
	on_step = tankstep
	on_draw = tankdraw
	on_hurt = tankhit
	on_destroy = tankbreak
	on_end_step = tankendstep
	on_begin_step = tankbeginstep
	driver = noone
	image_speed = 0
	doortime = 0
	maxspeed = 6
	maxhealth = 1000
	my_health = maxhealth
	spr_shadow = shd32
	reload = 0
	breload = 0
	gunangle = direction
	team = -1
	size = 2
	friction = .08
	portalmode = 0
	hurt = 0
	length = 10
	turnspeed = 0
	ammotype = 1
	ammocost = 2
	sub_fire = script_ref_create(machinegun_sub)
	sub_gun = wep_machinegun
	main_gun = "tank cannon"
	sf = surface_create(100,100)
}
return tank

#define dismount
mask_index = tankthings[0]
image_alpha = tankthings[1]
maxspeed = tankthings[2]
spr_shadow = tankthings[3]
wep = tankthings[5]
bwep = tankthings[6]
canwalk = 1
driving = 0
canswap = 1
my_health = tankthings[4]
canspec = 1
other.driver = noone

#define mount
tankthings = [mask_index,image_alpha,maxspeed,spr_shadow,my_health,wep,bwep]
image_alpha = 0
wep = other.main_gun
bwep = other.sub_gun
spr_shadow = mskNone
maxspeed = 10000
driving = 1
canspec = 0
canswap = 0
canwalk = 0
other.driver = id
other.team = team


#define step
//LAST RESORT FOR RESETTING PLAYER STATS IF THERE ARE NO tankS
with Player if "tankthings" in self && driving{
    if !array_length_1d(instances_matching(CustomHitme,"driver",id))
        with instance_create(x,y,CustomObject){
            with other
                dismount()
            instance_destroy()
        }
}

if button_pressed(0,"horn") tank_create(mouse_x,mouse_y)

#define tankbeginstep
if doortime > 0 {doortime -=1}
with Player if distance_to_object(other) < 15{
    if "driving" not in self driving = 0
	//ENTERING tank AND SETTING STATS(i optimized this by just making it a function)
	if button_pressed(index,"pick") && other.doortime = 0 && other.driver = noone && !driving{
		mount()
	}
}


#define tankstep
//PREVENTING GHOSTS FROM STEALING tankS
if !instance_exists(driver) driver = noone

//PREVENTING PEOPLE FROM DRIVING MULTIPLE tankS
if driver != noone with instances_matching(CustomHitme,"driver",driver){
	if id != other {driver = noone}
}

//BEING DRIVEN
if instance_exists(driver) && instance_is(driver,Player){
	if !portalmode{
		//ENGINE SOUNDS
		sound_play_pitchvol(sndExplosionS,.1 + .01*speed,.4)
		sound_play_pitchvol(sndExplosion,.1,.4)
		breload = max(breload - current_time_scale, 0)
		reload = max(reload - current_time_scale, 0)
		//gunangle += clamp(angle_difference(driver.gunangle,gunangle)*current_time_scale,-10*current_time_scale,10*current_time_scale)
		gunangle = driver.gunangle
	}
	//MOVEMENT
	if button_check(driver.index,"west"){
		motion_add(180,current_time_scale*.75)
	}
	if button_check(driver.index,"sout"){
		motion_add(270,current_time_scale*.75)
	}
	if button_check(driver.index,"nort"){
		motion_add(90,current_time_scale*.75)
	}
	if button_check(driver.index,"east"){
		motion_add(0,current_time_scale*.75)
	}
	image_angle = direction + 180
	if speed > maxspeed {speed = maxspeed}
	//PORTAL MODE
	if instance_exists(Portal){
		with driver{
			if distance_to_object(instance_nearest(x,y,Portal)) <=50 || instance_exists(BigPortal){
				other.portalmode = 1
			}
			else{
				other.portalmode = 0
			}
		}
	}
	if portalmode{
		persistent = 1
		x = driver.x
		y = driver.y
		driver.canwalk = 1
		driver.maxspeed = driver.tankthings[2]
		image_angle = driver.angle + driver.direction + 180
	}
	else{
		driver.x = x + hspeed_raw
		driver.y = y + vspeed_raw
		driver.canwalk = 0
		driver.maxspeed = 10000
		driver.speed = 0
		persistent = 0
	}
	if portalmode && !instance_exists(GenCont)&& !instance_exists(Portal) && !instance_exists(mutbutton){
		portalmode = 0
	}
	//tank prevents damage but not death
	driver.my_health = driver.maxhealth
	driver.nexthurt = current_frame + 2
	//LEAVING THE tank AND RESETTING STATS
	if button_pressed(driver.index,"pick") && doortime = 0{
		with driver{
			dismount()
		}
		doortime = 5
		driver = noone
	}
}else{
	//i dont know why i needed this
	image_angle = direction + 180
	persistent = 0
}

if place_meeting(x+hspeed_raw,y+vspeed_raw,Wall){
	//kill walls
	with instance_nearest(x + hspeed_raw,y+vspeed_raw,Wall){
		with instance_create(x,y,FloorExplo){
			with Debris if place_meeting(x,y,other){
				instance_destroy()
			}
		}
		instance_destroy()
	}
	my_health -=1
}

if my_health/maxhealth < 3/4{
	//smoke indicates damage
	if random(2) > (my_health/maxhealth){
		with instance_create(x-lengthdir_x(10,direction),y - lengthdir_y(10,direction),Smoke){
			motion_set(random_range(60,120),2+random(2))
			image_xscale = .5
			image_yscale = .5
			depth = other.depth
		}
	}
}

if my_health <= 0 {
	instance_destroy()
}

#define tankendstep
if floor(speed) > 0{
	var q = collision_circle(x+hspeed + lengthdir_x(length,direction),y+vspeed+ lengthdir_y(length,direction),5,hitme,0,1);
	if q!= noone && q.team != team && !instance_is(q,NothingInactive) && projectile_canhit_melee(q){
		projectile_hit(q,floor(speed*2),speed*2,point_direction(x,y,q.x,q.y))
		sound_play_pitchvol(sndImpWristHit,1,5)
	}
}
if !portalmode && instance_exists(driver){
    //machineguns
    if button_check(driver.index,"spec") && (driver.ammo[ammotype] >= ammocost || driver.infammo != 0) && breload <= 0{
    	if driver.infammo = 0 driver.ammo[ammotype]-=ammocost
    	mod_script_call(sub_fire[0],sub_fire[1],sub_fire[2])
    }
}

//tank takes damage
#define tankhit(damage, kb_vel, kb_dir)
my_health -= damage;
hurt = 1
sound_play(sndHitMetal)

#define tankbreak
if driver != noone with driver{
    dismount()
}
instance_create(x,y,Explosion)
repeat(3) instance_create(x,y,SmallExplosion)
sound_play(sndExplosionCar)
surface_destroy(sf)

#define tankdraw
var i;
var yoff = 0//random_range(-.5,.5) + 5;
if driver = noone{yoff = 5}
if hurt d3d_set_fog(1,c_white,1,1)
surface_set_target(sf)
draw_clear_alpha(0,0)
for (i = 0; i < 10; i++){
	draw_sprite_ext(global.lasertank, i , 50, 50 + yoff - i,image_xscale, image_yscale, image_angle, image_blend, 1);
}
if my_health/maxhealth < .1 draw_sprite(sprGroundFlame,current_frame*.4,50+lengthdir_x(8,image_angle),50+lengthdir_y(8,image_angle)-yoff)
var ang = image_angle
for (i = i; i<14; i++){
	draw_sprite_ext(global.lasertank, i , 50 + lengthdir_x(5,gunangle), 50 + lengthdir_y(5,gunangle) + yoff - i,image_xscale, image_yscale, gunangle+180, image_blend, 1);
}
surface_reset_target()
d3d_set_fog(1,0,0,0)
for (var o = 0; o <360; o+=90){
    draw_surface(sf,x-50+lengthdir_x(1,o),y-50+lengthdir_y(1,o))
}
d3d_set_fog(0,0,0,0)
draw_surface(sf,x-50,y-50)
hurt = max(hurt-current_time_scale,0)



#define machinegun_sub
sound_play(sndHeavyMachinegun)
sound_play_pitch(sndShotgun,1+random(.1))
breload = 3
var angle = gunangle;
for (var i = -1; i<= 1; i+=2){
    with create_bullet(x + hspeed_raw + lengthdir_x(4,angle+(90*i)) + lengthdir_x(10,angle), y + vspeed_raw + lengthdir_y(4,angle+(90*i)) + lengthdir_y(10,angle) - 5){
        direction = angle;
        image_angle = angle;
        creator = other.driver
        team = other.driver.team
        hyperspeed = 8
    }
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
	effected = 0
	dir = 0
	dd = 0
	recycleset = 0
	if irandom(2)=0 recycleset = 1
	on_step 	 = sniper_step
	on_destroy = sniper_destroy
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
if !effected with instance_create(x,y,CustomObject)
{
	depth = -1
	sprite_index = sprBullet1
	image_speed = .9
	on_step = muzzle_step
	on_draw = muzzle_draw
	image_yscale = .5
	image_angle = other.direction
	other.effected = 1
}
while !collision_line(x,y,x+lengthdir_x(100,direction),y+lengthdir_y(100,direction),Wall,1,1) && !collision_line(x,y,x+lengthdir_x(100,direction),y+lengthdir_y(100,direction),hitme,0,1) && dir <500{
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
	with instances_matching_ne(CustomSlash, "team", team){if place_meeting(x,y,other){mod_script_call(on_projectile[0],on_projectile[1],on_projectile[2]);with other{line()};}}
	var q = collision_point(x,y,hitme,0,1);
	if instance_exists(q) && projectile_canhit_np(q)
	{
		projectile_hit(q,damage,force,direction)
		if skill_get(16) = true && recycleset = 0{
		    recycleset = 1;
		    instance_create(xstart,ystart,RecycleGland);
		    sound_play(sndRecGlandProc);
		    creator.ammo[1] = min(creator.ammo[1] + 1, creator.typ_amax[1])
	    }
	    instance_destroy()
	    exit
	}
	if place_meeting(x,y,Wall){instance_destroy()}
}
while instance_exists(self) and dir < 500
instance_destroy()

#define void

#define line()
var dis = point_distance(x,y,xstart,ystart) + 1;
var num = 20;
for var i = 0; i <= num; i++{
    if !irandom(1){
        with instance_create(xstart+lengthdir_x(dis/num * i,direction),ystart + lengthdir_y(dis/num * i,direction),BoltTrail){
            image_angle = other.direction
            image_yscale = other.trailscale * (i/num)
            image_xscale = dis/num
        }
    }
}
xstart = x
ystart = y

#define sniper_destroy
instance_create(x,y,BulletHit)
line()

#define muzzle_step
if image_index > 1{instance_destroy()}

#define muzzle_draw
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 1.5*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);
