#define init
global.sprSniperFireRifle = sprite_add_weapon("../../sprites/weapons/iris/fire/sprSniperFireRifle.png", 5, 3);
global.sprFireMuzzle			= sprite_add("../../sprites/projectiles/iris/fire/sprFireMuzzle.png", 1, 7, 7);
global.sprFireBulletHit   = sprite_add("../../sprites/projectiles/iris/fire/sprFireBulletHit.png", 4, 8, 8);

global.color = 14074

#define weapon_chrg
return true;

#define weapon_name
return "FIRE SNIPER RIFLE"

#define weapon_sprt
return global.sprSniperFireRifle;

#define weapon_type
return 1;

#define weapon_auto
return 1;

#define weapon_load
return 21;

#define weapon_cost
return 12;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
with instances_matching(instances_matching(CustomObject, "name", "sniper fire charge"),"creator",self){
    with other{
        with mod_script_call_self("mod", "defpack tools", "sniper_fire", x, y, gunangle, team, 1 + other.charge/other.maxcharge){
            draw_line_width_color(xstart, ystart, x, y, 1, global.color, global.color)
            instance_destroy()
        }
    }
    return false
}
return false;

#define weapon_reloaded
with mod_script_call("mod","defpack tools", "shell_yeah_long", 100, 8, 3+random(2),c_red)
var _r = random_range(.8,1.2)
sound_play_pitchvol(sndSwapPistol,2*_r,.4)
sound_play_pitchvol(sndRecGlandProc,1.4*_r,1)
weapon_post(-2,-4,5)
return -1;

#define weapon_area
return -1;

#define weapon_text
return choose("TURN YOUR FACE AWAY");

#define weapon_fire
with mod_script_call_self("mod", "defpack tools", "create_sniper_charge", x, y){
    name = "sniper fire charge"
    creator = other
    team = other.team
    index = other.index
    cost = weapon_cost()
    on_fire = script_ref_create(fire_rifle_fire)
    spr_flash = global.sprFireMuzzle
}

#define fire_rifle_fire
var _ptch = random_range(-.5,.5)
sound_play_pitch(sndHeavyRevoler,.7-_ptch/3)
sound_play_pitch(sndSawedOffShotgun,1.8-_ptch)
sound_play_pitch(sndSniperFire,random_range(.6,.8))
sound_play_pitch(sndHeavySlugger,1.3+_ptch/2)
sound_play_pitch(sndFlareExplode,1.8)
sound_play_pitch(sndFlameCannonEnd,.7)
sound_play_pitch(sndQuadMachinegun,.7)
sound_play_pitch(sndSniperFire,random_range(.6,.8))
var _c = charge, _cc = charge/maxcharge;
with creator{
	weapon_post(12,2,158)
	motion_add(gunangle -180,_c / 20)
	sleep(120)
	var q = mod_script_call_self("mod", "defpack tools", "sniper_fire", x + lengthdir_x(10, gunangle), y + lengthdir_y(10, gunangle), gunangle, team, 1 + _cc)
	with q{
	    creator = other
	    damage = 12 + round(28 * _cc)
	    worth = 12
	    with instance_create(x, y, BulletHit) sprite_index = global.sprFireBulletHit
	    var n = hyperspeed/(_cc + .2)
	    for var i = 0; i < image_xscale; i += random(n){
	        with instance_create(xstart + lengthdir_x(2*i, direction), ystart + lengthdir_y(2*i, direction), Flame){
	            motion_set(random(360), random_range(1, 3) * _cc)
	            motion_add(other.direction + 180, 2 + 2*_cc)
	            projectile_init(other.team, other.creator)
	        }
	    }
	}
	mod_script_call_nc("mod", "defpack tools", "bolt_line_bulk", q, 2 * _cc, c_red, c_yellow)
}
sleep(charge*3)
