#define init
global.sprBullakRed = sprite_add("sprites/projectiles/sprBullakRed.png", 2, 8, 8)
global.sprBullakYellow = sprite_add("sprites/projectiles/sprBullakYellow.png", 2, 8, 8)
global.sprBullakGreen = sprite_add("sprites/projectiles/sprBullakGreen.png", 2, 8, 8)
global.sprBullakBlue = sprite_add("sprites/projectiles/sprBullakBlue.png", 2, 8, 8)
global.sprBullakBlueUpg = sprite_add("sprites/projectiles/sprBullakBlueUpg.png", 2, 8, 8)
global.sprBullakPurple = sprite_add("sprites/projectiles/sprBullakPurple.png", 2, 8, 8)
global.sprFireFlak = sprite_add("sprites/projectiles/Fire Flak.png", 2, 8, 8)
global.sprDarkFlak = sprFlakBullet //rip
global.sprIDPDFlak = sprite_add("sprites/projectiles/IDPD Flak.png", 2, 8, 8)
global.sprSplitFlak = sprite_add("sprites/projectiles/IDPD Flak.png", 2, 8, 8)
global.flaks = ["recursive", "fire", "toxic", "lightning", "psy", "dark", "split", "bouncer"]

#define flak_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.10);
draw_set_blend_mode(bm_normal);

#define create_split_flak(_x,_y)
var a = instance_create(_x,_y,CustomProjectile);
with(a){
	name = "Split Flak"
	sprite_index = global.sprSplitFlak
	image_speed = .7
	_ammo = 2
	typ = 1
	force = 10
	damage = 8
	friction = 1.5
	mask_index = mskFlakBullet
	on_draw = flak_draw
	on_destroy = split_pop
	on_hit = split_hit
	on_step = split_step
}
return a;

#define split_hit
if other.sprite_index != other.spr_hurt
{
	if other.size > 1{motion_set(point_direction(other.x,other.y,x,y),10)}
	projectile_hit(other, damage, force, direction);
	speed += 2*ammo
	sound_play(sndFlakExplode)
	view_shake_at(x,y,8)
	if ammo >= 0
	{
		if skill_get(19) = false{
			repeat(4){
					with mod_script_call("mod","defpack tools","create_split_shell",x,y){
						creator = other.creator
						team = other.team
						ammo = other.ammo
						motion_add(random(359),10)
						image_angle = direction
					}
			}
		}
		else
		{
			var offset = random(359);
			repeat(4){
					with mod_script_call("mod","defpack tools","create_split_shell",x,y){
						creator = other.creator
						team = other.team
						ammo = other.ammo
						motion_add(random(359),10)
						image_angle = direction
					}
			offset += 360/ammo
			}
		}
	}
	else{instance_destroy();exit}
	ammo--;
}

#define split_pop
sound_play(sndFlakExplode)
view_shake_at(x,y,8)
if ammo >= 0
{
	if skill_get(19) = false{
		repeat(4){
				with mod_script_call("mod","defpack tools","create_split_shell",x,y){
					creator = other.creator
					team = other.team
					ammo = other.ammo
					motion_add(other.direction+random_range(-20,20),random_range(16,20))
					image_angle = direction
				}
		}
	}
	else
	{
		var offset = random(359);
		repeat(4){
				with mod_script_call("mod","defpack tools","create_split_shell",x,y){
					creator = other.creator
					team = other.team
					ammo = other.ammo
					motion_add(other.direction+random_range(-7,7),random_range(16,20))
					image_angle = direction
				}
		offset += 360/ammo
		}
	}
}
else{instance_destroy()}
ammo--;

