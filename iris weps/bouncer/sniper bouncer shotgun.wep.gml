#define init
global.sprSniperBouncerShotgun = sprite_add_weapon("../../sprites/weapons/iris/bouncer/sprSniperBouncerShotgun.png", 8, 3);
global.deviation = 32;

#define weapon_chrg
return true;

#define weapon_name
return "BOUNCER SNIPER SHOTGUN"

#define weapon_sprt
return global.sprSniperBouncerShotgun;

#define weapon_type
return 1;

#define weapon_auto
return 1;

#define weapon_load
return 52;

#define weapon_cost
return 60;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
with instances_matching(instances_matching(CustomObject, "name", "BouncerSniperShotCharge"), "creator", self){
    with other {
        draw_set_alpha(.3 + .7  * (other.charge/other.maxcharge))
        var _c = 14074;
        with mod_script_call_self("mod", "defpack tools", "sniper_fire", x, y, gunangle - (global.deviation * (1 - other.charge/other.maxcharge))*accuracy, team, 1 + other.charge/other.maxcharge, 1){
            draw_line_width_color(xstart, ystart, x, y, 1, _c, _c)
            instance_destroy()
        }
        with mod_script_call_self("mod", "defpack tools", "sniper_fire", x, y, gunangle + (global.deviation * (1 - other.charge/other.maxcharge))*accuracy, team, 1 + other.charge/other.maxcharge, 1){
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
return -1;

#define weapon_text
return choose("BOUNCE FOREVER");

#define weapon_fire
with mod_script_call_self("mod", "defpack tools", "create_sniper_charge", x, y){
    name = "BouncerSniperShotCharge"
    creator = other
    team = other.team
    index = other.index
    cost = weapon_cost()
    amount = 5;
    deviation = global.deviation * other.accuracy
    on_fire = script_ref_create(bouncer_shotgun_fire)
}

#define bouncer_shotgun_fire
var _ptch = random_range(-.5,.5)
sound_play_pitch(sndHeavySlugger,.55-_ptch/8)
	sound_play_pitch(sndHeavyNader,.4-_ptch/8)
	sound_play_pitch(sndNukeExplosion,5-_ptch*2)
	sound_play_pitch(sndSawedOffShotgun,.8-_ptch)
    sound_play_pitchvol(sndBouncerSmg,.6, 2)
    sound_play_pitchvol(sndBouncerShotgun,.8, 2)
    sound_play_pitchvol(sndUltraGrenade,1.5, 2)
	sound_play_pitch(sndSniperFire,random_range(.6,.8))
var _c = charge, _cc = charge/maxcharge;
with creator{
        weapon_post(15,40,210)
		motion_add(gunangle -180,_c / 5)
		sleep(200)
	repeat(other.amount){var q = shoot(x + lengthdir_x(10, gunangle), y + lengthdir_y(10, gunangle), gunangle + random(other.deviation) * choose(-1, 1) * (1 - other.charge/other.maxcharge), team, 1 + _cc, 2)
	with q{
	    creator = other
	    damage = 40
	    worth = 12
	    friends = q
	}}
}
sleep(charge*3)

#define shoot(_x, _y, dir, t, w, bounces)
var ar = []
var q = mod_script_call_self("mod", "defpack tools", "sniper_fire", _x, _y, dir, t, w, 0);
unpack(ar, q)
if bounces > 0{
    with q[array_length(q)-1]{
	    	if instance_exists(Wall){
	        var hsp = lengthdir_x(2, direction), vsp = lengthdir_y(2, direction);
	        var x2 = x, y2 = y, l = 3, l2 = .5;
	        x -= hsp; y -= vsp;
	        if collision_rectangle(x - l, y + l2, x + l, y - l2, Wall, 1, 0) hsp *= -1
	        if collision_rectangle(x + l2, y - l, x - l2, y + l, Wall, 1, 0) vsp *= -1
	        x = x2; y = y2;
	        var d = point_direction(0, 0, hsp, vsp)
	        unpack(ar, shoot(x, y, d, team, w, bounces - 1))
	    }
    }
}
return ar;

#define unpack(box, stuff)
for var i = 0; i < array_length(stuff); i++{
    if is_array(stuff[i]){
        unpack(box, stuff[i])
    }
    else{
        array_push(box, stuff[i])
    }
}