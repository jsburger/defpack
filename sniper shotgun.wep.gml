#define init
global.sprSniperShotgun = sprite_add_weapon("sprites/weapons/sprSniperShotgun.png", 5, 3);
global.deviation = 25;

#define weapon_chrg
return true;

#define weapon_name
return "SNIPER SHOTGUN"

#define weapon_sprt
return global.sprSniperShotgun;

#define weapon_type
return 1;

#define weapon_auto
return mod_script_call_nc("mod", "defpack tools", "sniper_weapon_auto", self)

#define weapon_load
return 60;

#define weapon_cost
return 60;

#define weapon_iris
return "sniper x shotgun"

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
with instances_matching(instances_matching(CustomObject, "name", "SniperCharge"), "creator", self){
    with other {
        draw_set_alpha(.3 + .7  * (other.charge/other.maxcharge))
        var _c = 14074;
        with mod_script_call_self("mod", "defpack tools", "sniper_fire", x, y, gunangle - (global.deviation * (1 - other.charge/other.maxcharge)) * accuracy, team, 1 + other.charge/other.maxcharge, 1){
            draw_line_width_color(xstart, ystart, x, y, 1, _c, _c)
            instance_destroy()
        }
        with mod_script_call_self("mod", "defpack tools", "sniper_fire", x, y, gunangle + (global.deviation * (1 - other.charge/other.maxcharge)) * accuracy, team, 1 + other.charge/other.maxcharge, 1){
            draw_line_width_color(xstart, ystart, x, y, 1, _c, _c)
            instance_destroy()
        }
        draw_set_alpha(1)
    }
    return false
}
return false;

#define weapon_reloaded
repeat(5)mod_script_call("mod", "defpack tools", "shell_yeah_long", 100, 8, 3 + random(2), c_yellow)
sound_play_pitchvol(sndSwapPistol, 2, .4)
sound_play_pitchvol(sndRecGlandProc, 1.4, 1)
weapon_post(-2, -4, 5)

return -1;

#define weapon_area
return 13;

#define weapon_text
return choose("THE PARADOX");

#define weapon_fire
with mod_script_call_self("mod", "defpack tools", "create_sniper_charge", x, y){
    creator = other
    team = other.team
    index = other.index
    cost = weapon_cost()
    amount = 5;
    is_super = true;
    deviation = global.deviation * other.accuracy
}
