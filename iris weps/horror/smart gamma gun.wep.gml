#define init
global.sprSmartHorrorGun = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprSmartHorrorGunOn.png",4, 5);

#define weapon_name
return "SMART GAMMA GUN"

#define weapon_sprt
return global.sprSmartHorrorGun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 3;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return -1;

#define weapon_text
return "SPEAK THROUGH THE GUN";

#define weapon_fire
var ang = point_direction(x,y,mouse_x[index],mouse_y[index]);
if instance_exists(enemy)
{
	var mydude = instance_nearest(mouse_x[index],mouse_y[index],enemy);
	ang = point_direction(x,y,mydude.x,mydude.y)
}
gunangle = ang;
aimDirection = ang;
if fork(){
    wait(0)
    if !instance_exists(self) exit
    gunangle = ang;
    aimDirection = ang;
    exit
}
sound_play_pitch(sndSmartgun,random_range(.7,.9))
sound_play_pitchvol(sndBouncerSmg,1.6,.8)
sound_play_pitchvol(sndUltraPistol,random_range(2.4, 2.8),.8)
weapon_post(6,-2,4)
repeat(2) mod_script_call("mod","defpack tools", "shell_yeah", 100, 40, random_range(2,4), c_lime)

if fork(){
    var time = 8;
    while time > 0 && instance_exists(self){
        canaim = 0
        time -= current_time_scale
        wait(0)
    }
    if instance_exists(self) canaim = 1
    exit
}


with mod_script_call("mod", "defpack tools", "create_gamma_bullet",x,y){
    creator = other
    team = other.team
    motion_set(other.gunangle + random_range(-3,3) * other.accuracy,random_range(14,18))
	image_angle = direction
}with mod_script_call("mod", "defpack tools", "create_gamma_bullet",x,y){
    creator = other
    team = other.team
    motion_set(other.gunangle + random_range(-14,14) * other.accuracy,random_range(14,18))
	image_angle = direction
}