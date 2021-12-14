#define init
    global.sprPlasmaThrower = sprPlasmaRifle;

#define weapon_name
    return "PLASMATHROWER";

#define weapon_type
    return 5;

#define weapon_cost
    return 1;

#define weapon_area
    return -1;

#define weapon_load
    return 20;

#define weapon_swap
    return sndSwapEnergy;

#define weapon_auto
    return true;

#define weapon_melee
    return false;

#define weapon_laser_sight
    return false;

#define weapon_sprt
    return global.sprPlasmaThrower;

#define weapon_text
    return "ENDLESS HEAT";

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)
#define weapon_fire
    
    weapon_post(4, 6, 0);
    
    with instance_create(x, y, CustomObject) {
        
        name = "plasmathrower burst";
        team = other.team;
        creator = other;
        
        load = weapon_get_load(mod_current);
        
        on_step = plasmaburst_step;
    }
    
#define plasmaburst_step
    if (!instance_exists(creator)) {
        
        instance_delete(self);
        exit;
    }
    if (current_frame_active) {
        
        load--;
        
        repeat(2) with create_defball(creator.x + creator.hspeed, creator.y + creator.vspeed) {
            
            team = other.team;
            creator = other.creator;
             move_contact_solid(creator.gunangle, 12);
            motion_add(creator.gunangle + random_range(-3, 3) * creator.accuracy, 5 + random(1));
            timer = 30 * 3;
            friction = .2;
            accuracy = .3;
        }
        
        if (load <= 0) {
            
            instance_destroy();
        }
    }
    
#define create_defball(X, Y) return mod_script_call("mod", "defballs", "create_defball", X, Y);