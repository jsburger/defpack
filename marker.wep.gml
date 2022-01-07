#define init
global.sprMarker 				  		= sprite_add_weapon("sprites/weapons/sprMarker.png", 3, 2);
global.sprMarkerBolt 					= sprite_add("sprites/projectiles/sprMarkerBolt.png",2,-2,3)
global.sprBoltStickGround     = sprite_add("sprites/projectiles/sprBoltStickGround.png", 6, 6, 16)
global.sprSmallSonicExplosion = sprite_add("sprites/projectiles/sprSonicExplosionSmall.png", 8, 20, 20);
global.sprMarkerTrail         = sprite_add("sprites/other/sprMarkerTrail.png", 3, 4, 4);

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define weapon_name
return "MARKER"

#define weapon_sprt
return global.sprMarker;

#define weapon_type
return 3;

#define weapon_auto
return false;

#define weapon_load
return 26;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapBow;

#define weapon_area
return 9;

#define nts_weapon_examine
return{
    "d": "Marks a spot in the world than can be seen from any plane of existence. ",
}

#define weapon_text
return "UNSEEN ALLIES";

#define weapon_fire
	weapon_post(6,-50,5)
	sound_play_pitch(sndUltraCrossbow,random_range(3,4))
	sound_play_pitch(sndHeavyCrossbow,random_range(2,3))
	sound_play_pitch(sndSeekerPistol,random_range(1.6,2))
	with instance_create(x,y,Bolt){
		name = "marker bolt"
		damage = 6
		team = other.team
		creator = other
		sprite_index = global.sprMarkerBolt
		motion_add(other.gunangle+random_range(-2,2),24)
		image_angle = direction
	}

#define step
	with Bolt{
		if current_frame_active{
			with instance_create(x + random_range(-3, 3), y + random_range(-3, 3), Wind){
				sprite_index = global.sprMarkerTrail;
				motion_add(other.canhurt ? other.direction : random(360), choose(2, 2, 2, 3))
			}
		}
		if sprite_index = global.sprMarkerBolt && !canhurt && "spawn" not in self{
			with instance_create(x,y,CustomObject){
				with instance_create(x + lengthdir_x(10, other.direction), y + lengthdir_y(10, other.direction), PlasmaTrail){
					sprite_index = global.sprSmallSonicExplosion;
					image_blend = c_yellow
					image_index = 2
					image_speed = .7
					image_xscale = .75
					image_yscale = .75
				}
				tar_width  = 60
				tar_height = 60
				team   = 2
				ammo   = 15
				timer  = 30
				target = instance_nearest(x, y, Wall)
				on_step = volley_step
			}
			spawn = 1
		}
	}
	with BoltStick{
		if sprite_index = global.sprMarkerBolt && instance_exists(target){
			if current_frame_active && "stoppart" not in self{
				with instance_create(x + random_range(-3, 3), y + random_range(-3, 3), Wind){
					sprite_index = global.sprMarkerTrail;
					motion_add(random(360), choose(2, 2, 2, 3))
				}
			}
			if (instance_exists(target) && target.speed > .5){target.speed = .5}
			if "spawn" not in self{
				with instance_create(x + lengthdir_x(10, other.direction), y + lengthdir_y(10, other.direction), PlasmaTrail){
					sprite_index = global.sprSmallSonicExplosion;
					image_blend = c_yellow
					image_index = 2
					image_speed = .7
					image_xscale = .75
					image_yscale = .75
				}
				with instance_create(x,y,CustomObject){
					tar_width  = 60
					tar_height = 60
					team   = 2
					ammo   = 15
					timer  = 30
					owner  = other;
					target = instance_exists(other.target) ? other.target : instance_nearest(x, y, Wall)
					on_step = volley_step
				}
				spawn = 1
			}
		}
	}

#define volley_step
	if instance_exists(target){
		x = target.x
		y = target.y

	}
	timer -= current_time_scale
	if timer <= 0{
		if "owner" in self && instance_exists(owner){
			owner.stoppart = true
		}
		ammo--
		repeat(2) with instance_create(x+lengthdir_x(random(tar_width),random(360)),y+lengthdir_y(random(tar_height),random(360)),CustomProjectile){
			name = "volley arrow"
			depth = -10
			sprite_index = sprBolt
			mask_index   = mskNothing
			image_index  = 1
			image_speed  = 0
			direction    = random(360)
			image_angle = 270
			force = 0
			damage = 8
	        bounce = skill_get("compoundelbow") * 5
	        zfriction = 1.5
			team = other.team
			z = irandom_range(300,350)
    		maxzspd = 20
    		zspd = maxzspd;
			zstart = z
			on_step = rainarrow_step
			on_wall = rainarrow_wall
			on_draw = rainarrow_draw
		}
		timer = 1
	}
	else{
		sound_play_pitch(sndEnemySlash,1-timer/300)
		if current_frame mod 2 < current_time_scale sound_play_pitchvol(sndScrewdriver,1.4-timer/300,.2)
	}
	if ammo <= 0 instance_destroy()

