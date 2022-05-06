#define init
global.sprBursterShotgun = sprite_add_weapon("sprites/weapons/sprDoubleBursterShotgun.png",2,1);
global.sprBursterShotgunHUD = sprite_add_weapon("sprites/weapons/sprDoubleBursterShotgun.png",2,3);

// I took the tempo gun as a template thats why it looks like that
#define weapon_name             return "DOUBLE BURSTER SHOTGUN";
#define weapon_text             return ["DOUBLE THE BUBBLE"];

#define weapon_sprt             return global.sprBursterShotgun;
#define weapon_sprt_hud         return global.sprBursterShotgunHUD;
#define weapon_swap             return sndSwapShotgun;

#define weapon_auto             return false;
#define weapon_load             return 48;
#define weapon_type             return 2;
#define weapon_cost             return 2;
#define weapon_rads             return 0;

#define weapon_area             return 9;

#define weapon_melee            return false;
#define weapon_gold             return false;
#define weapon_laser_sight      return false;
#define weapon_fire

    var _p = random_range(.8, 1.2);
    sound_play_pitchvol(sndLilHunterSniper, 1.4 * _p, .4);
    sound_play_pitch(sndDoubleShotgun, 1.2 * _p);
    
    weapon_post(10, 18, 0);

    repeat(15) {
        
        with mod_script_call("mod", "defpack tools", "create_burster", x, y) {
            
            team    = other.team;
            creator = other;
            
            tar_dir = other.gunangle;
            tar_len = point_distance(x, y, mouse_x[other.index], mouse_y[other.index]);
		    move_contact_solid(other.gunangle, 10);
		    motion_add(other.gunangle + random_range(-100, 100) * other.accuracy, 9 * random_range(.8, 1.1));
		    image_angle = direction;
        }
    }