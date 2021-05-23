#define init
	global.sprChainsaw 			= sprite_add("sprites/weapons/sprEnergyChainsaw.png", 7, 3, 4);
	global.mskChainsaw 			= sprite_add_weapon("sprites/projectiles/mskChainsaw.png",20,3)
	global.sprMiniAmmo 			= sprite_add("sprites/other/sprMiniAmmo.png",7,3,3)
	global.sprChainsawShank = sprite_add("sprites/projectiles/sprEShank.png", 5, -6, 4);

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define weapon_name
	return "ENERGY CHAINSAW"
#define weapon_type
	return 5
#define weapon_cost
	return 1
#define weapon_area
	return 8;
#define weapon_load
	return 12;
#define weapon_swap
	return sndSwapMotorized
#define weapon_auto
	return true;
#define weapon_melee
	return 0
#define weapon_laser_sight
	return 0
#define weapon_sprt
	return global.sprChainsaw
#define weapon_text
	return choose("PLASMA TEARER", "KILLED ENEMIES ALWAYS#DROP SOME @yAMMO")
#define nts_weapon_examine
return{
    "d": "A point-blank melee weapon. #The trees are long gone ",
}
#define weapon_fire
	with instance_create(x,y,CustomObject){
		creator = other
		team    = other.team
		name    = "energy chainsaw burst"
		ammo    = weapon_get_load(mod_current)
		timer   = current_time_scale
		on_step = chainsaw_step
		bwep    = other.specfiring and other.race == "steroids"
	}

#define chainsaw_step
	if !instance_exists(creator){instance_destroy();exit}
	if ammo > 0 && current_frame_active{
		ammo--
		with creator{

			var _p = random_range(.8, 1.2);
			sound_play_pitch(sndJackHammer, .3 * _p);
			sound_play_pitchvol(sndSwapMotorized, 1,.2);
			sound_play_pitchvol(sndEnergyHammerUpg, .4, .9);
			if skill_get(mut_laser_brain) > 0{
				sound_play_pitchvol(sndEnergyScrewdriverUpg, .7, .7);
				sound_play_pitchvol(sndEnergySwordUpg, .7 * _p, .7);
			}else{
				sound_play_pitchvol(sndEnergyScrewdriver, .7, .7);
				sound_play_pitchvol(sndEnergySword, .7 * _p, .7);
			}
			sound_play_gun(sndClickBack,1, .8);
			sound_stop(sndClickBack)

			weapon_post(0,6,0)

			if other.bwep{
				bwkick = -6 - 6*skill_get(13) + random_range(-1,1)
			    var l = bwkick;
			}
			else{
			    wkick = -6 - 6*skill_get(13) + random_range(-1,1)
			    var l = wkick;
			}
		}
		with instance_create(creator.x+lengthdir_x(-l,creator.gunangle),creator.y+lengthdir_y(-l,creator.gunangle),CustomProjectile){
			if !irandom(4) repeat(1 + irandom(2)) instance_create(x + random_range(-3, 3) + lengthdir_x(12+(6*skill_get(13)),other.creator.gunangle),y + random_range(-3, 3) + lengthdir_y(12+(6*skill_get(13)),other.creator.gunangle),PlasmaTrail)
			sprite_index = mskNone
			canfix = false
			force = 0
			damage = choose(1, 1, 2)
			if skill_get(13) = true mask_index = global.mskChainsaw else mask_index = global.sprChainsaw
			image_xscale = 1.33
			image_yscale = 1.25
			creator = other.creator
			team = other.team
			image_angle = other.creator.gunangle
			image_speed /= (1 + skill_get(mut_laser_brain));
			with instances_matching_gt(instances_matching_ne(projectile,"team",other.team), "typ", 0){
				if place_meeting(x,y,other){instance_destroy()}
			}
			if irandom(1) with instance_create(x + lengthdir_x(4 * other.creator.right, other.image_angle), y + lengthdir_y(4 * other.creator.right, other.image_angle), Wind){
				sprite_index = global.sprChainsawShank;
				image_angle = other.image_angle + random_range(-12, 12);
				depth -= 1;
				image_speed /= (1 + skill_get(mut_laser_brain));
				motion_add(image_angle, random(1));
			}
			on_hit        = chainsawshank_hit
			on_wall       = chainsawshank_wall
			on_anim       = anim_destroy
		}
		if ammo <= 0{instance_destroy();exit}
	}

