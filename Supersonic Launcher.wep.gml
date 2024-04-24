#define init
global.sprSuperSonicLauncher   = sprite_add_weapon("sprites/weapons/sprSuperSonicLauncher.png", 1, 3);
global.sprSonicStreak   = sprite_add("sprites/projectiles/sprSonicStreak.png", 7, 24, 8);

#define weapon_name
return "SUPERSONIC LAUNCHER"

#define weapon_sprt
return global.sprSuperSonicLauncher;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 48;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 15;

#define nts_weapon_examine
return{
    "d": "The projectile is fast enough to break the sound barrier. #Shifts a lot of smoke. ",
}

#define weapon_text
return "DEAFENING";

#define weapon_fire
sleep(12)
var p = random_range(.8,1.2)
//sound_play_pitch(sndDiscgun,1.6) good pest sound
//sound_play_pitch(sndPortalAppear,3) ancient gunnery
sound_play_pitch(sndUltraShotgun,1.7*p)
sound_play_pitch(sndHyperLauncher,.6*p)
sound_play_gun(sndClickBack,1,.2)
sound_stop(sndClickBack)
weapon_post(12,-16,23)
motion_add(gunangle -180,6)

with instance_create(x,y,CustomProjectile){
	move_contact_solid(other.gunangle,10)
	sleep(55)
	sprite_index = mskNone
	mask_index = sprNuke
	index = other.index
	team  = other.team
	damage = 30
	dir = 0
	bounce = 0;
	hasbounced = false;
	image_angle = other.gunangle
	Ring1Amount = 6
	Ring2Amount = 12
	xdir = 1;
	ydir = 1;
	ringoffset	= random(360)
	instance_create(x,y,Smoke)
	direction = other.gunangle+random_range(-2,2)*other.accuracy
	with instance_create(x+lengthdir_x(16,direction),y+lengthdir_y(16,direction),AcidStreak){
		sprite_index = global.sprSonicStreak
		image_angle = other.direction
		image_speed = .5
	}
	do{
		hasbounced = false;
	    dir += 1
	    x += lengthdir_x(xdir,direction)
	    y += lengthdir_y(ydir,direction)

    	if irandom(1) = 0 with instance_create(x,y,Dust){
    	    motion_add(other.direction-random_range(-80,80),random_range(2,7));
    	    growspeed = random_range(0.1,0.06)
    	}

    	if hasbounced = false && place_meeting(x + xdir,y,Wall){

    		if bounce > 0{

				wall_burst();
				hasbounced = true;
				bounce--;
				xdir *= -1;
				move_bounce_solid(false);
    		}else{

				dir = 1000;
				break;
			}
		}
		if hasbounced = false && place_meeting(x,y + ydir,Wall){

    		if bounce > 0{

				wall_burst();
				hasbounced = true;
				bounce--;
				ydir *= -1;
				move_bounce_solid(false);
    		}else{

				dir = 1000;
				break;
			}
		}
		if hasbounced = false && place_meeting(x + xdir,y + ydir,Wall){

    		if bounce > 0{

				wall_burst();
				hasbounced = true;
				bounce--;
				xdir *= -1;
				ydir *= -1;
				move_bounce_solid(false);
    		}else{

				dir = 1000;
				break;
			}
		}

    	if place_meeting(x,y,enemy) || place_meeting(x,y,prop){
    	    break
    	}
    }
    while dir < 1000

    xprevious = x
    yprevious = y
	on_end_step = supersonic_step
	on_destroy  = supersonic_burst
}

#define supersonic_step
instance_destroy()

#define explo(length, dir, scale, spd, dmg, dustspeed)
with mod_script_call_nc("mod", "defpack tools", "create_sonic_explosion", x + lengthdir_x(length, dir), y + lengthdir_y(length, dir)){
    image_xscale = scale
    image_yscale = scale

    team = other.team
    creator = other.creator
    image_speed = spd
		superforce = 32
		superfriction = 0.01

    if dustspeed repeat(10 * scale) with instance_create(x, y, Smoke) {motion_set(random(360), dustspeed * random_range(.8, 1.1)); sprite_index = sprExtraFeetDust}

    return id
}

#define wall_burst
with mod_script_call_nc("mod", "defpack tools", "create_sonic_explosion", x, y){
    image_xscale = .75;
    image_yscale = .75;

    team = other.team
    creator = other.creator
    image_speed = .6;
	superforce = 24
	superfriction = 0.05
}

#define supersonic_burst
sound_play_pitch(sndImpWristKill,1.7)
sound_play_pitch(sndExplosionS,random_range(.4,.6))
sound_play_pitch(sndSuperBazooka,2)
var _a = random(360)
repeat(6){
	var _r = 64
	with instance_create(x+lengthdir_x(_r,_a),y+lengthdir_y(_r,_a),AcidStreak){
		sprite_index = global.sprSonicStreak
		image_angle = _a
		image_speed = .3
	}
	_a += 360/6
}
sleep(70)
explo(3, direction - 180,  1.1, .6, 12, 7)
explo(3, direction - 180,   .9, .4, 6, 7)
view_shake_max_at(x, y, 36)

repeat(24){with instance_nearest(x,y,Wall){if distance_to_object(other)<= 48{instance_create(x,y,FloorExplo);instance_destroy()}}}
