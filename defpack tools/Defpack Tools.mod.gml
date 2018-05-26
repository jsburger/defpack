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
global.sprLightningBulletUpg = sprite_add("sprThunderBulletUpg.png", 2, 8, 8)
global.sprLightningBulletHit = sprite_add("Lightning Bullet Hit.png", 4, 8, 8)
global.sprToxicBullet = sprite_add("Toxic Bullet.png", 2, 8, 8)
global.sprToxicBulletHit = sprite_add("Toxic Bullet Hit.png", 4, 8, 8)
global.sprFireBullet = sprite_add("Fire Bullet.png", 2, 8, 8)
global.sprFireBulletHit = sprite_add("Fire Bullet Hit.png", 4, 8, 8)
global.sprDarkBullet = sprite_add("Dark Bullet.png", 2, 8, 8)
global.mskDarkBullet = sprite_add("Dark Bullet Mask.png", 0, 2.5, 4.5)
global.sprDarkBulletHit = sprite_add("Dark Bullet Hit.png", 4, 8, 8)
global.sprLightBullet = sprite_add("Light Bullet.png", 2, 8, 8)
global.sprLightBulletHit = sprite_add("Light Bullet Hit.png", 4, 8, 8)
global.sprPlasmite = sprite_add("sprPlasmite.png",0,3,3)
global.sprRocklet = sprite_add("sprRocklet.png",2,2,6)

global.sprSonicExplosion = sprite_add("Soundwave_strip8.png",8,61,59);
global.mskSonicExplosion = sprite_add("mskSonicExplosion_strip9.png",9,32,32);

global.sprGenShell = sprite_add("Generic Shell.png",0, 1.5, 2.5);

global.stripes = sprite_add("BIGstripes.png",1,1,1)

global.sprSquare = sprite_add("sprSquare.png", 0, 7, 7)
global.mskSquare = sprite_add("mskSquare.png",0,5,5)
global.sprSuperSquare = sprite_add("sprSuperSquare.png", 0, 14, 14)
global.mskSuperSquare = sprite_add("mskSuperSquare.png",0,10,10)

#define cleanup
with instances_matching(CustomProjectile,"name","Psy Bullet","Psy Shell") instance_delete(self)

#define bullet_hit
if name = "Psy Bullet"{with other{motion_add(point_direction(x,y,other.x,other.y),5)}}
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
instance_destroy()

#define bullet_anim
image_index = 1
image_speed = 0

#define shell_hit
projectile_hit(other, (current_frame < fallofftime? damage : (damage - falloff)), force, direction);


//ill get to this later
#define bullet_step
if pattern = "helix"
{
	cycle = (cycle + 9) mod 360
	direction = dsin(cycle*pi)*(32-skill_get(19)*20)*dir+_direction
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
	damage = 3
	recycle_amount = 2
	force = -10
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
	on_anim = script_ref_create(bullet_anim)
}
return a;

#define psy_step
if timer > 0{
	timer -= 1
}
if timer = 0 && instance_exists(enemy){
	var closeboy = instance_nearest(x,y,enemy)
	if collision_line(x,y,closeboy.x,closeboy.y,Wall,0,0) < 0 && distance_to_object(closeboy) < 220{
		var dir, spd;

		dir = point_direction(x, y, closeboy.x, closeboy.y);
		spd = 11

		direction -= clamp(angle_difference(image_angle, dir) * .3, -spd, spd); //Smoothly rotate to aim position.
		image_angle = direction
	}
	if speed > maxspeed
	{
		speed = maxspeed
	}
}

#define psy_destroy
with instance_create(x,y,BulletHit){
	sprite_index = global.sprPsyBulletHit
	image_angle = other.direction + 180
}
if place_meeting(x + hspeed,y +vspeed,Wall){sound_play_hit(sndHitWall,.2)}