#define chainsawshank_hit
	if current_frame_active{
		view_shake_max_at(x, y, 5)
		sleep(20)
		other.speed = 0
		var _splat = -4,
		        _o = self;

		_splat = determine_gore(other)
	    with instance_create((other.x*other.size+x)/(other.size+1),(other.y*other.size+y)/(other.size+1),_splat){image_angle = random(360)}

		projectile_hit(other, damage, force, image_angle);

		if other.my_health <= 0 && "chainsawed" not in other{
			other.chainsawed = true;

			sound_play_pitch(sndDiscHit, random_range(.7,.8))
			sound_play_pitch(sndImpWristKill, random_range(1.6,1.8))
			sound_play_pitch(sndDiscBounce, random_range(.5,.6))

			if skill_get(mut_laser_brain) > 0{
				sound_play_pitch(sndPlasmaBigExplodeUpg, random_range(.7,.8))
				sound_play_pitch(sndPlasmaBigUpg, random_range(.7,.8))
			}else{
				sound_play_pitch(sndPlasmaBigExplode, random_range(.7,.8))
				sound_play_pitch(sndPlasmaBig, random_range(.7,.8))
			}

			sound_play_gun(sndClickBack, 1, -.5);
			sound_stop(sndClickBack)

			sleep(90 + other.size * 30)
			view_shake_max_at(x, y, 28 + other.size * 12)

			projectile_hit(other, 0, 9, _o.image_angle);

			var _c = crown_current
			crown_current = crwn_haste
			if other.size > 0 && instance_is(other, enemy){
				var _n = round(skill_get(mut_laser_brain)) + other.size * 3,
					_i = random(360);
					_c = instance_exists(creator) ? creator.accuracy : 0;

				repeat(_n){
						with instance_create(other.x, other.y, Laser){
						image_angle = _i + random_range(-12, 12) * _c;
						direction = image_angle;
						creator = other.creator
						team = other.team
						event_perform(ev_alarm,0)
					}
					_i += 360 / (_n * 2);

					with mod_script_call("mod", "defpack tools", "create_plasmite", other.x, other.y){
						team = other.team;
						creator = other.creator;
						motion_add(_i+ random_range(-6, 6) * _c, 12 + _n);
						maxspeed = speed;
					}
					_i += 360 / (_n * 2);
				}

				with instance_create(other.x, other.y, PlasmaImpact){
					team = other.team;
					creator = other.creator;
					depth = other.depth - 1;
				}

			}
			crown_current = _c
		}
	}

#define chainsawshank_wall
	if !instance_exists(creator){instance_delete(self); exit}
	with creator
	{
		var bwep = specfiring and race == "steroids",
				l = 0;

		if bwep{
			bwkick = -6 - 6*skill_get(13) + random_range(-1,1)
				var l = bwkick - 8;
		}
		else{
				wkick = -6 - 6*skill_get(13) + random_range(-1,1)
				var l = wkick - 8;
		}
	}
	if current_frame mod 2 = 0 with instance_create(x+lengthdir_x(-l,creator.gunangle) , y+lengthdir_y(-l,creator.gunangle), Hammerhead)
	{
		image_angle = random(360);
		if irandom(room_speed) = 0
		{
			instance_create((x + other.creator.x)/2, (y + other.creator.y)/2, Debris)
		}
	}
	view_shake_max_at(x, y, 4)
	sleep(12)
	sound_play_pitchvol(sndMeleeWall, random_range(1.3, 1.6), .8)

#define anim_destroy
	instance_destroy()

#define determine_gore(_id) return mod_script_call("mod", "defpack tools", "determine_gore", _id);
