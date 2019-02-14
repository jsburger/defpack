#define init
global.sprMegaImpactFist = sprite_add_weapon("sprites/mega impact fist.png", 4, 8);
global.sprMegaRealFist = sprite_add("sprites/mega impact fist fist.png", 1, 0, 13);
global.sprMegaRealFistUpg = sprite_add("sprites/big mega impact fist fist.png", 1, 0, 13);

#define weapon_name
return "MEGA IMPACT FIST"

#define weapon_sprt
return global.sprMegaImpactFist;

#define weapon_type
return 0;

#define weapon_cost
return 0;

#define weapon_auto
return false;

#define weapon_load
return 50;

#define weapon_text
return "You will be missed"

#define weapon_melee
return 0;

#define weapon_swap
return sndSwapShotgun;

#define weapon_area
return 9;

#define weapon_fire()
with instance_create(x,y,CustomSlash) {
    sprite_index = skill_get(mut_long_arms) ? global.sprMegaRealFistUpg : global.sprMegaRealFist
    creator = other
    team = other.team
    direction = other.gunangle
    image_angle = direction
    damage = 34
    image_xscale = 1.5
    lifespan = 0
    on_end_step = fiststep
    on_hit = fisthit
    on_wall = fistwall
    on_anim = fistanim
    on_projectile = fistproj
    on_grenade = fistproj
}
var r = random_range(.8,1.2)
sound_play_pitchvol(sndShotgun,.7*r,1);
sound_play_pitchvol(sndAssassinAttack,.8*r,1);
weapon_post(-4,56,56);

#define fistproj
if lifespan < 14 with other if typ > 0 instance_destroy()

#define fistwall

#define fistanim

#define fisthit
if lifespan < 8 and (floor(current_frame) < current_frame + current_time_scale){
    projectile_hit(other, damage, direction, 40)
    //other.speed += 40
    sleep(100)
    view_shake_at(x,y,15)
    sound_play_pitchvol(sndImpWristKill,1.2,.8)
    sound_play_pitchvol(sndExplosion,1.5,.8)
    sound_play_pitchvol(sndImpWristHit,1,.8)
    sound_play_pitchvol(sndWallBreak,1.4,.8)

    repeat(other.size*3+3)*6 with instance_create(x+lengthdir_x(20,direction),y+lengthdir_y(20,direction),Smoke) {
		sprite_index = sprDust;
		speed += random_range(8,13);
		var d = random_range(-90,90)
		direction = other.direction+choose(d, d, 80, -80)-180;
	}

    if other.size < 4{
        var dir = direction
        with other{
            var s = 5, l = 80
            var _x = lengthdir_x(s, dir), _y = lengthdir_y(s, dir)
            var n = l
    	    while n > 0{
                n -= s
                repeat(s/2 * n/l) with instance_create(x,y,Dust){
                    motion_set(dir - 180 + random_range(-65, 65), random_range(3, 9))
                }
                x += _x
                y += _y
                xprevious = x
                yprevious = y
                if place_meeting(x,y,Wall){
                    instance_create(x, y, size > 0 ? Explosion : SmallExplosion)
                    sound_play(sndExplosion)
                    break
    	        }
    	    }
	    }
	}
}
#define fiststep
if instance_exists(creator){
    var c = creator
    image_yscale = c.right
    if lifespan >= 14{
        with c weapon_post(other.lifespan/3, 4 * current_time_scale, 4 * current_time_scale)
        sound_play_pitchvol(sndCrossReload, c.wkick/12, .7)
        image_xscale -= .1*current_time_scale
    }
    else{
        if lifespan <= 2 and lifespan > 1 image_xscale = .6
        else if lifespan <= 3 image_xscale = 1
    }
    x = c.x + lengthdir_x(14 - c.wkick - current_time_scale, c.gunangle)
    y = c.y + lengthdir_y(14 - c.wkick - current_time_scale, c.gunangle)
    if c.back depth = -3
    else depth = -2
    direction = c.gunangle
    image_angle = direction
}
lifespan += current_time_scale
if lifespan > 20 instance_destroy()