#define split_step
if !irandom(2) {instance_create(x,y,Dust)}
if place_meeting(x+hspeed,y,Wall)
{
	hspeed *= -1
	sound_play(sndFlakExplode)
	view_shake_at(x,y,8)
	if ammo >= 0
	{
		if skill_get(19) = false{
			repeat(4*(4-ammo)){
					with mod_script_call("mod","defpack tools","create_split_shell",x,y){
						creator = other.creator
						team = other.team
						ammo = other.ammo
						motion_add(random(359),10)
						image_angle = direction
					}
			}
		}
		else
		{
			var offset = random(359);
			repeat((4-ammo)*4){
					with mod_script_call("mod","defpack tools","create_split_shell",x,y){
						creator = other.creator
						team = other.team
						ammo = other.ammo
						motion_add(random(359),10)
						image_angle = direction
					}
			offset += 360/ammo
			}
		}
	}
	else{instance_destroy()}
	ammo--;
}
if place_meeting(x,y+vspeed,Wall)
{
	vspeed *= -1
	sound_play(sndFlakExplode)
	view_shake_at(x,y,8)
	if ammo >= 0
	{
		if skill_get(19) = false{
			repeat((4-ammo)*4){
					with mod_script_call("mod","defpack tools","create_split_shell",x,y){
						creator = other.creator
						team = other.team
						ammo = other.ammo
						motion_add(random(359),10)
						image_angle = direction
					}
			}
		}
		else
		{
			var offset = random(359);
			repeat((4-ammo)*4){
					with mod_script_call("mod","defpack tools","create_split_shell",x,y){
						creator = other.creator
						team = other.team
						ammo = other.ammo
						motion_add(random(359),10)
						image_angle = direction
					}
			offset += 360/ammo
			}
		}
	}
	else{instance_destroy();exit}
	ammo--;
}
if speed <= .5
{
	speed += 6*(4-ammo)
	sound_play(sndFlakExplode)
	view_shake_at(x,y,8)
	if ammo >= 0
	{
		if skill_get(19) = false{
			repeat((4-ammo)*4){
					with mod_script_call("mod","defpack tools","create_split_shell",x,y){
						creator = other.creator
						team = other.team
						ammo = other.ammo
						motion_add(random(359),10)
						image_angle = direction
					}
			}
		}
		else
		{
			var offset = random(359);
			repeat((4-ammo)*4){
					with mod_script_call("mod","defpack tools","create_split_shell",x,y){
						creator = other.creator
						team = other.team
						ammo = other.ammo
						motion_add(random(359),10)
						image_angle = direction
					}
			offset += 360/ammo
			}
		}
	}
	else{instance_destroy()}
	ammo--;
}
if ammo <=0  || speed <= friction instance_destroy()

#define create_psy_flak(_x,_y)
var a = instance_create(_x,_y,CustomProjectile);
with(a){
	name = "Psy Bullet Flak"
	sprite_index = global.sprBullakPurple
	image_speed = 1
	ammo = 16
	force = 8
	typ = 1
	damage = 16
	mask_index = mskFlakBullet
	friction = 0 //frick you sani, im gonna use GML's friction and you cant stop me
	on_draw = flak_draw
	on_destroy = psy_pop
	on_step = psy_step
	on_hit  = psy_hit
}
return a;

#define psy_hit
if other.team != team
{
		if projectile_canhit_melee(other) = true
		{
			var _hp = other.my_health;
			sleep(40)
			projectile_hit(other,damage,force,direction-180)
			damage = round(damage-_hp)
			instance_create(x,y,Smoke)
			if ammo > 0
			{
				ammo--
				with mod_script_call("mod","defpack tools","create_psy_bullet",x,y){
					team = other.team
					creator = other.creator
					motion_set(random(359),12)
					image_angle = direction
					}
			}
			if damage <= 0 instance_destroy()
		}
}

#define psy_step
if speed > 12 speed = 12
if image_index = 1 image_speed = 0
if instance_exists(enemy){
	var closeboy = instance_nearest(x,y,enemy)
	if collision_line(x,y,closeboy.x,closeboy.y,Wall,0,0) < 0 && distance_to_object(closeboy) < 200{
		motion_add(point_direction(x,y,closeboy.x,closeboy.y),.54)
		motion_add(direction,-.02)
	}
}
if !irandom(2) {instance_create(x,y,Smoke)}
if speed < .1 {instance_destroy()}
image_angle = direction

