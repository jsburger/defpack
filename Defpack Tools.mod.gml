#define init
global.sprPsyBullet = sprite_add("Psy Bullet.png", 2, 8, 8)
global.mskPsyBullet = sprite_add("Psy Bullet Mask.png", 0, 7, 3)
global.sprPsyBulletHit = sprite_add("Psy Bullet Hit.png", 4, 8, 8)
global.sprPsyPellet = sprite_add("Psy Pellet.png", 2, 8, 8);
global.sprPsyPelletDisappear = sprite_add("Psy Pellet Disappear.png", 5, 8, 8);
global.sprMagPellet = sprite_add("Magnet Pellet.png", 2, 8, 8);
global.sprMagPelletDisappear = sprite_add("Magnet Pellet Dissapear.png", 5, 8, 8);
global.sprHeavyMagPellet = sprite_add("Heavy Magnet Pellet.png", 2, 9, 9);
global.sprHeavyMagPelletDisappear = sprite_add("Heavy Magnet Pellet Dissapear.png", 5, 9, 8);
global.sprLightningBullet = sprite_add("Lightning Bullet.png", 2, 8, 8)
global.sprLightningBulletHit = sprite_add("Lightning Bullet Hit.png", 4, 8, 8)
global.sprToxicBullet = sprite_add("Toxic Bullet.png", 2, 8, 8)
global.sprToxicBulletHit = sprite_add("Toxic Bullet Hit.png", 4, 8, 8)
global.sprFireBullet = sprite_add("Fire Bullet.png", 2, 8, 8)
global.sprFireBulletHit = sprite_add("Fire Bullet Hit.png", 4, 8, 8)
global.sprDarkBullet = sprite_add("Dark Bullet.png", 2, 8, 8)
global.mskDarkBullet = sprite_add("Dark Bullet Mask.png", 0, 2.5, 4.5)
global.sprDarkBulletHit = sprite_add("Dark Bullet Hit.png", 4, 8, 8)
global.sprDarkSmallExplosion = sprite_add("Dark Small Explosion.png",7,12,12)
global.sprLightBullet = sprite_add("Light Bullet.png", 2, 8, 8)
global.sprLightBulletHit = sprite_add("Light Bullet Hit.png", 4, 8, 8)

global.sprSonicExplosion = sprite_add("Soundwave_strip8.png",8,61,59);
global.mskSonicExplosion = sprite_add("mskSonicExplosion_strip9.png",9,32,32);

global.sprGenShell = sprite_add("Generic Shell.png",0, 1.5, 2.5);

global.stripes = sprite_add("BIGstripes.png",1,1,1)

global.pi = 3.14159265359
#define bullet_hit
projectile_hit(other, damage, force, direction);
if instance_exists(creator) if recycle_amount != 0 && irandom(9) <= 5 && skill_get(16){
	creator.ammo[1]+=recycle_amount
	if creator.ammo[1] > creator.typ_amax[1] {creator.ammo[1] = creator.typ_amax[1]}
	sound_play_pitchvol(sndRecGlandProc, 1, 7)
}
if instance_exists(creator) if recycle_amount != 0 && skill_get("recycleglandx10"){
	creator.ammo[1]+= 10*recycle_amount
	if creator.ammo[1] > creator.typ_amax[1] {creator.ammo[1] = creator.typ_amax[1]}
	sound_play_pitchvol(sndRecGlandProc, 1, 7)
}
if name = "Dark bullet"{sleep(80)}
instance_destroy()

#define bullet_step
if image_index = 1{
	image_speed = 0
}
if pattern = "helix"
{
	if cycle < 359{cycle += 9}else{cycle = 0}
	direction = dsin(cycle*global.pi)*(32-skill_get(19)*20)*dir+_direction
	image_angle = direction
}
if pattern = "tree"
{
	if timer1 > 0{timer1--}else
	{
		dir *= -1
		motion_set(direction+newdir*dir,speed)
		newdir = 0
		image_angle = direction
		newdir2 = 45
		if timer2 > 0{timer2--}else
		{
			if irandom(9) != 0 motion_set(direction+newdir2*dir*-1,speed)
			image_angle = direction
			newdir2 = 0
			timer1 = choose(10,12,12,15)
			newdir1 = 45
		}
	}
}
if pattern = "wide"
{
	motion_add(direction+range*dir*creator.accuracy,speed)
	if range > 1{range /= 1.05}
	if speed > _spd{speed = _spd}
	image_angle = direction
}
if pattern = "cloud"
{
	if instance_exists(parent){motion_add(point_direction(x,y,parent.x,parent.y)+50,_spd*radius)}
	image_angle = direction
	if speed > _spd{speed = _spd}
	if irandom(79) = 0{parent = -99999}
}
#define bullet_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.1);
draw_set_blend_mode(bm_normal);

