#define init
global.sprSniperHorrorShotgunOn = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprSniperHorrorShotgunOn.png", 12, 5);
global.sprGammaMuzzle 	        = sprite_add("../../sprites/projectiles/iris/horror/sprGammaMuzzle.png", 1, 7, 7)
global.sprGammaBulletHit        = sprite_add("../../sprites/projectiles/iris/horror/sprGammaBulletHit.png", 4, 8, 8)
global.deviation = 64;
global.color = merge_color(merge_color(c_green, c_yellow, .8), c_lime, .5)
global.mindev = 9;

#define weapon_chrg
return true;

#define weapon_name
return "GAMMA SNIPER SHOTGUN"

#define weapon_sprt
return global.sprSniperHorrorShotgunOn;

#define weapon_type
return 1;

#define weapon_auto
return 1;

#define weapon_load
return 70;

#define weapon_cost
return 60;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
with instances_matching(instances_matching(CustomObject, "name", "GammaSniperShotCharge"), "creator", self){
    with other {
        draw_set_alpha(.3 + .7  * (other.charge/other.maxcharge))
        var _c = global.color;
        with mod_script_call_self("mod", "defpack tools", "sniper_fire", x, y, gunangle - (global.mindev + (global.deviation - global.mindev) * accuracy * (1 - other.charge/other.maxcharge)), team, 1 + other.charge/other.maxcharge, 1){
            draw_line_width_color(xstart, ystart, x, y, 1, _c, _c)
            instance_destroy()
        }
        with mod_script_call_self("mod", "defpack tools", "sniper_fire", x, y, gunangle + (global.mindev + (global.deviation - global.mindev)  * accuracy * (1 - other.charge/other.maxcharge)), team, 1 + other.charge/other.maxcharge, 1){
            draw_line_width_color(xstart, ystart, x, y, 1, _c, _c)
            instance_destroy()
        }
        draw_set_alpha(1)
    }
    return false
}
return false;

#define weapon_reloaded
repeat(5)mod_script_call("mod", "defpack tools", "shell_yeah_long", 100, 8, 3 + random(2), c_lime)
sound_play_pitchvol(sndSwapPistol, 2, .4)
sound_play_pitchvol(sndRecGlandProc, 1.4, 1)
weapon_post(-2, -4, 5)

return -1;

#define weapon_area
return -1;

#define weapon_text
return choose("SUPRESSIVE FIRE");

#define weapon_fire
with mod_script_call_self("mod", "defpack tools", "create_sniper_charge", x, y){
    name = "GammaSniperShotCharge"
    creator = other
    team = other.team
    index = other.index
    cost = weapon_cost()
    amount = 15;
    deviation = global.mindev + (global.deviation - global.mindev) * other.accuracy
    on_fire = script_ref_create(gamma_shotgun_fire)
    spr_flash = global.sprGammaMuzzle
}

#define gamma_shotgun_fire
var _ptch = random_range(-.5,.5)
sound_play_pitch(sndHeavySlugger,.55-_ptch/8)
sound_play_pitch(sndHeavyNader,.4-_ptch/8)
sound_play_pitch(sndNukeExplosion,5-_ptch*2)
sound_play_pitch(sndSawedOffShotgun,1.8-_ptch)
sound_play_pitch(sndSniperFire,random_range(.6,.8))
sound_play_pitch(sndUltraShotgun,random_range(.4,.6))
sound_play_pitch(sndUltraGrenade,random_range(.6,.7))
sound_play_pitchvol(sndUltraCrossbow,random_range(1.3,1.5), .4)
var _c = charge, _cc = charge/maxcharge, _ccc = _cc = 1 ? 1 : 0;
with creator{
		weapon_post(15,40,210)
		motion_add(gunangle -180,_c / 5)
		sleep(200)
	var q = mod_script_call_self("mod", "defpack tools", "sniper_fire", x + lengthdir_x(10, gunangle), y + lengthdir_y(10, gunangle), gunangle, team, 1 + _cc, _ccc)
		with q{
			c1 = c_lime
			c2 = c_yellow
		    creator = other-
		    damage = 12 + round(12 * _cc)
		    worth = 12
		    with instance_create(x, y, BulletHit) sprite_index = global.sprGammaBulletHit
		    with instances_matching_ne(projectile, "team", other.team){
		    	if distance_to_object(other) <= 0{
		    		instance_destroy()
		    	}
		    }
		   mod_script_call_nc("mod", "defpack tools", "bolt_line_bulk", q, 2 * _cc, c_yellow, c_lime)
		}
	repeat(other.amount - 1){
	var q = mod_script_call_self("mod", "defpack tools", "sniper_fire", x + lengthdir_x(10, gunangle), y + lengthdir_y(10, gunangle), gunangle + irandom(global.mindev) * choose(-1, 1)  + random(other.deviation) * choose(-1, 1) * (1 - other.charge/other.maxcharge), team, 1 + _cc, _ccc)
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
}
sleep(charge*3)