#define psy_pop
sound_play(sndMachinegun)
sound_play(sndFlakExplode)
view_shake_at(x,y,8)
if skill_get(19) = false{
	repeat(ammo){
	with mod_script_call("mod","defpack tools","create_psy_bullet",x,y){
		team = other.team
		creator = other.creator
		motion_set(random(359),5)
		image_angle = direction
		}
	}
}
else
{
	var offset = random(359);
	repeat(ammo){
	with mod_script_call("mod","defpack tools","create_psy_bullet",x,y){
		team = other.team
		creator = other.creator
		motion_set(offset,5)
		image_angle = direction
		}
	offset += 360/ammo
	}
}

#define create_fire_flak(_x,_y)
var a = instance_create(_x,_y,CustomProjectile);
with(a){
	name = "Fire Bullet Flak"
	sprite_index = global.sprBullakRed
	image_speed = 1
	ammo = 16
	force = 12
	typ = 1
	damage = 32
	mask_index = mskFlakBullet
	friction = 0
	on_draw = flak_draw
	on_destroy = flame_pop
	on_step = flame_step
	on_hit  = flame_hit
}
return a;

#define flame_hit
if other.team != team
{
		if projectile_canhit_melee(other) = true
		{
			var _hp = other.my_health;
			sleep(40)
			projectile_hit(other,damage,force,direction)
			damage = round(damage-_hp)
			instance_create(x,y,Smoke)
			if ammo > 0
			{
				ammo--
				with mod_script_call("mod","defpack tools","create_fire_bullet",x,y){
					team = other.team
					creator = other.creator
					motion_set(random(359),18)
					image_angle = direction
					}
			}
			if damage <= 0 instance_destroy()
		}
}

#define flame_pop
sound_play(sndMachinegun)
sound_play(sndFlakExplode)
view_shake_at(x,y,8)
if skill_get(19) = false{
	repeat(ammo){
	with mod_script_call("mod","defpack tools","create_fire_bullet",x,y){
		team = other.team
		creator = other.creator
		motion_set(random(359),15)
		image_angle = direction
		}
	}
}
else
{
	var offset = random(359);
	repeat(ammo){
	with mod_script_call("mod","defpack tools","create_fire_bullet",x,y){
		team = other.team
		creator = other.creator
		motion_set(offset,15)
		image_angle = direction
		}
	offset += 360/ammo
	}
}
#define flame_step
if image_index = 1 image_speed = 0
if !irandom(1){
	with instance_create(x,y,Flame){
		team = other.team
		creator = other.creator
		motion_add(random(359),random(3))
	}
}
if speed < .1 {instance_destroy()}
image_angle = direction

#define create_lightning_flak(_x,_y)
var a = instance_create(_x,_y,CustomProjectile);
with(a){
	name = "Lightning Bullet Flak"
	if skill_get(17) = 0 sprite_index = global.sprBullakBlue else sprite_index = global.sprBullakBlueUpg
	image_speed = 1
	ammo = 16
	force = 8
	typ = 1
	damage = 16
	mask_index = mskFlakBullet
	friction = 0
	on_draw = flak_draw
	on_destroy = zap_pop
	on_step = zap_step
	on_hit = zap_hit
}
return a;

#define zap_hit
if other.team != team
{
		if projectile_canhit_melee(other) = true
		{
			var _hp = other.my_health;
			projectile_hit(other,damage,force,direction)
			damage = round(damage-_hp)
			instance_create(x,y,Smoke)
			if ammo > 0
			{
				ammo--
				with mod_script_call("mod","defpack tools","create_lightning_bullet",x,y){
					team = other.team
					creator = other.creator
					motion_set(random(359),18)
					image_angle = direction
					}
			}
			if damage <= 0 instance_destroy()
		}
}

#define zap_step
if image_index = 1 image_speed = 0
if !irandom(3) with instance_create(x,y,Lightning){
	team = other.team
	creator = other.creator
	ammo = 2+irandom(3)
	alarm0=1
	image_angle = random(359)
}
if speed < .1 {instance_destroy()}
image_angle = direction

