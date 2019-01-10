#define init
global.sprBullakRed = sprite_add("sprites/projectiles/sprBullakRed.png", 2, 11, 10)
global.sprBullakYellow = sprite_add("sprites/projectiles/sprBullakYellow.png", 2, 11, 10)
global.sprBullakGreen = sprite_add("sprites/projectiles/sprBullakGreen.png", 2, 11, 10)
global.sprBullakBlue = sprite_add("sprites/projectiles/sprBullakBlue.png", 2, 11, 10)
global.sprBullakBlueUpg = sprite_add("sprites/projectiles/sprBullakBlueUpg.png", 2, 12, 10)
global.sprBullakPurple = sprite_add("sprites/projectiles/sprBullakPurple.png", 2, 11, 10)
global.sprFireFlak = sprite_add("sprites/projectiles/Fire Flak.png", 2, 11, 10)
global.sprDarkFlak = sprFlakBullet //rip
global.sprIDPDFlak = sprite_add("sprites/projectiles/IDPD Flak.png", 2, 8, 8)
global.sprSplitFlak = sprite_add("sprites/projectiles/IDPD Flak.png", 2, 8, 8)
global.flaks = ["recursive", "fire", "toxic", "lightning", "psy", "dark", "split", "bouncer"]

#define flak_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.10);
draw_set_blend_mode(bm_normal);

#define chance(percentage)
return (random(100) < percentage * current_time_scale)

#define bullak_anim
image_index = 1
image_speed = 0

#define bullak_step
if chance(30) instance_create(x,y,Smoke)

#define bullak_hit
if projectile_canhit_melee(other) = true
{
	var _hp = other.my_health;
	sleep(40)
	projectile_hit(other,damage,force,direction)
	damage = round(damage-_hp)
	instance_create(x,y,Smoke)
	if ammo-- > 0{
	    with proj(payload){
	        team = other.team
	    	creator = other.creator
			motion_set(random(359),12)
			image_angle = direction
		}
	}
	if damage <= 0 instance_destroy()
}


#define flak_pop
burst(payload, ammo, accuracy)
sound_play_hit_big(sndFlakExplode, .1)

#define flak_step
if chance(30) instance_create(x,y,Smoke)
image_speed = speed / 10
if speed <= friction instance_destroy()

#define genbullak(_x,_y)
with instance_create(_x,_y,CustomProjectile){
    mask_index = mskFlakBullet
    payload = Bullet1
    image_speed = 1
    ammo = 5
    damage = 16
    on_hit = bullak_hit
    on_destroy = flak_pop
    on_step = bullak_step
    on_draw = flak_draw
    on_anim = bullak_anim
    return id
}

#define genflak(_x,_y)
with instance_create(_x,_y,CustomProjectile){
    mask_index = mskFlakBullet
    payload = Bullet2
    ammo = 12
    force = 8
    accuracy = 1
    damage = 12
    typ = 1
    on_draw = flak_draw
    on_step = flak_step
    on_destroy = flak_pop
    return id
}

#define burst(p, c, spread)
if c > 0{
    var a = random(360),
        d = 360/c;
    for var i = 0; i < 360; i += d{
        with proj(p){
            direction = i + random_range(-d/2, d/2) * spread
            projectile_init(other.team, other.creator)
            image_angle = direction
        }
    }
}

#define proj(p)
switch p{
    case Bullet2:
        with instance_create(x,y,Bullet2){
            speed = random_range(12,18)
            return id
        }
    case Bullet1:
        with instance_create(x,y,Bullet1){
            speed = 16
            return id
        }
    case FlameShell:
        with instance_create(x,y,FlameShell){
            speed = random_range(11,15)
            return id
        }
    case BouncerBullet:
        with instance_create(x,y,BouncerBullet){
            speed = 8
            return id
        }
    case "fire bullet":
        with mod_script_call_self("mod", "defpack tools", "create_fire_bullet", x, y){
            speed = 15
            return id
        }
    case "lightning bullet":
        with mod_script_call_self("mod", "defpack tools", "create_lightning_bullet", x, y){
            speed = 10
            return id
        }
    case "psy bullet":
        with mod_script_call_self("mod", "defpack tools", "create_psy_bullet", x, y){
            speed = 10
            return id
        }
    case "toxic bullet":
        with mod_script_call_self("mod", "defpack tools", "create_toxic_bullet", x, y){
            speed = 10
            return id
        }
}

