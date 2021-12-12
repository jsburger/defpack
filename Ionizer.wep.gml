 #define init
global.sprEnergyGun    = sprite_add_weapon("sprites/weapons/sprIonizer.png", 6, 4);
global.sprEnergyGunHUD = sprite_add_weapon("sprites/weapons/sprIonizer.png", 8, 5);

#define weapon_name
return "IONIZER"

#define weapon_sprt
return global.sprEnergyGun;

#define weapon_sprt_hud
return global.sprEnergyGunHUD;

#define weapon_type
return 5;

#define weapon_auto
return false;

#define weapon_load
return 24;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return 10;

#define nts_weapon_examine
return{
    "d": "Assembled out of bits and pieces of many different energy weapons. ",
}

#define weapon_text
return "CATASTROPHIC";

#define weapon_fire
    sleep(20)
    var _p = random_range(.8, 1.2)
    sound_play_pitch(sndLaser, .3 * _p)
    sound_play_pitch(sndLaserCannon, .6 * _p)
    if skill_get(mut_laser_brain) {
      sound_play_pitch(sndUltraLaserUpg,1.5*_p)
      sound_play_pitch(sndPlasmaUpg,.7*_p)
      sound_play_pitch(sndLaserCannonUpg,.6*_p)
    }
    else {
      sound_play_pitch(sndUltraLaser,1.5*_p)
      sound_play_pitch(sndPlasma,.7*_p)
    }
    sound_play_gun(sndClickBack, 1, .6)
    sound_stop(sndClickBack)
    weapon_post(9, -20, 16)
    
    var c = instance_is(self, FireCont) && "creator" in self ? creator : self;
	var ownedSquares = instances_matching(instances_matching(CustomSlash, "name", "Square"), "creator", c),
	    boost = false;
	#macro squareCost 4
	if array_length(ownedSquares) >= squareCost {
		with array_slice(ownedSquares, 0, squareCost) {
		    instance_destroy()
	    }
	    boost = true
	}
    
    with lightning_create(x, y, irandom_range(15,17) + 10 * skill_get(mut_laser_brain), gunangle + random_range(-10, 10)) {
        team = other.team
        creator = c
        accuracy = other.accuracy
        square_boosted = boost;
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
        accuracy = 1;
        image_angle = direction;
        creator = noone;
        damage = 20;
        force = 4;
        ammo = _ammo;
        typ = 0;
        square_boosted = false;

        on_step = lightning_step;
        on_draw = lightning_draw;
        on_hit = lightning_hit;
        on_anim = lightning_anim;

        timer = 24

        return id;
    }

#define lightning_step
    if(alarm0 > 0){
        alarm0 -= current_time_scale;
        if(alarm0 <= 0) lightning_grow();
    }
    timer -= current_time_scale
    if timer mod 2 <= current_time_scale {
        //Normal plasma impact
        var explo = noone;
        if square_boosted {
            explo = mod_script_call_nc("mod", "squares", "create_large_square_explo", x, y)
            explo.image_angle = random(360)
            
            repeat(1 /*+ irandom(1)*/) {
                with mod_script_call("mod", "squares", "create_square_explo", x + random_range(-30, 30), y + random_range(-30, 30)) {
                    image_speed = random_range(.3,.6)
                    team = other.team
                    creator = other.creator
                    image_angle = random(360)
                }
            }
        }
        else {
            explo = instance_create(x, y, PlasmaImpact)
            
            with mod_script_call("mod", "defpack tools", "create_plasma_impact_small", x + random_range(-30, 30), y + random_range(-30, 30)) {
                image_speed = random_range(.3,.6)
                team = other.team
                creator = other.creator
            }

        }
        
        with explo {
            var s = choose(.5, .75)
            image_xscale = s
            image_yscale = s
            image_speed = random_range(.3, .6)
            team = other.team
            creator = other.creator
        }
    
        if skill_get(mut_laser_brain) > 0 {
            with instance_create(x+random_range(-18,18),y+random_range(-18,18),GunGun){image_index = 3 + irandom(2)}
        }
        instance_destroy()
    }

#define lightning_grow()
    var _target = instance_nearest(x + lengthdir_x(80, direction), y + lengthdir_y(80, direction), enemy);

     // Find Direction to Move:
    direction += random_range(-6, 6) * accuracy;
    if(instance_exists(_target) && point_distance(x, y, _target.x, _target.y) < 120){ /// Weird homing system
        speed = 3;
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
            square_boosted = other.square_boosted
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
    if(projectile_canhit_melee(other)){
         // Hit:
        projectile_hit(other, damage, force, image_angle);

         // Effects:
        instance_create(x, y, Smoke);
        sound_play(sndLightningHit);
    }
if other.team != team other.speed = 0
#define lightning_anim
    instance_destroy();
