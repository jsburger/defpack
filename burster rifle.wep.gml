#define init
global.sprBursterRifle = sprite_add_weapon("sprites/weapons/sprBursterRifle.png",2,1);
global.sprBursterRifleHUD = sprite_add_weapon("sprites/weapons/sprBursterRifle.png",2,3);

// I took the tempo gun as a template thats why it looks like that
#define weapon_name             return "BURSTER RIFLE";
#define weapon_text             return ["BUBBLY @ySHELLS"];

#define weapon_sprt             return global.sprBursterRifle;
#define weapon_sprt_hud         return global.sprBursterRifleHUD;
#define weapon_swap             return sndSwapShotgun;

#define weapon_auto             return true;
#define weapon_load             return 2;
#define weapon_type             return 1;
#define weapon_cost             return 1;
#define weapon_rads             return 0;

#define weapon_area             return 5;

#define weapon_melee            return false;
#define weapon_gold             return false;
#define weapon_laser_sight      return false;
#define weapon_fire

    var _p = random_range(.8, 1.2);
    sound_play_pitchvol(sndPopgun, .8 * _p, .8);
    sound_play_pitchvol(sndDoubleShotgun, 1.4 * _p, .3);
    
    weapon_post(6, 12, 0);

   with mod_script_call("mod", "defpack tools", "create_burster", x, y) {
            
		team    = other.team;
		creator = other;
		
		tar_dir = other.gunangle;
		tar_len = point_distance(x, y, mouse_x[other.index], mouse_y[other.index]) + 200;
		move_contact_solid(other.gunangle, 10);
		motion_add(other.gunangle + random_range(-2, 2) * other.accuracy, 12);
		image_angle = direction;
		
    }