#define rainarrow_wall
	var wall = other
	with instance_create(x,y-z-8,CustomObject){
	    image_angle = 0
	    sprite_index = global.sprBoltStickGround
	    image_index = random(1)
	    image_xscale = choose(-1,1)
	    image_speed = .4
	    depth = -10
	    on_step = stickstep
	    if fork(){
	        repeat(60){
	            wait(1)
	            if !instance_exists(wall) break
	        }
	        if instance_exists(self) instance_destroy()
	        exit
	    }
	}
	with instance_create(x,y,Dust) depth = -10
	sound_play_pitch(sndBoltHitWall,random_range(.8,1.2))
	sound_play_pitch(sndHitWall,random_range(.8,1.2))
	instance_destroy()


#define rainarrow_step
  if zspd < maxzspd{
    zspd += zfriction;
  }else{
    zspd = maxzspd;
  }

	var dn = z
	z -= current_time_scale*zspd
	if z <= 25 and z > -25{
	    mask_index = sprFlak;
	    depth = TopCont.depth+1
	    if skill_get(mut_bolt_marrow){
	        var q = mod_script_call_self("mod", "defpack tools", "instance_nearest_matching_ne", x, y, hitme, "team", team)
	        if instance_exists(q) && point_distance(x, y, q.x, q.y) < 30{
	            x = q.x
	            y = q.y
	        }
	    }
	}
	else mask_index = mskNone
	var n = max(z, 0);
	dn = abs(z - dn)
	with instance_create(x,y - n,BoltTrail){
	    image_angle = point_direction(x,y,other.xprevious,other.yprevious - n - dn)
	    image_xscale = point_distance(x,y,other.xprevious,other.yprevious - n - dn)
	    depth = other.depth + 1
	    if fork(){
	        while instance_exists(self){
	            image_alpha -= .15 * current_time_scale
	            wait(0)
	        }
	        exit
	    }
	}

	if z < 0{

        if zspd > 0{image_angle = 270}else{image_angle = 90}
      if bounce > 0{
          bounce--
          zspd *= choose(-.65, -.8, -.8, -.9)
          instance_create(x,y-z,Dust)
          view_shake_at(x,y,!irandom(2))
        }else{
        var yoff = -8, dep = -10
  	    if place_meeting(x, y, Floor){
  	        yoff = 0
  	        dep = -1
  	    }
  	    else{
  	        if (instance_exists(InvisiWall)){
  	            depth = 11
  	            if z < -400 instance_destroy()
  	            exit
  	        }
  	    }
  	    with instance_create(x,y + yoff,CustomObject){
  	        image_angle = 0
  	        sprite_index = global.sprBoltStickGround
  	        image_index = random(1)
  	        image_xscale = choose(-1,1)
  	        image_speed = .5
  	        depth = dep
  	        on_step = stickstep
  	        if fork(){
  	            repeat(60){
  	                wait(1)
  	            }
  	            if instance_exists(self) instance_destroy()
  	            exit
  	        }
  	    }
  		instance_create(x,y-z,Dust)
  		sound_play_pitch(sndBoltHitWall,random_range(.8,1.2))
  		sound_play_pitch(sndHitWall,random_range(.8,1.2))
  		view_shake_at(x,y,2)
  		instance_destroy()
  	}
}
#define rainarrow_draw
	draw_sprite_ext(shd16, 0, x, y, .3, 1, 0, c_white, (1-z/zstart)*.4)
	draw_sprite_ext(sprite_index,image_index,x,y-z,image_xscale,image_yscale,270,image_blend,image_index)

#define stickstep
	if image_index + image_speed * current_time_scale > image_number{
	    if !irandom(1){
	        image_speed = 0
	        image_index = 5
	    }
	    else{
	        image_index = 3.1
	        image_speed += .1
	    }
	}
