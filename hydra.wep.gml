#define init
//Karm replace this sprite
global.sprRockletShotgun = sprite_add_weapon("sprites/weapons/sprRockletShotgun.png", 4, 1);
global.sprExtraCursor = sprite_add("sprites/interface/sprExtraCursor.png", 1, 8, 8)

//All of these variables are non-sync. Do not use them for logic
global.hydraLerps = [];
global.lastGoals = [];
global.hydraTargets = [];
//Populate the arrays with default values
repeat(rocklet_max) {
    array_push(lerps, new_lerp)
    array_push(lastGoal, new_point)
    array_push(targets, noone)
}

global.transformationCache = ds_map_create();
#macro rotationCache global.transformationCache;

#macro new_lerp {x: 0, y: 0, lerp_progress: 1}
#macro new_point {x: 0, y: 0}
#macro lerps global.hydraLerps
#macro lastGoal global.lastGoals
#macro targets global.hydraTargets

//File that the rocklets are being called from
#macro lib "rocklets"

#define weapon_name
return "HYDRA";

#define weapon_sprt
return global.sprRockletShotgun;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 2;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapExplosive;

// 7-3 L0
#define weapon_area
return 16;

#define nts_weapon_examine
return{
    "d": "A bizzare small-arms rocket weapon from the future. #It writhes in your hands. ",
}

#define weapon_text
return choose("THE FUTURE OF SNAKES", "ROCKLET EXPLOSIONS DEAL#LESS DAMAGE THAN MOST");

#define weapon_fire
    weapon_post(5,-7,4)
    var volume = .8
    //Karm these are just the rifle sounds feel free to adjust them
    sound_play_pitchvol(sndToxicBoltGas, .85, volume)
    sound_play_pitchvol(sndHeavySlugger, 1.5, volume)
    sound_play_pitchvol(sndRocketFly, 4, volume)
    sound_play_pitchvol(sndServerBreak, random_range(.5, .8), volume)
    sound_play_pitchvol(sndComputerBreak, random_range(.8, .9), volume)
    sound_play_pitchvol(sndSodaMachineBreak, 3, volume)
    sound_play_pitchvol(sndSuperSplinterGun, 2, volume)

    repeat(3) with instance_create(x + lengthdir_x(10, gunangle), y + lengthdir_y(10, gunangle), Dust) {
        motion_set(other.gunangle + choose(0,60,-60,0,0)+random_range(-15,15),sqr(1.4+random(1)))
    }
    
    var _creator = instance_is(self, FireCont) && "creator" in self ? creator : self;
    repeat(rocklet_count) {
        with mod_script_call("mod", lib, "create_rocklet", x + lengthdir_x(4, gunangle), y + lengthdir_y(4, gunangle)) {
            creator = _creator
            team = creator.team
            move_contact_solid(other.gunangle, 12)
            
            motion_set(other.gunangle + random_range(-10, 10), random(.5) + 2)
            var n = (rocklet_number mod rocklet_count);
            // Fun fact! Arguments from script_ref_create are provided before those that came with script_ref_call, but you do get all of them
            transform_mouse = script_ref_create(hydra_aim_cached, get_aim_angle(other.accuracy, n))
        }
    }
    
#define step(_primary)
    //Request set up for extra cursor drawing
    if _primary or race_id = char_steroids mod_script_call("mod", lib, "request_hud_draw", script_ref_create(draw_gui, self))

#macro aimSpread 30
#macro rocklet_max 4
#macro rocklet_count (rocklet_max - (crown_current != crwn_death))

#define get_aim_angle(accuracy, n)
    var corrected = aimSpread * accuracy;
    
    return -corrected + (n / (rocklet_count - 1)) * (corrected * 2);

#macro lockon_distance 48

