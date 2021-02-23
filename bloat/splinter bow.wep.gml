#define init
global.sprBow      = sprite_add_weapon("../sprites/weapons/sprSplinterBow.png",2,8)
global.sprArrow    = sprite_add("../sprites/projectiles/sprSplinterArrow.png",1,3,4)

#define weapon_name
return "SPLINTER BOW"

#define weapon_type
return 3

#define weapon_cost
return 1

#define weapon_area
return 8

#define weapon_chrg
return 1

#define weapon_load
return 13

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
    with instances_matching(instances_matching(CustomObject, "name", "splinter bow charge"),"creator", id){
        var yoff = (creator.race = "steroids" and btn = "spec") ? -1 : 1
        with creator{
            var l = other.charge/other.maxcharge * 4 + 5
            if !other.charged
                for var i = -2; i <= 2; i++{
                    draw_sprite_ext(sprSplinter, 2, x - lengthdir_x(l, gunangle), y - lengthdir_y(l, gunangle) + yoff, 1, 1, gunangle + 10*i, c_white, 1)
                }
            else
                for var i = -2; i <= 2; i++{
                    draw_sprite_ext(sprSplinter, 2, x - lengthdir_x(l, gunangle), y - lengthdir_y(l, gunangle) + yoff, 1, 1, gunangle + 3*i, c_white, 1)
                }

        }
    }
}
return global.sprBow

#define weapon_sprt_hud
return global.sprArrow

#define weapon_text
return "WOODCHIPPER"

#define weapon_fire
with instance_create(x,y,CustomObject){
    sound   = sndMeleeFlip
	name    = "splinter bow charge"
	creator = other
	charge    = 0
    maxcharge = 25
    defcharge = {
        style : 0,
        width : 14,
        charge : 0,
        maxcharge : maxcharge
    }
	charged = 0
	depth = TopCont.depth
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
if button_check(creator.index, "swap") && (creator.canswap = true || creator.bwep != 0){
  var _t = weapon_get_type(mod_current);
  creator.ammo[_t] += weapon_get_cost(mod_current)
  if creator.ammo[_t] > creator.typ_amax[_t] creator.ammo[_t] = creator.typ_amax[_t]
  instance_delete(self)
  exit
}

var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
if button_check(index,"swap"){instance_destroy();exit}
if reload = -1{
    reload = hand ? creator.breload : creator.reload
    reload += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale * 1.5
}
else{
    if hand creator.breload = max(creator.breload, reload)
    else creator.reload = max(reload, creator.reload)
}
view_pan_factor[index] = 3 - (charge/maxcharge * .5)
defcharge.charge = charge
if button_check(index, btn){
    if charge < maxcharge{
        charge += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale * 1.5;
        charged = 0
        sound_play_pitchvol(sound,sqr((charge/maxcharge) * 3.5) + 6,1 - charge/maxcharge)
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
sound_play_pitchvol(sndClusterOpen,2*_p,.2)
sound_play_pitchvol(sndSplinterGun,1.6*_p,.7)
if charged = 0{
    with creator weapon_post(1,-10,0)
    repeat(7) with instance_create(creator.x,creator.y,Splinter){
        creator = other.creator
        team    = creator.team
        move_contact_solid(creator.gunangle,6)
        motion_add(creator.gunangle+random_range(-8,8)+random_range(-26,26)*creator.accuracy*(1-(other.charge/other.maxcharge)),16 + irandom(4))
        image_angle = direction
    }
}
else
{
	with instance_create(x, y, CustomObject){
		creator = other.creator;
		//team = other.team;
	
		timer = 1
		ammo  = 3
		
		on_step = splinterbow_step
	}
}

#define splinterbow_step
if !instance_exists(creator){instance_delete(self);exit}
x = creator.x + creator.hspeed;
y = creator.y + creator.vspeed;
timer -= current_time_scale
if timer <= 0{
	timer = 2
	ammo--
	with creator{
	    weapon_post(1,-12,0)
	    repeat(6) with instance_create(x,y,Dust){
	       motion_add(random(360),choose(5,6))
	    }
	}
	sound_play_pitchvol(sndSplinterPistol, random_range(1.4, 1.6),.7)
	sound_play_pitchvol(sndShovel,2,.8)
	sound_play_pitchvol(sndUltraCrossbow,3,.8)
	repeat(2 + (ammo = 2 ? 2 : 0)){
	     with instance_create(creator.x + lengthdir_x( 1 + irandom(5) * creator.accuracy, creator.gunangle + choose(-90, 90)),creator.y + lengthdir_y( 1 + irandom(5) * creator.accuracy, creator.gunangle + choose(-90, 90)),Splinter){
	          creator = other.creator
	          team    = creator.team
	          move_contact_solid(creator.gunangle,6)
	          motion_add(creator.gunangle ,24 + irandom(4))
	          image_angle = direction
	        }
	    }
	}
	if ammo <= 0 instance_destroy()