#define create_psy_bullet(_x,_y)
var a = instance_create(_x, _y, CustomProjectile)
with (a) {
	name = "Psy Bullet"
	pattern = false
	sprite_index = global.sprPsyBullet
	typ = 2
	damage = 6
	recycle_amount = 2
	force = 10
	image_speed = 1
	image_angle = direction
	mask_index = global.mskPsyBullet
	timer = 11 + irandom(8)
	maxspeed = 5
	image_yscale = 1.2
	image_xscale = 1.2
	on_step = script_ref_create(psy_step)
	on_destroy = script_ref_create(psy_destroy)
	on_hit = script_ref_create(bullet_hit)
	on_draw = script_ref_create(bullet_draw)
}
return a;

#define psy_step
if timer > 0{
	timer -= 1
}
if timer = 0 && instance_exists(enemy){
	var closeboy = instance_nearest(x,y,enemy)
	if collision_line(x,y,closeboy.x,closeboy.y,Wall,0,0) < 0 && distance_to_object(closeboy) < 220{
	var dir, spd, dmp, rot;

	dir = point_direction(x, y, closeboy.x, closeboy.y);
	spd = max(11, 0);
	dmp = clamp(.3, 0, .8);

	direction -= clamp(angle_difference(image_angle, dir) * dmp, -spd, spd); //Smoothly rotate to aim position.
image_angle = direction
	}
	if speed > maxspeed
	{
		speed = maxspeed
	}
}
mod_script_call("mod","defpack tools","bullet_step")

#define psy_destroy
with instance_create(x,y,BulletHit){
	sprite_index = global.sprPsyBulletHit
	image_angle = other.direction + 180
}
if place_meeting(x + hspeed,y +vspeed,Wall){sound_play_pitchvol(sndHitWall,1,100/distance_to_object(creator))}


#define create_psy_shell(_x,_y)
var b = instance_create(_x, _y, CustomProjectile)
with (b){
	name = "Psy Shell"
	sprite_index = global.sprPsyPellet
	image_angle = direction
	mask_index = mskBullet2
	fric2 = 1.5
	fric = random_range(1.07,1.2)
	wallbounce = skill_get(15) * 5 + (skill_get("shotgunshouldersx10")*50)
	force = 4
	recycle_amount = 0
	image_speed = 1
	damage = 4
	timer = 5 + irandom(4)
	og_timer = timer
	speedset = 0
	maxspeed = 7
	on_hit = script_ref_create(bullet_hit)
	on_draw = script_ref_create(psy_shell_draw)
	on_step = script_ref_create(psy_shell_step)
	on_destroy = script_ref_create(psy_shell_destroy)
}
return b;

#define psy_shell_step
if speedset = 0
{
	move_bounce_solid(false)
	speed/= fric
	if speed < 1.00005{speedset = 1}
}
else
{
	if instance_exists(enemy)
	{
		var closeboy = instance_nearest(x,y,enemy)
		if instance_exists(enemy){
			var closeboy = instance_nearest(x,y,enemy)
			if collision_line(x,y,closeboy.x,closeboy.y,Wall,0,0) < 0 && distance_to_object(closeboy) < 200{
				motion_add(point_direction(x,y,closeboy.x,closeboy.y),1.2 * (1 + skill_get(15)))
				motion_add(direction,-.03  * (1 + skill_get(15)))
			}
		}
		motion_add(direction,1.2* (1 + skill_get(15)))
		speed -= fric2
		if speed > maxspeed{speed = maxspeed}
	}
	else motion_add(direction,.5)
}
if image_index >= 1{image_speed = 0}
image_angle = direction
if place_meeting(x + hspeed, y, Wall){
	hspeed /= -1.25
	if speed + wallbounce >= 18{
		speed = 18
	}
	else{
		speed += wallbounce
	}
	wallbounce /= 1.05
	instance_create(x,y,Dust)
	sound_play_pitchvol(sndShotgunHitWall, 1, 50/distance_to_object(creator))
	if speed < 1{
}
image_angle = direction
if place_meeting(x, y + vspeed, Wall){
	vspeed /= -1.25
	if speed + wallbounce >= 18{
		speed = 18
	}
	else{
		speed += wallbounce
	}
	wallbounce /= 1.05
	instance_create(x,y,Dust)
	sound_play_pitchvol(sndShotgunHitWall, 1, 50/distance_to_object(creator))
	image_angle = direction
}
if place_meeting(x + hspeed, y + vspeed, Wall){
	direction += 180
	speed /= 1.25
	if speed + wallbounce >= 18{
		speed = 18
	}
	else{
		speed += wallbounce
	}
	wallbounce /= 1.05
	instance_create(x,y,Dust)
	sound_play_pitchvol(sndShotgunHitWall, 1, 50/distance_to_object(creator))
}
	instance_destroy()
}