#define zap_pop
sound_play(sndMachinegun)
sound_play(sndFlakExplode)
view_shake_at(x,y,8)
if skill_get(19) = false{
	if fork()
	{
		repeat(2)
		{
			repeat(ammo){
			with mod_script_call("mod","defpack tools","create_lightning_bullet",x,y){
				team = other.team
				creator = other.creator
				motion_set(random(359),10)
				image_angle = direction
				}
			}
		}
		wait(2)
	}
}
else
{
	if fork()
	{
		repeat(2)
		{
			var offset = random(359);
			repeat(ammo){
			with mod_script_call("mod","defpack tools","create_lightning_bullet",x,y){
				team = other.team
				creator = other.creator
				motion_set(offset,5)
				image_angle = direction
				}
			offset += 360/ammo
			}
		}
		wait(2)
	}
}

#define create_bouncer_flak(_x,_y)
var a = instance_create(_x,_y,CustomProjectile);
with(a){
	name = "Bouncer Bullet Flak"
	sprite_index = sprBouncerBullet
	mask_index = sprGrenade
	image_speed = 1
	image_angle += 90
	image_xscale = 1.5
	image_yscale = 1.5
	ammo = 8
	force = 8
	typ = 1
	bounce = 2
	damage = 16
	mask_index = mskFlakBullet
	friction = 0
	on_draw = flak_draw
	on_destroy = bounce_pop
	on_step = bounce_step
	on_hit = bounce_hit
	on_wall = bounce_wall
}
return a;

#define bounce_wall
if speed > 12 speed = 12
move_bounce_solid(false)
speed -= 3
bounce--
with instance_create(x,y,BouncerBullet){
	team = other.team
	creator = other.creator
	view_shake_at(x,y,8)
	sleep(3)
	sound_play_pitch(sndBouncerBounce,random_range(.6,.7))
	motion_set(other.direction+random_range(-33,33),8)
	image_angle = direction
	}
if bounce < 0 instance_destroy()

#define bounce_hit
if other.team != team
{
		if projectile_canhit_melee(other) = true
		{
			var _hp = other.my_health;
			projectile_hit(other,damage,force,direction)
			damage = round(damage-_hp)
			instance_create(x,y,Smoke)
			if ammo > 0
			{
				ammo--
				with instance_create(x,y,BouncerBullet){
					team = other.team
					creator = other.creator
					motion_set(random(359),18)
					image_angle = direction
					}
			}
			if damage <= 0 instance_destroy()
		}
}

#define bounce_step
if image_index = 1 image_speed = 0
image_angle += 8

#define bounce_pop
sound_play(sndMachinegun)
sound_play(sndFlakExplode)
view_shake_at(x,y,8)
if skill_get(19) = false{
repeat(ammo){
	with instance_create(x,y,BouncerBullet){
	team = other.team
	creator = other.creator
	motion_set(random(359),5)
	image_angle = direction
	}
}
}
else
{
	var offset = random(359);
	repeat(ammo){
			with instance_create(x,y,BouncerBullet){
				team = other.team
				creator = other.creator
				motion_set(offset,5)
				image_angle = direction
				}
			offset += 360/ammo
			}
}

#define create_toxic_flak(_x,_y)
var a = instance_create(_x,_y,CustomProjectile);
with(a){
	name = "Toxic Bullet Flak"
	sprite_index = global.sprBullakGreen
	image_speed = 1
	ammo = 16
	force = 8
	typ = 1
	damage = 16
	mask_index = mskFlakBullet
	friction = 0
	image_angle = direction
	on_draw = flak_draw
	on_destroy = gas_pop
	on_step = gas_step
}
return a;