#define create_psy_shell(_x,_y)
var b = instance_create(_x, _y, CustomProjectile)
with (b){
	name = "Psy Shell"
	sprite_index = global.sprPsyPellet
	friction = .6
	image_angle = direction
	mask_index = mskBullet2
	wallbounce = skill_get(15) * 5 + (skill_get("shotgunshouldersx10")*50)
	force = 4
	recycle_amount = 0
	image_speed = 1
	damage = 4
	falloff = 1
	fallofftime = current_frame + 2
	timer = 5 + irandom(4)
	on_hit = script_ref_create(shell_hit)
	on_draw = script_ref_create(psy_shell_draw)
	on_step = script_ref_create(psy_shell_step)
	on_wall = script_ref_create(psy_shell_wall)
	on_destroy = script_ref_create(psy_shell_destroy)
	on_anim = script_ref_create(bullet_anim)
}
return b;

#define psy_shell_step
if timer > 0{
	timer -= current_time_scale
}
if timer = 0 && instance_exists(enemy){
	var closeboy = instance_nearest(x,y,enemy)
	if collision_line(x,y,closeboy.x,closeboy.y,Wall,0,0) < 0 && distance_to_object(closeboy) < 200{
		motion_add(point_direction(x,y,closeboy.x,closeboy.y),current_time_scale * (1 + skill_get(15)))
		motion_add(direction,-.03  * (1 + skill_get(15)))
		image_angle = direction
	}
}
if speed < 3{
	instance_destroy()
}

#define psy_shell_wall
fallofftime = current_frame + 2
move_bounce_solid(true)
speed /= 1.25
if speed + wallbounce >= 14{
	speed = 14
}
else{
	speed += wallbounce
}
wallbounce /= 1.05
instance_create(x,y,Dust)
sound_play_hit(sndShotgunHitWall,.2)
image_angle = direction

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
	friction = .475
	image_angle = direction
	mask_index = mskBullet2
	wallbounce = skill_get(15) * 4 + (skill_get("shotgunshouldersx10")*40)
	force = 4
	ammo = 2
	lasthit = -4
	recycle_amount = 0
	image_speed = 1
	damage = 3
	falloff = 1
	fallofftime = current_frame + 2
	timer = 5 + irandom(4)
	og_timer = timer
	on_hit = script_ref_create(mag_hit)
	on_draw = script_ref_create(mag_shell_draw)
	on_step = script_ref_create(mag_shell_step)
	on_destroy = script_ref_create(mag_shell_destroy)
	on_anim = script_ref_create(bullet_anim)
	on_wall = script_ref_create(split_wall)
}
return c;

