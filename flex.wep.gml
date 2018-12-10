#define init
global.sprInfinigun2 = sprite_add_weapon("sprites/sprPelletPistol2.png",8,4)

#define weapon_name
return "FLEX"

#define weapon_type
return 1

#define weapon_cost
return 2

#define weapon_area
return -1

#define weapon_load
return 2

#define weapon_swap
return sndSwapPistol

#define weapon_auto
return true

#define weapon_melee
return false

#define weapon_laser_sight
return false

#define weapon_fire
weapon_post(4+_a,3,5+_a*6)
with instance_create(x,y,CustomProjectile)
{
  if other.infammo > 0 var _a = 1 else var _a = 0
  var _p = random_range(.8,1.2)
  sound_play_pitchvol(sndHeavyRevoler,(.6-_a*.2)*_p,.6)
  sound_play_pitchvol(sndHeavyNader,(1.8-_a*.6)*_p,.6)
  sound_play_pitchvol(sndFlakExplode,.3*_p,.5*_a)
  sound_play_pitchvol(sndExplosion,_p,.4)
  projectile_init(other.team,other)
  if irandom(19) = 0 charged = true else charged = false
  mask_index   = mskBullet1
  if other.infammo >0 sprite_index = sprIDPDBullet else sprite_index = sprBullet1
  motion_add(other.gunangle+random_range(-8,8)*other.accuracy,18)
  image_angle = direction
  image_speed = 1
  recycle_amount = 2
  bounce = 1
  damage = 4
  force  = 7
  on_hit     = b_hit
  on_step    = b_step
  on_wall    = b_wall
  on_draw    = b_draw
  on_destroy = b_destroy
}

#define b_hit
if projectile_canhit(other)
{
  projectile_hit(other,damage,force,direction)
  if instance_exists(creator) if recycle_amount != 0 && irandom(9) <= 5 && skill_get(16){
  	creator.ammo[1]+=recycle_amount
  	if creator.ammo[1] > creator.typ_amax[1] {creator.ammo[1] = creator.typ_amax[1]}
  	sound_play_pitchvol(sndRecGlandProc, 1, 7)
  }
  if instance_exists(creator) if recycle_amount != 0 && skill_get("recycleglandx10"){
  	creator.ammo[1]+= 10*recycle_amount
  	if creator.ammo[1] > creator.typ_amax[1] {creator.ammo[1] = creator.typ_amax[1]}
  	sound_play_pitchvol(sndRecGlandProc, 1, 7)
  }
  if other.my_health <= 0
  {var o = other
    if instance_exists(creator)
    {
      var a = round(max(6,o.maxhealth/1.3))
      sleep(a*2)
      with creator if infammo + a <= 75 infammo += a else infammo = 75 //limit infammo gain to 45 frames
    }
  }
}
instance_destroy()

#define b_wall
if place_meeting(x+hspeed,y,Wall)
{
  instance_create(x,y,Smoke)
  sound_play_pitch(sndHitWall,random_range(.8,1.2))
  hspeed *= -1
  bounce--
  image_angle = direction
}
if place_meeting(x,y+vspeed,Wall)
{
  instance_create(x,y,Smoke)
  sound_play_pitch(sndHitWall,random_range(.8,1.2))
  vspeed *= -1
  bounce--
  image_angle = direction
}
if place_meeting(x+hspeed,y+vspeed,Wall)
{
  instance_create(x,y,Smoke)
  sound_play_pitch(sndHitWall,random_range(.8,1.2))
  vspeed *= -1
  hspeed *= -1
  bounce--
  image_angle = direction
}
if bounce < 0 instance_destroy()

#define b_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.1);
draw_set_blend_mode(bm_normal);

#define b_destroy
with instance_create(x,y,BulletHit){if other.sprite_index = sprIDPDBullet sprite_index = sprIDPDBulletHit else sprite_index = sprBulletHit}

#define b_step
if image_index = 1 image_speed = 0

#define weapon_sprt
return global.sprInfinigun2

#define weapon_text
return choose("NEWER AND BETTER","HUNGRY")
