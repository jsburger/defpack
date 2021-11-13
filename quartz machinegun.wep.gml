#define init
global.sprQuartzMachinegun  = sprite_add_weapon("sprites/weapons/sprQuartzMachinegun.png" ,7,3)
global.sprQuartzMachinegun1 = sprite_add_weapon("sprites/weapons/sprQuartzMachinegun1.png",7,3)
global.sprQuartzMachinegun2 = sprite_add_weapon("sprites/weapons/sprQuartzMachinegun2.png",7,3)
global.sprQuartzBullet     = sprite_add("sprites/projectiles/sprQuartzBullet.png",2,12,12)
global.sprHud  = sprite_add("sprites/interface/sprQuartzMachinegunHud.png" , 1, 12, 3)
global.sprHud1 = sprite_add("sprites/interface/sprQuartzMachinegunHud1.png", 1, 12, 3)
global.sprHud2 = sprite_add("sprites/interface/sprQuartzMachinegunHud2.png", 1, 12, 3)

#define weapon_name
return "QUARTZ MACHINEGUN"

#define nts_weapon_examine
return{
    "d": "A shiny and frail machinegun. #The clear bullets it fires are mesmerizing. ",
}
#define weapon_sprt_hud(wep)
if is_object(wep){
  switch wep.health{
    default: return global.sprHud;
    case 1: return global.sprHud1;
    case 0: return global.sprHud2;
  }
}
return global.sprHud;

#define weapon_sprt(wep)
if is_object(wep){
  switch wep.health{
    default: return global.sprQuartzMachinegun;
    case 1: return global.sprQuartzMachinegun1;
    case 0: return global.sprQuartzMachinegun2;
  }
}
return global.sprQuartzMachinegun;

#define weapon_type
return 1;

#define weapon_cost
return 2;

#define weapon_area
return 13;

#define weapon_load(w)
var _l = 5;
if is_object(w) return _l - (w.maxhealth - w.health) * 1 else return _l;

#define weapon_swap(w)
if instance_is(self, Player) if is_object(w){w.prevhealth = my_health}
sound_play_pitchvol(sndHyperCrystalHurt, 1.3, .6)
return sndSwapMachinegun;

#define weapon_auto
return true;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_text
return choose("GLASS CANNON","BE CAREFUL WITH IT")

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
  weapon_post(7, 7, 0)
  sound_play_pitch(sndHeavyRevoler,random_range(1,1.1))
  sound_play_pitch(sndLaserCrystalHit,random_range(1.7,2.1))
  with instance_create(x,y,CustomProjectile)
  {
      name = "Quartz Bullet"
      sprite_index = global.sprQuartzBullet
      mask_index   = mskHeavyBullet
      projectile_init(other.team,other)
      force  = 3
      damage = 4
      typ = 1
      image_speed = 1

      defbloom = {
          xscale : 2,
          yscale : 2,
          alpha : .1
      }

      motion_add(other.gunangle + random_range(-3, 3), 20);
      image_angle = direction
      pierce  = 2
      lasthit = -4
      on_hit     = quartzbullet_hit
      on_anim   = quartzbullet_anim
      on_destroy = quartzbullet_destroy
  }

#define quartzbullet_anim
  image_index = 1
  image_speed = 0

#define quartzbullet_destroy
  repeat(3) with instance_create(x+random_range(-4,4),y+random_range(-4,4),Dust){sprite_index = sprExtraFeetDust}
  instance_create(x+lengthdir_x(sprite_width/2,direction),y+lengthdir_y(sprite_height/2,direction),WepSwap){image_angle = random(360)}
  view_shake_at(x,y,2)
  sleep(1)

  #define quartzbullet_hit
  if projectile_canhit_melee(other) = true || lasthit != other{
      sleep(3 + clamp(other.size * 2, 1, 3));
      view_shake_at(x, y, 4);
      projectile_hit(other,damage,force,direction)
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