#define create_bullak(_x,_y)
with genbullak(_x, _y){
    name = "Bullak"
    sprite_index = global.sprBullakYellow
    return id
}

#define create_fire_bullak(_x,_y)
with genbullak(_x, _y){
    name = "Fire Bullak"
    damage = 18
    on_step = flame_bullak_step
    sprite_index = global.sprBullakRed
    payload = "fire bullet"
    return id
}

#define flame_bullak_step
if chance(30) with instance_create(x, y, Flame){
    team = other.team
    creator = other.creator
    motion_set(random(360), random_range(2, 4))
}

#define create_lightning_bullak(_x,_y)
with genbullak(_x, _y){
    name = "Lightning Bullak"
    on_step = lightning_bullak_step
    payload = "lightning bullet"
    damage = 20
    ammo = 6
    on_destroy = lightning_bullak_pop
    sprite_index = skill_get(mut_laser_brain) ? global.sprBullakBlueUpg : global.sprBullakBlue
    return id
}

#define lightning_bullak_pop
if fork(){
    with instance_create(x,y,CustomObject){
        sound_play_hit(sndFlakExplode,.1)
        sound_play_hit(sndMachinegun,.1)
        ammo = other.ammo
        creator = other.creator
        team = other.team
        payload = other.payload
        accuracy = other.accuracy
        var carry = ammo div 2;
        burst(payload, floor(ammo/2), accuracy)
        wait(3)
        if instance_exists(self)
            burst(payload, floor(ammo/2) + carry, accuracy)
    }
    exit
}

#define lightning_bullak_step
if chance(25) with instance_create(x,y,Lightning){
	team = other.team
	creator = other.creator
	ammo = 2+irandom(3)
	alarm0=1
	image_angle = random(359)
}
bullak_step()


#define create_psy_bullak(_x, _y)
with genbullak(_x, _y){
    name = "Psy Bullak"
    on_step = psy_bullak_step
    sprite_index = global.sprBullakPurple
    damage = 30
    payload = "psy bullet"
    timer = 5
    return id
}

#define psy_bullak_step
if timer > 0{
	timer -= current_time_scale
}
if timer <= 0{
	var closeboy = mod_script_call_self("mod","defpack tools","instance_nearest_matching_ne",x,y,hitme,"team",team)
	if instance_exists(closeboy) && distance_to_object(closeboy) < 160 && collision_line(x,y,closeboy.x,closeboy.y,Wall,0,0) < 0{
		var dir, spd;

		dir = point_direction(x, y, closeboy.x, closeboy.y);
		spd = speed * 5 * current_time_scale

        var _f = .3;
		direction -= clamp(angle_difference(image_angle, dir) * _f * current_time_scale, -spd, spd); //Smoothly rotate to aim position.
		image_angle = direction
	}
}
bullak_step()

#define create_toxic_bullak(_x, _y)
with genbullak(_x, _y){
    name = "Toxic Bullak"
    sprite_index = global.sprBullakGreen
    payload = "toxic bullet"
    on_step = toxic_bullak_step
    return id
}

#define toxic_bullak_step
if chance(50) && (!instance_exists(creator) || distance_to_object(creator) > 20) with instance_create(x,y,ToxicGas){
	image_angle = random(359)
	motion_set(random(356),random(2))
	creator = other.creator
}

#define create_bouncer_bullak(_x, _y)
with genbullak(_x, _y){
    name = "Bouncer Bullak"
    payload = BouncerBullet
    sprite_index = sprBouncerBullet
    image_xscale = 1.5
    image_yscale = 1.5
    on_wall = bouncer_bullak_wall
		on_step = bouncer_bullak_step
    bounces = 2
    return id
}

