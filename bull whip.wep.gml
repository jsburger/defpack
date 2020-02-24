#define init
    global.sprBullWhip = sprite_add_weapon("sprites/weapons/sprBullWhip.png", 0, 3)
    global.sprBullWhipGrip = sprite_add_weapon("sprites/weapons/sprBullWhipHandle.png", 0, 3)
    global.sprWhip = sprite_add_p("sprites/projectiles/sprBullWhipProj.png", 1, 0, 5)
    global.sprWhipTip = sprite_add("sprites/projectiles/sprBullWhipProjTip.png", 1, 0, 5)
    
#define sprite_add_p(sprite, subimages, xoffset, yoffset)
var q = sprite_add(sprite, subimages, xoffset, yoffset)
if fork(){
	var t = sprite_get_texture(q, 0),
	    w = 150;

	while(t == sprite_get_texture(q, 0) && w-- > 0){
	    wait 0;
	}
    sprite_collision_mask(q, 1, 1, 0, 0, 0, 0, 0, 0)
    exit
}
return q

    
#define weapon_name
    return "BULL WHIP"
#define weapon_type
    return 0
#define weapon_cost
    return 0
#define weapon_area
    return 7
#define weapon_load
    return 18
#define weapon_swap
    return sndSwapShotgun
#define weapon_auto
    return 0
#define weapon_melee
    return true
#define weapon_laser_sight
    return false
#define weapon_sprt(_w)
    if instance_is(self, Player) {
        if (wep = _w) and reload >= 0 {
            return global.sprBullWhipGrip
        }
        if race == "steroids" and bwep == _w and breload >= 0{
            return global.sprBullWhipGrip
        }
    }
    
    return global.sprBullWhip
    
#define weapon_text
    return "EPIC DUB"
#define weapon_fire
    wepangle = -wepangle
    
    with instance_create(x, y, CustomSlash) {
        creator = other
        team = other.team
        length = 60
        image_xscale = length/40
        image_yscale = sign(other.wepangle)
        direction = other.gunangle + random_range(-3, 3) * other.accuracy
        image_angle = direction
        sprite_index = global.sprWhip
        name = "WhipBase"
        
        damage = 6
        force = 3
        
        on_hit =  whip_hit
        on_wall = whip_wall
        on_projectile = whip_proj
        on_grenade    = whip_proj
        on_destroy = whip_destroy
        
        on_step = whip_step
        time = 15


        with instance_create(x + lengthdir_x(length, direction), y + lengthdir_y(length, direction), CustomSlash) {
            xstart = other.xstart
            ystart = other.ystart
            creator = other.creator
            team = other.team
            direction = other.direction
            image_angle = direction
            sprite_index = global.sprWhipTip
            image_yscale = other.image_yscale
            mask_index = mskScorpion
            name = "WhipTip"
            
            can_crit = 1
            damage = 21
            force = 8
            
            base = other
            other.tip = id
            
            on_hit =  whip_hit_tip
            on_wall = whip_wall
            on_projectile = whip_proj
            on_grenade    = whip_proj
            on_destroy = whip_destroy
            on_step = whip_step
            time = other.time
            
            on_tip = script_ref_create(whip_tip)
            on_draw = whip_draw
            
        }

    }
    
#define speed_to(_xgoal, _ygoal)
    var _dis = point_distance(x, y, _xgoal, _ygoal);
    return sqrt(abs(2 * (friction) * _dis))

#define whip_draw
    draw_sprite_ext(mask_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha * .4)
    draw_self()
    
    
#define script_ref_call_self(scr)
    return mod_script_call_self(scr[0], scr[1], scr[2])

#define whip_hit_tip
    if projectile_canhit_melee(other) {
        var _tip = 1;
        // if instance_exists(base) with other {
        //     _tip = !place_meeting(x, y, other.base)
        // }
        if _tip {
            script_ref_call_self(on_tip)
        }
        projectile_hit(other, damage, force, direction)
    }

#define whip_tip
    if can_crit {
        can_crit = false
        mod_script_call_self("mod", "defpack tools", "crit")
    }
    
#define whip_hit
    if projectile_canhit_melee(other) {
        projectile_hit(other, damage, force, direction)
    }

#define whip_wall
    
#define whip_proj
    with other if typ > 0 {
        instance_destroy()
    }
    
#define whip_destroy
    with instances_matching([chestprop, Pickup, WepPickup], "", undefined) {
        if place_meeting(x, y, other) {
            if friction = 0 friction = .1
            motion_set(point_direction(x, y, other.xstart, other.ystart), speed_to(other.xstart, other.ystart))
            maxspeed = speed
        }
    }
    
    
    
#define whip_step
    time -= current_time_scale
    if time <= 0
        instance_destroy()
    
    
    
    
    
    
