#define init
global.sprSniperGammaRifle = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprSniperHorrorRifleOn.png", 5, 3);
global.sprGammaMuzzle 	   = sprite_add("../../sprites/projectiles/iris/horror/sprGammaMuzzle.png", 1, 7, 7)
global.sprGammaBulletHit   = sprite_add("../../sprites/projectiles/iris/horror/sprGammaBulletHit.png", 4, 8, 8)

global.color = merge_color(merge_color(c_green, c_yellow, .8), c_lime, .5)

#define weapon_name
return "GAMMA SNIPER RIFLE"

#define weapon_chrg
return true;

#define weapon_sprt
return global.sprSniperGammaRifle;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 24;

#define weapon_cost
return 12;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
with instances_matching(instances_matching(CustomObject, "name", "GammaSniperCharge"),"creator",self){
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
with mod_script_call("mod","defpack tools", "shell_yeah_long", 100, 8, 3+random(2),c_lime)
var _r = random_range(.8,1.2)
sound_play_pitchvol(sndSwapPistol,2*_r,.4)
sound_play_pitchvol(sndRecGlandProc,1.4*_r,1)
weapon_post(-2,-4,5)
return -1;

#define weapon_area
return -1;

#define weapon_text
return choose("AIM AT THE @wBULLETS");

#define weapon_fire
with mod_script_call_self("mod", "defpack tools", "create_sniper_charge", x, y){
    name = "GammaSniperCharge"
    creator = other
    team = other.team
    index = other.index
    cost = weapon_cost()
    on_fire = script_ref_create(gamma_rifle_fire)
    spr_flash = global.sprGammaMuzzle
}

#define gamma_rifle_fire
var _ptch = random_range(-.5,.5)
sound_play_pitch(sndHeavyRevoler,.7-_ptch/3)
sound_play_pitch(sndSawedOffShotgun,1.8-_ptch)
sound_play_pitch(sndSniperFire,random_range(.6,.8))
sound_play_pitch(sndHeavySlugger,1.3+_ptch/2)
sound_play_pitch(sndUltraShotgun,random_range(.5,.7))
sound_play_pitch(sndUltraGrenade,random_range(.7,.8))
var _c = charge, _cc = charge/maxcharge, _ccc = _cc = 1 ? 1 : 0;
with creator{
	weapon_post(12,2,158)
	motion_add(gunangle -180,_c / 20)
	sleep(120)
	var q = mod_script_call_self("mod", "defpack tools", "sniper_fire", x + lengthdir_x(10, gunangle), y + lengthdir_y(10, gunangle), gunangle, team, 1 + _cc, _ccc)
		with q{
			c1 = c_lime
			c2 = c_yellow
		    creator = other
		    damage = 13 + round(13 * _cc)
		    worth = 12
		    with instance_create(x, y, BulletHit) sprite_index = global.sprGammaBulletHit
		    with instances_matching_ne(projectile, "team", other.team){
		    	if distance_to_object(other) <= 0{
		    		instance_destroy()
		    	}
		    }
		   mod_script_call_nc("mod", "defpack tools", "bolt_line_bulk", q, 2 * _cc, c_yellow, c_lime)
		}
	var q = mod_script_call_self("mod", "defpack tools", "sniper_fire", x + lengthdir_x(10, gunangle), y + lengthdir_y(10, gunangle), gunangle + random_range(-8, 8) * accuracy, team, 1 + _cc, _ccc)
		with q{
			c1 = c_lime
			c2 = c_yellow
		    creator = other
		    damage = 13 + round(13 * _cc)
		    worth = 12
		    with instance_create(x, y, BulletHit) sprite_index = global.sprGammaBulletHit
		    with instances_matching_ne(projectile, "team", other.team){
		    	if distance_to_object(other) <= 0{
		    		instance_destroy()
		    	}
		    }
		   mod_script_call_nc("mod", "defpack tools", "bolt_line_bulk", q, 2 * _cc, c_yellow, c_lime)
		}
}
sleep(charge*3)
