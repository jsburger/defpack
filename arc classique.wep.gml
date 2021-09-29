#define init
global.sprBow      = sprite_add_weapon("sprites/weapons/sprArchClassique.png", 2, 9)
global.sprArrow    = sprite_add("sprites/projectiles/sprArchClassiqueArrow.png", 1, 4, 4)
global.sprArrowHUD = sprite_add_weapon("sprites/projectiles/sprArchClassiqueArrow.png", 5, 3)

#define weapon_name
return "ARC CLASSIQUE"

#define weapon_type
return 3

#define weapon_cost
return 2

#define weapon_area
return 8

#define weapon_chrg
return 1

#define weapon_load
return 8

#define weapon_swap
return sndSwapHammer

#define weapon_auto
return mod_script_call_nc("mod", "defpack tools", "abris_weapon_auto", "CritBowCharge", self)

#define weapon_melee
return false

#define weapon_laser_sight
return false

#define weapon_reloaded

#define weapon_sprt
if instance_is(self, Player){
    with instances_matching(instances_matching(CustomObject, "name", "CritBowCharge"), "creator", id){
        var yoff = (creator.race = "steroids" and btn = "spec") ? -1 : 1;
        with creator{
            var l = other.charge/other.maxcharge * 4 - 1;
            draw_sprite_ext(other.spr_arrow, 0, x - lengthdir_x(l, gunangle), y - lengthdir_y(l, gunangle) + yoff, 1, 1, gunangle, c_white, 1)
        }
    }
}
return global.sprBow

#define weapon_sprt_hud
return global.sprArrowHUD

#define nts_weapon_examine
return{
    "d": "A fancy hunting weapon. #Guaranteed to hit a weakspot with. ",
}
#define weapon_text
return "CLASSIC"

#define weapon_fire
with instance_create(x, y, CustomObject){
    sound   = sndMeleeFlip
	name    = "CritBowCharge"
	creator = other
	charge    = 0
    maxcharge = 20
    defcharge = {
        style : 2,
        width : 14,
        charge : 0,
        maxcharge : maxcharge
    }
	charged = 0
	depth = TopCont.depth
	index = creator.index
	spr_arrow  = global.sprArrow
	on_step    = bow_step
	on_destroy = bow_destroy
	on_cleanup = script_ref_create(bow_cleanup)
	reload = -1
	btn = other.specfiring ? "spec" : "fire"
	hand = other.specfiring and other.race == "steroids"
}

#define sound_play_hit_ext(_sound, _pitch, _vol)
var _s = sound_play_hit(_sound, 0);
sound_pitch(_s, _pitch);
sound_volume(_s, _vol);

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
if button_check(index, "swap") {
	instance_destroy();
	exit;
}
if reload = -1 {
    reload = hand ? creator.breload : creator.reload
    reload += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale
}
else {
    if hand creator.breload = max(creator.breload, reload)
    else creator.reload = max(reload, creator.reload)
}
view_pan_factor[index] = 3 - (charge/maxcharge * .5)
defcharge.charge = charge
if button_check(index, btn) {
    if charge < maxcharge{
        charge += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale;
        charged = 0
        sound_play_hit_ext(sound, sqr((charge/maxcharge) * 3.5) + 6, 1 - charge/maxcharge)
    }
    else{
        if current_frame mod 6 < current_time_scale {
            creator.gunshine = 1
            with defcharge blinked = 1
        }
        charge = maxcharge;
        if charged == 0 {
            mod_script_call_self("mod", "defpack tools", "weapon_charged", creator, 12)
            charged = 1
        }
    }
}
else {
	instance_destroy()
}

#define bow_cleanup
  view_pan_factor[index] = undefined
  sound_stop(sound)

#define bow_destroy
bow_cleanup()

