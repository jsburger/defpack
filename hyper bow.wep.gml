#define init
global.sprBow      = sprite_add_weapon("sprites/weapons/sprThunderBow.png",6,12)
global.sprArrow    = sprite_add("sprites/projectiles/sprThunderArrow.png",1,4,2)
global.sprArrowHUD = sprite_add_weapon("sprites/projectiles/sprThunderArrow.png",5,3)
global.sprBoltStick = sprite_add("sprites/projectiles/sprBoltStickGround.png", 6, 6, 10)

global.deflectors = [
	CrystalShield, PopoShield,
	
	Slash, GuitarSlash, BloodSlash, EnergySlash, Shank, EnergyShank, EnergyHammerSlash, LightningSlash, EnemySlash
];

global.deflector_count = array_length(global.deflectors);

#define weapon_name
return "HYPER BOW"

#define weapon_type
return 3

#define weapon_cost
return 2

#define weapon_area
return 11

#define weapon_chrg
return 1

#define weapon_load
return 14

#define weapon_swap
return sndSwapHammer

#define weapon_auto
return mod_script_call_nc("mod", "defpack tools", "abris_weapon_auto", "hyper bow charge", self)

#define weapon_melee
return false

#define weapon_laser_sight
return false

#define weapon_reloaded

#define weapon_sprt
if instance_is(self,Player){
    with instances_matching(instances_matching(CustomObject, "name", "thunder bow charge"),"creator", id){
        var yoff = (creator.race = "steroids" and btn = "spec") ? -1 : 1
        with creator{
            var l = other.charge/other.maxcharge * 4 - 1
            if other.charged
                for var i = -.5; i <= .5; i++{
                    draw_sprite_ext(other.spr_arrow, 0, x - lengthdir_x(l, gunangle), y - lengthdir_y(l, gunangle) + yoff, 1, 1, gunangle + 12*i, c_white, 1)
                }
            else draw_sprite_ext(other.spr_arrow, 0, x - lengthdir_x(l, gunangle), y - lengthdir_y(l, gunangle) + yoff, 1, 1, gunangle, c_white, 1)
        }
    }
}
return global.sprBow

#define weapon_sprt_hud
return global.sprArrowHUD

#define nts_weapon_examine
return{
    "d": "The limit of hunting weapon technology. #Fires arrows in a spread or straight ahead. ",
}

#define weapon_text
return "MOST ADVANCED TECHNOLOGY"

#define weapon_fire
with instance_create(x,y,CustomObject){
    sound   = sndHyperRifle
	name    = "hyper bow charge"
	creator = other
	charge    = 0
    maxcharge = 8
    defcharge = {
        style : 2,
        width : 14,
        charge : 0,
        maxcharge : maxcharge
    }
	charged = 0
	depth = TopCont.depth
	spr_arrow = global.sprArrow
	index = creator.index
    accuracy = other.accuracy
	on_step    = bow_step
	on_destroy = bow_destroy
	on_cleanup = bow_cleanup
	reload = -1
	btn = other.specfiring ? "spec" : "fire"
	hand = other.specfiring and other.race == "steroids"
}


#define bow_step
if !instance_exists(creator){instance_delete(self);exit}
var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
if button_check(index,"swap"){instance_delete(self);exit}
if reload = -1{
    reload = hand ? creator.breload : creator.reload
    reload += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale
}
else{
    if hand creator.breload = max(creator.breload, reload)
    else creator.reload = max(reload, creator.reload)
}
view_pan_factor[index] = 3 - (charge/maxcharge * .5)
defcharge.charge = charge
if button_check(index, btn){
    if charge < maxcharge{
        charge += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale;
        charged = 0
        sound_play_pitchvol(sound,sqr((charge/maxcharge) * 4) * .2,1 - charge/maxcharge * .4)
    }
    else{
        if current_frame mod 6 < current_time_scale {
            creator.gunshine = 1
            with defcharge blinked = 1
        }
        charge = maxcharge;
        if charged = 0{
            mod_script_call_self("mod","defpack tools", "weapon_charged", creator, 12)
            charged = 1
        }
    }
}
else{instance_destroy(); exit}
if charged {
  creator.speed *= .75;
}

#define bow_cleanup
view_pan_factor[index] = undefined
sound_stop(sound)

#define bow_destroy
bow_cleanup()
var _p = random_range(.8,1.2)
sound_play_pitchvol(sndSwapGuitar,4*_p,.8)
sound_play_pitchvol(sndAssassinAttack,2*_p,.8)
sound_play_pitchvol(sndClusterOpen,1.6*_p,.5)
sound_play_pitchvol(sndHyperLauncher,3.5*_p,1)
sound_play_pitchvol(sndSuperCrossbow,.7*_p,.4)

