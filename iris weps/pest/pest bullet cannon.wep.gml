#define init
global.sprPestBulletCannon = sprite_add_weapon("../../sprites/weapons/iris/pest/sprPestBulletCannon.png", 4, 2);

#define weapon_name
return "PEST BULLET CANNON";

#define weapon_sprt
return global.sprPestBulletCannon;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 24;

#define weapon_cost
return 7;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "DIRTY WARFARE";

#define weapon_fire

weapon_post(9,-6,52)
var _ptch = random_range(-.4,.4),
    vol = .6;
sound_play_pitchvol(sndHeavySlugger,2+_ptch, vol)
sound_play_pitchvol(sndDoubleShotgun,2, vol)
sound_play_pitchvol(sndSawedOffShotgun,1.8, vol)
sound_play_pitchvol(sndToxicBarrelGas,.6+_ptch/10, vol)
sound_play_pitchvol(sndToxicBoltGas,.6+_ptch/10, vol)
repeat(8){
    mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, 2+random(3), c_green)
    with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x+lengthdir_x(random_range(-7,7)*accuracy,gunangle+90),y+lengthdir_y(random_range(-7,7)*accuracy,gunangle+90)){
    	creator = other
    	team = other.team
    	move_contact_solid(other.gunangle,5)
    	motion_add(other.gunangle+random_range(-4,4)*other.accuracy,14+random_range(-3,3)*other.accuracy)
    	image_angle = direction
    }
}
