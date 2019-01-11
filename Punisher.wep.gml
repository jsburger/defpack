#define init
global.gun = sprite_add_weapon("sprites/sprPunisher.png", 6, 4)
global.proj = sprite_add("sprites/projectiles/sprPunisherBolt.png", 4, 2, 1)
global.shock = sprite_add("sprites/projectiles/sprPunisherShock.png", 4, 12, 12)
#define weapon_name
return "PUNISHER"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return 15
#define weapon_load
return 16
#define weapon_swap
return sndSwapShotgun
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
/*var length = 150
draw_set_blend_mode(bm_add)
draw_line_width_color(x,y,x+lengthdir_x(length,gunangle+30),y+lengthdir_y(length,gunangle+30),1,c_red,c_black)
draw_line_width_color(x,y,x+lengthdir_x(length,gunangle-30),y+lengthdir_y(length,gunangle-30),1,c_red,c_black)
draw_triangle_color(x,y,x+lengthdir_x(length,gunangle+30),y+lengthdir_y(length,gunangle+30),x+lengthdir_x(length,gunangle-30),y+lengthdir_y(length,gunangle-30),merge_color(c_red,c_black,.5),c_black,c_black,0)
draw_set_blend_mode(bm_normal)
*/
return 0
#define weapon_fire
weapon_post(7,-13,7)
sound_play_pitchvol(sndBloodCannon,1.3+random(.1),.7)
sound_play_pitch(sndExplosionL,2)
sound_play_pitch(sndDoubleShotgun,.8)
sleep(120)
if infammo = 0 projectile_hit(self,1)
lasthit = [global.gun, weapon_name()]
sleep(120)
var _x = x + lengthdir_x(14, gunangle), _y = y + lengthdir_y(14, gunangle);

with lightning_create(x,y,20,other.gunangle){
    team = other.team
    creator = other
    epictime = 1
}
var i = -1
repeat(2){
    with lightning_create(_x,_y,12,other.gunangle + random_range(15,45) * i * accuracy){
        team = other.team
        creator = other
        epictime = 1
        forks = 2
    }
    i*= -1
}

#define weapon_sprt
return global.gun
#define weapon_text
return "@rLIFE@s AND @dDEATH@s"

#define instance_nearest_matching_ne(_x,_y,obj,varname,value)
var num = instance_number(obj),
    man = instance_nearest(_x,_y,obj),
    mans = [],
    n = 0,
    found = -4;
if instance_exists(obj){
    while ++n <= num && variable_instance_get(man,varname) = value || (instance_is(man,prop) && !instance_is(man,Generator)){
        man.x += 10000
        array_push(mans,man)
        man = instance_nearest(_x,_y,obj)
    }
    if variable_instance_get(man,varname) != value && (!instance_is(man,prop) || instance_is(man,Generator)) found = man
    with mans x-= 10000
}
return found


//yokin is truly defpacks greatest ally
#define lightning_create(_x, _y, _ammo, _direction)
    with(instance_create(_x, _y, CustomProjectile)){
        name = "Punisher Bolt";
        
        sprite_index = global.proj;
        mask_index = mskLaser;
        image_alpha = 1
        image_speed = 0.4;
        direction = _direction;
        image_angle = direction;
        image_yscale = choose(-1,1)
        hitid = [global.shock,"Punisher Strand"]
        creator = noone;
        damage = 1;
        force = 4;
        forks = 3
        ammo = _ammo;
        typ = 0;
        explo = 1
        
        on_step = lightning_step;
        on_draw = lightning_draw;
        on_hit = lightning_hit;
        on_anim = lightning_anim;

        epictime = 0

        return id;
    }

#define lightning_step
    if(epictime > 0){
        epictime -= current_time_scale;
        if(epictime <= 0) lightning_grow();
    }

#define lightning_grow()
    var _target = instance_nearest_matching_ne(x + lengthdir_x(80, direction), y + lengthdir_y(80, direction), hitme, "team", team);

     // Find Direction to Move:
    direction += sqr(random(4)) * choose(-1,1);
    if(instance_exists(_target) && point_distance(x, y, _target.x, _target.y) < 120){ /// Weird homing system
        speed = 4;
        motion_add(point_direction(x, y, _target.x, _target.y), 1);
        speed = 0;
    }
    var length = 8 + random(4);
    var _x = x + lengthdir_x(length, direction), _y = y + lengthdir_y(length, direction);
    var q = instance_nearest(_x, _y,Wall)
    if instance_exists(q){
        var ang = angle_difference(direction,point_direction(_x,_y,q.x+8,q.y+8))
        if distance_to_object(q) < 25 and abs(ang) < 80 direction += ang/4
    }
    
    image_angle = direction;

     // Stretch:
    x+= lengthdir_x(length, direction)
    y+= lengthdir_y(length, direction)
    image_xscale = -point_distance(x, y, xprevious, yprevious) / 2;

     // Bounce:
    if(place_meeting(x, y, Wall)){
        x = xprevious;
        y = yprevious;
        direction += 180;
    }

     // Continue Rail:
    if(--ammo > 0){
        image_index += 0.4 / ammo;
        if !irandom(ammo/3) and forks > 0{
            forks--
            with(lightning_create(x, y, ceil(ammo/2), direction + (choose(-1,1)* random_range(10,25)))){
                team = other.team;
                creator = other.creator;
                image_index = other.image_index;
                forks = 0
                epictime = 1;
            }
        }
        if !irandom(7) with instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), LightningHit) sprite_index = global.shock;
        with(lightning_create(x, y, ammo, direction)){
            team = other.team;
            creator = other.creator;
            image_index = other.image_index;
            forks = other.forks
            lightning_grow();
        }
    }

     // End of Rail:
    else{
        var _dis = image_xscale / 2,
            _dir = image_angle;

        //with instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), LightningHit) sprite_index = global.shock;
    }

#define lightning_draw
    image_yscale = (1 + random(1.5));
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale / 2, image_angle, image_blend, image_alpha);

     // Bloom:
    draw_set_blend_mode(bm_add);
    draw_sprite_ext(sprite_index, image_index + image_speed, x, y, image_xscale, image_yscale * 2, image_angle, image_blend, image_alpha * 0.1);
    draw_set_blend_mode(bm_normal);

#define lightning_hit
   // if(projectile_canhit_melee(other)){
         // Hit:
        projectile_hit(other, damage, force, image_angle);
    
         // Effects:
        instance_create(x, y, Smoke);
        if explo{
            sound_play_pitch(sndBloodLauncherExplo,1.7);
            with instance_create(x,y,MeatExplosion) team = other.team
            explo = 0
        }
    //}

#define lightning_anim
    instance_destroy();
