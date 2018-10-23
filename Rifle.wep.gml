#define init
global.gun = sprite_add_weapon("sprites/sprRifle.png",8,4)

#define weapon_name
return "XM-15"
#define weapon_type
return 1
#define weapon_cost
return 1
#define weapon_area
return 24
#define weapon_load
return 2
#define weapon_swap
return sndSwapMachinegun
#define weapon_auto
return 1
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire

weapon_post(3,-10,4)
sound_play_pitch(sndHeavyRevoler,1.2)
with instance_create(x+lengthdir_x(8,gunangle),y+lengthdir_y(8,gunangle),CustomProjectile){
    creator = other
    team = other.team
    direction = other.gunangle + random_range(-4,4)*(max(sqrt(other.speed),1))*other.accuracy
    image_angle = direction
    mask_index = mskBullet1
    force = 0
    damage = 5
    dir = 500
    hyperspeed = 6
    
    on_end_step = bullet_step
    on_destroy = bullet_destroy
}

#define bullet_step

var particles = mod_exists("mod","defparticles")

var _x = lengthdir_x(100,direction), _y = lengthdir_y(100,direction)
while !collision_line(x, y, x + _x, y + _y, hitme, 0, 0) and !collision_line(x, y, x + _x, y + _y, Wall, 0, 0) and dir > 0{
    dir -= 100/hyperspeed
    x += _x
    y += _y
    if dir < 480 repeat(100/hyperspeed){
        if particles && !irandom(50){
            //make_trail(100)
        }
    }
}


var _x = lengthdir_x(hyperspeed, direction), _y = lengthdir_y(hyperspeed, direction)
while !place_meeting(x,y,Wall) and dir > 0{
    x += _x
    y += _y
    dir -= hyperspeed
     if dir < 480 && particles && !irandom(30){
        //make_trail(hyperspeed)
    }
    if place_meeting(x,y,hitme){
        with instances_matching_ne(hitme,"team",team) if place_meeting(x,y,other){
            with other{
                projectile_hit(other,damage,force,direction)
                instance_destroy()
                exit
            }
        }
    }
}

#define make_trail(range)
var num = random_range(20,40)
var _x = lengthdir_x(range,direction), _y = lengthdir_y(range,direction)
with instance_create(x-random(_x),y-random(_y),Dust){
    motion_set(other.image_angle + 180+ num*choose(-1,1),3+random(1))
    x+=hspeed
    y+=vspeed
}

#define bullet_destroy
var num = 20
var pivot = 12
var length = 6
var dist = min(point_distance(x,y,xstart,ystart),400)
var tolerance = 150
var _x = lengthdir_x(dist/num,direction), _y = lengthdir_y(dist/num,direction)
for (var i = 1; i <= num; i++){
    if i > length or dist < tolerance
    with instance_create(x - _x * i, y - _y * i, BoltTrail){
        image_xscale = dist/num
        image_angle = other.direction
        if dist > tolerance{
            image_yscale = 1 - (abs(pivot - i)/(pivot - length))
            motion_set(image_angle,dist/10)
        }
        else image_yscale = 1- i/num
        if i < num - 2 && !irandom(7) make_trail(dist/num)
    }
}
with instance_create(x+lengthdir_x(hyperspeed,direction),y+lengthdir_y(hyperspeed,direction),MeleeHitWall){
    image_angle = other.direction
    image_speed *= 2
    image_index++
}
if mod_exists("mod","defparticles") repeat(random(2)+2) with mod_script_call("mod","defparticles","create_spark",x,y){
    motion_set(random(360),random(3)+1)
    gravity = 0
    age /= 2
    depth = -5
    color = merge_color(c_yellow,c_white,.5)
    fadecolor = c_white
}


#define weapon_sprt
return global.gun
#define weapon_text
return "War. War never changes."