#define psy_shell_destroy
with instance_create(x,y,BulletHit){
	sprite_index = global.sprPsyPelletDisappear
	speed = other.speed/5
	direction = other.direction
	image_angle = direction
}

#define psy_shell_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.2);
draw_set_blend_mode(bm_normal);

#define create_split_shell(_x,_y)
var c = instance_create(_x, _y, CustomProjectile)
with (c){
	name = "Split Shell"
	sprite_index = global.sprMagPellet
	friction = random_range(.50,.54)
	image_angle = direction
	mask_index = mskBullet2
	wallbounce = skill_get(15) + (skill_get("shotgunshouldersx10")*50)
	force = 4
	ammo = 2
	lasthit = -99999
	recycle_amount = 0
	image_speed = 1
	damage = 3
	lifetime = room_speed*8 //since shotgun shoulders synergy is mad
	timer = 5 + irandom(4)
	og_timer = timer
	on_hit = script_ref_create(mag_hit)
	on_draw = script_ref_create(mag_shell_draw)
	on_step = script_ref_create(mag_shell_step)
	on_destroy = script_ref_create(mag_shell_destroy)
}
return c;

#define mag_hit
speed /= 1.05
if lasthit != other.id
{
	projectile_hit(other, damage, force, direction);
	if ammo > 0
	{
		ammo -= 1
		direction = random(359)
		image_xscale /= 1.25
		with mod_script_call("mod","defpack tools","create_split_shell",x,y)
		{
			creator = other.creator
			image_xscale = other.image_xscale
			team = other.team
			ammo = other.ammo
			motion_add(other.direction + random_range(-80,80),random_range(12,14))
			image_angle = direction
		}
	}
}
lasthit = other.id

#define mag_shell_step
if ammo >= 3{sprite_index = global.sprHeavyMagPellet}
else{sprite_index = global.sprMagPellet}
if lifetime > 0{lifetime--}else{instance_destroy();exit}
image_yscale = image_xscale
if timer > 0{
	timer -= 1
}
if timer = (og_timer - 2){
	damage -= 1
}
image_angle = direction
if image_index >= 1{
	image_speed = 0
}
if place_meeting(x + hspeed, y, Wall){
	hspeed *= -1
	if speed + wallbounce >= 14{
		speed = 14
	}
	else{
		speed += wallbounce
	}
	wallbounce /= .8
	instance_create(x,y,Smoke)
	sound_play_pitchvol(sndShotgunHitWall, 1, 50/distance_to_object(creator))
	image_angle = direction
	move_bounce_solid(false)
	if ammo > 0
	{
		ammo -= 1
		if sprite_index != global.sprHeavyMagPellet{image_xscale /= 1.25}
		with mod_script_call("mod","defpack tools","create_split_shell",x,y){
			creator = other.creator
			image_xscale = other.image_xscale
			team = other.team
			ammo = other.ammo
			motion_add(other.direction + random_range(-40,40)*creator.accuracy,random_range(12,14))
			image_angle = direction
		}
	}
}
if place_meeting(x, y + vspeed, Wall){
	vspeed *= -1
	if speed + wallbounce >= 14{
		speed = 14
	}
	else{
		speed += wallbounce
	}
	wallbounce /= .8
	instance_create(x,y,Smoke)
	sound_play_pitchvol(sndShotgunHitWall, 1, 50/distance_to_object(creator))
	image_angle = direction
	move_bounce_solid(false)
	if ammo > 0
	{
		ammo -= 1
		if sprite_index != global.sprHeavyMagPellet{image_xscale /= 1.25}
		with mod_script_call("mod","defpack tools","create_split_shell",x,y){
			creator = other.creator
			image_xscale = other.image_xscale
			team = other.team
			ammo = other.ammo
			motion_add(other.direction + random_range(-40,40)*creator.accuracy,random_range(12,14))
			image_angle = direction
		}
	}
}
if place_meeting(x + hspeed, y + vspeed, Wall){
	direction += 180
	if speed + wallbounce >= 14{
		speed = 14
	}
	else{
		speed += wallbounce
	}
	wallbounce /= .8
	instance_create(x,y,Smoke)
	sound_play_pitchvol(sndShotgunHitWall, 1, 50/distance_to_object(creator))
	image_angle = direction
	move_bounce_solid(false)
	if ammo > 0
	{
		ammo -= 1
		if sprite_index != global.sprHeavyMagPellet{image_xscale /= 1.25}
		with mod_script_call("mod","defpack tools","create_split_shell",x,y){
			creator = other.creator
			image_xscale = other.image_xscale
			team = other.team
			ammo = other.ammo
			motion_add(other.direction + random_range(-40,40)*other.creator.accuracy,random_range(12,14))
			image_angle = direction
		}
	}
}
if speed < 2{instance_destroy()}

