#define init
global.sprSuperRockletCannon = sprite_add_weapon("sprites/weapons/sprSuperRockletCannon.png", 6, 6);
global.sprPuncherRocket      = sprite_add("sprites/projectiles/sprBigRocklet.png",0,4,3)
global.sprSuperRocklet       = sprite_add("sprites/projectiles/sprSuperRocklet.png",0,0,6)

#define weapon_name
return "SUPER ROCKLET CANNON";

#define weapon_sprt
return global.sprSuperRockletCannon;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 150;

#define weapon_cost
return 20;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 16;

#define nts_weapon_examine
return{
    "d": "A gun that fires rockets that fires rockets that fires rockets. ",
}

#define weapon_text
return "THE SWARM";

#define weapon_fire
weapon_post(10,-7,54)
motion_add(gunangle-180,5)
sound_play_pitch(sndSlugger,.6)
sound_play_pitch(sndNukeFire,random_range(1.3,1.5))
sound_play_pitch(sndRocketFly,random_range(1.8,2.2))
sound_play_pitch(sndGrenadeRifle,random_range(.2,.3))
sound_play_pitch(sndHeavyNader,random_range(.7,.8))
sound_play_pitch(sndHeavyMachinegun,random_range(.6,.7))
sound_play_pitch(sndSeekerShotgun,random_range(.5,.6))
with instance_create(x,y,CustomProjectile)
{
    creator = other
    team = other.team
    name = "huge rocklet"
    damage = 12
    sprite_index = global.sprSuperRocklet
    motion_add(other.gunangle+random_range(-5,5)*other.accuracy,2)
    friction = -.6
    maxspeed = 24
    timer = 0
    flip = 1
    anginc = 0
    image_angle = direction
    ammo = 6
    on_draw    = cannon_draw
    on_step    = scannon_step
    on_destroy = scannon_destroy
}

#define scannon_step
timer += current_time_scale
anginc = 0
if timer >= 4 && ammo repeat(2){
    timer = 0
    ammo--
    flip *= -1
    anginc+= pi/3
    var n = 90*sin(anginc);
    with create_big_rocklet(x,y){
        creator = other.creator
        motion_set(other.direction-n*other.flip,12)
        direction_goal = other.direction+n*other.flip
        image_angle = direction
        timer = 2
    }
    n *= -1
}
anginc = 0


if speed > maxspeed{speed = maxspeed}

#define scannon_destroy
var i = random(360);
instance_create(x,y,Explosion)
if fork(){
    sound_play(sndExplosionL)
    repeat(ammo){
        var _x = x+lengthdir_x(48,i)
        var _y = y+lengthdir_y(48,i)
        var o = random(360)
        instance_create(_x,_y,Explosion)
        repeat(20){
            instance_create(_x+lengthdir_x(16,o),_y+lengthdir_y(16,0),SmallExplosion)
            o+=360/20
        }
        i += 360/ammo
    }
}

#define create_big_rocklet(_x,_y)
with instance_create(x,y,CustomProjectile){
    creator = other
    name = "big rocklet"
    team = other.team
    damage = 3
    sprite_index = global.sprPuncherRocket
    anginc = 0
    direction_goal = 0
    sub_creator = noone
    timer = 0
    friction = -.8
    depth = -1
    maxspeed = 16
    image_angle = direction
    ammo = 20 + (4* (GameCont.crown == crwn_death))
    on_draw    = cannon_draw
    on_step    = cannon_step
    on_destroy = cannon_destroy
    return id
}

#define cannon_step
direction -= mod_script_call_nc("mod", "defpack tools", "angle_approach", direction, direction_goal, 10, current_time_scale)
timer += current_time_scale
if timer >= 2 && ammo > 0{
    timer -= 2
    anginc += pi/3
    ammo -= 2
    var n = 90*sin(anginc);
    sound_play_pitch(sndSlugger,2)
    sound_play_pitch(sndRocketFly,random_range(2.6,3.2))
    sound_play_pitch(sndGrenadeRifle,random_range(.3,.4))
    sound_play_pitch(sndMachinegun,random_range(.7,.8))
    repeat(2){
        with mod_script_call("mod","defpack tools", "create_rocklet",x,y){
            creator = other.creator
            team = other.team
            motion_add(other.direction + n,2)
            move_contact_solid(direction,10)
            direction_goal = other.direction - n
            image_angle = direction
        }
        n *= -1
    }
}
image_angle = direction
if speed > maxspeed{speed = maxspeed}

#define cannon_destroy
var i = random(360);
instance_create(x,y,Explosion)
repeat(ammo){
    sound_play(sndExplosionS)
    instance_create(x+lengthdir_x(16,i),y+lengthdir_y(16,i),SmallExplosion)
    i += 360/ammo
}



#define cannon_draw
draw_self()
draw_sprite_ext(sprRocketFlame,-1,x,y,1,1,image_angle,c_white,image_alpha)