#define split_wall
fallofftime = current_frame + 2
move_bounce_solid(true)
speed /= 1.5
if speed + wallbounce >= 14{
	speed = 14
}
else{
	speed += wallbounce
}
wallbounce /= 1.05
instance_create(x,y,Dust)
sound_play_hit(sndShotgunHitWall,.2)
image_angle = direction
if ammo{
	ammo--
	image_xscale /= 1.2
	with mod_script_call("mod","defpack tools","create_split_shell",x,y){
		creator = other.creator
		image_xscale = other.image_xscale
		team = other.team
		ammo = other.ammo
		motion_add(other.direction + random_range(-40,40),random_range(12,14))
		image_angle = direction
	}
}
#define mag_hit
speed /= 1 + (.5*current_time_scale)
if lasthit != other.id
{
	shell_hit();
	if ammo > 0
	{
		ammo -= 1
		direction = point_direction(x,y,other.x,other.y)+180
		image_angle = direction
		image_xscale /= 1.2
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
image_yscale = image_xscale
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
	if skill_get(17)=0{sprite_index = global.sprLightningBullet}else{sprite_index=global.sprLightningBulletUpg}
	typ = 2
	mask_index = mskBullet1
	force = 7
	damage = 1
	recycle_amount = 1
	image_speed = 1
	image_angle = direction
	on_step = script_ref_create(thunder_step)
	on_destroy = script_ref_create(thunder_destroy)
	on_hit = script_ref_create(bullet_hit)
	on_draw = script_ref_create(bullet_draw)
	on_anim = script_ref_create(bullet_anim)
}
return c;

#define thunder_step
if random(21) < 1*current_time_scale{
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

#define thunder_destroy
with instance_create(x,y,Lightning){
	image_angle = random(360)
	creator = other.creator
	team = other.team
	ammo = 4
	alarm0 = 1
	visible = 0
	with instance_create(x,y,LightningSpawn)
	{
	   image_angle = other.image_angle
	}
	sound_play_hit(sndHitWall,.2)
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
	damage = 2
	recycle_amount = 2
	image_speed = 1
	image_angle = direction
	//on_step = script_ref_create(bullet_step)
	on_destroy = script_ref_create(toxic_destroy)
	on_hit = script_ref_create(bullet_hit)
	on_draw = script_ref_create(bullet_draw)
	on_anim = script_ref_create(bullet_anim)
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
if place_meeting(x + hspeed,y +vspeed,Wall){sound_play_hit(sndHitWall,.2)}

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
	on_step = script_ref_create(fire_step)
	on_destroy = script_ref_create(fire_destroy)
	on_hit = script_ref_create(bullet_hit)
	on_draw = script_ref_create(bullet_draw)
	on_anim = script_ref_create(bullet_anim)
}
return e;

#define fire_step
if irandom(12) = 1{
	with instance_create(x,y,Flame){
		team = other.team
		creator = other.creator
	}
}

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
if place_meeting(x + hspeed,y +vspeed,Wall){sound_play_hit(sndHitWall,.2)}

#define create_dark_bullet(_x,_y)
var f = instance_create(_x, _y, CustomSlash)
with (f){
	name = "Dark Bullet"
	pattern = false
	sprite_index = global.sprDarkBullet
	typ = 2
	mask_index =global.mskDarkBullet
	damage = 8
	force = 7
	offset = random(359)
	ringang = random(359)
	recycle_amount = 1
	image_speed = 1
	image_angle = direction
	//on_step = script_ref_create(dark_step)
	on_projectile = script_ref_create(dark_proj)
	on_destroy = script_ref_create(dark_destroy)
	on_wall = script_ref_create(dark_wall)
	on_hit = script_ref_create(bullet_hit)
	on_draw = script_ref_create(bullet_draw)
	on_anim = script_ref_create(bullet_anim)
}
return f;

#define dark_step

#define dark_wall
instance_destroy()

#define dark_proj
var t = team;
with other{
	if "typ" in self && typ >= 1 {
		var ringang = random(359);
		with create_sonic_explosion(x,y){
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
		repeat(3){
			with create_sonic_explosion(other.x+lengthdir_x(other.speed*1.3,other.offset+ringang),other.y+lengthdir_y(other.speed*1.3,other.offset+ringang)){
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
if place_meeting(x + hspeed,y +vspeed,Wall){sound_play_hit(sndHitWall,.2)}

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
	//on_step = script_ref_create(light_step)
	on_destroy = script_ref_create(light_destroy)
	on_hit = script_ref_create(light_hit)
	on_draw = script_ref_create(bullet_draw)
	on_anim = script_ref_create(bullet_anim)
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
if pierces = 0{
	instance_destroy()
}

#define light_destroy
with instance_create(x,y,BulletHit){
	sprite_index = global.sprLightBulletHit
}
if place_meeting(x + hspeed,y +vspeed,Wall){sound_play_hit(sndHitWall,.2)}



#define create_sonic_explosion(_x,_y)
var a = instance_create(_x,_y,CustomSlash)
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
	if GameCont.area = 101{synstep = 0}else{synstep = 1} //oasis synergy
	hitid = [sprite_index,"Sonic Explosion"]
	on_step = script_ref_create(sonic_step)
	on_projectile = script_ref_create(sonic_projectile)
	on_grenade = script_ref_create(sonic_grenade)
	on_hit = script_ref_create(sonic_hit)
	on_wall = script_ref_create(nothing)
	on_anim = script_ref_create(sonic_anim)
}
return a
#define nothing

#define sonic_anim
instance_destroy()

#define sonic_step
if synstep = 0
{
	synstep = 1
		image_xscale *= 1.25
		image_yscale *= 1.25
		image_speed  *= .8
}
if shake {view_shake_at(x,y,shake);shake = 0}

#define sonic_projectile
with other{
	if typ = 1 && other.candeflect{
		team = other.team
		direction = point_direction(other.x,other.y,x,y)
		image_angle = direction
	}
	if typ = 2 || typ = 3 || (typ = 1 && !other.candeflect){
		instance_destroy()
	}
}

#define sonic_grenade
with other{
	direction = point_direction(other.x,other.y,x,y)
	image_angle = direction
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
	accspeed = 1.2
	accset = false
	//other things
	wep = weapon
	check = 0 //the button it checks, 0 is undecided, 1 is fire, 2 is specs, should only be 0 on creation, never step
	btn = [button_check(index,"fire"),button_check(index,"spec"),other.swapmove]
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
	//god bless YAL
	check = other.specfiring ? 2 : 1;
	if check = 2 && (other.race = "venuz" || other.race = "skeleton") popped = 1;
}
return a

//hahahahah fuck this
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
			if btn[2]{
				check = 2
			}
			else check = 1
		}
		break
	case "venuz":
		if btn[1] {
			check = 2;
			++popped
		}
		else {check = 1}
		break
	case "skeleton":
		if btn[1]{
			check = 2
		}else{
			check = 1
		}
		break
	default:
		check = 1
		break
}

#define abris_step
if instance_exists(creator){
	if check = 0{
		abris_check()
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
		acc/=accspeed
		if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) >= 0{
			if acc < accbase{acc += abs(creator.accuracy*3)}else{acc = accbase;lasercolour=c_white}
		}
	}
	if !button_check(creator.index,(check = 1?"fire":"spec")) || (auto && acc<=accmin){
		if instance_exists(self){
			dropped = 1
			var _wall = collision_line_first(x,y,mouse_x[index],mouse_y[index],Wall,0,0);
			if _wall > -4
			{
				explo_x = x + lengthdir_x(point_distance(x,y,_wall.x,_wall.y)-accmin,creator.gunangle);
				explo_y = y + lengthdir_y(point_distance(x,y,_wall.x,_wall.y)-accmin,creator.gunangle);
			}
			else
			{
				explo_x = mouse_x[index]
				explo_y = mouse_y[index]
			}
			if fork(){
				on_destroy = payload
				instance_destroy()
				exit
			}
		};
	}
}
else{instance_destroy()}

#define abris_draw
if instance_exists(creator) && check{
	x = creator.x
	y = creator.y
	if collision_line_first(x,y,mouse_x[index],mouse_y[index],Wall,0,0) > -4
	{
		var _wall = collision_line_first(x,y,mouse_x[index],mouse_y[index],Wall,0,0);
		var _tarx = x + lengthdir_x(point_distance(x,y,_wall.x,_wall.y),creator.gunangle);
		var _tary = y + lengthdir_y(point_distance(x,y,_wall.x,_wall.y),creator.gunangle);
	}
	else
	{
		var _tarx = mouse_x[index];
		var _tary = mouse_y[index];
	}
	if button_check(creator.index, (check = 1? "fire":"spec")){
			var radi = acc+accmin;
			mod_script_call("mod", "defpack tools","draw_polygon_striped", 16, radi, 45, _tarx+1, _tary+1, global.stripes, lasercolour1, 0.1+(accbase-acc)/(accbase*5),(current_frame mod 16)*.004);
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,radi,1,acc+image_angle,_tarx,_tary,lasercolour1,1*(accbase-acc))
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",16, accmin,1,acc+image_angle,_tarx,_tary,lasercolour1,.2)
			draw_line_width_colour(x,y,_tarx,_tary,1,lasercolour1,lasercolour1);
		var comp = (check = 1 ? creator.wep : creator.bwep);
		if popped {comp = wep}
		if wep != comp {instance_destroy()}
	}
}
#define collision_line_first(x1,y1,x2,y2,object,prec,notme)
/// collision_line_first(x1,y1,x2,y2,object,prec,notme)
//
//  Returns the instance id of an object colliding with a given line and
//  closest to the first point, or noone if no instance found.
//  The solution is found in log2(range) collision checks.
//
//      x1,y2       first point on collision line, real
//      x2,y2       second point on collision line, real
//      object      which objects to look for (or all), real
//      prec        if true, use precise collision checking, bool
//      notme       if true, ignore the calling instance, bool
//
/// GMLscripts.com/license
{
    var ox,oy,dx,dy,object,prec,notme,sx,sy,inst,i;
    ox = argument0;
    oy = argument1;
    dx = argument2;
    dy = argument3;
    object = argument4;
    prec = argument5;
    notme = argument6;
    sx = dx - ox;
    sy = dy - oy;
    inst = collision_line(ox,oy,dx,dy,object,prec,notme);
    if (inst != noone) {
        while ((abs(sx) >= 1) || (abs(sy) >= 1)) {
            sx /= 2;
            sy /= 2;
            i = collision_line(ox,oy,dx,dy,object,prec,notme);
            if (i) {
                dx -= sx;
                dy -= sy;
                inst = i;
            }else{
                dx += sx;
                dy += sy;
            }
        }
    }
    return inst;
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

#define draw
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
				//draw_line_width_colour(x,y,q.x,q.y,1,lasercolour2,lasercolour2)
				with q instance_destroy()
			}
		}
		else{draw_curve(x,y,instance_nearest(mouse_x[index],mouse_y[index],enemy).x,instance_nearest(mouse_x[index],mouse_y[index],enemy).y,gunangle,12)}
	}
}