#define mag_shell_destroy
with instance_create(x,y,BulletHit){
	image_xscale = other.image_xscale
	image_yscale = image_xscale
	sprite_index = global.sprMagPelletDisappear
	if other.sprite_index = global.sprHeavyMagPellet {sprite_index = global.sprHeavyMagPelletDisappear}
	speed = other.speed/5
	direction = other.direction
	image_angle = direction
}

#define mag_shell_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.2);
draw_set_blend_mode(bm_normal);

#define create_lightning_bullet(_x,_y)
var c =instance_create(_x, _y, CustomProjectile)
with (c){
	name = "Lightning Bullet"
	pattern = false
	sprite_index = global.sprLightningBullet
	typ = 2
	mask_index = mskBullet1
	force = 7
	damage = 2
	recycle_amount = 2
	image_speed = 1
	image_angle = direction
	on_step = script_ref_create(lightning_step)
	on_destroy = script_ref_create(lightning_destroy)
	on_hit = script_ref_create(bullet_hit)
	on_draw = script_ref_create(bullet_draw)
}
return c;

#define lightning_step
if irandom(17) = 1{
	with instance_create(x,y,Lightning){
      	image_angle = random(360)
      	team = other.team
		creator = other.creator
      	ammo = choose(1,2)
		alarm0 = 1
		visible = 0
      	with instance_create(x,y,LightningSpawn)
        {
      	   image_angle = other.image_angle
        }
    }
}
mod_script_call("mod","defpack tools","bullet_step")

#define lightning_destroy
with instance_create(x,y,Lightning){
	image_angle = random(360)
	creator = other.creator
	team = other.team
	ammo = 6
	alarm0 = 1
	visible = 0
	with instance_create(x,y,LightningSpawn)
	{
	   image_angle = other.image_angle
	}
	sound_play_pitchvol(sndHitWall,1,100/distance_to_object(creator))
}
with instance_create(x,y,BulletHit){
	direction = other.direction
	sprite_index = global.sprLightningBulletHit
}

#define create_toxic_bullet(_x,_y)
var d = instance_create(_x, _y, CustomProjectile)
with (d) {
	name = "Toxic Bullet"
	pattern = false
	sprite_index = global.sprToxicBullet
	typ = 1
	force = 8
	mask_index = mskBullet1
	damage = 3
	recycle_amount = 2
	image_speed = 1
	image_angle = direction
	on_step = script_ref_create(bullet_step)
	on_destroy = script_ref_create(toxic_destroy)
	on_hit = script_ref_create(bullet_hit)
	on_draw = script_ref_create(bullet_draw)
}
return d;