#define gas_hit
if other.team != team
{
		if projectile_canhit_melee(other) = true
		{
			var _hp = other.my_health;
			projectile_hit(other,damage,force,direction)
			damage = round(damage-_hp)
			instance_create(x,y,Smoke)
			if ammo > 0
			{
				ammo--
				with mod_script_call("mod","defpack tools","create_toxic_bullet",x,y){
					team = other.team
					creator = other.creator
					motion_set(random(359),18)
					image_angle = direction
					}
			}
			if damage <= 0 instance_destroy()
		}
}

#define gas_step
if image_index = 1 image_speed = 0
if !irandom(1) && distance_to_object(creator) > 20 with instance_create(x,y,ToxicGas){
	image_angle = random(359)
	motion_set(random(356),random(2))
}
if speed < .1 {instance_destroy()}
image_angle = direction

#define gas_pop
sound_play(sndMachinegun)
sound_play(sndFlakExplode)
view_shake_at(x,y,8)
if skill_get(19) = false{
	repeat(ammo){
	with mod_script_call("mod","defpack tools","create_toxic_bullet",x,y){
		team = other.team
		creator = other.creator
		motion_set(random(359),10)
		image_angle = direction
		}
	}
}
else
{
	var offset = random(359);
	repeat(ammo){
	with mod_script_call("mod","defpack tools","create_toxic_bullet",x,y){
		team = other.team
		creator = other.creator
		motion_set(offset,10)
		image_angle = direction
		}
	offset += 360/ammo
	}
}

#define create_dark_flak(_x,_y)//not even used mates what is this
var a = instance_create(_x,_y,CustomProjectile);
with(a){
	name = "Dark Bullet Flak"
	sprite_index = global.sprDarkFlak
	image_speed = .7
	ammo = 22
	force = 5
	typ = 1
	damage = 32
	mask_index = mskFlakBullet
	friction = 0
	on_draw = flak_draw
	on_destroy = dark_pop
	on_step = dark_step
}
return a;

#define dark_step
if !irandom(2) {instance_create(x,y,Smoke)}
if speed < .1 {instance_destroy()}

#define dark_pop
sound_play(sndMachinegun)
sound_play(sndFlakExplode)
view_shake_at(x,y,8)
repeat(ammo){
	with mod_script_call("mod","defpack tools","create_dark_bullet",x,y){
		team = other.team
		creator = other.creator
		motion_set(random(359),10)
		image_angle = direction
	}
}

#define create_idpd_flak(_x,_y)
var a = instance_create(_x,_y,CustomProjectile);
with(a){
	name = "IDPD Bullet Flak"
	sprite_index = global.sprIDPDFlak
	image_speed = .7
	ammo = 22
	force = 5
	typ = 1
	damage = 32
	mask_index = mskFlakBullet
	friction = random_range(.8,1.2)
	on_draw = flak_draw
	on_destroy = cop_pop
	on_step = cop_step
}
return a;

#define cop_step
if !irandom(2) {instance_create(x,y,Smoke)}
if speed < .1 {instance_destroy()}

#define cop_pop
sound_play(sndMachinegun)
sound_play(sndFlakExplode)
view_shake_at(x,y,7)
repeat(ammo){
	with instance_create(x,y,IDPDBullet){
		team = other.team
		creator = other.creator
		motion_set(other.direction + random_range(-25,25),20)
		image_angle = direction
	}
}
if speed < 0.1{instance_destroy()}

#define create_heavy_flak(_x,_y)
var a = instance_create(_x,_y,CustomProjectile);
with(a){
	name = "Heavy Bullet Flak"
	sprite_index = sprFlakBullet
	image_xscale = 1.5
	image_yscale = 1.5
	image_speed = .7
	ammo = 22
	force = 8
	typ = 1
	damage = 64
	mask_index = mskFlakBullet
	friction = 0
	on_draw = flak_draw
	on_destroy = fat_pop
	on_step = fat_step
}
return a;

#define fat_step
if !irandom(1) {instance_create(x,y,Smoke)}
if speed < .1 {instance_destroy()}