#define step
with instances_matching([Explosion,SmallExplosion,GreenExplosion,PopoExplosion],"hitid",-1){
    hitid = [sprite_index,string_replace(string_upper(object_get_name(object_index)),"EXPLOSION"," EXPLOSION")]
}

//drop tables
with Inspector			{if my_health <= 0 && irandom(97)=0{with instance_create(x,y,WepPickup){wep = choose("donut box","idpd slugger")}}};
with Shielder 			{if my_health <= 0 && irandom(97)=0{with instance_create(x,y,WepPickup){wep = choose("donut box","idpd minigun")}}};
with EliteGrunt 		{if my_health <= 0 && irandom(97)=0{with instance_create(x,y,WepPickup){wep = choose("donut box","idpd bazooka")}}};
with EliteInspector {if my_health <= 0 && irandom(97)=0{with instance_create(x,y,WepPickup){wep = choose("donut box","idpd energy sword")}}};
with EliteShielder  {if my_health <= 0 && irandom(97)=0{with instance_create(x,y,WepPickup){wep = choose("donut box","idpd plasma minigun")}}};
with PopoFreak	    {if my_health <= 0 && irandom(97)=0{with instance_create(x,y,WepPickup){wep = choose("donut box","idpd grenade launcher")}}};
with Van	    			{if my_health <= 0 && irandom(97)=0{with instance_create(x,y,WepPickup){wep = choose("donut box","idpd shotgun")}}};

