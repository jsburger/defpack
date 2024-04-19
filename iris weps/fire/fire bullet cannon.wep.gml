#define init
global.sprFireBulletCannon = sprite_add_weapon("../../sprites/weapons/iris/fire/sprFireBulletCannon.png", 4, 2);

#define weapon_name
return "FIRE BULLET CANNON";

#define weapon_sprt
return global.sprFireBulletCannon;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 18;

#define weapon_cost
return 7;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "GOUTS OF @rFLAME@d";

#define weapon_fire

weapon_post(9,-6,72)
var _p = random_range(.8, 1.2),
    vol = .6;
sound_play_pitchvol(sndHeavySlugger,      2 * _p, vol)
sound_play_pitchvol(sndDoubleFireShotgun, 2 * _p, vol)
sound_play_pitchvol(sndSawedOffShotgun, 1.8 * _p, vol)
sound_play_pitchvol(sndFlamerStop,       .4 * _p, .6 * vol)
repeat(8){
    mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_red)
    with mod_script_call("mod", "defpack tools", "create_fire_bullet",x+lengthdir_x(random_range(-7,7)*accuracy,gunangle+90),y+lengthdir_y(random_range(-7,7)*accuracy,gunangle+90)){
    	creator = other
    	team = other.team
    	team = other.team
    	move_contact_solid(other.gunangle,5)
    	motion_add(other.gunangle+random_range(-18,18)*other.accuracy,18+random_range(-8,5)*other.accuracy)
    	image_angle = direction
    }
}
