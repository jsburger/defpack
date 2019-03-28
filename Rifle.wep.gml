#define init
global.gun = sprite_add_weapon("sprites/sprRifle.png",9,4)
global.gun2 = sprite_add("sprites/sprRifleAnim.png",7,9,3)
global.clip = sprite_add("sprites/sprRifleClip.png",1,3,3)

global.animarray = []
wait(3)
for var i = 0; i < 7; i++{
    array_push(global.animarray, sprite_duplicate_ext(global.gun2, i, 1))
}

wait(60)
global.animarray = []
for var i = 0; i < 7; i++{
    array_push(global.animarray, sprite_duplicate_ext(global.gun2, i, 1))
}


#define weapon_name
return "RIFLE"
#define weapon_type
return 1
#define weapon_cost
return 3
#define weapon_area
return 12
#define weapon_load
return 8
#define weapon_swap
return sndSwapMachinegun
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_sprt_hud
return global.gun
#define weapon_sprt(w)
if instance_is(self,Player) && is_object(w){
    if is_object(w){
        var q = lq_defget(w, "anim_index", 0)
        if q > 0 return global.animarray[floor(q)]
    }
}
return global.gun
#define weapon_text
return "Chrome lined, 4150 steel barrel"
#define weapon_reloaded(p)
var w = p ? wep : bwep
if !is_object(w) exit
if w.ammo <= 0 and ammo[1] > 0{
    clicked = 0
    w.anim_index = 0
    w.image_speed = .4
    if p{
        reload += 25
    }
    else{
        breload += 25
    }
    w.ammo = min(45, ammo[1])
    with instance_create(x,y,PopupText){
        target = other.index
        text = "RELOADING"
        time /= 2
    }
    sound_play(sndEmpty)
    with instance_create(x,y,Shell){
        sprite_index = global.clip
        motion_add(other.gunangle - random_range(60,90)*other.right, 4 + random(2))
    }
}



#define weapon_fire(w)
if !is_object(w){
    w = {
        wep : mod_current,
        ammo : 45,
        anim_index : 0,
        image_speed : 0
    }
    wep = w
}

var i = 1
repeat(3){
    if infammo == 0 w.ammo--
    var _r = random_range(.9,1.1)
    sound_play_pitch(sndHeavyRevoler,1*_r)
    sound_play_pitch(sndExplosionS,1.6*_r)
    weapon_post(3,-10,4)
    with instance_create(x, y, Shell){
        motion_set(90 + other.right * (30 + random_range(-10, 30)), random_range(2,4))
        if !irandom(1){
            with instance_create(x, y, Smoke){
                motion_set(other.direction, other.speed/2)
                image_xscale /= 2
                image_yscale /= 2
                gravity = -.1
            }
        }
        ystart += 5 + random(3)
        gravity = .5
        depth = -2
        friction = .1
        image_angle = direction -90
        yspeed = lengthdir_y(-1, other.gunangle + random_range(-20, 20))
        bounces = 1 + irandom(3)
        if fork(){
            while instance_exists(self) && bounces > 0{
                y += yspeed*current_time_scale
                ystart += yspeed*current_time_scale
                image_angle += 10*current_time_scale*-(hspeed)
                if y > ystart{
                    vspeed*= -1
                    hspeed*= random_range(.25,1.25) * choose(-1,1)
                    if --bounces = 0{
                      gravity = 0
                      speed = 0
                    }
               }
               wait(0)
           }
           exit
        }
        
    }
    with instance_create(x + lengthdir_x(12, gunangle), y + lengthdir_y(12, gunangle) - 4*(race == "steroids" and specfiring), CustomProjectile){
        creator = other
        team = other.team
        direction = other.gunangle + random_range(-2*i,2*i)*(max(sqrt(2*other.speed),1))*other.accuracy
        image_angle = direction
        mask_index = mskBullet1
        force = 0
        damage = 5
        dir = 500
        dist = 0

        hyperspeed = 6
        
        with instance_create(x + lengthdir_x(6, other.gunangle),y + lengthdir_y(6, other.gunangle),BulletHit){
            image_angle = other.direction - 120
            image_speed *= 4
            image_blend = merge_color(c_white,c_yellow,.1 + random(.2))
            motion_set(other.direction,4)
            with instance_create(x, y, MeleeHitWall){
                sprite_index = sprImpactWrists
                image_angle = other.direction + 90
                image_xscale = .7
                image_yscale = .15
                image_speed = 1
                image_index = 2
            };
        }
        
        on_end_step = bullet_step
        on_destroy = bullet_destroy
    }
    wait(++i)
}