with SodaMachine{
	if my_health <= 0 && irandom(0)=0
	{
		with instance_create(x,y,WepPickup)
		{
			if skill_get(14)=1
			{
				if irandom(99)=0{wep = "soda popper"}
				else{wep = choose("lightning blue lifting drink(tm)","extra double triple coffee","autoproductive expresso","saltshake","munitions mist","vinegar","guardian juice","sunset mayo")}
			}
			else
			{
				if irandom(99)=0{wep = "soda popper"}
				else
				{wep = choose("lightning blue lifting drink(tm)","extra double triple coffee","autoproductive expresso","saltshake","munitions mist","vinegar","guardian juice")}
			}
		}
	}
}


#define create_lightning(_x,_y)
with instance_create(_x,_y,CustomProjectile){
	lightning_refresh()
	hitid = [sprLightningHit,"Lightning Bolt"]
	name = "Lightning Bolt"
	time = skill_get(17)+4
	create_frame = current_frame
	colors = [c_black,c_white,c_white,merge_color(c_blue,c_white,.3),c_white]
	damage = 18
	repeat(30){
		with instance_create(x,y,Dust){
			motion_set(random(360),3+random(10))
		}
	}
	if instance_exists(Floor){
	    var closeboy = instance_nearest(x,y,Floor);
    	if point_in_rectangle(x,y,closeboy.x-16,closeboy.y-16,closeboy.x+16,closeboy.y+16){
    	    with instance_create(x,y,Scorchmark){
    	        time = 0;
    	        if fork(){
    	            while instance_exists(self) && time < 45{
    	                time += current_time_scale
    	                image_alpha -= current_time_scale/45
    	                if random(100) <= (45-time)*current_time_scale{
    	                    with instance_create(x,y,Smoke){
    	                        motion_add(90,random_range(1,2))
    	                        image_xscale = (1-(other.time/45)) * random_range(.5,1)
    	                        image_yscale = image_xscale
    	                        gravity = -friction
    	                    }
    	                }
    	                wait(0)
    	            }
    	            if instance_exists(self) instance_destroy()
    	            exit
    	        }
    	    }
    	}
	}
	force = 40
	on_wall = lightning_wall
	on_draw = lightning_draw;
	mask_index = sprGammaBlast
	image_xscale = .5
	image_yscale = .5
    on_destroy = lightning_destroy
	on_step = lightning_step
	on_hit = lightning_hit
	depth = -8
	return id
}