var _c = charge/maxcharge;

if charged = 1{
    sleep(60)

    sound_play_pitchvol(sndHeavyCrossbow, .4 * _p, .8)
    sound_play_pitchvol(sndHyperRifle, 1.8 * _p, .8)
    sound_play_pitchvol(sndHyperLauncher, 2 * _p, .8)

    var _elbow = skill_get("compoundelbow");

    with creator weapon_post(3,-46,6)
    with creator motion_add(gunangle - 180, 2)
    with HitscanBolt_create(creator.x + creator.hspeed, creator.y + creator.vspeed){
      direction = other.creator.gunangle;
      image_angle = direction;
      team = other.creator.team;
      creator = other.creator;
      damage = 50;
      bounce = 4 * _elbow;
      hitscan = true;

	}
    instance_destroy()
}else{
    with creator weapon_post(1,-20,0)

    var ang = creator.gunangle + random_range(-5,5) * creator.accuracy,
	    i   = -30 * accuracy * (1 - _c * .6);
    repeat(5){
        with instance_create(creator.x,creator.y,Bolt){
            sprite_index = other.spr_arrow
            mask_index   = mskBullet1
            creator = other.creator
            team    = creator.team
            damage = 8
            move_contact_solid(creator.gunangle,2)
            motion_add(ang + i,30)
            image_angle = direction
        }
        i += 15 * accuracy * (1 - _c * .6);
    }
}


#define hyperbow_step
	timer -= current_time_scale
	if timer <= 0{
		timer = 2
		ammo--

		with creator{
	        weapon_post(1,-10,0)
	        repeat(6) with instance_create(x,y,Dust){
	            motion_add(random(360),choose(5,6))
	        }
	    }
	    sound_play_pitchvol(sndShovel,2,.8)
    sound_play_pitchvol(sndUltraCrossbow,3,.8)

	    with instance_create(creator.x + lengthdir_x(2 + irandom(5), creator.gunangle + choose(-90, 90)),creator.y + lengthdir_y(2 + irandom(5), creator.gunangle + choose(-90, 90)),HeavyBolt){
            sprite_index = global.sprArrow
            mask_index   = mskBullet1
            creator = other.creator
            team    = creator.team
            damage = 11
            move_contact_solid(creator.gunangle,4)
            motion_add(creator.gunangle,32)
            image_angle = direction
        }
    }
    if ammo <= 0 instance_destroy()


#define HitscanBolt_create(_x, _y)
with(instance_create(_x, _y, CustomProjectile)){
	name = "HitscanBolt";
	
	creator = (instance_is(other, FireCont) && "creator" in other ? other.creator : other);
	team = ("team" in other ? other.team : other);
	damage = 20;
	old_x = x;
	old_y = y;
	
	bounce = 4 * skill_get("compoundelbow");
	hitscan = true;
	homing_dist = 24;
	walled = false;
	
	destroy_timer = 30;
	
	sprite_index = sprBolt;
	mask_index = mskBolt;
	image_speed = 0.4;
	speed = 20;
	
	on_anim = script_ref_create(HitscanBolt_anim);
	on_step = script_ref_create(HitscanBolt_step);
	on_wall = script_ref_create(HitscanBolt_wall);
	on_hit = script_ref_create(HitscanBolt_hit);
	
	return self;
}

#define HitscanBolt_anim
if (walled) {
    if !irandom(1){
        image_speed = 0
        image_index = 5
    }
    else{
        image_index = irandom(3)
        image_speed += .1
    }
}

#define HitscanBolt_trail()
var _dist = point_distance(old_x, old_y, x, y);
var _dir = point_direction(old_x, old_y, x, y);

with(instance_create(old_x, old_y, BoltTrail)){
	image_xscale = _dist;
	image_angle = _dir;
	image_yscale = other.image_yscale;
}

old_x = x;
old_y = y;

#define HitscanBolt_attack(_home)
var _dist = homing_dist * _home * skill_get(mut_bolt_marrow);

if (distance_to_object(hitme) <= _dist){
	var _targets = instances_matching_ne(instances_matching_ne(instances_matching_le(instances_matching_le(instances_matching_ge(instances_matching_ge(hitme, "bbox_right", bbox_left - _dist), "bbox_bottom", bbox_top - _dist), "bbox_left", bbox_right + _dist), "bbox_top", bbox_bottom + _dist), "object_index", IceFlower, ThroneStatue, GeneratorInactive, ProtoStatue, GuardianStatue), "team", team);
	
	if (array_length(_targets)){
		var original_dist = _dist;
		var _hits = 0;
		// var _x = x;
		// var _y = y;
		
		with(_targets){
			if (team == 0){
				_dist = 0;
			}
			
			if (distance_to_object(other) <= _dist){
				_hits += 1;
				
				with(other){
					HitscanBolt_trail();
					
					if (_dist && !place_meeting(x, y, other)){
						x = other.x;
						y = other.y;
					}
					
					HitscanBolt_hit();
					
					if (!instance_exists(self)){
						return false;
					}
					
					// x = _x;
					// y = _y;
				}
			}
			
			_dist = original_dist;
		}
		
		return (_hits > 0);
	}
}

