#define init
global.sprSniperThunderRifle = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprSniperThunderRifle.png", 5, 4);
global.sprThunderMuzzle   	 = sprite_add("../../sprites/projectiles/iris/thunder/sprThunderMuzzle.png", 1, 7, 7)
global.sprLightningBulletHit = sprite_add("../../sprites/projectiles/iris/thunder/sprThunderBulletHit.png", 4, 8, 8)

global.color = merge_color(c_navy, c_aqua, .4)

#define weapon_chrg
return true;

#define weapon_name
return "THUNDER SNIPER RIFLE"

#define weapon_sprt
return global.sprSniperThunderRifle;

#define weapon_type
return 1;

#define weapon_auto
return mod_script_call_nc("mod", "defpack tools", "sniper_weapon_auto", self)

#define weapon_load
return 30;

#define weapon_cost
return 30;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
with instances_matching(instances_matching(CustomObject, "name", "ThunderSniperCharge"), "creator", self) {
    with other{
        with mod_script_call_self("mod", "defpack tools", "sniper_fire", x, y, gunangle, team, 1 + other.charge/other.maxcharge, 1){
            draw_line_width_color(xstart, ystart, x, y, 1, global.color, global.color)
            instance_destroy()
        }
    }
    return false
}
return false;

#define weapon_reloaded
repeat(2)with mod_script_call("mod","defpack tools", "shell_yeah_long", 100, 8, 3+random(2), c_navy)
var _r = random_range(.8,1.2)
sound_play_pitchvol(sndSwapPistol,2*_r,.4)
sound_play_pitchvol(sndRecGlandProc,1.4*_r,1)
sound_play_pitchvol(sndLightningReload,1,.5)
weapon_post(-2,-4,5)
return -1;

#define weapon_area
return -1;

#define weapon_text
return choose("THE SPEED OF SOUND");

#define weapon_fire
with mod_script_call_self("mod", "defpack tools", "create_sniper_charge", x, y){
    name = "ThunderSniperCharge"
    creator = other
    team = other.team
    index = other.index
    chargespeed = 2
    cost = weapon_cost()
    on_fire = script_ref_create(thunder_rifle_fire)
    spr_flash = global.sprThunderMuzzle
}

#define thunder_rifle_fire
var _c = charge, _cc = charge/maxcharge, _ccc = _cc = 1 ? 1 : 0, cr = creator;
var _s = skill_get(mut_laser_brain)
repeat(1) {
    var _ptch = random_range(-.5, .5)
    sound_play_pitch(sndHeavyRevoler,.7-_ptch/3)
  	sound_play_pitch(sndSawedOffShotgun,1.8-_ptch)
  	sound_play_pitch(sndSniperFire,random_range(.6,.8))
  	sound_play_pitch(sndHeavySlugger,1.3+_ptch/2)
    if skill_get(mut_laser_brain) > 0{
      sound_play_pitch(sndLightningCannon,.8*random_range(.8, 1.2))
      sound_play_pitch(sndGammaGutsKill,.6*random_range(.8, 1.2))
    }
    sound_play_pitch(sndLightningRifleUpg,1.4*random_range(.8, 1.2))
    sound_play_pitch(sndLightningReload,.8*random_range(.8, 1.2))
    with cr {
    	weapon_post(12,2,158)
    	motion_add(gunangle -180,_c / 20)
    	sleep(120)
    	for (var o = -1; o <= 1; o += 1) {
        	var q = mod_script_call_self("mod", "defpack tools", "sniper_fire", x + lengthdir_x(10, gunangle), y + lengthdir_y(10, gunangle), gunangle + o * 12 * accuracy, team, 1 + _cc, _ccc)
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
        	           // with instance_create(x, y, LightningSpawn) image_angle = other.image_angle
        	        }
        	    }
        	    mod_script_call_nc("mod", "defpack tools", "bolt_line_bulk", q, 2 * _cc, c_blue, c_aqua)
            }
    	}
    }
}
