#define init
global.sprPlasmiteCannon = sprite_add_weapon("sprites/weapons/sprPlasmiteCannon.png",0,1)
global.sprPlasmiteBig = sprite_add("sprites/projectiles/sprPlasmiteBig.png",0,9,9)

#define weapon_name
return "PLASMITE CANNON"
#define weapon_sprt
return global.sprPlasmiteCannon;
#define weapon_type
return 5
#define weapon_cost
return 3
#define weapon_area
return 8
#define weapon_load
return 34
#define weapon_swap
return sndSwapEnergy
#define weapon_auto
return 1
#define weapon_laser_sight
return 0
#define weapon_text
return "HEH";
#define weapon_fire

weapon_post(7,12,32+skill_get(17)*12)
if !skill_get(17)
{
	sound_play_pitch(sndPlasmaHuge,2)
	sound_play_pitch(sndPlasmaMinigun,random_range(1.3,1.45))
}
else
{
	sound_play_pitch(sndPlasmaHugeUpg,2)
	sound_play_pitch(sndPlasmaMinigunUpg,random_range(1.3,1.45))
}
with instance_create(x,y,CustomSlash)
{
	name = "plasmite cannon"
	move_contact_solid(other.gunangle,12)
	
	image_speed  = 0;
	image_index  = 0;
	sprite_index = global.sprPlasmiteBig;
	mask_index   = mskBullet1;
	friction     = .2;
	
	creator    = other;
	team	   = other.team;
	ammo       = 3 + skill_get(mut_laser_brain) * 3;
	eindex     = 0;
	angle      = random(360);
	startspeed = 10;
	timer	   = 30 * 6;
	damage	   = 15;
	margin     = 48;
	
	motion_set(other.gunangle+random_range(-2,2)*other.accuracy, startspeed);
	
	defbloom = {
        xscale : 1.5+skill_get(mut_laser_brain),
        yscale : 1.5+skill_get(mut_laser_brain),
        alpha : .1 + skill_get(mut_laser_brain) * .025
    }
	accuracy = other.accuracy
	
	on_hit		  = atom_hit
	on_step 	  = atom_step
	on_wall 	  = atom_wall
	on_destroy    = atom_destroy
	on_projectile = atom_projectile
	on_square     = script_ref_create(atom_square)
	
	repeat(ammo){with create_electron() index = other.eindex++}
}

#define atom_hit
	
#define atom_step
	angle += (3 + speed * 3) * current_time_scale;
	
	var _scl = random_range(.8,1.2);
	image_xscale = _scl
	image_yscale = _scl
	
	var _me = noone;
	x += hspeed * 2
	y += vspeed * 2
	with instances_matching_ne(hitme, "team", other.team){
		if !instance_is(self, prop) && collision_line(x, y, other.x, other.y, Wall, 0, 0) < 0
		{
			if _me = noone {
				_me = self;
			}else if distance_to_object(other) < point_distance(other.x, other.y, _me.x, _me.y){
				_me = self;
			}
		}
	}
	if distance_to_object(_me) <= margin{
		with other{
			var _s = speed;
			motion_add(point_direction(x, y, _me.x, _me.y), 2 * current_time_scale)
			speed = _s;
		}
	}
	
	with instances_matching_ne(hitme, "team", team){
		if distance_to_object(other) <= ((3 + other.ammo * 2 + other.speed * 1.5) * .5) && sprite_index != spr_hurt{
			var _k = my_health > (other.damage + other.ammo) ? false : true;
			projectile_hit(self, other.damage + other.ammo, other.speed, other.direction);
			with other with create_electron() index = other.eindex++;
			other.ammo++;
			sleep(15);
			view_shake_at(other.x, other.y, 8);
	    	sound_play_pitchvol(skill_get(mut_laser_brain) > 0 ? sndPlasmaMinigunUpg : sndPlasmaMinigun, other.ammo / 10, 1)
			with instance_create(other.x+random_range(-12,12),other.y+random_range(-12,12),GunGun){image_index=2-skill_get(17)}
			if !_k with other{
				instance_destroy()
				exit
			}
		}
	}
	x -= hspeed * 2
	y -= vspeed * 2
	
	timer -= current_time_scale;
	if speed <= friction || timer <= 0{instance_destroy()}

