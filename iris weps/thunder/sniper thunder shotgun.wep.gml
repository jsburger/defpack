#define init
global.sprSniperThunderShotgun = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprSniperThunderShotgun.png", 7, 3);
global.sprThunderMuzzle   	 = sprite_add("../../sprites/projectiles/iris/thunder/sprThunderMuzzle.png", 1, 7, 7)
global.sprLightningBulletHit = sprite_add("../../sprites/projectiles/iris/thunder/sprThunderBulletHit.png", 4, 8, 8)
global.deviation = 120;
global.color = merge_color(c_navy, c_aqua, .4)

#define weapon_chrg
return true;

#define weapon_name
return "THUNDER SNIPER SHOTGUN"

#define weapon_sprt
return global.sprSniperThunderShotgun;

#define weapon_type
return 1;

#define weapon_auto
return 1;

#define weapon_load
return 70;

#define weapon_cost
return 72;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
with instances_matching(instances_matching(CustomObject, "name", "ThunderSniperCharge"), "creator", self){
    with other {
        draw_set_alpha(.3 + .7  * (other.charge/other.maxcharge))
        var _c = global.color;
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
repeat(5)mod_script_call("mod", "defpack tools", "shell_yeah_long", 100, 8, 3 + random(2), c_navy)
sound_play_pitchvol(sndSwapPistol, 2, .4)
sound_play_pitchvol(sndRecGlandProc, 1.4, 1)
weapon_post(-2, -4, 5)

return -1;

#define weapon_area
return -1;

#define weapon_text
return choose("FTL");

#define weapon_fire
with mod_script_call_self("mod", "defpack tools", "create_sniper_charge", x, y){
    creator = other
    team = other.team
    index = other.index
    cost = weapon_cost()
    amount = 12;
    chargespeed = 2
    is_super  = true;
    deviation = global.deviation * other.accuracy
    name = "ThunderSniperCharge"
    on_fire = script_ref_create(thunder_shotgun_fire)
    spr_flash = global.sprThunderMuzzle
}

#define thunder_shotgun_fire
    var _c = charge, _cc = charge/maxcharge, _ccc = _cc = 1 ? 1 : 0, cr = creator;
    var _ptch = random_range(-.5, .5)
    sound_play_pitch(sndHeavySlugger,.55-_ptch/8)
  	sound_play_pitch(sndHeavyNader,.4-_ptch/8)
  	sound_play_pitch(sndNukeExplosion,5-_ptch*2)
  	sound_play_pitch(sndSawedOffShotgun,1.8-_ptch)
  	sound_play_pitch(sndSniperFire,random_range(.6,.8))
    if skill_get(mut_laser_brain) > 0{
      sound_play_pitch(sndLightningCannonEnd,.8*random_range(.8, 1.2))
      sound_play_pitch(sndGammaGutsKill,.6*random_range(.8, 1.2))
    }
    sound_play_pitch(sndLightningRifleUpg,1.4*random_range(.8, 1.2))
    sound_play_pitch(sndLaserUpg,.8*random_range(.8, 1.2))
    sound_play_pitch(sndLightningReload,.8*random_range(.8, 1.2))
    with cr {
    	weapon_post(15,40,210)
		motion_add(gunangle -180,_c / 5)
		sleep(200)


        var _a = -other.deviation;

        repeat(other.amount){
        	var q = mod_script_call_self("mod", "defpack tools", "sniper_fire", x + lengthdir_x(10, gunangle), y + lengthdir_y(10, gunangle), gunangle + _a * (1-other.charge/other.maxcharge), team, 1 + _cc, _ccc)
        	with q {
        		c2 = merge_color(c_aqua, c_blue, .3)
        	    creator = other
        	    damage = 12 + round(12 * _cc)
        	    worth = 12
        	    with instance_create(x, y, BulletHit) sprite_index = global.sprLightningBulletHit
        	    var n = 3*hyperspeed/(_cc + .2)
        	    for var i = 12; i < image_xscale; i += random(n){
        	        with instance_create(xstart + lengthdir_x(2*i, direction), ystart + lengthdir_y(2*i, direction), Lightning){
        	            creator = cr
        	            team = cr.team
        	            ammo = choose(1, 2) * ceil(3*(.1 + _cc))
        	            alarm0 = ceil(i/12)
        	            image_angle = other.direction + random_range(-90, 90)
        	            with instance_create(x, y, LightningSpawn) image_angle = other.image_angle
        	        }
        	    }
        	mod_script_call_nc("mod", "defpack tools", "bolt_line_bulk", q, 2 * _cc, c_blue, c_aqua)
        	}
        	_a += other.deviation /other.amount * 2;
        }
    }