var _p = random_range(.8, 1.2);
sound_play_hit_ext(sndSwapGuitar, 4 * _p, .8)
sound_play_hit_ext(sndAssassinAttack, 2 * _p, .8)
sound_play_hit_ext(sndClusterOpen, 2 * _p, .2)
if charged = 0 {
    with creator weapon_post(1, -10, 0)
    with instance_create(creator.x, creator.y, Bolt) {
        sprite_index = other.spr_arrow
        mask_index   = mskBullet1
        creator = other.creator
        team    = creator.team
        damage = 20
        move_contact_solid(creator.gunangle, 6)
        motion_add(creator.gunangle + random_range(-2, 2) * creator.accuracy * (1 - (other.charge/other.maxcharge)), 26 + (2 * other.charge/other.maxcharge))
        image_angle = direction
    }
}
else {
    with creator{
        weapon_post(1, -30, 0)
        repeat(6) with instance_create(x, y, Dust){
            motion_add(random(360), choose(5, 6))
        }
    }

    sound_play_pitchvol(sndShovel, 2, .8)
    sound_play_pitchvol(sndUltraCrossbow, 3, .8)
    var ang = creator.gunangle
    with bolt_create(creator.x,creator.y){
      sprite_index = other.spr_arrow
      mask_index   = mskBullet1
      hand = other.hand;
      creator = other.creator
      team    = creator.team
      damage = 12
      move_contact_solid(creator.gunangle, 6)
      motion_add(ang, 28)
      image_angle = direction
      charged = other.charged
    }
  }

#define bolt_create(x,y)
with instance_create(x,y,CustomProjectile){
    sprite_index = global.sprArrow
    mask_index = mskBolt
    charged = 0
    force = 3
	cooldown = 0; // time in frames the arrow needs from a hit to be critical again (only applies if charged)
    bounce = round(skill_get("compoundelbow") * 5)
    on_step = bolt_step
    on_end_step = bolt_end_step
    on_hit = bolt_hit
    on_wall = bolt_wall
    on_destroy = bolt_destroy
    reloadcheck = false;
    return id
}

#define bolt_step
if reloadcheck = false{
	reloadcheck = true;
	var _r = 8; //extra reload gained from fully charging
	if instance_exists(creator) if !hand creator.reload += _r else creator.breload += _r;
}

#define bolt_end_step

cooldown--;
var hitem = 0
if skill_get(mut_bolt_marrow){
    var q = mod_script_call_nc("mod","defpack tools","instance_nearest_matching_ne",x,y,hitme,"team",team)
    if instance_exists(q) and point_distance(x,y,q.x,q.y) < 24 {
        x = q.x - hspeed_raw
        y = q.y - vspeed_raw
        hitem = 1
    }
}
with instance_create(x,y,BoltTrail){
    image_xscale = point_distance(x,y,other.xprevious,other.yprevious)
    image_angle = point_direction(x,y,other.xprevious,other.yprevious)
    image_blend = other.cooldown <= 0 ? c_black : c_white
    if other.cooldown <= 0 if fork(){
        while instance_exists(self){
            image_blend = merge_color(image_blend,c_red,.8*current_time_scale)
            wait(0)
        }
        exit
    }
}
if hitem with q with other bolt_hit()

#define bolt_hit
sleep(10)
var o = other, hp = other.my_health;
if charged && cooldown <= 0 {
	cooldown = 99999999;
	mod_script_call_self("mod","defpack tools","crit")
}
projectile_hit(o, damage, force, direction)
if hp > damage{
    with instance_create(x,y,BoltStick){
        target = o
        sprite_index = other.sprite_index
        image_angle = point_direction(x,y,o.x,o.y)

    }
    instance_destroy()
}

#define bolt_wall
	if bounce > 0{
		bounce--
		move_bounce_solid(false)
		image_angle = direction
		speed *= .9
		sound_play_pitch(sndBoltHitWall,random_range(.9, 1.1))
		instance_create(x, y, Dust)
	}else{
	  with instance_create(x+hspeed/2,y+vspeed/2,CustomObject){
	    instance_create(x, y, Dust)
	    sprite_index = other.sprite_index
	    image_angle = other.image_angle
	    if fork(){
	        wait(30)
	        if instance_exists(self) instance_destroy()
	        exit
	    }
	  }
	  sound_play_hit(sndBoltHitWall,.1)
	  instance_destroy()
	}

#define bolt_destroy