/*#define weapon_fire2
with instance_create(x,y,CustomObject) {
	if skill_get(mut_long_arms) = true sprite_index = global.sprMegaRealFistUpg else sprite_index = global.sprMegaRealFist;
	creator = other;
	team = other.team;
	direction = other.gunangle;
	image_angle = direction;
	damage = 96;
	on_step = fuckohshitimdying;
	lifespan = 0;
	image_xscale=1.5;
}
var r = random_range(.8,1.2)
sound_play_pitchvol(sndShotgun,.7*r,1);
sound_play_pitchvol(sndAssassinAttack,.8*r,1);
weapon_post(0,56,56);

#define fuckohshitimdying
if instance_exists(creator) image_yscale = creator.right;
if(lifespan < 16) with(hitme) if(instance_exists(self)) if(place_meeting(x,y,other) && team != other.team){
     // Hurt Frames:
    sprite_index = spr_hurt;
    image_index = 0;
     // Sound:
    sound_play(snd_hurt);
     // Damage:
    my_health -= other.damage;
	direction = other.direction;
	speed+=40;
	//friction = 0;
	 sleep(100)
	 view_shake_at(x,y,15)
	 sound_play_pitchvol(sndImpWristKill,1.2,.8)
	 sound_play_pitchvol(sndExplosion,1.5,.8)
	 sound_play_pitchvol(sndImpWristHit,1,.8)
	 sound_play_pitchvol(sndWallBreak,1.4,.8)
	repeat (size*3+3)*3 with instance_create(x+lengthdir_x(20,direction),y+lengthdir_y(20,direction),Smoke) {
		sprite_index = sprDust;
		speed+=random_range(8,13);
		direction = other.direction+random_range(-90,90)-180;
	}
	repeat (size*3+3)*3 with instance_create(x+lengthdir_x(20,direction),y+lengthdir_y(20,direction),Smoke) {
		sprite_index = sprDust;
		speed+=random_range(8,13);
		if(random(2)>1) {
			direction = other.direction+90;
		} else {
			direction = other.direction-90;
		}
	}
	if(size < 4) {
		if(collision_line(x, y, x+lengthdir_x(40,other.direction), y+lengthdir_y(40,other.direction), Wall, 0, 1))
		{
			sleep(size * 12)
			view_shake_at(x,y,size * 5)
			if(size > 0) with instance_create(x+lengthdir_x(40,other.direction),y+lengthdir_y(40,other.direction),SmallExplosion) team = 2;
			sleep(100)
	 	 view_shake_at(x,y,15)
	 	 sound_play_pitchvol(sndImpWristKill,1.2,.8)
	 	 sound_play_pitchvol(sndExplosion,1.5,.8)
	 	 sound_play_pitchvol(sndImpWristHit,1,.8)
	 	 sound_play_pitchvol(sndWallBreak,1.4,.8)
		}
		else
		 {
		 sleep(size * 8)
		 view_shake_at(x,y,size * 3)
			if(collision_line(x,y,x+lengthdir_x(80,other.direction), y+lengthdir_y(80,other.direction), Wall, 0, 1)) {
				if(size > 0) with instance_create(x+lengthdir_x(80,other.direction),y+lengthdir_y(80,other.direction),SmallExplosion) team = 2;
				sleep(100)
		 	 view_shake_at(x,y,15)
		 	 sound_play_pitchvol(sndImpWristKill,1.2,.8)
		 	 sound_play_pitchvol(sndExplosion,1.5,.8)
		 	 sound_play_pitchvol(sndImpWristHit,1,.8)
		 	 sound_play_pitchvol(sndWallBreak,1.4,.8)
			}
			x+=lengthdir_x(40,other.direction);
			y+=lengthdir_y(40,other.direction);
		}
	}
}
lifespan++;
if(instance_exists(creator)) {
	if(lifespan < 14) {
		x = creator.x+lengthdir_x(14-creator.wkick,creator.gunangle)+creator.hspeed;
		y = creator.y+lengthdir_y(14-creator.wkick,creator.gunangle)+creator.vspeed;
		image_xscale=1;
	} else {
	with(creator) weapon_post(other.lifespan/3,4,4);
		x = creator.x+lengthdir_x(14-image_xscale/(lifespan/14)-creator.wkick,creator.gunangle)+creator.hspeed;
		y = creator.y+lengthdir_y(14-image_xscale/(lifespan/14)-creator.wkick,creator.gunangle)+creator.vspeed;
		sound_play_pitchvol(sndCrossReload, creator.wkick/12,.7);
		image_xscale-=0.1;
	}
	if(lifespan==1) {
		image_xscale=0.6;
	}
	if(creator.gunangle > 180 && creator.gunangle < 360) {
		depth = -3;
	} else {
		depth = 0;
	}
	direction = creator.gunangle;
	image_angle = direction;
}
if(lifespan < 16) with(projectile) if(place_meeting(x,y,other) && team != other.team) instance_destroy();
if(lifespan > 20) instance_destroy();
*/
