#define init
global.sprFlechetteShotgun = sprite_add_weapon("sprites/weapons/sprFlechetteShotgun.png", 5, 2);

#define weapon_name
return "FLECHETTE SHOTGUN";

#define weapon_sprt
return global.sprFlechetteShotgun;

#define weapon_type
return 3;

#define weapon_auto
return true;

#define weapon_load
return 26;

#define weapon_cost
return 6;

#define weapon_laser_sight
return true;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 8;

#define weapon_text
return "ANTI-PERSONELL WATER GUN";

#define weapon_fire
repeat(3){
    weapon_post(7,-8,22)
    sound_play_pitch(sndUltraCrossbow,random_range(2.5,3))
    sound_play_pitch(sndCrossbow,random_range(.4,.6))
    sound_play_pitch(sndDoubleShotgun,random_range(1.2,1.4))
    with mod_script_call("mod", "defpack tools", "create_flechette", x + lengthdir_x(6, gunangle), y + lengthdir_y(6, gunangle)){
    	creator = other;
    	team    = creator.team;
      friction *= random_range(.9, 1.1);
    	motion_add(other.gunangle - random_range(-8, 8) * creator.accuracy - 8 * creator.accuracy, 20 + random_range(-4, 4) * creator.accuracy);
    	image_angle = direction;
    }

    with mod_script_call("mod", "defpack tools", "create_flechette", x + lengthdir_x(6, gunangle), y + lengthdir_y(6, gunangle)){
    	creator = other;
    	team    = creator.team;
      friction *= random_range(.9, 1.1);
    	motion_add(other.gunangle + random_range(-8, 8) * creator.accuracy + 8 * creator.accuracy, 20 + random_range(-4, 4) * creator.accuracy);
    	image_angle = direction;
    }
}