//Rotation given by the script ref, rocklet (self) and the mouse provided by script_ref_call in rocklet step
#define hydra_aim_cached(rotation, rocklet, mouse)
    var cached = rotationCache[? rotation];
    //Check for the angle offset in the cache, if it isnt there or isn't valid, recalculate it.
    if (cached == undefined || cached.lastUsed != current_frame || !(cached.mouse.x == mouse.x && cached.mouse.y == mouse.y)) {
        //Recalculate
        var transformed = hydra_aim(rotation, rocklet, mouse);
        //Cache it
        rotationCache[? rotation] = create_cached_transformation(transformed, mouse)
        //Return result
        return transformed;
    }
    //If the cache already has the result, return it
    return cached.result;

#define create_cached_transformation(transformed, mouseIn)
    return {
        lastUsed: current_frame,
        mouse: mouseIn,
        result: transformed
    }
    
#define hydra_aim(rotation, rocklet, mouse)
    var rotated = rotate_around_point(rocklet.creator, mouse, rotation);
    
    var nearest = instance_nearest(rotated.x, rotated.y, enemy);
    if instance_exists(nearest) {
        if point_distance(nearest.x, nearest.y, rotated.x, rotated.y) <= lockon_distance {
            return {x: nearest.x, y: nearest.y, target: nearest}
        }
    }

    return {x: rotated.x, y: rotated.y, target: -4};
    
#macro current altCursors[i]
#define draw_gui(player)
    //I still don't know if this is how you do local drawing yet.
    with player if player_is_local_nonsync(index) {
        var cursor = {x: mouse_x_nonsync, y: mouse_y_nonsync};
        
        //Extremely strange way of making the visual cursors slide around.
        //Uses interpolation and essentially keeps the "percentage" of progress constantly growing.
        var altCursors = array_create(rocklet_count);

        for (var i = 0, l = array_length(altCursors); i < l; i++) {
            altCursors[i] = hydra_aim(get_aim_angle(accuracy, i), {creator: self}, cursor);
        }
        
        for (var i = 0, l = array_length(altCursors); i < l; i++) {
            
            lerps[i].lerp_progress += .05 * current_time_scale
            lerps[i].lerp_progress = min(1, lerps[i].lerp_progress)
            
            //Target changed, reset lerp
            if targets[i] != current.target {
                //Set cached target
                targets[i] = current.target
                //Plant the origin of the movement to the current position
                lerps[i].x = lastGoal[i].x
                lerps[i].y = lastGoal[i].y
                //Make movement start from the beginning at new position
                lerps[i].lerp_progress = 0
            }
            
            var goal = points_lerp(lerps[i], current, lerps[i].lerp_progress);
            lastGoal[i] = goal
            
            draw_sprite_ext(global.sprExtraCursor, 0, goal.x - view_xview_nonsync, goal.y - view_yview_nonsync, 1, 1, 0, player_get_color(player.index), .5)

        }
        
    }
    
#define points_add(vec, vec2)
    return {x: vec.x + vec2.x, y: vec.y + vec2.y}
    
#macro easeFunction easeOutBack
#define points_lerp(vec, vec2, n)
    return {x: lerp(vec.x, vec2.x, easeFunction(n)), y: lerp(vec.y, vec2.y, easeFunction(n))}

#define rotate_around_point(center, point, angle)
    var _sin = dsin(angle),
        _cos = dcos(angle);
    
    return {
        x: (point.x - center.x)*_cos - (point.y - center.y)*_sin + center.x,
        y: (point.x - center.x)*_sin + (point.y - center.y)*_cos + center.y
    }
    
//Got this from easings.net
#define easeOutBack(n) 
#macro c1 1.70158;
#macro c3 c1 + 1;

return 1 + c3 * power(n - 1, 3) + c1 * power(n - 1, 2);

#define easeOutElastic(x)
#macro c4 (2 * pi) / 3;

return x == 0
  ? 0
  : x == 1
  ? 1
  : power(2, -10 * x) * sin((x * 10 - 0.75) * c4) + 1;
