 #define init
global.sprEnergyGun = sprite_add_weapon("sprites/Energy Gun.png", 5, 2);

#define weapon_name
return "ENERGY GUN"

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

sound_play(sndLaser)
sound_play(sndLightningPistol)
sound_play(sndPlasma)
weapon_post(9,-10,16)




/*repeat(2)
{
	with instance_create(x,y,Laser)
	{
		team = other.team
		creator = other
		image_angle = other.gunangle+random_range(-10,10)*other.accuracy
		event_perform(ev_alarm,0)
	}
}
with instance_create(x,y,PlasmaBall)
{
	team = other.team
	motion_add(other.gunangle+random_range(-7,7)*other.accuracy,12)
	image_angle = direction
	creator = other
}
repeat(4)
{
	with instance_create(x,y,Lightning)
	{
		team = other.team
		ammo = choose(9,12,15,18)
		image_angle = other.gunangle+random_range(-34,34)*other.accuracy
		event_perform(ev_alarm,0)
	}
}*/

with lightning_create(x,y,12,gunangle+random_range(-10,10)){
    team = other.team
    creator = other
    lightning_grow();
}




//yokin is truly defpacks greatest ally
#define lightning_create(_x, _y, _ammo, _direction)
    with(instance_create(_x, _y, CustomProjectile)){
        name = "Lightning";

        sprite_index = sprLightning;
        mask_index = mskLaser;
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

        timer = 5

        return id;
    }

#define lightning_step
    if(alarm0 > 0){
        alarm0 -= current_time_scale;
        if(alarm0 <= 0) lightning_grow();
    }
    timer -= current_time_scale
    if timer<= 0{
        with instance_create(x,y,Laser){
            image_angle = random(360)
            team = other.team
            creator = other.creator
            image_yscale = other.image_yscale
            event_perform(ev_alarm,0)
            with instance_create(x,y,PlasmaImpact){
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
    move_contact_solid(direction, 8 + random(4));
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

        instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), LightningHit);
    }

#define lightning_draw
    image_yscale = 1 + random(1.5);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale / 2, image_angle, image_blend, image_alpha);

     // Bloom:
    draw_set_blend_mode(bm_add);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale * 2, image_angle, image_blend, image_alpha * 0.1);
    draw_set_blend_mode(bm_normal);

#define lightning_hit
    if(projectile_canhit_melee(other)){
         // Hit:
        projectile_hit(other, damage, force, image_angle);

         // Effects:
        instance_create(x, y, Smoke);
        sound_play(sndLightningHit);
    }

#define lightning_anim
    instance_destroy();