#define draw_dark()
with instances_matching(CustomProjectile,"name","Lightning Bolt"){
	draw_circle_color(x,y,550 + random(10), c_gray,c_gray,0)
	draw_circle_color(x,y,250 + random(10), c_black,c_black,0)
}

#define lightning_wall
with other{
	instance_create(x,y,FloorExplo)
	instance_destroy()
}

#define lightning_draw
if random(100) <= 50*current_time_scale lightning_refresh()
draw_set_color(colors[min((current_frame - create_frame),array_length_1d(colors)-1)])
for (var i = 1; i < array_length_1d(ypoints); i++){
	if !irandom(4) draw_sprite(sprLightningHit,1+irandom(2),xpoints[i],ypoints[i])
	draw_line_width(xpoints[i],ypoints[i],xpoints[i-1],ypoints[i-1],i/10)
}
var yy = ypoints[array_length_1d(ypoints)-1];
draw_set_color(c_white)
draw_set_blend_mode(bm_max)
draw_triangle_color(xmax,yy,xmin,yy,x,y,c_white,c_white,c_black,0)
draw_set_blend_mode(bm_normal)

#define lightning_hit
if projectile_canhit(other){
	projectile_hit_push(other,damage,force)
}

#define lightning_refresh
ypoints = [y]
xpoints = [x]
var mmax = 100;
var mmin = -100;
var xx = x;
var yy = y;
while ypoints[array_length_1d(ypoints)-1] > y - 2*game_height{
	xx += random_range(-6,6)
	yy -= random_range(-2,8)
	array_push(xpoints,xx)
	array_push(ypoints,yy)
	var m = slope(x,xx,y,yy)
	if m < 0.01 && abs(m) < abs(mmin) {mmin = m}
	if  m > 0.01 && m < mmax {mmax = m}
}
var y1 = y - 2*game_height;
xmax = x+(y1 - y)/mmin
xmin = x+(y1 - y)/mmax

#define slope(x1,x2,y1,y2)
return((y2-y1)/(x2-x1))

#define lightning_destroy
for (var i = 1; i < array_length_1d(ypoints); i++){
	if !irandom(4) with instance_create(xpoints[i],ypoints[i],FireFly){
		depth = other.depth
		image_speed/=1.5
		sprite_index = sprLightning
		hspeed += random_range(-.5,.5)
		vspeed += random_range(-.5,.5)
	}
}
sound_set_track_position(sndExplosionL,0)

#define lightning_step
view_shake_max_at(x,y,30)
time -= current_time_scale
if time <= 0 instance_destroy()

