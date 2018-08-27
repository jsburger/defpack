#define init
//global.gun
global.sprDrill = sprite_add("sprites/projectiles/sprDrill.png",4,6,4)
global.explosive = 1 //boolean, try turning it off 
#define weapon_name
return "DRILL LAUNCHER"
#define weapon_type
return global.explosive ? 4 : 3
#define weapon_cost
return 2
#define weapon_area
return 8
#define weapon_load
return 30
#define weapon_swap
return sndSwapMotorized
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_sprt
return sprBazooka
#define weapon_text
//how could you not
return "PIERCE THE HEAVENS"
#define weapon_fire
weapon_post(5,-12,5)
sound_play_pitch(sndRocket,1.8)
if fork(){
    repeat(10){
        sound_play_pitchvol(sndCrossbow,3,.6)
        wait(0)
    }
    exit
}
with instance_create(x,y,CustomProjectile){
    motion_set(other.gunangle,16)
    //friction = -.5
    image_speed = .4
    damage = 3 - global.explosive
    sprite_index = global.sprDrill
    lasthit = -4
    hits = 0
    image_angle = direction
    projectile_init(other.team,other)
    on_hit = global.explosive ? drill_explo : drill_hit
    on_step = drill_step
    on_wall = drill_wall
    on_draw = drill_draw
}

#define drill_draw
draw_self()
draw_set_blend_mode(bm_add)
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale*1.5,image_yscale*1.5,image_angle,image_blend,0.1)
draw_set_blend_mode(bm_normal)

#define drill_step
if random(100) < 50*current_time_scale instance_create(x,y,Smoke)

#define drill_wall
with instance_create(x+hspeed,y+vspeed,CustomObject){
    sprite_index = other.sprite_index
    image_speed = 0
    sound_play(sndBoltHitWall)
    image_angle = other.image_angle
    on_draw = drill_draw
    if fork(){
        wait(20)
        if instance_exists(self) instance_destroy()
        exit
    }
}
instance_destroy()

#define drill_hit
sleep(12)
//speed = max(speed - 3, 3)
x = xprevious
y = yprevious
projectile_hit(other,damage)
var mans = other;
if other = lasthit{
    if ++hits > 10{
        with instance_create(x,y,BoltStick){
            sprite_index = other.sprite_index
            target = mans
            image_angle = other.image_angle
        }
        instance_destroy()
        exit
    }
}
else{
    lasthit = other
    hits = 0
}

#define drill_explo
with instance_create(x+random_range(-6,6),y+random_range(-6,6),SmallExplosion){
    image_xscale = .5
    image_yscale = .5
    damage = 1
    sound_play_pitch(sndExplosionS,2)
    hitid = [sprite_index,"MINI EXPLOSION"]
}
drill_hit()