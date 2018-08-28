#define init
//global.gun
global.sprDrillLauncher = sprite_add_weapon("sprites/sprDrillLauncher.png",6,4)
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
return global.sprDrillLauncher
#define weapon_text
//how could you not
return "PIERCE THE HEAVENS"
#define weapon_fire
weapon_post(5,-12,5)
var _fac = random_range(.8,1.2);
sound_play_pitch(sndSwapMotorized,1.3*_fac)
sound_play_pitch(sndCrossbow,.7*_fac)
sound_play_pitch(sndDiscBounce,1.5*_fac)
sound_play_drill(.6)
with instance_create(x,y,CustomProjectile){
    motion_set(other.gunangle+random_range(-3,3)*other.accuracy,1)
    friction = -1.5
    image_speed = .4
    maxspeed = 16
    damage = 3 - global.explosive
    sprite_index = global.sprDrill
    lasthit = -4
    hits = 0
    walls = 4
    image_angle = direction
    projectile_init(other.team,other)
    repeat(4) instance_create(x,y,Smoke)
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
if speed > maxspeed speed = maxspeed

#define drill_wall
if walls > 0
{
  sound_play_drill(.4)
   with other{instance_create(x,y,FloorExplo);instance_destroy()}
   walls--
   speed = 4
   sleep(15)
   view_shake_at(x,y,5)
}
else
{
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
}

#define drill_hit

sleep(12)
//speed = max(speed - 3, 3)
x = xprevious
y = yprevious
speed = 2
other.speed = 0
sleep(12)
view_shake_at(x,y,4)
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
    team = other.team
    sound_play_pitchvol(sndExplosionS,2,.3)
    hitid = [sprite_index,"MINI EXPLOSION"]
}
drill_hit()

#define sound_play_drill(_vol)
if fork(){
    repeat(10){
        sound_play_pitchvol(sndJackHammer,.8,_vol)
        sound_play_pitchvol(sndCrossbow,2,_vol)
        sound_play_pitchvol(sndDiscHit,1.6,_vol)
        wait(0)
    }
    exit
}
