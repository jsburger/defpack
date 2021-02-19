#define init
global.sprQuartzShotgun  = sprite_add_weapon("sprites/weapons/sprQuartzShotgun.png" ,7,3)
global.sprQuartzShotgun1 = sprite_add_weapon("sprites/weapons/sprQuartzShotgun1.png",7,3)
global.sprQuartzShotgun2 = sprite_add_weapon("sprites/weapons/sprQuartzShotgun2.png",7,3)
global.sprQuartzBullet2 = sprite_add("sprites/projectiles/sprQuartzBullet2.png",2,12,12)
global.sprHud  = sprite_add("sprites/interface/sprQuartzShotgunHud.png" , 1, 7, 3)
global.sprHud1 = sprite_add("sprites/interface/sprQuartzShotgunHud1.png", 1, 7, 3)
global.sprHud2 = sprite_add("sprites/interface/sprQuartzShotgunHud2.png", 1, 7, 3)

#define weapon_name
return "QUARTZ SHOTGUN"

#define weapon_sprt_hud(wep)
if is_object(wep){
  switch wep.health{
    default: return global.sprHud;
    case 1: return global.sprHud1;
    case 0: return global.sprHud2;
  }
}
return global.sprHud

#define weapon_sprt(wep)
if is_object(wep){
  switch wep.health{
    default: return global.sprQuartzShotgun;
    case 1: return global.sprQuartzShotgun1;
    case 0: return global.sprQuartzShotgun2;
  }
}
return global.sprQuartzShotgun;

#define weapon_type
return 2;

#define weapon_cost
return 2;

#define weapon_area
return 13;

#define weapon_load
return 15;

#define weapon_swap(w)
if instance_is(self, Player) if is_object(w){w.prevhealth = my_health}
sound_play_pitchvol(sndHyperCrystalHurt, 1.3, .6)
return sndSwapShotgun;

#define weapon_auto
return false;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_text
return choose("PRODUCT OF PRISMATIC FORGERY","BE CAREFUL WITH IT")

#define nts_weapon_examine
return{
    "d": "A shiny and frail shotgun. #Shells fired are overwhelmingly bright. ",
}

#define weapon_fire(w)
  if !is_object(w){
      w = {
          wep: w,
          prevhealth: other.my_health,
          maxhealth: 2,
          health: 2,
          is_quartz: true,
          shinebonus:0
      }
      wep = w
  }
  weapon_post(7,30,25)
  var _c = 1 - w.health / w.maxhealth,
      _p = random_range(.9 - .2 * _c, 1.1 + .2 * _c)
  sound_play_pitch(sndSawedOffShotgun,1.3 * _p)
  sound_play_pitch(sndSlugger,.75 * _p)
  sound_play_pitch(sndLaserCrystalHit,1.55 * _p)
  repeat(5) with instance_create(x,y,CustomProjectile){
      name = "Quartz Shell"
      sprite_index = global.sprQuartzBullet2
      mask_index   = mskHeavyBolt
      team    = other.team
      creator = other
      force  = 4
      damage = 6
      falloff = 2
      fallofftime = current_frame + 2 + skill_get(15) * 2
      typ = 1
      friction = random_range(.6,2)
      image_speed = 1
      wallbounce = 3 + skill_get(15) * 5;
      motion_add(other.gunangle+random_range(-9,9) * (other.accuracy + (2 - 2 * w.health/w.maxhealth)),26 * random_range(1 * (1 - _c * .45), 1))
      image_angle = direction
      defbloom = {
          xscale : 2,
          yscale : 2,
          alpha : .2
      }
      pierce  = 2
      lasthit = -4
      _f = fallofftime >= current_frame
      on_hit     = quartzbullet_hit
      on_step    = quartzbullet_step
      on_destroy = quartzbullet_destroy
      on_wall    = quartzbullet_wall
      on_anim    = quartzbullet_anim
  }

#define quartzbullet_anim
  image_speed = 0
  image_index = 1

#define quartzbullet_wall
  move_bounce_solid(false)
  defbloom.alpha = .2
  direction += random_range(-4,4)
  image_angle = direction
  speed *= .9
  if speed + wallbounce > 26{
    speed = 26
  }
  else{
    speed += wallbounce
  }
  wallbounce *= .9
  fallofftime = current_frame + 2 + skill_get(15) * 2
  sound_play_pitchvol(sndHitWall,random_range(.8,1.2),.5)
  with instance_create(x+random_range(-4,4),y+random_range(-4,4),Dust){sprite_index = sprExtraFeetDust}

#define quartzbullet_step
  if fallofftime < current_frame defbloom.alpha = .1
  if speed <= friction instance_destroy()

#define quartzbullet_destroy
  repeat(3) with instance_create(x+random_range(-4,4),y+random_range(-4,4),Dust){sprite_index = sprExtraFeetDust}
  instance_create(x+lengthdir_x(sprite_width/2,direction),y+lengthdir_y(sprite_height/2,direction),WepSwap){image_angle = random(360)}
  view_shake_at(x,y,2)
  sleep(1)

#define quartzbullet_hit
  if projectile_canhit_melee(other) || lasthit != other{
      var dmg = fallofftime >= current_frame ? damage : damage - falloff
      sleep(dmg)
      view_shake_at(x,y,dmg)
      projectile_hit(other,dmg,force,direction)
      pierce--
      lasthit = other
  }
  if pierce < 0{instance_destroy()}

#define step(p)
  if p && is_object(wep){
    mod_script_call_self("mod","defpack tools","quartz_penalty",mod_current, wep, p)
    mod_script_call_self("mod","defpack tools","quartz_step", self, wep);
  }
  if !p && is_object(bwep) && race = "steroids"{
    mod_script_call_self("mod","defpack tools","quartz_penalty",mod_current, bwep, p)
    mod_script_call_self("mod","defpack tools","quartz_step", self, bwep);
  }