return false;

#define HitscanBolt_deflect()
var _array = [];

for (var i = 0; global.deflector_count > i; i ++){
	var _deflector = global.deflectors[i];
	
	if (!distance_to_object(_deflector)){
		array_push(_array, _deflector);
	}
}

if (array_length(_array)){
	var _deflectors = instances_matching_ne(instances_matching_le(instances_matching_le(instances_matching_ge(instances_matching_ge(_array, "bbox_right", bbox_left), "bbox_bottom", bbox_top), "bbox_left", bbox_right), "bbox_top", bbox_bottom), "team", team);
	
	if (array_length(_deflectors)){
		with(_deflectors){
			if (place_meeting(x, y, other)){
				with(other){
					instance_destroy();
					return true;
				}
			}
		}
	}
}

if (instance_exists(CustomSlash)){
	var custom_slashes = instances_matching_ne(instances_matching_le(instances_matching_le(instances_matching_ge(instances_matching_ge(CustomSlash, "bbox_right", bbox_left), "bbox_bottom", bbox_top), "bbox_left", bbox_right), "bbox_top", bbox_bottom), "team", team);
	
	if (array_length(custom_slashes)){
		with(custom_slashes){
			if (place_meeting(x, y, other)){
				if (candeflect && is_array(on_projectile) && array_length(on_projectile) >= 3){
					if (mod_script_exists(on_projectile[0], on_projectile[1], on_projectile[2])){
						mod_script_call(on_projectile[0], on_projectile[1], on_projectile[2]);
						
						if (!instance_exists(other)){
							return true;
						}
					}
				}
				
				else if (candeflect){
					with(other){
						instance_destroy();
						return true;
					}
				}
			}
		}
	}
}

return false;

#define HitscanBolt_step
if (distance_to_point(xstart, ystart) >= 2048){
	instance_destroy();
	exit;
}

if (abs(image_speed) > 0 && (image_index + image_speed_raw >= image_number || image_index + image_speed_raw < 0)){
	image_speed = 0;
}

if (walled){
	if (destroy_timer > 0){
		destroy_timer -= current_time_scale;
		
		if (destroy_timer <= 0){
			instance_destroy();
		}
	}
	
	exit;
}

if (!hitscan){
	HitscanBolt_attack(true);
	HitscanBolt_trail();
}

else{
	var _tries = 128;
	var _ox = lengthdir_x(4, direction);
	var _oy = lengthdir_y(4, direction);
	
	while (_tries -- > 0){
		if (place_meeting(x, y, Wall)){
			break;
		}
		
		if (HitscanBolt_attack(true) || !instance_exists(self) || HitscanBolt_deflect()){
			break;
		}
		
		xprevious = x;
		yprevious = y;
		x += _ox;
		y += _oy;
	}
}

#define HitscanBolt_wall
if (!instance_exists(self)){
	exit;
}

if (bounce > 0){
	bounce -= 1;
	move_bounce_solid(true);
	image_angle = direction;
	sound_play_pitchvol(sndBoltHitWall, random_range(1.4, 1.7), 0.7);
}

else if (other.solid && !walled){
	speed = 0;
	walled = true;
	sound_play(sndBoltHitWall);
	move_contact_solid(direction, speed_raw);
	sprite_index = global.sprBoltStick;
	image_angle += 90;
	HitscanBolt_trail();
	instance_create(x, y, Dust).depth = depth;
}

#define HitscanBolt_hit
if (walled){
	exit;
}

if (projectile_canhit(other)){
	projectile_hit(other, damage);
	
	var _destroy = false;
	
	with(other){
		if (my_health > 0){
			_destroy = true;
			
			var _angle = other.direction;
			var _sprite = other.sprite_index;
			
			with(instance_create(x, y, BoltStick)){
				target = other;
				image_angle = _angle;
			}
		}
		
		view_shake_max_at(x, y, 8 + 4 * clamp(size, 1, 3));
		sleep(10 + 5 * clamp(size, 1, 3));
	}
	
	HitscanBolt_trail();
	
	if (_destroy){
		instance_destroy();
	}
}
