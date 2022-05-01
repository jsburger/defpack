#define init
    global.sprBullet = sprite_add("../../../sprites/sage/bullets/sprBulletEcho.png", 2, 7, 11);
    global.sprFairy = sprite_add("../../../sprites/sage/bullet icons/sprFairyIconEcho.png", 2, 5, 5);
    
    global.tracker = noone
    global.trackedProjectiles = ds_map_create()
    #macro tracked global.trackedProjectiles
    
    with effect_type_create("projectileEcho", `@(color:${c.neutral})+PROJECTILES @(color:${$FFD4AA})RUPTURE @(color:${c.neutral})FOR {} @rDAMAGE`, scr.describe_whole) {
        on_new_projectiles = script_ref_create(echo_update)
    }
    
    global.effects = [
        effect_instance_named("projectileEcho", 2, 2)
    ]

#macro c mod_variable_get("race", "sage", "colormap");
#macro scr mod_variable_get("mod", "sageeffects", "scr")

    
#define cleanup
    ds_map_destroy(tracked)
    with global.tracker instance_destroy()


#define fairy_sprite
    return global.sprFairy;

#define fairy_color
    return $FFD4AA;

#define bullet_sprite
    return global.sprBullet;

#define bullet_name
    return "ECHO";

#define bullet_ttip
    return [`@(color:${$FFD4AA})RUPTURES @sSCALE IN SIZE#WITH PROJECTILE DAMAGE`, "::VORTEX IMPACT EX-8863", "::RUPTURE CASCADES ELIMINATED#::EFFECTIVENESS RETAINED"];

#define bullet_area
    return 1;

#define bullet_swap
    var _p = random_range(.9, 1.1);
    sound_play_pitchvol(sndSwapHammer,        .6 * _p, .5);
    sound_play_pitchvol(sndSwapShotgun,  	 1.2 * _p, .9);
    sound_play_pitchvol(sndCrossReload,      1.4 * _p, .9);

#define bullet_effects
	return global.effects

#define create_echo_explosion(_x, _y, _damage, echoValue)
    with instance_create(_x, _y, CustomProjectile) {
        
        damage = ceil(echoValue);
        force  = 2;
        radius = floor(14 * sqrt(abs(_damage/3)) * (echoValue/2));
        time = 1
        maxtime = 4
        
        sprite_index = sprEnemyBullet1
        mask_index = sprEnemyBullet1
        var scale = radius/sprite_width;
        image_xscale = scale
        image_yscale = scale
        sprite_index = mskNone
        
        
        //Sage Do Not Interact, prevents sage from interacting with the projectiles at all
        sage_dni = true
        //Mod compat thing, should prevent interaction
        ammo_type = -1
        
        hitlist = []
        
        on_hit = echo_hit;
        on_wall = nothing
        on_step = echo_step
        on_draw = echo_draw
        on_destroy = echo_destroy
        
        return self
    }

#define echo_destroy
    var q = instance_create(x, y, CaveSparkle);
    q.depth -= 2
    q.image_speed *= random_range(1.5, 2)

#define echo_step
    time += current_time_scale
    if time > maxtime {
        instance_destroy()
    }

#define echo_draw
    draw_circle(x, y, radius * sin(sqrt(time/maxtime) * pi), false)

#define nothing
#define echo_hit
    if array_find_index(hitlist, other) == -1 {
        projectile_hit(other, damage, force, point_direction(x, y, other.x, other.y));
        array_push(hitlist, other)
    }
    
#define echo_update(value, effect, newProjectiles)
    if !instance_exists(global.tracker) {
        with script_bind_end_step(echo_tracking, -1) {
            global.tracker = self
        }
    }
    with instances_matching_ne(newProjectiles, "sage_no_echo", true) {
        start_tracking(self, value)
    }


#define start_tracking(proj, value)
    tracked[? proj] = {
        x: proj.x,
        y: proj.y,
        creator: proj.creator,
        team: proj.team,
        damage: proj.damage,
        "value": value
    }
    
    
#define echo_tracking
    var keys = ds_map_keys(tracked),
        values = ds_map_values(tracked);
    
    for (var i = array_length(keys) - 1; i >= 0; i--) {
        var info = values[i];
        //If projectile doesn't exist anymore
        if !instance_exists(keys[i]) {
            
            with create_echo_explosion(info.x, info.y, info.damage, info.value) {
                team = info.team
                creator = info.creator
            }
            //Remove id from map
            ds_map_delete(tracked, keys[i])
        }
        //Update tracker values if projectile does exist
        else {
            var proj = keys[i]
            info.x = proj.x + proj.hspeed_raw/1.5
            info.y = proj.y + proj.vspeed_raw/1.5
            info.damage = proj.damage
            info.team = proj.team
        }
    }
    
    if array_length(keys) == 0 {
        instance_destroy()
    }
    
#define simple_stat_effect(variableName, value, scaling) return mod_script_call("mod", "sageeffects", "simple_stat_effect", variableName, value, scaling)
#define effect_instance_named(effectName, value, scaling) return mod_script_call("mod", "sageeffects", "effect_instance_create", value, scaling, effectName)
#define effect_type_create(name, description, describe_script) return mod_script_call("mod", "sageeffects", "effect_type_create", name, description, describe_script)

