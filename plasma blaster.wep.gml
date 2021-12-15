#define init
    global.sprPlasmaThrower = sprPlasmaGun;

#define weapon_name
    return "PLASMA BLASTER";

#define weapon_type
    return 5;

#define weapon_cost
    return 2;

#define weapon_area
    return -1;

#define weapon_load
    return 5;

#define weapon_swap
    return sndSwapEnergy;

#define weapon_auto
    return false;

#define weapon_melee
    return false;

#define weapon_laser_sight
    return false;
    
#define weapon_reloaded
    return -4;

#define weapon_sprt
    return global.sprPlasmaThrower;

#define weapon_text
    return "GREEN GOO";

#define weapon_fire
    
    var _p = random_range(.8, 1.2),
        _u = skill_get(mut_laser_brain) > 0;
    sound_play_pitchvol(_u ? sndPlasmaRifleUpg : sndPlasmaRifle, 1.7 * _p - .2 * _u, .7);
    sound_play_pitchvol(sndLilHunterBouncer, 3 * _p, .7);
    
    weapon_post(6, 0, 8);
    
    var _speed = 12,
        _minsp = .01,
        _timer = 40,
        _frict = .7;
    with instance_create(x, y, CustomProjectile) {
        
        team = other.team;
		creator = other;
        sprite_index = mskNone;
        mask_index   = sprHeavyNade;
        image_speed  = 0;
        depth -= 10;
        
        motion_add(other.gunangle + random_range(-2, 2) * other.accuracy, _speed * 1.3);
        minspeed = _minsp;
        friction = _frict;
        
        on_step = plastarget_step;
        on_hit  = plastarget_wall;
        on_wall = plastarget_wall; 
        
        var _t = self;
    }
    
    with create_defball_xl(x, y) {
            
        team = other.team;
        creator = other;
        motion_add(other.gunangle + random_range(-4, 4) * other.accuracy, _speed * random_range(.8, 1.2));
        timer = _timer;
        friction = _frict;
        minspeed = _minsp;
        accuracy = .1;
        target = _t;
    }

    repeat(4 + skill_get(mut_laser_brain) * 4) with create_defball_l(x, y) {
            
        team = other.team;
        creator = other;
        motion_add(other.gunangle + random_range(-24, 24) * other.accuracy, _speed * random_range(.8, 1.2));
        timer = _timer;
        friction = _frict;
        minspeed = _minsp;
        accuracy = .1;
        target = _t;
    }
    
    repeat(2 + skill_get(mut_laser_brain)) with create_defball_m(x, y) {
            
        team = other.team;
        creator = other;
        motion_add(other.gunangle + random_range(-24, 24) * other.accuracy, _speed);
        timer = _timer;
        friction = _frict;
        minspeed = _minsp;
        accuracy = .1;
        target = _t;
    }

#define plastarget_step
    if (speed < minspeed) {
    		
        speed += friction + .15;
    }

#define plastarget_wall
    instance_destroy();
    
#define nothing
#define create_defball_m(X, Y) return mod_script_call("mod", "defballs", "create_defball_m", X, Y);
#define create_defball_l(X, Y) return mod_script_call("mod", "defballs", "create_defball_l", X, Y);
#define create_defball_xl(X, Y) return mod_script_call("mod", "defballs", "create_defball_xl", X, Y);