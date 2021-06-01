#define init
global.sprSniperPsyShotgun = sprite_add_weapon("../../sprites/weapons/iris/psy/sprSniperPsyShotgun.png", 5, 3);
global.deviation = 45;
global.sprPsyBullet = sprite_add("../../sprites/projectiles/iris/psy/sprPsyBullet.png", 2, 8, 8);

#define weapon_chrg
return true;

#define weapon_name
return "PSY SNIPER SHOTGUN"

#define weapon_sprt
return global.sprSniperPsyShotgun;

#define weapon_type
return 1;

#define weapon_auto
return mod_script_call_nc("mod", "defpack tools", "sniper_weapon_auto", self)

#define weapon_load
return 60;

#define weapon_cost
return 60;

#define weapon_swap
return sndSwapMachinegun;


#define weapon_laser_sight
with instances_matching(instances_matching(CustomObject, "name", "PsySniperShotCharge"), "creator", self){
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
    repeat(5)with mod_script_call("mod","defpack tools", "shell_yeah_long", 100, 8, 3+random(2),c_purple)
    var _r = random_range(.8,1.2)
    sound_play_pitchvol(sndSwapPistol,2*_r,.4)
    sound_play_pitchvol(sndRecGlandProc,1.4*_r,1)
    weapon_post(-2,-4,5)

#define weapon_area
return -1;

#define weapon_text
    return choose("EYE ON YOU");

#define weapon_fire
	with mod_script_call_self("mod", "defpack tools", "create_sniper_charge", x, y) {
        name = "PsySniperShotCharge"
	    creator = other
	    team = other.team
	    index = other.index
        on_fire = script_ref_create(psy_rifle_fire)
        spr_flash = global.sprPsyBullet
	    cost = weapon_cost()
	    amount = 5;
	    is_super = true;
	    deviation = global.deviation * other.accuracy
	}

#define psy_rifle_fire
    var _ptch = random_range(-.5,.5)
    sound_play_pitch(sndHeavyRevoler,.7-_ptch/3)
    sound_play_pitch(sndCursedPickup,.6)
    sound_play_pitch(sndSniperFire,random_range(.6,.8))
    sound_play_pitch(sndHeavySlugger,1.3+_ptch/2)
    var _c = charge, _cc = charge/maxcharge;
    with creator{
    	weapon_post(12,2,158)
    	motion_add(gunangle -180,_c / 20)
    	sleep(120)
    	
    	repeat(other.amount) {
			var _ang = (gunangle + random(other.deviation) * choose(-1, 1) * (1 - other.charge/other.maxcharge) * other.creator.accuracy);
			
			with mod_script_call_self("weapon", "sniper psy rifle", "create_psy_sniper_shot", x, y, _c) {
				direction = _ang
				image_angle = direction
				sight = 30
				minsight = 20
			}
    	}
    	
    }
