#define init
global.test0 = sprite_add_weapon("sprites/test0.png",9,8);
global.test1 = sprite_add_weapon("sprites/test1.png",10,10);
global.test2 = sprite_add_weapon("sprites/test2.png",13,13);

#define weapon_name
return "test";

#define weapon_type
return 5;

#define weapon_cost
return 1;

#define weapon_area
return -1;

#define weapon_load
return 1;//???

#define weapon_swap
return sndSwapHammer;

#define weapon_auto
return false;

#define weapon_melee
return true;

#define weapon_laser_sight
return false;

#define weapon_fire
var _p = random_range(.8,1.2);
sound_play_pitch(sndChickenThrow,1.2*_p)
if !skill_get(17)
{
  sound_play_pitch(sndEnergyHammer,1.5*_p)
  sound_play_pitch(sndEnergyScrewdriver,.7*_p)
}
else
{
  sound_play_pitch(sndEnergyHammer,.7*_p)
  sound_play_pitch(sndEnergyHammer,1.5*_p)
  sound_play_pitch(sndPlasmaUpg,1.7*_p)
  sound_play_pitch(sndEnergyScrewdriverUpg,1.4*_p)

}
with instance_create(x,y,CustomObject)
{
  team = other.team
  creator = other
  if !skill_get(17){sprite_index = global.test1}else{sprite_index = global.test2}
  mask_index   = sprMapDot
  image_speed = 0
  curse = other.curse
  other.wep = 0
  maxspeed = 14 + skill_get(13)*6
  phase = 0
  friction = 1.2
  check = 0
  btn = [button_check(other.index,"fire"),button_check(other.index,"spec"),other.swapmove]
  btn = "fire"
  check = other.specfiring ? 2 : 1;
  if check = 2
  {
    btn = "spec"
  }
  motion_add(other.gunangle,14)
  on_step = boom_step
  on_draw = boom_draw
  with instance_create(x,y,MeleeHitWall){image_angle = other.direction-180}
}

#define boom_step
if irandom(7-skill_get(17)*2) = 0
{
  sound_play_pitchvol(sndLightningReload,random_range(.8,1.2),.2*(1-distance_to_object(creator)/200))
  instance_create(x,y,LaserBrain)
}

if instance_exists(creator)
{
  if current_frame mod 6 = 0
  {
    if skill_get(17){sound_play_pitchvol(sndPlasmaBigExplodeUpg,1,.1*(1-distance_to_object(creator)/200))}
    sound_play_pitchvol(sndBouncerBounce,.1,(1-distance_to_object(creator)/200))
    sound_play_pitchvol(sndGrenadeHitWall,.1,.15*(1-distance_to_object(creator)/200))
  }
}
with instances_matching_ne(hitme,"team",other.team)
{
  if current_frame mod (3-skill_get(17)) = 0
  if distance_to_object(other) <= 7+skill_get(17)*2
  {
    if projectile_canhit(other) = true
    {
      with other
      {
        view_shake_at(x,y,4)
        sleep(other.size*4)
        var _k = point_direction(other.x,other.y,x,y)
        projectile_hit(other,2,other.size,_k)
      }
      x -= (hspeed*(skill_get(17)+1))/(2+skill_get(17))
      x -= (vspeed*(skill_get(17)+1))/(2+skill_get(17))
    }
  }
}
with instances_matching_ne(projectile,"team",other.team)
{
  if distance_to_object(other) <= 7+skill_get(17)*2
  {
    with other if other.team != team with other instance_destroy()
  }
}
if curse = true{instance_create(x+random_range(-5,5),y+random_range(-5,5),Curse)}
image_angle += 16
if phase = 0 //move regularly
{
  if speed <= friction
  {
    if button_check(creator.index,btn)
    {
      speed = 0
      image_angle += 10
      mask_index = sprite_index
      if irandom(20-skill_get(17)*5) = 0{with instance_create(x,y,GunGun){image_index = 4}}
      repeat(1+skill_get(17))with instance_create(x,y,PlasmaTrail){motion_add(random(360),4+skill_get(17))}
      if creator.infammo <= 0
      {
        if creator.ammo[5] > 0{if current_frame mod (24-skill_get(17)*4) = 0 creator.ammo[5]--}
        else
        {
          with instance_create(x,y,ThrownWep)
          {
            sprite_index = global.test0
            wep = mod_current
            curse = other.curse
            motion_add(random(360),2)
            team = other.team
            creator = other.creator
          }
          instance_destroy()
          exit
        }
      }
    }
    else
    {
      mask_index = sprMapDot
      phase = 1
      friction *= -1
    }
  }
}
else//return to player
{
  if instance_exists(creator)
  {
    /*if place_meeting(x,y,Wall)
    {
      with instance_create(x,y,ThrownWep)
      {
        sprite_index = global.test0
        wep = mod_current
        curse = other.curse
        motion_add(other.direction-180+random_range(-30,30),2)
        team = other.team
        creator = other.creator
      }
      instance_destroy()
      exit
    }*/
    var _d = point_direction(x,y,creator.x,creator.y)
    if phase = 1 motion_add(_d,8)
    if distance_to_object(creator) <= 9+skill_get(17)*3
    {
      if creator.wep  = 0{sleep(30);sound_play(sndSwapHammer);instance_create(x,y,WepSwap);creator.wep = mod_current;instance_destroy();exit}
      if creator.bwep = 0{sleep(30);sound_play(sndSwapHammer);instance_create(x,y,WepSwap);creator.bwep = mod_current;instance_destroy();exit}
      //phase = 2//not homing anymore
    }
    if creator.mask_index != mskNothing && distance_to_object(Portal) <= 9+skill_get(17)*3
    {
      if creator.wep  = 0{sleep(30);sound_play(sndSwapHammer);instance_create(x,y,WepSwap);creator.wep = mod_current;instance_destroy();exit}
      if creator.bwep = 0{sleep(30);sound_play(sndSwapHammer);instance_create(x,y,WepSwap);creator.bwep = mod_current;instance_destroy();exit}
    }
  }
}
if place_meeting(x+hspeed,y+vspeed,Wall)
{
  phase = 1
  var _y = false;
  if instance_exists(creator){if !collision_line(x,y,creator.x,creator.y,Wall,0,0){_y = true}}else{_y = true}
  if _y = false
  {
    with instance_create(x,y,ThrownWep)
    {
      sprite_index = global.test0
      wep = mod_current
      curse = other.curse
      motion_add(other.direction-180+random_range(-30,30),2)
      team = other.team
      creator = other.creator
    }
    instance_destroy()
    exit
  }
  else{speed = 0}
}
if speed > maxspeed speed = maxspeed

#define weapon_sprt
return global.test0

#define weapon_text
return choose("HOLD FIRE TO HOLD THE SPIN")

#define step
with WepPickup if wep = 0 instance_delete(self)

#define boom_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, (1.5+skill_get(17)*.16)*image_xscale, (1.5+skill_get(17)*.16)*image_yscale, image_angle, image_blend, 0.15);
draw_set_blend_mode(bm_normal);