#define fat_pop
sound_play(sndHeavyMachinegun)
sound_play(sndFlakExplode)
view_shake_at(x,y,12)
 if skill_get(19) = false{
	repeat(ammo){
		with instance_create(x,y,HeavyBullet){
			team = other.team
			creator = other.creator
			motion_set(random(359),16)
			image_angle = direction
		}
	}
}
else
{
	var offset = random(359);
	repeat(ammo){
		with instance_create(x,y,HeavyBullet){
			team = other.team
			creator = other.creator
			motion_set(offset,16)
			image_angle = direction
		}
	offset += 360/ammo
	}
}
#define create_bullet_flak(_x,_y)
var a = instance_create(_x,_y,CustomProjectile);
with(a){
	name = "Bullet Flak"
	sprite_index = global.sprBullakYellow
	image_speed = 1
	ammo = 16
	force = 8
	typ = 1
	damage = 16
	mask_index = mskFlakBullet
	friction = 0
	on_draw    = flak_draw
	on_destroy = woa_pop
	on_step    = woa_step
	on_hit     = woa_hit
}
return a;

#define woa_hit
if other.team != team
{
		if projectile_canhit_melee(other) = true
		{
			var _hp = other.my_health;
			projectile_hit(other,damage,force,direction)
			damage = round(damage-_hp)
			instance_create(x,y,Smoke)
			if ammo > 0
			{
				ammo--
				with instance_create(x,y,Bullet1){
					team = other.team
					creator = other.creator
					motion_set(random(359),18)
					image_angle = direction
					}
			}
			if damage <= 0 instance_destroy()
		}
}

#define woa_step
/*if irandom(7) = 0
{
	with instance_create(x,y,Bullet1)
	{
		team = other.team
		creator = other.creator
		motion_add(other.direction-180+random_range(-60,60),16)
		image_angle = direction
	}
}*/
if image_index = 1 image_speed = 0
if !irandom(2) {instance_create(x,y,Dust)}
if speed < .1 {instance_destroy()}
image_angle = direction

#define woa_pop
sound_play(sndMachinegun)
sound_play(sndFlakExplode)
view_shake_at(x,y,8)
if skill_get(19) = false{
	repeat(ammo){
	with instance_create(x,y,Bullet1){
		team = other.team
		creator = other.creator
		motion_set(random(359),16)
		image_angle = direction
		}
	}
}
else
{
	var offset = random(359);
	repeat(ammo){
	with instance_create(x,y,Bullet1){
		team = other.team
		creator = other.creator
		motion_set(offset,16)
		image_angle = direction
		}
	offset += 360/ammo
	}
}

#define create_flameshell_flak(_x,_y)
var a = instance_create(_x,_y,CustomProjectile);
with(a){
	name = "Flame Flak"
	sprite_index = global.sprFireFlak
	image_speed = 1
	ammo = 22
	force = 5
	typ = 1
	friction = random_range(.8,1.2)
	damage = 32
	mask_index = mskFlakBullet
	friction = random_range(.3,.7)
	on_draw = flak_draw
	on_destroy = flameshell_pop
	on_step = flameshell_step
}
return a;

#define flameshell_pop
sound_play(sndMachinegun)
sound_play(sndFlakExplode)
view_shake_at(x,y,8)
if skill_get(19) = false{
	repeat(ammo){
	with instance_create(x,y,FlameShell){
		team = other.team
		creator = other.creator
		motion_set(random(359),random_range(11,13))
		image_angle = direction
		}
	}
}
else
{
	var offset = random(359);
	repeat(ammo){
	with instance_create(x,y,FlameShell){
		team = other.team
		creator = other.creator
		motion_set(offset,13)
		image_angle = direction
		}
	offset += 360/ammo
	}
}
#define flameshell_step
if !irandom(1){
	with instance_create(x,y,Flame){
		team = other.team
		creator = other.creator
		motion_add(random(359),random(3))
	}
}
image_angle = direction
if speed < .1 {instance_destroy()}

