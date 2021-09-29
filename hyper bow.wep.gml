#define init
global.sprBow      = sprite_add_weapon("sprites/weapons/sprThunderBow.png",6,12)
global.sprArrow    = sprite_add("sprites/projectiles/sprThunderArrow.png",1,4,2)
global.sprArrowHUD = sprite_add_weapon("sprites/projectiles/sprThunderArrow.png",5,3)
global.sprBoltStick = sprite_add("sprites/projectiles/sprBoltStickGround.png", 6, 6, 10)

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
else{instance_destroy()}

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
    with BouncerBolt_create(creator.x + creator.hspeed, creator.y + creator.vspeed){
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


#define BouncerBolt_create(_x, _y)
with(instance_create(_x, _y, CustomProjectile)){
	team = 2;
	creator = (instance_is(other, FireCont) && "creator" in other ? other.creator : other);
	typ = 2;
	damage = 20;
	destroy_timer = 30;

	bounce = 4;
	homing_dist = 24;
	old_x = x;
	old_y = y;
	hitscan = false;
	trail_yscale = 1;
	walled = false;

	sprite_index = sprBolt;
	mask_index = mskBolt;
	image_speed = 0.4;
	speed = 20;

	on_step = script_ref_create(BouncerBolt_step);
	on_anim = script_ref_create(BouncerBolt_anim);
	on_wall = script_ref_create(BouncerBolt_wall);
	on_hit = script_ref_create(BouncerBolt_hit);

	on_bounce = [];

	return self;
}

#define BouncerBolt_trail()
var _dist = point_distance(old_x, old_y, x, y);
var _dir = point_direction(old_x, old_y, x, y);
var _scale = trail_yscale;

with(instance_create(old_x, old_y, BoltTrail)){
	image_xscale = _dist;
	image_angle = _dir;
	image_yscale = _scale;
}

old_x = x;
old_y = y;

#define BouncerBolt_attack(_home)
var _dist = homing_dist * skill_get(mut_bolt_marrow) * _home;

if (distance_to_object(hitme) <= _dist){
	var _hitmes = [];

	if (_home){
		_hitmes = instances_matching_ne(hitme, "team", team, 0);
	}

	else{
		_hitmes = instances_matching_ne(hitme, "team", team);
	}

	if (array_length(_hitmes)){
		var _hits = 0;

		with(instance_rectangle_bbox(bbox_left - homing_dist, bbox_top - homing_dist, bbox_right + homing_dist, bbox_bottom + homing_dist, instances_matching_ne(_hitmes, "object_index", IceFlower, ThroneStatue, GeneratorInactive, ProtoStatue, GuardianStatue))){
			if (distance_to_object(other) <= _dist){
				_hits += 1;

				with(other){
					BouncerBolt_hit();

					if (!instance_exists(self)){
						return false;
					}
				}
			}
		}

		return (_hits > 0);
	}
}

return false;

#define BouncerBolt_deflect()
if (!distance_to_object(CrystalShield) || !distance_to_object(PopoShield)){
	with(instance_rectangle_bbox(bbox_left, bbox_top, bbox_right, bbox_bottom, instances_matching_ne([CrystalShield, PopoShield], "team", team))){
		if (!distance_to_object(other)){
			with(other){
				instance_destroy();
				return true;
			}
		}
	}
}

else if (!distance_to_object(Slash) || !distance_to_object(GuitarSlash) || !distance_to_object(BloodSlash) || !distance_to_object(EnergySlash) || !distance_to_object(Shank) || !distance_to_object(EnergyShank) || !distance_to_object(EnergyHammerSlash) || !distance_to_object(LightningSlash) || !distance_to_object(EnemySlash)){
	with(instance_rectangle_bbox(bbox_left, bbox_top, bbox_right, bbox_bottom, instances_matching_ne([Slash, GuitarSlash, BloodSlash, EnergySlash, Shank, EnergyShank, EnergyHammerSlash, LightningSlash, EnemySlash], "team", team))){
		if (!distance_to_object(other)){
			with(other){
				instance_destroy();
				return true;
			}
		}
	}
}

else if (!distance_to_object(CustomSlash)){
	with(instance_rectangle_bbox(bbox_left, bbox_top, bbox_right, bbox_bottom, instances_matching_ne(CustomSlash, "team", team))){
		if (!distance_to_object(other)){
			if (is_array(on_projectile) && array_length(on_projectile) >= 3){
				var _type = on_projectile[0];
				var _name = on_projectile[1];
				var _script = on_projectile[2];

				if (mod_script_exists(_type, _name, _script)){
					mod_script_call(_type, _name, _script, other);

					if (!instance_exists(other)){
						return true;
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

#define BouncerBolt_step
if (distance_to_point(xstart, ystart) >= 4096){
	instance_destroy();
	exit;
}

if (image_speed > 0 && (image_index + image_speed_raw >= image_number || image_index + image_speed_raw < 0)){
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
	BouncerBolt_attack(true);
	BouncerBolt_trail();
}

else{
	var _length = 4;
	var _dir = direction;
	var _ox = lengthdir_x(_length, _dir);
	var _oy = lengthdir_y(_length, _dir);
	var _tries = 256;

	var _dist = homing_dist;

	while (_tries -- > 0){
		if (!distance_to_object(Wall)){
			break;
		}

		if (!distance_to_object(hitme) && BouncerBolt_attack(false)){
			break;
		}

		else if (!instance_exists(self)){
			break;
		}

		if (BouncerBolt_attack(true) || !instance_exists(self) || BouncerBolt_deflect()){
			break;
		}

		xprevious = x;
		yprevious = y;
		x += _ox;
		y += _oy;
	}
}

#define BouncerBolt_anim
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

#define BouncerBolt_wall
if (walled){
	exit;
}

BouncerBolt_trail();
instance_create(x, y, Dust).depth = depth

if (bounce > 0){
	move_bounce_solid(true);

	image_angle = direction;

	bounce -= 1;

  sound_play_pitchvol(sndBoltHitWall, random_range(1.4, 1.7), .7);

	if (is_array(on_bounce) && array_length(on_bounce) >= 3){
		var _type = on_bounce[0];
		var _name = on_bounce[1];
		var _script = on_bounce[2];

		if (mod_script_exists(_type, _name, _script)){
			mod_script_call(_type, _name, _script);
		}
	}
}

else{
	move_contact_solid(direction, speed_raw);
	walled = true;
	speed = 0;
	sound_play(sndBoltHitWall)
	sprite_index = global.sprBoltStick
    image_xscale = choose(-1,1)
    image_speed = .4
	image_angle += 90
}

#define BouncerBolt_hit
if (walled){
	exit;
}

if (projectile_canhit(other)){
	var _damage = damage;
	var _destroy = false;

	var _x = x;
	var _y = y;
	var _angle = direction;

	var _sprite = sprite_index;

	with(other){
		if (my_health > _damage){
			_destroy = true;

			with(instance_create(_x, _y, BoltStick)){
				target = other;
				image_angle = _angle;
				sprite_index = _sprite;
				image_index = image_number - 1;
				image_speed = 0;
			}
		}

		projectile_hit(self, _damage);
	    view_shake_max_at(x, y, 8 + 4 * clamp(size, 1, 3));
	    sleep(10 + 5 * clamp(size, 1, 3));
	}

	BouncerBolt_trail();

	if (_destroy){
		instance_destroy();
	}
}

#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)
var _x = _x1;
var _y = _y1;

_x1 = min(_x, _x2);
_y1 = min(_y, _y2);
_x2 = max(_x, _x2);
_y2 = max(_y, _y2);

return instances_matching_le(instances_matching_le(instances_matching_ge(instances_matching_ge(_obj, "bbox_right", _x1), "bbox_bottom", _y1), "bbox_left", _x2), "bbox_top", _y2);

if "i" in self{
    with other{
        
    }
}
