#define init
global.sprSniperPestShotgun = sprite_add_weapon("../../sprites/weapons/iris/pest/sprSniperPestShotgun.png", 7, 4);
global.sprPestMuzzle 	  	= sprite_add("../../sprites/projectiles/iris/pest/sprPestMuzzle.png", 1, 7, 7)
global.sprToxicBulletHit    = sprite_add("../../sprites/projectiles/iris/pest/sprPestBulletHit.png", 4, 8, 8)
global.deviation = 18;
global.color = merge_color(merge_color(c_green, c_yellow, .5), c_lime, .5)

#define weapon_chrg
return true;

#define weapon_name
return "PEST SNIPER SHOTGUN"

#define weapon_sprt
return global.sprSniperPestShotgun;

#define weapon_type
return 1;

#define weapon_auto
return 1;

#define weapon_load
return 48;

#define weapon_cost
return 60;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
with instances_matching(instances_matching(CustomObject, "name", "PestSniperShotCharge"), "creator", self){
    with other {
        draw_set_alpha(.3 + .7  * (other.charge/other.maxcharge))
        var _c = global.color;
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
repeat(5)with mod_script_call("mod","defpack tools", "shell_yeah_long", 100, 8, 3+random(2),c_green)
var _r = random_range(.8,1.2)
sound_play_pitchvol(sndSwapPistol,2*_r,.4)
sound_play_pitchvol(sndRecGlandProc,1.4*_r,1)
weapon_post(-2,-4,5)
return -1;

#define weapon_area
return -1;

#define weapon_text
return choose("GREEN TRAILS EVERYWHERE");

#define weapon_fire
with mod_script_call_self("mod", "defpack tools", "create_sniper_charge", x, y){
    name = "PestSniperShotCharge"
    creator = other
    team = other.team
    index = other.index
    cost = weapon_cost()
    on_fire = script_ref_create(pest_shotgun_fire)
    spr_flash = global.sprPestMuzzle
    deviation = global.deviation * other.accuracy
    amount = 5;
}


#define pest_shotgun_fire
var _ptch = random_range(-.5,.5)
var _ptch = random_range(-.5,.5)
sound_play_pitch(sndHeavySlugger,.7-_ptch/8)
	sound_play_pitch(sndHeavyNader,.6-_ptch/8)
	sound_play_pitch(sndNukeExplosion,7-_ptch*2)
	sound_play_pitch(sndSniperFire,random_range(.6,.8))
    sound_play_pitch(sndDoubleMinigun,random_range(.3,.5))
    sound_play_pitch(sndToxicBarrelGas,random_range(.5,.6))


var _c = charge, _cc = charge/maxcharge, _ccc = _cc = 1 ? 1 : 0;
with creator{
	weapon_post(15,40,210)
	motion_add(gunangle -180,_c / 5)
	sleep(200)
	repeat(other.amount){
	var q = mod_script_call_self("mod", "defpack tools", "sniper_fire", x + lengthdir_x(10, gunangle), y + lengthdir_y(10, gunangle), gunangle + random(other.deviation) * choose(-1, 1) * (1 - other.charge/other.maxcharge) * other.creator.accuracy, team, 1 + _cc, _ccc)
	 with q{
		c2 = c_lime
	    creator = other
	    damage = 20 + round(20 * _cc)
	    worth = 12
	    with instance_create(x, y, BulletHit) sprite_index = global.sprToxicBulletHit
	    var n = hyperspeed/(_cc + .2)
	    for var i = 12; i < image_xscale; i += random(n){
	        with instance_create(xstart + lengthdir_x(2*i, direction), ystart + lengthdir_y(2*i, direction), ToxicGas){
	            image_xscale *= .75
	            image_yscale *= .75
	            motion_add(other.direction, 2 + 2*_cc)
	            friction += .1
	            creator = other.creator
	        }
	    }
	 }
  }
}
sleep(charge*3)
