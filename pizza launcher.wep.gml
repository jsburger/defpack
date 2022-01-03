#define init
global.sprPizzaLauncher = sprite_add_weapon("sprites/weapons/sprPizzaLauncher.png", 1, 4)
global.sprPizzaFX = sprite_add("sprites/projectiles/sprPizzaGamble.png", 4, 16, 16);
#define weapon_name
return "PIZZA LAUNCHER"
#define weapon_type
return 3
#define weapon_cost
return 1
#define weapon_area
if GameCont.area = 102 { // Drop in pizza sewers exclusively
    
    return 0;
}
return -1;
#define weapon_load
return 16
#define weapon_swap
sound_play_pitch(sndSwapBow, 1.2);
sound_play_pitch(sndPizzaBoxBreak, 1.2);
return -1
#define weapon_auto
return 1
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_sprt
return global.sprPizzaLauncher
#define weapon_reloaded

#define weapon_text
return choose("COWABUNGA UNLIMITED")

#define weapon_fire
var _p = random_range(.8, 1.2)
sound_play_pitchvol(sndDiscgun, .8 * _p, .7);
sound_play_pitchvol(sndFrogExplode, 3 * _p, 1);
sound_play_pitchvol(sndRatKingVomit, 7 * _p, .6);
sound_play_pitchvol(sndBigMaggotHit, 1.2 * _p, .6);
weapon_post(3, -4, 0)
with mod_script_call_nc("mod", "defpack tools", "create_pizzadisc", x, y){
    motion_set(other.gunangle + random_range(-3, 3) * other.accuracy, 6);
    image_angle = direction
    team = other.team;
    creator = other;
    move_contact_solid(other.gunangle, 16);
    with instance_create(x, y, BloodGamble) {
        
        sprite_index = global.sprPizzaFX;
        image_angle  = other.direction;
    }
}
