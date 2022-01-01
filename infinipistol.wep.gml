#define init
global.sprInfiniPistol = sprite_add_weapon("sprites/weapons/sprPelletPistol.png", -3, 2);
global.sprHUD          = sprite_add("sprites/interface/sprPelletPistolHUD.png", 1, -3, 2);
global.sprPellet       = mod_script_call("mod", "defpack tools", "sprite_add_p", "../sprites/projectiles/sprPellet.png", 2, 8, 8)
global.sprPelletHit    = sprite_add("sprites/projectiles/sprPelletHit.png",4,8,8)
#define weapon_name
return "INFINIPISTOL";

#define weapon_sprt_hud
return global.sprHUD;

#define weapon_sprt
return global.sprInfiniPistol;

#define weapon_type
return 0;

 //as funny as -100 was, -1 is the most likely to get picked up by mod compat, since people might just check for -1 instead of checking > -1
#define weapon_auto
return -1;

#define weapon_load
return 0;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapPistol

#define weapon_melee
return 0;

#define weapon_area
return 4;

#define nts_weapon_examine
return{
    "d": "The exception to most rules. ",
}

#define weapon_text
return "POTENTIAL"

#define weapon_fire
    weapon_post(2, 0, 3)
    motion_add(gunangle - 180, friction * 3)
    var _p = random_range(.8, 1.2), _v = 1;
    sound_play_pitchvol(sndRustyRevolver, 2 * _p, .6 * _v)
    sound_set_track_position(sound_play_pitchvol(sndLaserCannonCharge, 3 * _p, .4 * _v), .2)
    // sound_play_pitchvol(sndEnemyFire,     random_range(1, 2),  .8)
    // sound_play_pitchvol(sndNothing2Ball,  random_range(2, 3), .2)
    reload += mod_script_call("mod", "defpack tools", "get_reloadspeed", self);
    with instance_create(x, y, CustomProjectile) {
        name = "InfiniPellet"
        sprite_index = global.sprPellet
        mask_index   = global.sprPellet

        move_contact_solid(other.gunangle, 6);
        motion_add(other.gunangle + random_range(-7, 7) * other.accuracy, 5)
        image_angle = direction
        projectile_init(other.team, instance_is(other, FireCont) ? other.creator : other)

        damage = 2
        force = 12
        bounce = 2
        typ = 1
        image_speed = 1
        super = false
        if irandom(100000 - 1) == 0 {
            damage = 999999999999999999
            speed *= 4
            bounce = 10
            on_end_step = superpellet_step
            super = true
            sound_play_pitchvol(sndPlasmaHugeUpg, 3, .5)
            with other {
                motion_add(gunangle + 180, 8)
                reload += 20
            }
        }

        on_destroy = pellet_destroy
        on_wall    = pellet_wall
        on_anim    = pellet_anim
        defbloom = {
            xscale : 2,
            yscale : 2,
            alpha : .1
        }
    }

#define pellet_wall
    sound_pitch(sound_play_hit(sndHitWall, .2), 1.2 + random(.4))
    var d = direction + 180, h = hspeed, v = vspeed;
    move_bounce_solid(false)
    image_angle = direction
    if --bounce < 0 {
        instance_destroy()
    }
    else {
        with instance_create(x + h, y + v, MeleeHitWall) {
            image_angle = d - angle_difference(other.direction, d)/4 + 180
            image_yscale = .5
            image_speed *= 2
            image_index = irandom(1)
        }
        if super {
            instance_create(x, y, LightningHit)
            with other {
                instance_create(x, y, FloorExplo)
                instance_destroy()
            }
        }
    }

#define pellet_destroy
    with instance_create(x, y, BulletHit) {
        sprite_index = global.sprPelletHit
    }
    if super{
        sound_play(sndExploGuardianDeadCharge)
        if fork() {
            var _x = x, _y = y, _l = 50;
            repeat(12 + random(8)) {
                repeat(choose(1, 2)){
                    instance_create(_x + lengthdir_x(random(_l), random(360)), _y + lengthdir_y(random(_l), random(360)), LightningHit)
                }
                wait(choose(irandom(8), irandom_range(3, 15)))
            }
            exit
        }
        with instance_create(x, y, PopoExplosion) {
            image_speed *= 2
            image_xscale /= 2
            image_yscale = image_xscale
            team = other.team
        }
    }

#define pellet_anim
    image_speed = 0
    image_index = 1

#define superpellet_step
    var flutes = 2, num = 360/(flutes)
    var w = 3;
    var ang = direction;
    var n = 32
    var spd = speed;
    var off = (current_frame)*n
    for (var i = 0; i < 360; i+=num){
        i+=off
        var _x = x + lengthdir_x(w*dsin(i),ang+90), _y = y + lengthdir_y(w*dsin(i),ang+90);
        var _x2 = xprevious + lengthdir_x(w*dsin(i-n*current_time_scale),image_angle+90), _y2 = yprevious + lengthdir_y(w*dsin(i-n*current_time_scale),image_angle+90);
        with instance_create(_x,_y,BoltTrail){
            image_angle = point_direction(x,y,_x2,_y2)
            image_xscale = point_distance(x,y,_x2,_y2)
            if random(100) < 20 * current_time_scale
                with instance_create(x, y, Dust) motion_add(other.image_angle, random(spd/2))
        	if fork() {
        	    while instance_exists(self) {
        	        image_blend = merge_color(image_blend,c_aqua,.1*current_time_scale)
        	        wait(0)
        	    }
        	    exit
        	}

        }
        i-=off
    }