#define create_plasmite(_x,_y)
a = instance_create(x,y,CustomProjectile);
with a
{
	image_speed = 0
	image_index = 0
	damage = 2+skill_get(17)
	sprite_index = global.sprPlasmite
	fric = random_range(1.2,1.3)
	speedset = 0
	maxspeed = 7
	on_step 	 = plasmite_step
	on_wall 	 = plasmite_wall
	on_destroy = plasmite_destroy
}
return a;

#define plasmite_step
image_angle = direction
if irandom(12-skill_get(17)*5) = 1{instance_create(x,y,PlasmaTrail)}
if speedset = 0
{
	speed/= fric
	if speed < 1.00005{speedset = 1}
}
else
{
	if instance_exists(enemy)
	{
		var closeboy = instance_nearest(x,y,enemy)
		motion_add(point_direction(x,y,closeboy.x,closeboy.y),.5+skill_get(17)*.3)
	}
	if speed > maxspeed{speed = maxspeed}
	maxspeed /= fric
	if maxspeed <= fric instance_destroy()
}

#define plasmite_wall
instance_destroy()

#define plasmite_destroy
sound_play_pitch(sndPlasmaHit,random_range(1.55,1.63))
with instance_create(x,y,PlasmaImpact){image_xscale=.5;image_yscale=.5;damage = round(damage/2)}

#define create_supersquare(_x,_y)
var a = instance_create(_x,_y,CustomProjectile);
with a
{
	typ = 1
	name = "square"
	size = 4
	friction = .3
	bounce = 5+skill_get(17)*2
	damage = 3
	image_xscale = 1+skill_get(17)*.3
	image_yscale = 1+skill_get(17)*.3
	force = 12
	iframes = 0
	minspeed = 2
	anglefac = random_range(0.6,2)
	fac = choose(1,-1)
	sprite_index = global.sprSuperSquare
	mask_index 	 = global.mskSuperSquare
	hitframes = 0
	lifetime = room_speed * 7
	on_step    = square_step
	on_hit     = square_hit
	on_wall    = actually_nothing
	on_draw    = square_draw
	on_destroy = square_destroy
}
return a;

#define create_square(_x,_y)
var a = instance_create(_x,_y,CustomProjectile);
with a
{
	typ = 1
	name = "square"
	size = 1
	friction = .3
	bounce = 7+skill_get(17)*3
	damage = 2
	minspeed = 2
	image_xscale = 1+skill_get(17)*.3
	image_yscale = 1+skill_get(17)*.3
	force = 6
	iframes = 0
	anglefac = random_range(0.8,2.5)
	fac = choose(1,-1)
	sprite_index = global.sprSquare
	mask_index 	 = global.mskSquare
	hitframes = 0
	lifetime = room_speed * 6
	on_step    = square_step
	on_hit     = square_hit
	on_wall    = actually_nothing
	on_draw    = square_draw
	on_destroy = square_destroy
}
return a;

#define square_destroy
if size > 1
{
		var i = random(360);
		repeat(4)
		{
			with create_square(x,y)
			{
				creator = other.creator
				team    = other.team
				size    = 1
				motion_add(i+random_range(-6,6),6)
			}
			i += 360/size
		}
}
sound_play_pitch(sndPlasmaHit,random_range(.9,1.1))
with instance_create(x,y,PlasmaImpact){team = other.team;image_xscale=1.5;image_yscale=1.5}

#define square_hit
if team != other.team
{
	with other motion_add(point_direction(other.x,other.y,x,y),other.size)
	if speed > minspeed && projectile_canhit_melee(other) = true{projectile_hit(other, round(5*damage), force, direction)}else{hitframes += 1;projectile_hit(other, damage, force, direction)};
}

#define square_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.1);
draw_set_blend_mode(bm_normal);

#define actually_nothing

