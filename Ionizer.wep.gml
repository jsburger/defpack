 #define init
global.sprEnergyGun = sprite_add_weapon("sprites/Energy Gun.png", 6, 4);

#define weapon_name
return "IONIZER"

#define weapon_sprt
return global.sprEnergyGun;

#define weapon_type
return 5;

#define weapon_auto
return false;

#define weapon_load
return 30;

#define weapon_cost
return 6;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 10;

#define weapon_text
return "CATASTROPHIC";

#define weapon_fire
sleep(20)
var _p = random_range(.8,1.2)
sound_play_pitch(sndLaser,.3*_p)
if !skill_get(17)
{
  sound_play_pitch(sndUltraLaser,1.5*_p)
  sound_play_pitch(sndPlasma,.7*_p)
}
else
{
  sound_play_pitch(sndUltraLaserUpg,1.5*_p)
  sound_play_pitch(sndPlasmaUpg,.7*_p)
}
weapon_post(9,-10,16)
with lightning_create(x,y,12,gunangle+random_range(-10,10)){
    team = other.team
    creator = other
    lightning_grow();
}
motion_add(gunangle-180,4)
//yokin is truly defpacks greatest ally
#define lightning_create(_x, _y, _ammo, _direction)
    with(instance_create(_x, _y, CustomProjectile)){
        name = "Lightning";

        sprite_index = sprLightning;
        mask_index = mskLaser;
        image_alpha = 0
        image_speed = (skill_get(mut_laser_brain) ? 0.3 : 0.4);
        direction = _direction;
        image_angle = direction;
        creator = noone;
        damage = 7;
        force = 4;
        ammo = _ammo;
        typ = 0;

        on_step = lightning_step;
        on_draw = lightning_draw;
        on_hit = lightning_hit;
        on_anim = lightning_anim;

        timer = 1

        return id;
    }

#define lightning_step
    if(alarm0 > 0){
        alarm0 -= current_time_scale;
        if(alarm0 <= 0) lightning_grow();
    }
    timer -= current_time_scale
    if timer<= 0{
        with instance_create(x,y,Laser)
        {
          image_angle = random(360)
          team = other.team
          creator = other.creator
          image_yscale = other.image_yscale
          with instance_create(x,y,PlasmaImpact)
          {
            s = choose(.5,.75)
            image_xscale = s
            image_yscale = s
            image_speed = random_range(.3,.6)
            team = other.team
            creator = other.creator
          }
          with instance_create(x+random_range(-30,30),y+random_range(-30,30),PlasmaImpact)
          {
            s = .25
            image_xscale = s
            image_yscale = s
            image_speed = random_range(.3,.6)
            team = other.team
            creator = other.creator
          }
          event_perform(ev_alarm,0)
          with instance_create(x,y,PlasmaImpact)
          {
            team = other.team
            creator = other.creator
          }
        }
        instance_destroy()
    }

#define lightning_grow()
    var _target = instance_nearest(x + lengthdir_x(80, direction), y + lengthdir_y(80, direction), enemy);

     // Find Direction to Move:
    direction += random_range(-15, 15);
    if(instance_exists(_target) && point_distance(x, y, _target.x, _target.y) < 120){ /// Weird homing system
        speed = 4;
        motion_add(point_direction(x, y, _target.x, _target.y), 1);
        speed = 0;
    }
    image_angle = direction;

     // Stretch:
    var length = 8 + random(4)
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
        with(lightning_create(x, y, ammo, direction)){
            team = other.team;
            creator = other.creator;
            image_index = other.image_index;
            lightning_grow();
        }
    }

     // End of Rail:
    else{
        var _dis = image_xscale / 2,
            _dir = image_angle;

        //instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), LightningHit);
    }

#define lightning_draw
    image_yscale = 1 + random(1.5);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale / 2, image_angle, image_blend, image_alpha);

     // Bloom:
    draw_set_blend_mode(bm_add);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale * 2, image_angle, image_blend, image_alpha * 0.1);
    draw_set_blend_mode(bm_normal);

#define lightning_hit
/*
    if(projectile_canhit_melee(other)){
         // Hit:
        projectile_hit(other, damage, force, image_angle);

         // Effects:
        instance_create(x, y, Smoke);
        sound_play(sndLightningHit);
    }
*/
if other.team != team other.speed = 0
#define lightning_anim
    instance_destroy();