#define bouncer_bullak_step
image_angle += 6

#define bouncer_bullak_wall
move_bounce_solid(0)
speed *= .8
with instance_create(x,y,BouncerBullet){
    creator = other.creator
    team = other.team
	view_shake_at(x,y,8)
	sleep(3)
	sound_play_pitch(sndBouncerBounce,random_range(.6,.7))
	motion_set(other.direction+random_range(-33,33),8)
	image_angle = direction
}
image_angle = direction + 90
if bounces-- <= 0{
    instance_destroy()
}

#define create_flameshell_flak(_x, _y)
with genflak(_x, _y){
    name = "Flame Shell Flak"
    payload = FlameShell
    ammo = 25
    sprite_index = global.sprFireFlak
    on_step = flameshell_flak_step
    friction = random_range(.3,.7)
    return id
}

#define flameshell_flak_step
if chance(20) with instance_create(x, y, Flame){
    motion_set(random(360), random(2))
    projectile_init(other.team, other.creator)
    image_angle = direction
}
flak_step()



#define create_split_flak(_x,_y)
var a = instance_create(_x,_y,CustomProjectile);
with(a){
	name = "Split Flak"
	sprite_index = global.sprSplitFlak
	image_speed = .7
	ammo = 1
	typ = 1
	force = 10
	damage = 8
	friction = 1.5
	mask_index = mskFlakBullet
	heavy = 0
	on_draw = flak_draw
	on_destroy = split_pop
	on_hit = split_hit
	on_step = split_step
}
return a;

#define split_burst(count, spread)
var a = heavy ? "create_heavy_split_shell" : "create_split_shell"
sound_play(sndFlakExplode)
view_shake_at(x,y,8)
var inc = 360/count, ang = random(360)
for var i = 0; i < 360; i+= inc{
    with mod_script_call_self("mod", "defpack tools", a, x, y){
        creator = other.creator
        team = other.team
        motion_set(i + random_range(-inc/2, inc/2) * spread, 10)
        image_angle = direction
    }
}

#define split_hit
projectile_hit(other, damage, force, direction);
instance_destroy()

#define split_pop
var a = "create_split_shell"
if heavy a = "create_heavy_split_shell"
sound_play_hit_big(sndFlakExplode,.1)
view_shake_at(x,y,8)
repeat(4){
    with mod_script_call("mod","defpack tools",a,x,y){
		creator = other.creator
	    team = other.team
		motion_add(other.direction+random_range(-20,20)*other.accuracy,random_range(16,20))
		image_angle = direction
	}
}
split_burst(4, accuracy)

#define split_step
if chance(30) {instance_create(x,y,Dust)}
image_speed = speed/10
if speed <= friction{
    if heavy{
        split_burst(4, accuracy)
        speed += 20
        heavy = 0
        image_xscale = 1
        image_yscale = 1
    }
    else{
        instance_destroy()
        exit
    }
}



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
	accuracy = 1
	friction = 0
	on_draw = flak_draw
	on_destroy = loop_pop
	on_step = loop_step
}
return a;

#define loop_step
if chance(30) instance_create(x,y,Smoke)
image_speed = speed/10
if speed <= friction {instance_destroy()}

#define loop_pop
sound_play(sndFlakExplode)
with create_recursive_flak(x,y){
	motion_set(random(360),12+random(2))
	creator = other.creator
	team = other.team
	image_angle = direction
}
with script_execute(script_get_index("create_" + choose("split_flak", "fire_bullak", "toxic_bullak", "lightning_bullak", "bullak", "psy_bullak", "bouncer_bullak", "flameshell_flak", "recursive_flak")), x, y){
	motion_set(random(360),12+random(2))
	creator = other.creator
	team = other.team
	image_angle = direction
	accuracy = other.accuracy
}
