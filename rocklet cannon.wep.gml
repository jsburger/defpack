#define init
global.sprRockletCannon = sprite_add_weapon("sprites/weapons/sprRockletCannon.png", 5, 3);
global.sprPuncherRocket = sprite_add("sprites/projectiles/sprBigRocklet.png",0,4,3)

#define weapon_name
return "ROCKLET CANNON";

#define weapon_sprt
return global.sprRockletCannon;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 32;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 11;

#define nts_weapon_examine
return{
    "d": "A gun that fires rockets that fires rockets. ",
}

#define weapon_text
return "WHIRLWIND";

#define weapon_fire
weapon_post(7,-3,20)
sound_play_pitch(sndSlugger,.6)
sound_play_pitch(sndRocketFly,random_range(2,2.6))
sound_play_pitch(sndGrenadeRifle,random_range(.2,.3))
sound_play_pitch(sndComputerBreak,random_range(.6,.7))
sound_play_pitch(sndHeavyNader,random_range(.7,.8))
sound_play_pitch(sndSeekerShotgun,random_range(.7,.8))
with instance_create(x,y,CustomProjectile)
{
    creator = other
    name = "big rocklet"
    team = other.team
    damage = 3
    sprite_index = global.sprPuncherRocket
    motion_add(other.gunangle+random_range(-5,5)*other.accuracy,2)
    anginc = 0
    timer = 0
    friction = -.8
    depth = -1
    maxspeed = 16
    image_angle = direction
    ImmuneToDistortion = true;
    ammo = 20 + (4* (GameCont.crown == crwn_death))
    on_draw    = cannon_draw
    on_step    = cannon_step
    on_destroy = cannon_destroy
}

#define cannon_step
timer += current_time_scale
if timer >= 2 && ammo > 0{
    timer-=2
    anginc+= pi/3
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
