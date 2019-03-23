#define init
global.sprSniperBouncerRifle = sprite_add_weapon("sprites/sprSniperBouncerRifle.png", 6, 2);
global.color = 14074
#define weapon_name
return "BOUNCER SNIPER RIFLE"

#define weapon_chrg
return true;

#define weapon_sprt
return global.sprSniperBouncerRifle;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 20;

#define weapon_cost
return 12;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
with instances_matching(instances_matching(CustomObject, "name", "sniper bouncer charge"),"creator",self){
    with other{
        var q = shoot(x + lengthdir_x(10, gunangle), y + lengthdir_y(10, gunangle), gunangle, team, 1 + other.charge/other.maxcharge, 2)
        with q{
            draw_line_width_color(xstart, ystart, x, y, 1, global.color, global.color)
            instance_destroy()
        }
    }
    return false
}
return false;

#define weapon_reloaded
with mod_script_call("mod","defpack tools", "shell_yeah_long", 100, 8, 3+random(2), c_yellow)
var _r = random_range(.8,1.2)
sound_play_pitchvol(sndSwapPistol,2*_r,.4)
sound_play_pitchvol(sndRecGlandProc,1.4*_r,1)
weapon_post(-3,0,3)

#define weapon_area
return -1;

#define weapon_text
return choose("BEWARE THE RICOCHET");

#define weapon_fire
with mod_script_call_self("mod", "defpack tools", "create_sniper_charge", x, y){
    name = "sniper bouncer charge"
    creator = other
    team = other.team
    index = other.index
    cost = weapon_cost()
    on_fire = script_ref_create(bouncer_rifle_fire)
}

#define bouncer_rifle_fire
var _ptch = random_range(-.5,.5)
sound_play_pitch(sndHeavyRevoler,.7-_ptch/3)
sound_play_pitch(sndSawedOffShotgun,1.8-_ptch)
sound_play_pitch(sndSniperFire,random_range(.6,.8))
sound_play_pitch(sndBouncerSmg,random_range(.8,1.2))
sound_play_pitch(sndBouncerShotgun,random_range(.8,1.2))
sound_play_pitch(sndHeavySlugger,1.3+_ptch/2)
var _c = charge, _cc = charge/maxcharge;
with creator{
	weapon_post(12,2,158)
	motion_add(gunangle -180,_c / 20)
	sleep(120)
	var q = shoot(x + lengthdir_x(10, gunangle), y + lengthdir_y(10, gunangle), gunangle, team, 1 + _cc, 2)
	with q{
	    creator = other
	    damage = 40
	    worth = 12
	    friends = q
	}
	mod_script_call_nc("mod", "defpack tools", "bolt_line_bulk", q, 2 * _cc, c_white, c_yellow)
}
sleep(charge*3)

#define shoot(_x, _y, dir, t, w, bounces)
var ar = []
var q = mod_script_call_self("mod", "defpack tools", "sniper_fire", _x, _y, dir, t, w);
unpack(ar, q)
if bounces > 0{
    with q[array_length(q)-1] if instance_exists(Wall){
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