#define square_step
if speed > 2
{
	with instance_create(x+random_range(-8,8),y+random_range(-8,8),PlasmaImpact)
	{
		image_index = 1
		image_speed = 0.3-skill_get(17)*0.05
		image_xscale = .25
		image_yscale = .25
		with Smoke if place_meeting(x,y,other) instance_destroy()
	}
}
with instance_create(x+random_range(-8,8)+lengthdir_x(sprite_width/2,direction-180),y+random_range(-8,8)+lengthdir_y(sprite_width/2,direction-180),PlasmaTrail)
{
	image_speed = 0.35-skill_get(17)*0.05
	image_xscale += skill_get(17)/2
	image_yscale = image_xscale
}
if iframes <= 0
{
	with EnergyShank
	{
		if place_meeting(x,y,other)
		{
				with instance_create(other.x,other.y,GunGun){image_index=2}
				if other.speed <20{with other{direction=other.direction;speed=9}}
				sound_play_pitch(sndPlasmaBigExplode,1.4)
				sound_play_pitch(sndPlasmaHit,2.2)
				if skill_get(17){sound_play_pitch(sndPlasmaBigExplodeUpg,2.2)}
				other.iframes += 10*image_speed
		}
	}
	with EnergySlash
	{
		if place_meeting(x,y,other)
		{
				with instance_create(other.x,other.y,GunGun){image_index=2}
				with other{direction=other.direction;speed=12}
				sound_play_pitch(sndPlasmaBigExplode,1.4)
				sound_play_pitch(sndPlasmaHit,2.2)
				if skill_get(17){sound_play_pitch(sndPlasmaBigExplodeUpg,2.2)}
				other.iframes += 10*image_speed
		}
	}
	with EnergyHammerSlash
	{
		if place_meeting(x,y,other)
		{
				with instance_create(other.x,other.y,GunGun){image_index=2}
				with other{direction=other.direction;speed=17}
				sound_play_pitch(sndPlasmaBigExplode,1.4)
				sound_play_pitch(sndPlasmaHit,2.2)
				if skill_get(17){sound_play_pitch(sndPlasmaBigExplodeUpg,2.2)}
				other.iframes += 10*image_speed
		}
	}
}
else{iframes--}
if speed < minspeed speed = minspeed
if speed > 16 speed = 16
image_angle += speed * anglefac * fac
if place_meeting(x+hspeed,y,Wall)
{
	if speed = minspeed bounce--;
	hspeed *= -1
}
if place_meeting(x,y+vspeed,Wall)
{
	if speed = minspeed bounce--;
	vspeed *= -1
}
if bounce <= 0 instance_destroy()
with instances_matching(CustomProjectile,"name","square")
{
	if place_meeting(x,y,other)
	{
		motion_add(point_direction(other.x,other.y,x,y),7*(other.size/size))
		sound_play_pitch(sndPlasmaHit,random_range(.9,1.1))
		with instance_create(x,y,PlasmaImpact){team = other.team}
	}
}


#define create_rocklet(_x,_y)
with instance_create(_x,_y,CustomProjectile){
    sprite_index = global.sprRocklet
    damage = 3
    maxspeed = 14
    typ = 1
    direction_goal = 0
    friction = -.6
    on_step = rocket_step
    on_destroy = rocket_destroy
    on_anim = bullet_anim
    on_draw = rocket_draw
    return id
}

#define rocket_step
direction -= (angle_difference(direction,direction_goal)*current_time_scale)/8
with instance_create(x,y,BoltTrail)
{
    image_blend = c_white
	image_angle = other.direction
	image_yscale = .8
	image_xscale = other.speed_raw - other.friction*current_time_scale
	if fork(){
	    while instance_exists(self){
	        image_yscale+=.02 * current_time_scale
	        image_blend = merge_color(image_blend,c_black,.05*current_time_scale)
	        wait(0)
	    }
	    exit
	}
}

if speed > maxspeed{speed = maxspeed}
image_angle = direction


#define rocket_destroy
sound_play_pitch(sndExplosionS,1.5)
with instance_create(x,y,SmallExplosion){damage -= 2}

#define rocket_draw
draw_self()
draw_sprite_ext(sprRocketFlame,-1,x,y,speed/(2*maxspeed),image_yscale/2,image_angle,c_white,image_alpha)
/*draw_set_blend_mode(bm_add)
draw_sprite_ext(sprRocketFlame,-1,x,y,speed/maxspeed,image_yscale,image_angle,c_white,.2)
draw_set_blend_mode(bm_normal)*/
