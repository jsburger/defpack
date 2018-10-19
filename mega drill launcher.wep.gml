#define init
//global.gun
global.sprMegaDrillLauncher = sprite_add_weapon("sprites/sprBigDrillLauncher.png",15,10)
global.sprMegaDrill = sprite_add("sprites/projectiles/sprBigDrill.png",4,15,10)
global.explosive = 0 //boolean, try turning it off
#define weapon_name
return "MEGA DRILL LAUNCHER"
#define weapon_type
return 3//global.explosive ? 4 : 3
#define weapon_cost
return 8
#define weapon_area
return -1
#define weapon_load
return 75
#define weapon_swap
return sndSwapMotorized
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 1
#define weapon_sprt
return global.sprMegaDrillLauncher
#define weapon_text
//how could you not
return "HOLLOW THE EARTH"
#define weapon_fire
weapon_post(21,-260,80)
extraspeed = 8+gunangle/10000
var _fac = random_range(.8,1.2);
sound_play_pitch(sndSwapMotorized,.7*_fac)
sound_play_pitch(sndHeavyCrossbow,.7*_fac)
sound_play_pitch(sndHeavySlugger,.7*_fac)
sound_play_pitch(sndGrenade,.3*_fac)
sound_play_pitch(sndDiscBounce,1.5*_fac)
sound_play_drill(.6)
motion_set(gunangle-180,maxspeed * 2)
sleep(55)
with instance_create(x,y,CustomProjectile){
    motion_set(other.gunangle+random_range(-3,3)*other.accuracy,1)
    friction = -.6
    image_speed = .4
    maxspeed = 12
    damage = 6 - 2*global.explosive
    sprite_index = global.sprMegaDrill
    lasthit = -4
    hits = 0
    walls = 8
    image_angle = direction
    projectile_init(other.team,other)
    repeat(12) instance_create(x,y,Smoke)
    on_hit = global.explosive ? drill_explo : drill_hit
    on_step = drill_step
    on_wall = drill_wall
    on_draw = drill_draw
}

#define drill_draw
draw_self()
/* sorry burg i cant live a lie like this
draw_set_blend_mode(bm_add)
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale*1.5,image_yscale*1.5,image_angle,image_blend,0.1)
draw_set_blend_mode(bm_normal)
*/
#define drill_step
if random(100) < 50*current_time_scale instance_create(x,y,Smoke)
if speed > maxspeed speed = maxspeed
image_speed = max(speed * .075,.4)

#define drill_wall
if walls > 0
{
  sound_play_drill(.4)
   with other{instance_create(x,y,FloorExplo);instance_destroy()}
   walls--
   speed = 3
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
walls = 6
sound_play_drill(.4)
//speed = max(speed - 3, 3)
x = xprevious
y = yprevious
speed = 1
other.speed = 0
sleep(20)
view_shake_at(x,y,7)
projectile_hit(other,damage)
var mans = other;
if other = lasthit{
    if ++hits > 30{
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
var _meetx = (x + other.x)/2;
var _meety = (y + other.y)/2;
with instance_create(_meetx+random_range(-12,12),_meety+random_range(-12,12),SmallExplosion){
    //image_xscale = .5
    //image_yscale = .5
    //damage = 1
    team = other.team
    sound_play_pitchvol(sndExplosion,1,.5)
    //hitid = [sprite_index,"MINI EXPLOSION"]
}
drill_hit()

#define sound_play_drill(_vol)
if fork(){
    repeat(10){
        sound_play_pitchvol(sndJackHammer,.4,_vol)
        sound_play_pitchvol(sndCrossbow,1.6,_vol)
        sound_play_pitchvol(sndHyperRifle,.6,_vol)
        sound_play_pitchvol(sndDiscHit,1.5,_vol)
        wait(0)
    }
    exit
}

#define step
if "extraspeed" in self
{
  if extraspeed > 26 extraspeed = 26
	if extraspeed > 0
	{
		if irandom(2) != 0{instance_create(x,y,Dust)}
		motion_add(frac(extraspeed)*10000-180,extraspeed-frac(extraspeed))
		extraspeed--
	}
	else{extraspeed = 0}
}