#define bullet_step
var _x = lengthdir_x(100,direction), _y = lengthdir_y(100,direction)
while !collision_line(x, y, x + _x, y + _y, hitme, 0, 0) and !collision_line(x, y, x + _x, y + _y, Wall, 0, 0) and dir > 0{
    dir -= 100/hyperspeed
    x += _x
    y += _y
    dist += 100
}
var enemies = instances_matching_ne(hitme,"team",team)
var _x = lengthdir_x(hyperspeed, direction), _y = lengthdir_y(hyperspeed, direction)
while !place_meeting(x,y,Wall) and dir > 0{
    dist += hyperspeed
    x += _x
    y += _y
    dir -= hyperspeed
    if place_meeting(x,y,hitme){
        with enemies if place_meeting(x,y,other){
            with other{
                sound_play_gun(sndClick, .1, .5)
                for var i = 45; i < 360; i+= 90{
                    with instance_create(x+lengthdir_x(4, i), y+lengthdir_y(4, i), BoltTrail){
                        image_angle = i
                        image_xscale = 6
                        depth = -4
                    }
                }
                projectile_hit(other,damage,force,direction)
                instance_destroy()
                exit
            }
        }
    }
}
with instance_create(x+lengthdir_x(hyperspeed,direction),y+lengthdir_y(hyperspeed,direction),MeleeHitWall){
    image_angle = other.direction
    image_speed *= 2
    image_index++
}
if mod_exists("mod","defparticles") repeat(random(2)+2) with mod_script_call("mod","defparticles","create_spark",x,y){
    motion_set(other.direction + 180 + random_range(-80,80),random(3)+2)
    gravity = .2
    gravity_direction = other.direction
    age = 4+speed/2
    depth = -5
    color = merge_color(c_yellow,c_white,.5)
    fadecolor = c_white
}
instance_destroy()


#define make_trail(range,direction)
var num = random_range(20,40)
var _x = lengthdir_x(range,direction), _y = lengthdir_y(range,direction)
with instance_create(x-random(_x),y-random(_y),Dust){
    motion_set(direction + num*choose(-1,1),3+random(1))
    x+=hspeed
    y+=vspeed
}

#define bullet_destroy
var num = 25
var length = irandom_range(4,6)
var width = random_range(.7, 1.2)
var pivot = num - length - irandom((num - 2*length)/1.5)
//var dist = point_distance(x,y,xstart,ystart)
var tolerance = 150
var _x = lengthdir_x(dist/num,direction), _y = lengthdir_y(dist/num,direction)

var xscale = dist/num, spd = (dist*((pivot)/num) / width * .2)

for (var i = 1; i <= num; i++){
    var yscale = 1 - (min(abs(pivot - i), length)/(length))
    if yscale > 0{
        with instance_create(x - _x * i, y - _y * i, BoltTrail){
            image_xscale = xscale
            image_angle = other.direction
            image_yscale = yscale * width
            motion_set(image_angle,spd)
            if i < num - 2 && !irandom(7) make_trail(image_xscale, image_angle + 180)
        }
    }
}

#define step(w)
if w script_bind_draw(scr_gui, -16, 3, 48, is_object(wep) ? wep.ammo : 45, index)
else if race = "steroids" script_bind_draw(scr_gui, -16, 40, 48, is_object(bwep) ? bwep.ammo : 45, index)

if w goodstep(wep, 1)
else if race == "steroids" goodstep(bwep, -1)

#define goodstep(w, f)
if is_object(w) and lq_defget(w, "image_speed", 0) > 0{
    w.anim_index += w.image_speed * current_time_scale
    if w.anim_index + w.image_speed * current_time_scale >= sprite_get_number(global.gun2){
        if f wkick = -2
        else bwkick = -2
        sound_play_pitchvol(sndSwapShotgun, 2*random_range(.9,1.2), .8)
        w.image_speed = 0
        w.anim_index = 0
    }
}


#define scr_gui(x, y, ammo, index)
var m = 15, w = 2, h = 2, hup = .15
var bheight = floor(45/m) * h + hup*m
var bwidth = w * m
draw_set_visible_all(0)
draw_set_visible(index, 1)
draw_set_projection(0)
draw_line_width_color(x, y+bheight/2 - hup*m, x + bwidth, y + bheight/2,bheight,c_dkgray,c_dkgray)

draw_line_width_color(x, y+bheight - hup*m, x + bwidth, y + bheight, 1, c_black, c_black)
draw_line_width_color(x + bwidth, y, x + bwidth , y + bheight, 1, c_black, c_black)

for var i = 0; i < ammo; i++{
    draw_sprite(sprBulletShell, 0, x + (i mod m)*w + 1, y + h*floor(i/m) + (i mod m)*hup)
}

instance_destroy()
draw_reset_projection()
draw_set_visible_all(1)

