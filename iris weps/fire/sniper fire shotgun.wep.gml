#define init
global.sprSniperFireShotgun = sprite_add_weapon("../../sprites/weapons/iris/fire/sprSniperFireShotgun.png", 10, 3);
global.sprFireMuzzle	    = sprite_add("../../sprites/projectiles/iris/fire/sprFireMuzzle.png", 1, 7, 7);
global.spr = mod_variable_get("mod", "defpack tools", "spr");
global.deviation = 45;

#define weapon_chrg
return true;

#define weapon_name
return "FIRE SNIPER SHOTGUN"

#define weapon_sprt
return global.sprSniperFireShotgun;

#define weapon_type
return 1;

#define weapon_auto
return mod_script_call_nc("mod", "defpack tools", "sniper_weapon_auto", self)

#define weapon_load
return 38;

#define weapon_cost
return 60;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
with instances_matching(instances_matching(CustomObject, "name", "FireSniperShotCharge"), "creator", self){
    with other {
        draw_set_alpha(.3 + .7  * (other.charge/other.maxcharge))
        var _c = 14074;
        with mod_script_call_self("mod", "defpack tools", "sniper_fire", x, y, gunangle - (global.deviation * (1 - other.charge/other.maxcharge))*other.creator.accuracy, team, 1 + other.charge/other.maxcharge, 1){
            draw_line_width_color(xstart, ystart, x, y, 1, _c, _c)
            instance_destroy()
        }
        with mod_script_call_self("mod", "defpack tools", "sniper_fire", x, y, gunangle + (global.deviation * (1 - other.charge/other.maxcharge))*other.creator.accuracy, team, 1 + other.charge/other.maxcharge, 1){
            draw_line_width_color(xstart, ystart, x, y, 1, _c, _c)
            instance_destroy()
        }
        draw_set_alpha(1)
    }
    return false
}
return false;

#define weapon_reloaded
repeat(5)mod_script_call("mod", "defpack tools", "shell_yeah_long", 100, 8, 3 + random(2), c_red)
sound_play_pitchvol(sndSwapPistol, 2, .4)
sound_play_pitchvol(sndRecGlandProc, 1.4, 1)
weapon_post(-2, -4, 5)
return -1;

#define weapon_area
return -1;

#define weapon_text
return choose("FACE MELTER");

#define weapon_fire
with mod_script_call_self("mod", "defpack tools", "create_sniper_charge", x, y){
    name = "FireSniperShotCharge"
    creator = other
    team = other.team
    index = other.index
    cost = weapon_cost()
    amount = 5;
    is_super  = true;
    deviation = global.deviation * other.accuracy
    spr_flash = global.sprFireMuzzle
    on_fire = script_ref_create(fire_shotgun_fire)
}

#define fire_shotgun_fire
var _ptch = random_range(-.5,.5),
	vol = .5;
sound_play_pitchvol(sndHeavySlugger,.55-_ptch/8, vol)
sound_play_pitchvol(sndHeavyNader,.4-_ptch/8, vol)
sound_play_pitchvol(sndExplosionL,1.5-_ptch/2, vol)
sound_play_pitchvol(sndNukeExplosion,7-_ptch*2, vol)
sound_play_pitchvol(sndSawedOffShotgun,1.8-_ptch, vol)
sound_play_pitchvol(sndSniperFire,random_range(.6,.8), vol)
sound_play_pitchvol(sndFlameCannonEnd,.7, vol)
sound_play_pitchvol(sndQuadMachinegun,.7, vol)
sound_play_pitchvol(sndIncinerator,.8, vol)
sound_play_pitchvol(sndDoubleFireShotgun,1.3, vol)
var _c = charge, _cc = charge/maxcharge, _ccc = _cc = 1 ? 1 : 0;
with creator{
	weapon_post(15,40,210)
	motion_add(gunangle -180,_c / 5)
	sleep(200)
	repeat(other.amount){
		var q = mod_script_call_self("mod", "defpack tools", "sniper_fire", x + lengthdir_x(10, gunangle), y + lengthdir_y(10, gunangle), gunangle + random(other.deviation) * choose(-1, 1) * (1 - other.charge/other.maxcharge), team, 1 + _cc, _ccc)
		with q{
			c1 = c_red
			c2 = c_yellow
		    creator = other
		    damage = 20 + round(20 * _cc)
		    worth = 12
		    with instance_create(x, y, BulletHit) sprite_index = global.spr.FireBulletHit
		    var n = hyperspeed/(_cc + .2)
		    for var i = 0; i < image_xscale; i += random(n){
		        with instance_create(xstart + lengthdir_x(2*i, direction), ystart + lengthdir_y(2*i, direction), Flame){
		            motion_set(other.direction + 70 * choose(-1,1), random_range(1, 3) * _cc)
		            motion_add(direction + random_range(-90, 90), 1 + _cc)
		            projectile_init(other.team, other.creator)
		        }
		    }
	   }
   }
}
sleep(charge*3)