#define toxic_destroy
repeat(2){
	instance_create(x,y,ToxicGas)
}
with instance_create(x,y,BulletHit){
	sprite_index = global.sprToxicBulletHit
	direction = other.direction
}
if place_meeting(x + hspeed,y +vspeed,Wall){sound_play_pitchvol(sndHitWall,1,100/distance_to_object(creator))}

#define create_fire_bullet(_x,_y)
var e = instance_create(_x, _y, CustomProjectile)
with (e){
	name = "Fire Bullet"
	pattern = false
	sprite_index = global.sprFireBullet
	typ = 1
	force = 7
	mask_index = mskBullet1
	damage = 3
	recycle_amount = 2
	image_speed = 1
	image_angle = direction
	on_step = script_ref_create(fire_step)
	on_destroy = script_ref_create(fire_destroy)
	on_hit = script_ref_create(bullet_hit)
	on_draw = script_ref_create(bullet_draw)
}
return e;

#define fire_step
if irandom(12) = 1{
	with instance_create(x,y,Flame){
		team = other.team
		creator = other.creator
	}
}
mod_script_call("mod","defpack tools","bullet_step")

#define fire_destroy
repeat(3){
	with instance_create(x,y,Flame){
		team = other.team
		creator = other.creator
		motion_set(random(360),random_range(0.6,1.2))
	}
}
with instance_create(x,y,BulletHit){
	sprite_index = global.sprFireBulletHit
	direction = other.direction
}
if place_meeting(x + hspeed,y +vspeed,Wall){sound_play_pitchvol(sndHitWall,1,100/distance_to_object(creator))}

#define create_dark_bullet(_x,_y)
var f = instance_create(_x, _y, CustomProjectile)
with (f){
	name = "Dark Bullet"
	pattern = false
	sprite_index = global.sprDarkBullet
	typ = 2
	mask_index =global.mskDarkBullet
	damage = 15
	force = 7
	offset = random(359)
	ringang = random(359)
	recycle_amount = 1
	image_speed = 1
	image_angle = direction
	on_step = script_ref_create(dark_step)
	on_destroy = script_ref_create(dark_destroy)
	on_hit = script_ref_create(bullet_hit)
	on_draw = script_ref_create(bullet_draw)
}
return f;

#define dark_step
mod_script_call("mod","defpack tools","bullet_step")
var t = team;
with instances_matching_ne(projectile,"team",team) if distance_to_object(other) <= 0{
	if "typ" in self && typ >= 1 && !instance_is(self,Grenade)
	{
		var ringang = random(359);
		with create_sonic_explosion(x,y)
		{
			var scalefac = random_range(0.26,0.3);
			image_xscale = scalefac
			image_yscale = scalefac
			damage = 2
			shake = 2
			image_speed = 0.85
			image_blend = c_black
			team = t
			candeflect = 0
		}
		repeat(3)
		{
			with create_sonic_explosion(other.x+lengthdir_x(other.speed*1.3,other.offset+ringang),other.y+lengthdir_y(other.speed*1.3,other.offset+ringang))
			{
				var scalefac = random_range(0.15,0.2);
				image_xscale = scalefac
				image_yscale = scalefac
				damage = 2
				shake = 2
				image_speed = 1
				image_blend = c_black
				team = t
				candeflect = 0
			}
			ringang += 120
		}
		instance_destroy()
	}

}
if speed <= 0
{
	instance_destroy()
}

#define dark_destroy
with instance_create(x,y,BulletHit){
	sprite_index = global.sprDarkBulletHit
	image_angle = other.direction + 180
}
with create_sonic_explosion(x,y){
	team = other.team
	var scalefac = random_range(0.37,0.4);
	image_xscale = scalefac
	image_yscale = scalefac
	candeflect = 0
	shake = 5
	damage = 8
	image_speed = 0.8
	image_blend = c_black
}
if place_meeting(x + hspeed,y +vspeed,Wall){sound_play_pitchvol(sndHitWall,1,100/distance_to_object(creator))}

#define create_light_bullet(_x,_y)
var g = instance_create(_x, _y, CustomProjectile)
with (g){
	name = "Light Bullet"
	pattern = false
	sprite_index = global.sprLightBullet
	typ = 0
	mask_index = mskBullet1
	force = 2
	damage = 3
	recycle_amount = 1
	pierces = 6
	image_speed = 1
	image_angle = direction
	on_step = script_ref_create(light_step)
	on_destroy = script_ref_create(light_destroy)
	on_hit = script_ref_create(light_hit)
	on_draw = script_ref_create(bullet_draw)
}
return g;

