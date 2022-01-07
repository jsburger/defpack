#define init
	global.sprChainsaw 		= sprite_add_weapon("sprites/weapons/sprChainsaw.png",0,3)
	global.mskChainsaw 		= sprite_add_weapon("sprites/projectiles/mskChainsaw.png",20,3)
	global.sprMiniAmmo 		= sprite_add("sprites/other/sprMiniAmmo.png",7,3,3)
	global.sprChainsawShank = sprite_add("sprites/projectiles/sprHexNeedleShank.png", 4, -6, 4);

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define weapon_name
	return "CHAINSAW"
#define weapon_type
	return 4
#define weapon_cost
	return 1
#define weapon_area
	return 6;
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
	return choose("RIP AND TEAR", "KILLED ENEMIES ALWAYS#DROP SOME @yAMMO")
#define nts_weapon_examine
return{
    "d": "A point-blank melee weapon. #Killing with this weapon feels glorious! ",
}
#define weapon_fire
	with instance_create(x,y,CustomObject){
		creator = other
		team    = other.team
		name    = "chainsaw burst"
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
			sound_play_pitch(sndJackHammer,random_range(.4,.6))
			sound_play_pitchvol(sndSwapMotorized,1,.6)
			sound_play_gun(sndClickBack,1,.8)
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
		with instance_create(creator.x+creator.hspeed+lengthdir_x(-l,creator.gunangle),creator.y+creator.vspeed+lengthdir_y(-l,creator.gunangle),CustomProjectile){
			//if !irandom(2) instance_create(x+lengthdir_x(6+(6*skill_get(13)),other.creator.gunangle),y+lengthdir_y(6+(6*skill_get(13)),other.creator.gunangle),Smoke)
			sprite_index = mskNone
			canfix = false
			force = 0
			damage = irandom_range(1, 2)
			if skill_get(13) = true mask_index = global.mskChainsaw else mask_index = global.sprChainsaw
			image_xscale = 1.33
			image_yscale = 1.25
			creator = other.creator
			team = other.team
			image_angle = other.creator.gunangle
			with instances_matching_gt(instances_matching_ne(projectile,"team",other.team), "typ", 0){
				if place_meeting(x,y,other){instance_destroy()}
			}
			with instance_create(x, y, Wind){
				sprite_index = global.sprChainsawShank;
				image_angle = other.image_angle + random_range(-12, 12);
				depth -= 1;
				motion_add(image_angle, 1 + random(.2));
			}
			on_hit        = chainsawshank_hit
			on_wall       = chainsawshank_wall
			on_anim       = anim_destroy
		}
		if ammo <= 0{instance_destroy();exit}
	}

#define chainsawshank_hit
	if current_frame_active && instance_exists(creator){
		view_shake_max_at(x, y, 5)
		sleep(20)
	
		with other {
			
			x = xprevious;
			y = yprevious;
			speed = 0;
		
			// Make enemy brain freeze:
			if("alarm0" in self) {alarm0 = min(alarm0 + current_time_scale, 25)}
			if("alarm1" in self) {alarm0 = min(alarm1 + current_time_scale, 25)}
		}
		
		var _splat = -4,
		        _o = self;

		_splat = determine_gore(other)
	    with instance_create((other.x*other.size+x)/(other.size+1),(other.y*other.size+y)/(other.size+1),_splat){image_angle = random(360)}

		projectile_hit(other, damage, force, image_angle);

		if other.my_health <= 0 && "chainsawed" not in other{
			other.chainsawed = true;
	        sound_play_pitch(sndDiscHit,random_range(.7,.8))
			sound_play_pitch(sndImpWristKill,random_range(1.6,1.8))
			sound_play_pitch(sndDiscBounce,random_range(.5,.6))
			sleep(70 + other.size * 20)
			view_shake_max_at(x, y, 28 + other.size * 12)
			projectile_hit(other, 0, 9, _o.image_angle);

			if other.size > 1 && instance_is(other, enemy) repeat(min(5, other.size)){
				 with instance_create(other.x,other.y,AmmoPickup){motion_add(random(360), 5);num = .5; alarm0 = 1}
			}
		}
	}

#define chainsawshank_wall
	if !instance_exists(creator){instance_delete(self); exit}
	with creator
	{
		var bwep = specfiring and race == "steroids",
				l      = 0;

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
	view_shake_max_at(x, y, 3)
	sound_play_pitchvol(sndMeleeWall, random_range(1.3, 1.6), .8)

#define anim_destroy
	instance_destroy()

#define determine_gore(_id) return mod_script_call("mod", "defpack tools", "determine_gore", _id);
