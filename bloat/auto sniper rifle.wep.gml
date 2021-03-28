#define init
global.sprAutoSniperRifle = sprite_add_weapon("../sprites/weapons/sprAutoSniperRifle.png", 7, 3);

#define weapon_name
return "AUTO SNIPER RIFLE"

#define weapon_sprt
return global.sprAutoSniperRifle;

#define weapon_type
return 1;

#define weapon_auto
return 1;

#define weapon_load
return 20;

#define weapon_cost
return 12;

#define weapon_iris
return "auto sniper x rifle"

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
with instances_matching(instances_matching(CustomObject, "name", "SniperCharge"), "creator", self) {
    with other {
        with mod_script_call_self("mod", "defpack tools", "sniper_fire", x, y, gunangle, team, 1 + other.charge/other.maxcharge, 1){
            draw_line_width_color(xstart, ystart, x, y, 1, 14074, 14074)
            instance_destroy()
        }
    }
    return false
}
return false;

#define weapon_reloaded
mod_script_call("mod", "defpack tools", "shell_yeah_long", 100, 8, 3 + random(2), c_yellow)
sound_play_pitchvol(sndSwapPistol, 2, .4)
sound_play_pitchvol(sndRecGlandProc, 1.4, 1)
weapon_post(-2, -4, 5)

return -1;

#define weapon_area
return 9;

#define weapon_text
return choose("HOLD THE FIRE");

#define weapon_fire
with mod_script_call_self("mod", "defpack tools", "create_sniper_charge", x, y){
    creator = other
    team = other.team
    index = other.index
    cost = weapon_cost()
    deviation = 8 * other.accuracy;
    mod_script_call("mod", "defpack tools", "snipercharge_fire")
    instance_destroy()
}