#define light_hit
if (projectile_canhit_melee(other)){
	projectile_hit(other, damage, force, direction);
	pierces -= 1
}
//apparently this being wrong is being balanced around, so ill leave it be i suppose
if irandom(5) = 5 && skill_get(16){
	creator.ammo[1]+=recycle_amount
	if creator.ammo[1] > creator.typ_amax[1] {creator.ammo[1] = creator.typ_amax[1]}
	sound_play_pitchvol(sndRecGlandProc, 1, 7)
}
if !irandom(1) && skill_get("recycleglandx10"){
	creator.ammo[1]+=10*recycle_amount
	if creator.ammo[1] > creator.typ_amax[1] {creator.ammo[1] = creator.typ_amax[1]}
	sound_play_pitchvol(sndRecGlandProc, 1, 7)
}

#define light_step
mod_script_call("mod","defpack tools","bullet_step")
if pierces = 0{
	instance_destroy()
}

#define light_destroy
with instance_create(x,y,BulletHit){
	sprite_index = global.sprLightBulletHit
}
if place_meeting(x + hspeed,y +vspeed,Wall){sound_play_pitchvol(sndHitWall,1,100/distance_to_object(creator))}



#define create_sonic_explosion(_x,_y)
var a = instance_create(_x,_y,CustomProjectile)
with(a){
	name = "Sonic Explosion"
	sprite_index = global.sprSonicExplosion
	mask_index = global.mskSonicExplosion
	team = 0
	typ = 0
	damage = 5
	candeflect = 1
	image_speed = .7
	force = 20
	shake = 10
	hitid = [sprite_index,"Sonic Explosion"]
	on_step = sonic_step
	on_hit = sonic_hit
	on_wall = nothing
}
return a
#define nothing

#define sonic_step
if shake {view_shake_at(x,y,shake);shake = 0}
if !(current_frame mod 2) with instances_matching_ne(projectile,"team",team) if distance_to_object(other)<=0{
	if "typ" in self && !instance_is(self,Grenade){
		if typ = 1 && other.candeflect{
			team = other.team
			direction = point_direction(other.x,other.y,x,y)
			image_angle = direction
		}
		if typ = 2 || typ = 3 || (typ = 1 && !other.candeflect){
			instance_destroy()
		}
	}
	if instance_is(self,Grenade){
		direction = point_direction(other.x,other.y,x,y)
		image_angle = direction
	}
}
if image_index >= 7{
	instance_destroy()
}

#define sonic_hit
if projectile_canhit_melee(other){
	projectile_hit(other,damage,force,point_direction(x,y,other.x,other.y))
}

//ok i guess im stealing stuff from gunlocker too but its a good idea alright
#define shell_yeah(_angle, _spread, _speed, _color)
with instance_create(x, y, Shell){
	motion_add(other.gunangle + (other.right * _angle) + random_range(-_spread, _spread), _speed);
	sprite_index = global.sprGenShell
	image_blend = _color
}



//old function that i changed the name of because i didnt want to comment it out for some reason, used the american spelling so karm wouldnt accidentally use it
#define draw_circle_width_color(precision,radius,width,offset,xcenter,ycenter,col,alpha)
//offset = angle btw
//precision = amount of edges(doesnt work well <4, values of 2^n create "perfect" circles, multiple of 2 create regular patterns, others are weird), radius = circle radius, col = circle colour, width = circle thiccness, x/y center = x/y coordinates of the center
precmax = precision
repeat(precision)
{
	draw_set_alpha(alpha)
	draw_line_width_colour(xcenter+lengthdir_x(radius,offset+(360*precision/precmax)+precmax),ycenter+lengthdir_y(radius,offset+(360*precision/precmax)+precmax),xcenter+lengthdir_x(radius,offset+(360*(precision+1)/precmax)+precmax),ycenter+lengthdir_y(radius,offset+(360*(precision+1)/precmax)+precmax),width,col,col)
	draw_set_alpha(1)
	offset += 360*precision/precmax
	precision -= 1
}

