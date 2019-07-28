#define init
global.sprMegaImpactFist  = sprite_add_weapon("sprites/weapons/sprImpactFist.png", 4, 8);
global.sprMegaRealFist    = sprite_add("sprites/projectiles/sprImpactFistProj.png", 4, 0, 13);
global.sprMegaRealFistUpg = sprite_add("sprites/projectiles/sprImpactFistProjUpg.png", 4, 0, 13);

#define weapon_name
return "IMPACT FIST"

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
var f = other.race == "steroids" and other.specfiring
with instance_create(x,y - 4 * f,CustomSlash) {
    sprite_index = skill_get(mut_long_arms) ? global.sprMegaRealFistUpg : global.sprMegaRealFist
    creator = other
    team = other.team
    direction = other.gunangle
    image_angle = direction
    damage = 34
    hand = f
    image_xscale = 1.5
    image_speed = 0
    if GameCont.crown = crwn_death image_index = 1
    if GameCont.crown = crwn_destiny image_index = 2
    if skill_get(mut_last_wish) image_index = 3
    lifespan = 0
    on_end_step = fiststep
    on_hit = fisthit
    on_wall = fistwall
    on_anim = fistanim
    on_projectile = fistproj
    on_grenade = fistproj
}
var r = random_range(.9,1.2)
sound_play_pitchvol(sndShotgun,.7*r,1);
sound_play_pitchvol(sndAssassinAttack,.8*r,1);
weapon_post(-4,56,56);

#define fistproj
if lifespan < 10 with other if typ > 0 instance_destroy()

#define fistwall

#define fistanim

#define fisthit
if lifespan <= 4 and (floor(current_frame) < current_frame + current_time_scale) and (projectile_canhit_melee(other) or other.size < 4){
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
                xprevious = x
                yprevious = y
                x += _x
                y += _y
                if place_meeting(x, y, Wall){
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
    image_yscale = c.right * sign(!hand - .1)
    var k = hand ? c.bwkick : c.wkick
    if lifespan >= 10{
        with c{
            weapon_post(0, 4 * current_time_scale, 4 * current_time_scale)
            if other.hand bwkick = other.lifespan/3
            else wkick = other.lifespan/3
        }
        sound_play_pitchvol(sndCrossReload, (k + 2)/12, .7)
        image_xscale += approach(image_xscale, 0, 3.5, current_time_scale)
    }
    else{
        if lifespan <= 3 and lifespan > 1 image_xscale += approach(image_xscale, .6, 1.5, current_time_scale)
        else if lifespan > 3 image_xscale += approach(image_xscale, 1, 1.5, current_time_scale)
    }
    var k = hand ? c.bwkick : c.wkick
    x = c.x + lengthdir_x(14 - k - current_time_scale, c.gunangle)
    y = c.y + lengthdir_y(14 - k - current_time_scale, c.gunangle) - 4 * hand
    if c.back or hand depth = -2
    else depth = -3
    direction = c.gunangle
    image_angle = direction
}
lifespan += current_time_scale
if lifespan > 16 instance_destroy()

#define approach(a, b, n, dn)
return (b - a) * (1 - power((n - 1)/n, dn))
