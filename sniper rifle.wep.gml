#define init
global.sprSniperRifle = sprite_add_weapon("sprites/weapons/sprSniperRifle.png", 5, 3);

#define weapon_chrg
return true;

#define weapon_name
return "SNIPER RIFLE"

#define weapon_sprt
return global.sprSniperRifle;

#define weapon_type
return 1;

#define weapon_auto
return 1;

#define weapon_load
return 43;

#define weapon_cost
return 12;

#define weapon_iris
return "sniper x rifle"

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
with instances_matching(instances_matching(CustomObject, "name", "sniper charge"),"creator",self){
    with other{
        with mod_script_call_self("mod", "defpack tools", "sniper_fire", x, y, gunangle, team, 1 + other.charge/other.maxcharge){
            draw_line_width_color(xstart, ystart, x, y, 1, 14074, 14074)
            instance_destroy()
        }
    }
    return false
}
return false;

#define weapon_reloaded
mod_script_call("mod","defpack tools", "shell_yeah_long", 100, 8, 3+random(2), c_yellow)
sound_play_pitchvol(sndSwapPistol,2,.4)
sound_play_pitchvol(sndRecGlandProc,1.4,1)
weapon_post(-2,-4,5)
return -1;

#define weapon_area
return 9;

#define weapon_text
return choose("ONE SHOT");

#define weapon_fire
with mod_script_call_self("mod", "defpack tools", "create_sniper_charge", x, y){
    creator = other
    team = other.team
    index = other.index
    cost = weapon_cost()
}