//new function with the same purpose as the last one, it just doesnt have that weird power of 2 thing going on
#define draw_circle_width_colour(precision,radius,width,offset,xcenter,ycenter,col,alpha)
var int = 360/precision;
draw_set_alpha(alpha);
draw_set_color(col);
for (var i = 0; i < 360; i+=int){
	draw_line_width(xcenter+lengthdir_x(radius,offset+i),ycenter+lengthdir_y(radius,offset+i),xcenter+lengthdir_x(radius,offset+i+int),ycenter+lengthdir_y(radius,offset+i+int),width)
}
draw_set_color(c_white)
draw_set_alpha(1)

//this is basically a fucked up version of the draw_polygon_texture function, but it does something neat i guess
#define draw_polygon_striped(sides,radius,angle,_x,_y,sprite,col,alpha)
draw_set_alpha(alpha)
draw_set_color(col)
var tex,w;
w = sprite_get_width(sprite);
tex = sprite_get_texture(sprite, 0);
draw_primitive_begin_texture(pr_trianglefan, tex);
draw_vertex_texture(_x,_y,.50,0)
for (var i = angle; i <= angle+360; i += 360/sides){
    draw_vertex_texture(_x+lengthdir_x(radius,i), _y+lengthdir_y(radius,i), .5+(1/w)*lengthdir_x(radius,-angle+i+180),0);
}
draw_primitive_end();
draw_set_color(c_white)
draw_set_alpha(1)

#define draw_polygon_texture(sides,radius,angle,spriteang,_x,_y,xscale,yscale,sprite,frame,col,alpha)
draw_set_alpha(alpha)
draw_set_color(col)
var tex,w,h;
w = sprite_get_width(sprite);
h = sprite_get_height(sprite);
tex = sprite_get_texture(sprite, frame);
draw_primitive_begin_texture(pr_trianglefan, tex);
draw_vertex_texture(_x,_y,.5,.5)
for (var i = angle; i <= angle+360; i += 360/sides){
    draw_vertex_texture(_x+lengthdir_x(radius,i), _y+lengthdir_y(radius,i), .5+(1/(w*xscale))*lengthdir_x(radius,-spriteang+i), .5+(1/(h*yscale))*lengthdir_y(radius,-spriteang+i));
}
draw_primitive_end();
draw_set_color(c_white)
draw_set_alpha(1)

//abris time
#define create_abris(Creator,startsize,endsize,weapon)
var a  = instance_create(0,0,CustomObject)
with a{
	//generic variables
	creator = Creator;
	name = "Abris Target"
	team = -1
	on_step = abris_step
	on_draw = abris_draw
	index = creator.index
	//accuarcy things
	accbase = startsize*creator.accuracy
	acc = accbase
	accmin = endsize
	accspeed = [1.2,3.5]
	//other things
	wep = weapon
	check = 0 //the button it checks, 0 is undecided, 1 is fire, 2 is specs, should only be 0 on creation, never step
	btn = [button_check(index,"fire"),button_check(index,"spec")]
	popped = 0
	dropped = 0
	type = weapon_get_type(wep)
	cost = weapon_get_cost(wep)
	auto = weapon_get_auto(wep)
	//visual things
	rotspeed = 3
	offspeed = 3
	lasercolour1 = c_red
	lasercolour = c_red
	lasercolour2 = c_maroon
	offset = random(359)
}
return a

#define abris_check()
switch creator.race{
	case "steroids":
		if creator.wep = wep var we = 1;
		if creator.bwep = wep var be = 1;
		if be && !we{
			check = 2
		}
		if we && !be{
			check = 1
		}
		if we && be{
			if btn[1] && !btn[0]{
				check = 2
			}
			if btn[0] && !btn[1]{
				check = 1
			}
			if btn[1] && btn[0]{
				var slots = [0,0,0];
				check = choose(1,2)
				with instances_matching(CustomObject,"name","Abris Target") if creator = other.creator && id != other{
					slots[check]++
				}
				if slots[check]{
					check = (check = 1 ? 2:1)
				}
			}
		}
		break
	case "venuz":
		if btn[1] {
			check = 2;
			++popped
		}
		else {check = 1}
		break
	default:
		check = 1
		break
		case "skeleton":
		if btn[1]
		{
			creator.ammo[type] -= cost
		}
}