//THESE ARE A HORRIBLE IDEA NEVER USE THEM
#define create_recursive_flak(_x,_y)
var a = instance_create(_x,_y,CustomProjectile);
with(a){
	name = "Recursive Flak"
	sprite_index = sprFlakBullet
	image_speed = .7
	force = 5
	typ = 1
	damage = 32
	mask_index = mskFlakBullet
	friction = 0
	on_draw = flak_draw
	on_destroy = loop_pop
	on_step = loop_step
}
return a;

#define loop_step
if !irandom(2) {instance_create(x,y,Smoke)}
if speed < friction {instance_destroy()}

#define loop_pop
sound_play(sndFlakExplode)
with create_recursive_flak(x,y){
	motion_set(random(359),12+random(2))
	creator = other.creator
	team = other.team
	image_angle = direction
}
/*with choose(create_dark_flak(x,y),create_fire_flak(x,y),create_heavy_flak(x,y),create_idpd_flak(x,y),create_lightning_flak(x,y),create_psy_flak(x,y),create_toxic_flak(x,y)){
	motion_set(random(359),12+random(2))
	creator = other.creator
	team = other.team
	image_angle = direction
}*/

//function that converts vintage code to new code so i dont have to rewrite the flak guns
#define create_flak(accuracymode,accuracy,offset,Friction,bullet,bulletmass,Creator)
if !accuracymode{
	var acc = random(accuracy)-accuracy/2;
}else{
	var acc = accuracy;
}
var x1 = x+lengthdir_x(offset,gunangle);
var y1 = y+lengthdir_y(offset,gunangle);
var b = "stop this";
if bullet = HeavyBullet{
	b = create_heavy_flak(x1,y1)
}
if bullet = BouncerBullet{
	b = create_bouncer_flak(x1,y1)
}
if bullet = "split"{
	b = create_split_flak(x1,y1)
}
if bullet = "recursive"{
	b = create_recursive_flak(x1,y1)
}
if bullet = IDPDBullet{
	b = create_idpd_flak(x1,y1)
}
if bullet = FlameShell{
	b = create_flameshell_flak(x1,y1)
}
if bullet = Bullet1{
	b = create_bullet_flak(x1,y1)
}
if !is_string(bullet)
if bullet < 5{
	b = mod_script_call("mod","defpack tools 2","create_"+global.flaks[bullet]+"_flak",x1,y1)
}

if b = "stop this" {trace(b)}
else with(b){
	motion_set(other.gunangle+acc*other.accuracy,16)
	if bullet = 2{speed/=1.5}
	ammo = bulletmass
	offset = random(360)
	if bullet = 3{speed/=2}
	creator = Creator
	team = creator.team
}
return b


