#define init
global.gun = sprite_add_weapon("sprites/sprRifle.png",8,4)
global.gun2 = sprite_add("sprites/sprRifleAnim.png",7,8,4)
global.clip = sprite_add("sprites/sprRifleClip.png",1,3,3)

#define weapon_name
return "XM-15"
#define weapon_type
return 1
#define weapon_cost
return 3
#define weapon_area
return 24
#define weapon_load
return 10
#define weapon_swap
return sndSwapMachinegun
#define weapon_auto
return 1
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_sprt_hud
return global.gun
#define weapon_sprt(w)
if instance_is(self,Player) && is_object(w){
    if wep = w and reload > weapon_load(){
        gunshine = min((1 - ((reload - weapon_load)/(30 - weapon_load))) * 10,7)
        if gunshine >= 7{
            gunshine = 0
            return global.gun
        }
        return global.gun2
    }
}
return global.gun
#define weapon_text
return "Chrome lined rifled barrel"
#define weapon_fire
if !is_object(wep){
    wep = {
        wep : mod_current,
        ammo : 16,
    }
}

if --wep.ammo = 0 {
    reload += 15
    wep.ammo = 16
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
repeat(3){
    sound_play_pitch(sndShotgun,1.5)
    sound_play_pitch(sndSlugger,1.5)
    weapon_post(3,-10,4)
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
        
        with instance_create(x+lengthdir_x(hyperspeed,direction),y+lengthdir_y(hyperspeed,direction),MeleeHitWall){
            image_angle = other.direction + 180
            image_speed *= 4
            image_blend = merge_color(c_white,c_yellow,.3)
        }
        
        on_end_step = bullet_step
        on_destroy = bullet_destroy
    }
    wait(2)
}

#define bullet_step

var _x = lengthdir_x(100,direction), _y = lengthdir_y(100,direction)
while !collision_line(x, y, x + _x, y + _y, hitme, 0, 0) and !collision_line(x, y, x + _x, y + _y, Wall, 0, 0) and dir > 0{
    dir -= 100/hyperspeed
    x += _x
    y += _y
}


var _x = lengthdir_x(hyperspeed, direction), _y = lengthdir_y(hyperspeed, direction)
while !place_meeting(x,y,Wall) and dir > 0{
    x += _x
    y += _y
    dir -= hyperspeed
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
sound_play_hit(sndShotgunHitWall,.1)
if mod_exists("mod","defparticles") repeat(random(2)+2) with mod_script_call("mod","defparticles","create_spark",x,y){
    motion_set(random(360),random(3)+1)
    gravity = 0
    age /= 2
    depth = -5
    color = merge_color(c_yellow,c_white,.5)
    fadecolor = c_white
}
