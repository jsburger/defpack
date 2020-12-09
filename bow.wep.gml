#define init
global.sprBow      = sprite_add_weapon("sprites/weapons/sprBow.png",2,8)
global.sprArrow    = sprite_add("sprites/projectiles/sprArrow.png",1,3,4)
global.sprArrowHUD = sprite_add_weapon("sprites/projectiles/sprArrow.png",5,3)

global.sprBow2     = sprite_add_weapon_base64("iVBORw0KGgoAAAANSUhEUgAAAAoAAAASCAYAAABit09LAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAA7BAAAOwQG4kWvtAAAAB3RJTUUH4wEXBQ8FXZOvsQAAARBJREFUKM+Nkr9Kw1AUxn8ndJF2MlQQQ4OLNGSJgxXBIdAphYKPEOe+QZ31YXwAu3a1DrqEbkqhRTDoVHA8DnpvExP//OAul+/e833nHFFVBsc7yhc3ty9CDdLtNPU88ezF9P4NQCazvCIEUIA4ctnf3aoVO/PFGu/ghPliLdOHV56e34kPtwE06bU3Qvu1yK/iRsmHCIB8WnFLHq1QVUtvAr+l/WEKoKMjxOEH+sOUMAzrPdZhxLb05R5ceQXx2QiALMuqYQzjpRL4LSCthhkvN2ECv6Vx5PJ4dw0gp6scx3gTEXu+c7EqhDEt6naaakZZxDH9U1Vbsm7e/16KBqBx5P69ZgBJr20jT2Z5bec/ACvpa0JPoQuCAAAAAElFTkSuQmCC", 1, 8)
global.sprArrow2   = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABIAAAAHCAYAAAAF1R1/AAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAA7BAAAOwQG4kWvtAAAAB3RJTUUH4wEXBQMR6/w0wAAAANRJREFUGNOV0bFKxEAQxvH/iI2vsAipdC1trYKwaXwWayGFbxG2PbCztrjiIHZTW2ax2eIIvoGdn8XpNYdRfzDNDAzMN1Zr5dvt3T0AT48PLCmlABBj3PfM3QkhaJ5nQgg0TWMAzx8nPy4Kry8AApjPLu366H03aNtWtVa5u2qt4hc5Z3LOkqRpmiQJk4SZ0batbi7e+IvVesvp+RXDMBBjpJTCsZnh7vR9z2q95b9KKYzjCO5+cJokliqlREpJOWellHanfX3tIOwlXdftw95sNgbwCTnnhjndldg9AAAAAElFTkSuQmCC",1, 3, 4)

#define weapon_name
//if instance_is(self,WepPickup) return `  BOW @0(${sprEnergyIcon}:0) `
return "BOW"

#define weapon_type
return 3

#define weapon_cost
return 1

#define weapon_area
return 4

#define weapon_chrg
return 1

#define weapon_load
return 5

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
    with instances_matching(instances_matching(CustomObject, "name", "bow charge"),"creator", id){
        var yoff = (creator.race = "steroids" and btn = "spec") ? -1 : 1
        with creator{
            var l = other.charge/other.maxcharge * 4 - 1
            if other.charged
                for var i = -1; i <= 1; i++{
                    draw_sprite_ext(other.spr_arrow, 0, x - lengthdir_x(l, gunangle), y - lengthdir_y(l, gunangle) + yoff, 1, 1, gunangle + 12*i, c_white, 1)
                }
            else
                draw_sprite_ext(other.spr_arrow, 0, x - lengthdir_x(l, gunangle), y - lengthdir_y(l, gunangle) + yoff, 1, 1, gunangle, c_white, 1)

        }
    }
    if race = "skeleton" return global.sprBow2
}
return global.sprBow

#define weapon_sprt_hud
return global.sprArrowHUD

#define weapon_text
return "CLASSIC"

#define weapon_fire
with instance_create(x,y,CustomObject){
    sound   = sndMeleeFlip
	name    = "bow charge"
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
	spr_arrow = other.race = "skeleton" ? global.sprArrow2 : global.sprArrow
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
if creator.bwep != 0 && button_check(creator.index, "swap") && creator.canswap = true{
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
if charged = 0{
    with creator weapon_post(1,-10,0)
    with instance_create(creator.x,creator.y,Bolt){
        sprite_index = other.spr_arrow
        mask_index   = mskBullet1
        creator = other.creator
        team    = creator.team
        damage = 10
        move_contact_solid(creator.gunangle,6)
        motion_add(creator.gunangle+random_range(-8,8)*creator.accuracy*(1-(other.charge/other.maxcharge)),16+6*other.charge/other.maxcharge)
        image_angle = direction
    }
}
else
{
    with creator{
        weapon_post(1,-30,0)
        repeat(6) with instance_create(x,y,Dust){
            motion_add(random(360),choose(5,6))
        }
    }
    sound_play_pitchvol(sndShovel,2,.8)
    sound_play_pitchvol(sndUltraCrossbow,3,.8)
    var ang = creator.gunangle + random_range(-5,5) * creator.accuracy
    var i = -12 * accuracy;
    repeat(3){
        with instance_create(creator.x,creator.y,Bolt){
            sprite_index = other.spr_arrow
            mask_index   = mskBullet1
            creator = other.creator
            team    = creator.team
            damage = i = 0 ? 10 : 5
            move_contact_solid(creator.gunangle,6)
            motion_add(ang + i,20)
            image_angle = direction
        }
        i += 12 * accuracy;
    }
}
