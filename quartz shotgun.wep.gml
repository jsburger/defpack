#define init
global.sprQuartzShotgun = sprite_add_weapon("sprites/sprQuartzShotgun.png",7,3)
global.sprQuartzBullet2 = sprite_add("sprites/projectiles/sprQuartzBullet2.png",2,12,12)
global.sprHud = sprite_add("sprites/sprQuartzShotgunHud.png", 1, 7, 3)

#define weapon_name
return "QUARTZ SHOTGUN"

#define weapon_sprt_hud
return global.sprHud

#define weapon_sprt
return global.sprQuartzShotgun;

#define weapon_type
return 2;

#define weapon_cost
return 1;

#define weapon_area
return 13;

#define weapon_load
return 12;

#define weapon_swap
return sndSwapShotgun;

#define weapon_auto
return false;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_text
return choose("PRODUCT OF PRISMATIC FORGERY","BE CAREFUL WITH IT")

#define weapon_fire
weapon_post(7,30,25)
sound_play_pitch(sndSawedOffShotgun,random_range(1.2,1.4))
sound_play_pitch(sndSlugger,random_range(.7,.8))
sound_play_pitch(sndLaserCrystalHit,random_range(1.4,1.7))
repeat(5) with instance_create(x,y,CustomProjectile)
{
  sprite_index = global.sprQuartzBullet2
  mask_index   = mskBullet2
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
  motion_add(other.gunangle+random_range(-9,9)*other.accuracy,26)
  image_angle = direction
  pierce  = 2
  lasthit = -4
  on_hit     = quartzbullet_hit
  on_step    = quartzbullet_step
  on_draw    = quartzbullet_draw
  on_destroy = quartzbullet_destroy
  on_wall    = quartzbullet_wall
  on_anim    = quartzbullet_anim
}

#define quartzbullet_anim
image_speed = 0
image_index = 1

#define quartzbullet_wall
move_bounce_solid(false)
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

#define quartzbullet_draw
var _f = fallofftime >= current_frame
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.1+_f*.2);
draw_set_blend_mode(bm_normal);

#define step
mod_script_call_self("mod","defpack tools","quartz_penalty",mod_current)
