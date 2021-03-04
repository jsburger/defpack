#define init
global.sprBow      = sprite_add_weapon("sprites/weapons/sprThunderBow.png",6,12)
global.sprArrow    = sprite_add("sprites/projectiles/sprThunderArrow.png",1,4,2)
global.sprArrowHUD = sprite_add_weapon("sprites/projectiles/sprThunderArrow.png",5,3)

#define weapon_name
return "HYPER BOW"

#define weapon_type
return 3

#define weapon_cost
return 2

#define weapon_area
return 11

#define weapon_chrg
return 1

#define weapon_load
return 14

#define weapon_swap
return sndSwapHammer

#define weapon_auto
return 1

#define weapon_melee
return false

#define weapon_laser_sight
return false

#define weapon_reloaded

#define weapon_sprt
if instance_is(self,Player){
    with instances_matching(instances_matching(CustomObject, "name", "thunder bow charge"),"creator", id){
        var yoff = (creator.race = "steroids" and btn = "spec") ? -1 : 1
        with creator{
            var l = other.charge/other.maxcharge * 4 - 1
            if other.charged
                for var i = -.5; i <= .5; i++{
                    draw_sprite_ext(other.spr_arrow, 0, x - lengthdir_x(l, gunangle), y - lengthdir_y(l, gunangle) + yoff, 1, 1, gunangle + 12*i, c_white, 1)
                }
            else draw_sprite_ext(other.spr_arrow, 0, x - lengthdir_x(l, gunangle), y - lengthdir_y(l, gunangle) + yoff, 1, 1, gunangle, c_white, 1)
        }
    }
}
return global.sprBow

#define weapon_sprt_hud
return global.sprArrowHUD

#define nts_weapon_examine
return{
    "d": "The limit of hunting weapon technology. #Fires arrows in a spread or straight ahead. ",
}

#define weapon_text
return "MOST ADVANCED TECHNOLOGY"

#define weapon_fire
with instance_create(x,y,CustomObject){
    sound   = sndHyperRifle
	name    = "thunder bow charge"
	creator = other
	charge    = 0
    maxcharge = 8
    defcharge = {
        style : 0,
        width : 14,
        charge : 0,
        maxcharge : maxcharge
    }
	charged = 0
	depth = TopCont.depth
	spr_arrow = global.sprArrow
	index = creator.index
    accuracy = other.accuracy
	on_step    = bow_step
	on_destroy = bow_destroy
	on_cleanup = bow_cleanup
	reload = -1
	btn = other.specfiring ? "spec" : "fire"
	hand = other.specfiring and other.race == "steroids"
}


#define bow_step
if !instance_exists(creator){instance_delete(self);exit}
var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
if button_check(index,"swap"){instance_delete(self);exit}
if reload = -1{
    reload = hand ? creator.breload : creator.reload
    reload += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale
}
else{
    if hand creator.breload = max(creator.breload, reload)
    else creator.reload = max(reload, creator.reload)
}
view_pan_factor[index] = 3 - (charge/maxcharge * .5)
defcharge.charge = charge
if button_check(index, btn){
    if charge < maxcharge{
        charge += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale;
        charged = 0
        sound_play_pitchvol(sound,sqr((charge/maxcharge) * 4) * .2,1 - charge/maxcharge * .4)
    }
    else{
        if current_frame mod 6 < current_time_scale {
            creator.gunshine = 1
            with defcharge blinked = 1
        }
        charge = maxcharge;
        if charged = 0{
            mod_script_call_self("mod","defpack tools", "weapon_charged", creator, 12)
            charged = 1
        }
    }
}
else{instance_destroy()}

#define bow_cleanup
view_pan_factor[index] = undefined
sound_stop(sound)

#define bow_destroy
bow_cleanup()
var _p = random_range(.8,1.2)
sound_play_pitchvol(sndSwapGuitar,4*_p,.8)
sound_play_pitchvol(sndAssassinAttack,2*_p,.8)
sound_play_pitchvol(sndClusterOpen,1.6*_p,.5)
sound_play_pitchvol(sndHyperLauncher,3.5*_p,1)
sound_play_pitchvol(sndSuperCrossbow,.7*_p,.4)

var _c = charge/maxcharge;

if charged = 1{
    sleep(50)
    with instance_create(x, y, CustomObject){
		creator = other.creator;
	
		spr_arrow = other.spr_arrow;
		timer = 1
		ammo  = 5
		
		on_step = hyperbow_step
	}
    instance_destroy()
}else{
    with creator weapon_post(1,-20,0)
    
    var ang = creator.gunangle + random_range(-5,5) * creator.accuracy,
	    i   = -30 * accuracy * (1 - _c * .6);
    repeat(5){
        with instance_create(creator.x,creator.y,Bolt){
            sprite_index = other.spr_arrow
            mask_index   = mskBullet1
            creator = other.creator
            team    = creator.team
            damage = 8
            move_contact_solid(creator.gunangle,2)
            motion_add(ang + i,30)
            image_angle = direction
        }
        i += 15 * accuracy * (1 - _c * .6);
    }
}

#define hyperbow_step
	timer -= current_time_scale
	if timer <= 0{
		timer = 2
		ammo--
		
		with creator{
	        weapon_post(1,-10,0)
	        repeat(6) with instance_create(x,y,Dust){
	            motion_add(random(360),choose(5,6))
	        }
	    }
	    sound_play_pitchvol(sndShovel,2,.8)
    sound_play_pitchvol(sndUltraCrossbow,3,.8)
		
	    with instance_create(creator.x + lengthdir_x(2 + irandom(5), creator.gunangle + choose(-90, 90)),creator.y + lengthdir_y(2 + irandom(5), creator.gunangle + choose(-90, 90)),HeavyBolt){
            sprite_index = global.sprArrow
            mask_index   = mskBullet1
            creator = other.creator
            team    = creator.team
            damage = 11
            move_contact_solid(creator.gunangle,4)
            motion_add(creator.gunangle,32)
            image_angle = direction
        }
    }
    if ammo <= 0 instance_destroy()