//previously mentioned vintage code
/*#define create_flak(accuracymode,accuracy,offset,Friction,bullet,bulletmass,Creator)
// PUT IN FOR BULLET EITHER AN OBJECT NAME OR 1 = FIRE BULLET, 2 = TOXIC BULLET, 3 = LIGHTNING BULLET, 4 = PSY BULLET, 4 = DARK BULLET
// ATM CAN THE REGUALR FLAK BULLET COLLISION RARELY OCCUR VEFOR THE INSTANCE_CHANGE FUNCTION, LITTLE BIT BUGGY
if accuracymode = 0
{
  acc = random(accuracy)-accuracy/2
}
else
{
  acc = accuracy;
}
var q = instance_create(x+lengthdir_x(offset,point_direction(x,y,mouse_x,mouse_y)),y+lengthdir_y(offset,point_direction(x,y,mouse_x,mouse_y)),CustomProjectile)
with q
 {
   hashit = 0
   creator = Creator;
   motion_add(point_direction(x,y,mouse_x,mouse_y)+other.acc*creator.accuracy,9)
   friction = Friction;
   team = other.team;
   typ = 1
   damage = 100
   force = 12
   Bullet = bullet;
   Bulletmass = bulletmass;
   sprite_index = sprFlakBullet
   if Bullet = 1{sprite_index = global.sprFireFlak}
   if Bullet = 2{sprite_index = global.sprToxicFlak}
   if Bullet = 3{speed /= 2; sprite_index = global.sprLightningFlak}
   if Bullet = 4{speed /= 3; sprite_index = global.sprPsyFlak}
   if Bullet = 5{sprite_index = global.sprDarkFlak}
   if Bullet = IDPDBullet{sprite_index = global.sprIDPDFlak;friction = 0.58}
   if Bullet = HeavyBullet{image_xscale *= 1.5; image_yscale *= 1.5; damage *= 2; speed += 4}
   //on_destroy = script_ref_create(flak_destroy)
   on_draw = script_ref_create(flak_draw)
   on_hit = script_ref_create(flak_hit)
   on_step = script_ref_create(flak_step)
   timer = 8
      on_destroy = script_ref_create(flak_destroy)
}

#define flak_step
if Bullet = 1
{
  if irandom(1) = 1
  {
    with instance_create(x,y,Flame)
    {
      team = other.team
      motion_add(other.direction,random_range(0.6,1.2))
    }
  }
}
if Bullet = 4
{
  if instance_exists(enemy)
  {
    if collision_line(x,y,instance_nearest(x,y,enemy).x,instance_nearest(x,y,enemy).y,Wall,0,0) < 0
    {
      if distance_to_object(instance_nearest(x,y,enemy)) < 200
      {
          motion_add(point_direction(x,y,instance_nearest(x,y,enemy).x,instance_nearest(x,y,enemy).y),0.64)
          image_angle = direction
      }
    }
  }
  if speed >8
  {
    speed = 8
  }
}
if Bullet = HeavyBullet
{
  if irandom(2) = 1
  {
    instance_create(x,y,Smoke)
  }
}
if Bullet != 2
{
  if irandom(2) = 1
  {
    instance_create(x,y,Smoke)
  }
}
else
{
  timer -= 1
  if timer <= 0
  {
    if irandom(1) = 1
    {
      instance_create(x,y,ToxicGas)
    }
  }
}
if speed <= 0
{
  instance_destroy()
}

#define flak_destroy
repeat(Bulletmass)
{
  if Bullet < 6
  {
    if instance_exists(creator)
    {
      if Bullet = 1
      {
          with mod_script_call("mod", "Defpack Tools", "create_fire_bullet",x,y){
          creator = other
          team = other.team
          motion_set(random(360),15)
         image_angle = direction
      }
    }
    if Bullet = 2
    {
      with mod_script_call("mod", "Defpack Tools", "create_toxic_bullet",x,y){
      creator = other
      team = other.team
      motion_set(random(360),10)
      image_angle = direction
      }
   }
   if Bullet = 3{with mod_script_call("mod", "Defpack Tools", "create_lightning_bullet",x,y){
        creator = other
        team = other.team
        motion_set(random(360),5)
        image_angle = direction
     }}
    if Bullet = 4{with mod_script_call("mod", "Defpack Tools", "create_psy_bullet",x,y){
         creator = other
         team = other.team
         motion_set(random(360),2.5)
         image_angle = direction
      }}
    if Bullet = 5{mod_script_call("mod", "Defpack Tools", "create_dark_bullet",0,random(360),0,creator)}
  }
  }
  else
  {
    if Bullet = IDPDBullet
    {
      if irandom(1) = 1
      {
        with instance_create(x-lengthdir_x(speed+5,direction),y-lengthdir_y(speed+5,direction),Bullet)
        {
         motion_add(random(360),16)
         image_angle = direction
         team = other.team
        }
      }
    }
    else
    {
      with instance_create(x-lengthdir_x(speed+5,direction),y-lengthdir_y(speed+5,direction),Bullet)
      {
       motion_add(random(360),16)
       image_angle = direction
       team = other.team
      }
    }
  }
}
instance_create(x,y,BulletHit)
sound_play(sndFlakExplode)

#define flak_hit

projectile_hit(other, damage, force);
if hashit = 0
{
  hashit = 1
  image_speed = 1
  sound_play(sndFlakExplode)
  if Bullet = HeavyBullet
  {
    sound_play(sndHeavyMachinegun)
  }
  instance_destroy()
}