#define abris_step
if instance_exists(creator){
	if check = 0{
		abris_check()
	}
	if button_pressed(index,"swap") && creator.race = "steroids"{
		check = (check = 1 ? 2:1)
	}
	if !dropped{
		image_angle += rotspeed;
		offset += offspeed;
		if check = 1 || popped{
			if popped{
				var pops = 1;
				with instances_matching(CustomObject,"name","Abris Target") if creator = other.creator && id != other{
					if popped {pops+=1}
				}
				creator.reload = weapon_get_load(creator.wep) *(pops)
			}else{
				creator.reload = weapon_get_load(creator.wep)
			}
		}else{
			creator.breload = weapon_get_load(creator.bwep)
		}
		acc/=accspeed[skill_get(13)]
		if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) >= 0{
			if acc < accbase{acc += abs(creator.accuracy*3)}else{acc = accbase}
		}
	}
	if !button_check(creator.index,(check = 1?"fire":"spec")) || (auto && acc<=accmin){
		if !collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) &&!dropped{
			dropped = 1
			explo_x = mouse_x[index]
			explo_y = mouse_y[index]
			if fork(){
				on_destroy = payload
				instance_destroy()
				exit
			}
		}
		else if instance_exists(self){
			if !dropped{
				if creator.infammo = 0{creator.ammo[type] += cost}
				instance_destroy()
			}
		};
	}
}
else{instance_destroy()}

#define abris_draw
if instance_exists(creator) && check{
	x = creator.x
	y = creator.y
	if button_check(creator.index, (check = 1? "fire":"spec")){
		if !collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0){
			var radi = acc+accmin;
			mod_script_call("mod", "defpack tools","draw_polygon_striped", 16, radi, 45, mouse_x[index]+1, mouse_y[index]+1, global.stripes, lasercolour1, 0.1+(accbase-acc)/(accbase*5),(current_frame mod 16)*.004);
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,radi,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,1*(accbase-acc))
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",16, accmin,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,.2)
			draw_line_width_colour(x,y,mouse_x[index],mouse_y[index],1,lasercolour1,lasercolour1);
		}
		else{
			var q = instance_create(x,y,CustomObject);
			with q{
				mask_index = sprBulletShell
				image_angle = other.creator.gunangle
				move_contact_solid(image_angle,game_width)
			}
			draw_line_width_colour(x,y,q.x,q.y,1,lasercolour2,lasercolour2)
			with q instance_destroy()
		}
		var comp = (check = 1 ? creator.wep : creator.bwep);
		if popped {comp = wep}
		if wep != comp {instance_destroy()}
	}
}

#define draw_curve(x1,y1,x2,y2,direction,detail)
// SOURCE: http://www.gmlscripts.com/script/draw_curve
//  Draws a curve between two points with a given starting angle.
//      x1,y1       position of start of curve, real
//      x2,y2       position of end of curve, real
//      direction   start angle of the curve, real
//      detail      number of segments in the curve, real
//var x1, y1, x2, y2, start_angle, detail, dist, dist_ang, inc, draw_x, draw_y;
x1 = argument[0];
y1 = argument[1];
x2 = argument[2];
y2 = argument[3];
start_angle = argument[4];
detail = argument[5];

dist = point_distance(x1,y1,x2,y2);
dist_ang = angle_difference(point_direction(x1,y1,x2,y2),start_angle);
  inc = (1/detail);

draw_primitive_begin(pr_linestrip);
for (i=0; i<1+inc; i+=inc) {
	draw_x = x1 + (lengthdir_x(i * dist, i * dist_ang + start_angle));
  draw_y = y1 + (lengthdir_y(i * dist, i * dist_ang + start_angle));
  draw_vertex(draw_x,draw_y);
  }
draw_primitive_end();
return 0;

#define step
with Player
{
	if wep = "psy sniper rifle"
	{
		if !instance_exists(enemy)
		{
			if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0)
			{
				var q = instance_create(x,y,CustomObject);
				with q{
					mask_index = sprBulletShell
					image_angle = other.gunangle
					move_contact_solid(image_angle,game_width)
				}
				draw_line_width_colour(x,y,q.x,q.y,1,lasercolour2,lasercolour2)
				with q instance_destroy()
			}
		}
		else{draw_curve(x,y,instance_nearest(mouse_x[index],mouse_y[index],enemy).x,instance_nearest(mouse_x[index],mouse_y[index],enemy).y,gunangle,12)}
	}
}