#define atom_wall
	move_bounce_solid(false);
	sound_play_pitchvol(sndPlasmaHit, random_range(2, 4), .3);
	
#define atom_square
    ammo += 5*other.size
    repeat(5*other.size){
        create_electron()
    }
    repeat(3*other.size) with instance_create(x,y,PlasmaTrail){image_index = 0;image_speed = .5;motion_add(other.direction+random_range(-140,140),random_range(9,12))}
    repeat(8*other.size){
        with mod_script_call("mod","defpack tools","create_plasmite",x,y)
        {
            creator = other.creator
            team = other.team
            motion_add(other.direction+random_range(-140,140),random_range(16,20))
            image_angle = direction
        }
    }
    sound_play_pitch(sndPlasmaHit,random_range(.9,1.1))
    with instance_create(x,y,PlasmaImpact){team = other.team;instance_create(x+random_range(-8,8),y+random_range(-8,8),Smoke)}
    with other{
        instance_destroy()
        exit
    }

#define atom_destroy
	x += hspeed * 2
	y += vspeed * 2
	sleep(70)
	view_shake_at(x,y,16)
	sound_play_pitch(sndPlasmaBigExplodeUpg,random_range(1.2,1.4))
	instance_create(x,y,PlasmaImpact)
	var i = angle;
	repeat(ammo)
	{
		with mod_script_call("mod","defpack tools","create_plasmite",x,y)
		{
			fric = random_range(.06,.08) + .08
			motion_set(i, 24)
			projectile_init(other.team,other.creator)
			image_angle = direction
		}
		i += 360/ammo
	}
	with Wall{
		if distance_to_object(other) <= 26{
			instance_create(x, y, FloorExplo)
			instance_destroy()
		}
	}

#define atom_projectile
	/*if other.team != team{
		with other{
			instance_destroy();
		}
		with create_electron() index = other.eindex++;
		ammo++;
	}*/


#define create_electron()
	var _a = instance_create(x,y,CustomProjectile);
	with _a
	{
		name ="electron";
		defbloom = {
	        xscale : 2+skill_get(mut_laser_brain),
	        yscale : 2+skill_get(mut_laser_brain),
	        alpha : .1 + skill_get(mut_laser_brain) * .025
	    }
		image_speed = 0;
		image_index = 0;
		sprite_index = sprPlasmaTrail;
		mask_index   = sprAllyBullet;
		
		creator  = other.creator;
		team     = other.team;
		damage   = 3;
		radius   = 1;
		target   = other;
		index    = 0;
		
		on_hit       = mb_hit
		on_step 	 = mb_step
		on_wall 	 = mb_wall
		on_destroy   = mb_destroy
	}
	return _a;

#define mb_hit
	var _e = other;
	with target{
		mod_script_call("mod", mod_current, "atom_hit", _e);
	}

#define mb_destroy
	sound_play_pitch(sndPlasmaHit,random_range(1.55,1.63))
	with instance_create(x,y,PlasmaImpact){image_xscale=.5;image_yscale=.5;damage = round(damage/2);team = other.team}

#define mb_step
	if !instance_exists(target){instance_destroy(); exit}else{
		var _ra = 3 * radius + target.ammo * 2 + target.speed * 1.5,
		    _dr = target.angle + 360 / target.ammo * index,
		    _tx = target.x + target.hspeed + lengthdir_x(_ra, _dr),
		    _ty = target.y + target.vspeed + lengthdir_y(_ra, _dr);
	}

	image_angle = direction
	if irandom(6-skill_get(17)*4) = 1{instance_create(x,y,PlasmaTrail)}

	motion_set(point_direction(x, y, _tx, _ty), point_distance(x, y, _tx, _ty) * .8);

#define mb_wall
	//move_bounce_solid(false)
