#define init
global.sprSuperSonicLauncher   = sprite_add_weapon("sprites/sprSuperSonicLauncher.png", 1, 3);
global.sprSonicStreak   = sprite_add("sprites/projectiles/sprSonicStreak.png",6,8,32);

#define weapon_name
return "SUPERSONIC LAUNCHER"

#define weapon_sprt
return global.sprSuperSonicLauncher;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 43;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 15;

#define weapon_text
return choose("A TRUE BOOMBURST","SHIFT SOME SMOKE","CLOSE COMBAT INFUSION");

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
	damage = 70
	dir = 0
	image_angle = other.gunangle
	Ring1Amount = 6
	Ring2Amount = 12
	ringoffset	= random(360)
	instance_create(x,y,Smoke)
	repeat(30) with instance_create(x, y, Dust){
	    motion_add(other.direction-random_range(-60,60),random_range(2,5));
	    growspeed = random_range(0.1,0.005)
    }
	direction = other.gunangle+random_range(-2,2)*other.accuracy
	do{
	    dir += 1
	    x += lengthdir_x(1,direction)
	    y += lengthdir_y(1,direction)
    	if irandom(1) = 0 with instance_create(x,y,Dust){
    	    motion_add(other.direction-random_range(-80,80),random_range(2,7));
    	    growspeed = random_range(0.1,0.005)
    	}
    	if place_meeting(x,y,enemy) || place_meeting(x,y,Wall) || place_meeting(x,y,prop){
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
    damage = dmg
    
    if dustspeed repeat(10 * scale) with instance_create(x, y, Dust) motion_set(random(360), dustspeed)
    
    return id
}

#define supersonic_burst
sound_play_pitch(sndImpWristKill,1.7)
sound_play_pitch(sndExplosionS,random_range(.4,.6))
sound_play_pitch(sndSuperBazooka,2)
var _a = random(360)
repeat(8){
	var _r = random_range(47,54)
	with instance_create(x+lengthdir_x(_r,_a),y+lengthdir_y(_r,_a),AcidStreak){
		sprite_index = global.sprSonicStreak
		image_angle = _a - 90
		image_speed = .3
	}
	_a += 360/8
}
explo(0, 0, 1, .6, 12, 7)
explo(0, 0, .8, .5, 8, 7)
explo(0, 0, .5, .4, 6, 7)

for var i = 0; i < Ring1Amount; i++{
    explo(60, 360/Ring1Amount * i + ringoffset, .5, 1, 5, 0)
    explo(60, 360/Ring1Amount * i + ringoffset, .2, .5, 4, 0)
}
for var i = 0; i < Ring2Amount; i++{
    explo(100, 360/Ring2Amount * i + ringoffset, .2, .8, 3, 0)
}
repeat(8){with instance_nearest(x,y,Wall){if distance_to_object(other)<= 32{instance_create(x,y,FloorExplo);instance_destroy()}}}








