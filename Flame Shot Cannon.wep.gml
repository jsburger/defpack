#define init
global.sprShotCannon = sprite_add_weapon("sprites/weapons/sprFlameShotCannon.png", 4, 2);
global.sprShotBullet = sprite_add("sprites/projectiles/sprFireShot.png",3,8,8)
sprite_collision_mask(global.sprShotBullet,1,1,0,0,0,0,0,0)
#define weapon_name
return "FLAME SHOT CANNON";

#define weapon_sprt
return global.sprShotCannon;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 25;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapShotgun;

#define weapon_area
return 8;

#define weapon_text
return "RING OF FIRE";

#define weapon_fire
	weapon_post(7,43,0)
	sound_play_pitch(sndFlakCannon,1.2)
	sound_play_pitchvol(sndFlakExplode,random_range(.4,.7),.8)
	sound_play_pitch(sndDoubleFireShotgun,1.2)
	sound_play_pitch(sndIncinerator,.8)
	with instance_create(x+lengthdir_x(12,gunangle),y+lengthdir_y(12,gunangle),CustomProjectile) {
		move_contact_solid(other.gunangle,6)
		motion_set(other.gunangle + random_range(-3, 3) * other.accuracy, 15 + random(2))
	    projectile_init(other.team,other)
		sprite_index = global.sprShotBullet
		mask_index = mskFlakBullet
		damage = 2
		force = 0
		image_speed = .5
		accuracy = other.accuracy;
		ortimer = 12
		timer = ortimer
		ftimer = 1.5
		time = ftimer
		canshoot = 0
		dirfac = random(359)
		sage_no_bounce = true;
		hittimer = 0;
		on_hit = script_ref_create(cannon_hit)
		on_wall = script_ref_create(cannon_wall)
		on_step = script_ref_create(cannon_step)
		on_draw = script_ref_create(cannon_draw)
		on_destroy = cannon_destroy;
	}

#define cannon_wall
	view_shake_at(x,y,12)
	sound_play_pitch(sndShotgunHitWall,.8)
	if skill_get(15){speed ++;image_index = 0}
	move_bounce_solid(1)
	
	repeat(2) cannon_fire();
	if timer <= 0{instance_destroy()}

#define cannon_fire()
	dirfac += 14
	timer -= 1;
	sound_play_pitch(sndFireShotgun, 1 * random_range(1.2, .8))
	sound_play_pitch(sndIncinerator, .7 * random_range(1.2, .8))
	var ang = dirfac;
	repeat (5){
		with instance_create(x, y, FlameShell){
			motion_set(ang + random_range(-7, 7) * other.accuracy, 10 + 2 * skill_get(mut_shotgun_shoulders) - irandom(2) * other.accuracy);
			team = other.team
			creator = other.creator
			ang += 72
			image_angle = direction
		}
	}

#define cannon_hit
	if hittimer <= 0 {
		
		hittimer = 3;
		x = xprevious
		y = yprevious
		projectile_hit_push(other,damage + other.image_index = 0 ? 0 : 1,force)
		view_shake_at(x,y,5)
		cannon_fire();
		if timer <= 0 {
			instance_destroy()
		}
	}

#define cannon_step
	hittimer -= current_time_scale;
	with instances_matching(Slash, "team", team){
		if place_meeting(x, y, other){
			with other{
				motion_add(other.direction, max(0, 12 - speed))
				time = ftimer;
				canshoot = false;
				timer = ortimer;
				with instance_create(x, y, Deflect){
					image_angle = other.direction;
					sound_play_pitchvol(sndFlakExplode, .6, .8);
					sound_play_pitchvol(sndShotgun, 1, .8);
				}
				sleep(30)
				view_shake_at(x, y, 4)
				with instance_create(x, y, FlameShell){
					motion_set(other.direction + random_range(-32, 32), 13 + irandom(3))
					team = other.team
					creator = other.creator
					image_angle = direction
				}
			}
		}
	}
	with instances_matching(instances_matching(CustomSlash, "candeflect", true), "team", team){
		if place_meeting(x, y, other){
			with other{
				motion_add(other.direction, max(0, 12 - speed))
				time = ftimer;
				canshoot = false;
				timer = ortimer;
				with instance_create(x, y, Deflect){
					image_angle = other.direction;
					sound_play_pitchvol(sndFlakExplode, .6, .8);
					sound_play_pitchvol(sndShotgun, 1, .8);
				}
				sleep(30)
				view_shake_at(x, y, 4)
				cannon_fire();
			}
		}
	}

	image_angle+=(6+speed*3)*current_time_scale
	time -= current_time_scale

	if image_index >= 2.5{image_index = 1}

	image_xscale = clamp(image_xscale + (random_range(-.05,.05)*current_time_scale),1.2,1.4)
	image_yscale = image_xscale
	if timer = 4 ftimer = 3
	speed /= 1 + (.1*current_time_scale)
	if speed <= 1 {canshoot = 1; speed = 0}

	while time <= 0{
		
	    time += ftimer;
	    
	    if canshoot{
			view_shake_at(x,y,5)

			cannon_fire();
				
			if timer <= 0 {
					
				instance_destroy()
				exit;
			}
	   }
	}

#define cannon_draw
	if image_index = 0{var i = .5}else{var i = .1}
	draw_sprite_ext(sprite_index, image_index, x, y, .7*image_xscale+i, .7*image_yscale+i, image_angle, image_blend, 1.0);
	draw_set_blend_mode(bm_add);
	draw_sprite_ext(sprite_index, image_index, x, y, 1.25*image_xscale+i*2, 1.25*image_yscale+i*2, image_angle, image_blend, i);
	draw_set_blend_mode(bm_normal);


#define cannon_destroy
repeat(40) {
	
	with instance_create(x, y, Flame) {
	
		creator = other.creator;
		team = other.team;
		motion_add(random(360), random_range(6, 8))
	}	
}
sleep(30);
view_shake_at(x, y, 8);
sound_play_pitchvol(sndFlameCannonEnd, 1.6, .7)
sound_play_pitchvol(sndFlareExplode, 1.2, .7)