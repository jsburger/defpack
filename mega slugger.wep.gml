#define init
  global.sprMassiveSlugger       = sprite_add_weapon("sprites/weapons/sprMassiveSlugger.png",18,6);
  global.sprFatShell             = sprite_add("sprites/other/sprFatShell.png",0,4,5);
  global.sprFatShellUpg          = sprite_add("sprites/other/sprFatShellUpg.png",0,4,7);
  global.sprMassiveSlug          = sprite_add("sprites/projectiles/sprMassiveSlug.png",2,27,27);
  global.sprMassiveSlugHit       = sprite_add("sprites/projectiles/sprMassiveSlugDissapear.png",4,50,50);
  global.sprMassiveSlugDisappear = sprite_add("sprites/projectiles/sprMassiveSlugDissapear.png",7,27,27);

#define weapon_name
  return "MEGA SLUGGER";

#define weapon_type
  return 2;

#define weapon_cost
  return 6;

#define weapon_area
  return 100;

#define weapon_load
  return 50;

#define weapon_swap
if instance_is(self, Player){
	view_shake_at(x, y, 20);
	sleep(10);
}
sound_play_pitchvol(sndBasicUltra, 1.2, .6);
sound_play_pitch(sndSwapShotgun, .9);
return -4;

#define weapon_auto
  return false;

#define weapon_melee
  return false;

#define weapon_laser_sight
  return false;

#define weapon_sprt
  return global.sprMassiveSlugger;

#define weapon_text
  return choose("HEFTY");

#define weapon_fire
  if fork()
  {
    repeat(20+random(10))
    {
      if instance_exists(self) with instance_create(x+lengthdir_x(32,gunangle),y+lengthdir_y(32,gunangle),Smoke)
      {
        gravity = -.1
        image_xscale /=2
        image_yscale/=2
      }
      wait(1)
    }
    exit
  }
  if "extraspeed2" not in self{extraspeed2 = 12 + gunangle / 10000}else{extraspeed2 += 12   + gunangle / 10000} //knockback, adding variables to the player is a sin

  with instance_create(x,y,CustomProjectile) //the projectile
  {
    creator = other;
    team    = other.team;
    damage[0]  = 10;
    damage[1]  = 15;
    maxframes = 2 + skill_get(15) * 2
    frames    = maxframes
    force = 30;
    typ   = 0;
    sprite_index = global.sprMassiveSlug;
    mask_index   = mskHeavyBullet;
    motion_add(other.gunangle + random_range(-4,4) * other.accuracy,28);
    image_angle = direction;
    friction = 1;
    wallbounce = 3 + skill_get(15) * 5;
    repeat(12)
    {
      with instance_create(x,y,Smoke)
      {
        motion_add(other.direction+random_range(-7,7),random_range(3,4));
      }
    }
    repeat(24)
    {
      if instance_exists(Wall) with instance_nearest(x, y, Wall) if distance_to_object(other) <= 8{
        with instance_nearest(x, y, Wall){
          instance_create(x, y, FloorExplo);
          instance_destroy();
        }
      }
    }
    on_hit      = slug_hit
    on_step     = slug_step
    on_wall     = slug_wall
    on_draw     = slug_draw
    on_destroy  = slug_destroy
    on_end_step = slug_end_step
  }
  sound_play_pitchvol(sndDevastatorExplo,3,.4);

#define slug_hit

#define slug_step
  if image_index = 1
  {
    if image_speed = 1
    {
      sleep(30)
      with creator weapon_post(15,-100,1000)
      var _pitch = random_range(.8,1.2);
      sound_play_pitch(sndHeavySlugger,.6*_pitch);
      sound_play_pitch(sndSuperFlakExplode,.4*_pitch);
      sound_play_pitch(sndDoubleShotgun,.7*_pitch);
      sound_play_pitch(sndSuperSlugger,.5*_pitch);
    }
    image_speed = 0
    sound_play_gun(sndClickBack,1,0);
    sound_stop(sndClickBack);
  }
  image_xscale = 1 + speed / 100;
  if frames > 0{frames--}
  image_angle = direction;
  if speed <= friction * 4{instance_destroy()}

#define slug_end_step
  if current_frame mod 2 < current_time_scale with instances_matching_ne(hitme,"team",team)
  {
    if distance_to_object(other) <= 15
    {
      var _id = id;
      with other
      {
        var _s = max(other.size,1);
        if other.team != team
        {
          repeat(2+_s) instance_create(x+random_range(-8,8),y+random_range(-8,8),Smoke)
          projectile_hit(other,damage[min(frames,1)],force,direction)
          x -= lengthdir_x(other.size * 2, direction)
          y -= lengthdir_y(other.size * 2, direction)
          with other{
            x += lengthdir_x(speed * .7, direction)
            y += lengthdir_y(speed * .7, direction)
          }
          sleep(12*_s)
          view_shake_at(x,y,8*_s)
          x -= hspeed/3
          y -= vspeed/3
        }
      }
    }
  }

#define slug_wall
  move_bounce_solid(false)
  repeat(4)
  {
    with instance_create(x+random_range(-5,5),y+random_range(-5,5),Smoke)
    {
      motion_add(random(360),random_range(2,3))
    }
  }
  sound_play_pitch(sndHitWall,.8)
  speed *= .8
  if speed + wallbounce > 28
  {
    speed = 28
  }
  else
  {
    speed += wallbounce
    wallbounce *= .9
  }
  repeat(3)
  {
    with instance_create(x,y,Bullet2)
    {
      team    = other.team
      creator = other.creator
      motion_add(random(360),random_range(10,12))
      image_angle = direction
    }
    with instance_create(x,y,Slug)
    {
      team    = other.team
      creator = other.creator
      motion_add(random(360),random_range(5,8))
      image_angle = direction
    }
  }
  frames = maxframes
  sleep(20)
  view_shake_at(x,y,20)
  if speed > 14{with other{instance_create(x,y,FloorExplo);instance_destroy()}}

#define slug_draw
  var _f = min(frames,1);
  draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
  draw_set_blend_mode(bm_add);
  draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.1+_f*.2);
  draw_set_blend_mode(bm_normal);

#define slug_destroy
  with instance_create(x,y,BulletHit)
  {
    sprite_index = global.sprMassiveSlugDisappear
    image_angle  = other.direction
  }

#define step

  with instances_matching(Player, "wep", mod_current){speed *= min(1, .8 + .2 * (skill_get(mut_extra_feet)))}
  with instances_matching(instances_matching(Player, "race", "steroids"), "bwep", mod_current){speed *= min(1, .8 + .2 * (skill_get(mut_extra_feet)))}

  if "extraspeed2" in self
  {
    if extraspeed2 > 30{extraspeed2 = 30} //cap speed for safety reasons
  	if extraspeed2 > 0
  	{
      sleep(1)
      sound_play_gun(sndFootOrgSand4,999999999999999999999999999999999999999999999999,.00001)//mute action
  		instance_create(x + random_range(-4, 4),y + random_range(-4, 4), Dust);
  		canaim = false;
  		with instance_create(x+lengthdir_x(extraspeed2+20*skill_get(13),frac(extraspeed2)*10000),y+lengthdir_y(extraspeed2+20*skill_get(13),frac(extraspeed2)*10000),Shank)
      {
  			team = other.team;
        creator = other;
        damage = 20;
        sprite_index = mskNone;
        mask_index = sprFlakBullet;
        image_xscale = 2;
        image_yscale = 2;
  			image_angle = other.gunangle;
  		}
  		motion_add(frac(extraspeed2)*10000-180,extraspeed2-frac(extraspeed2));
  		extraspeed2 -= current_time_scale;
  	}
  	else{extraspeed2 = 0;canaim = true}
  }

#define weapon_reloaded
  sound_play_pitchvol(sndShotReload,.8,.7);
  sound_play_pitchvol(sndBouncerBounce,.082,.5);
  weapon_post(3,5,2);
  view_shake_at(x, y, 6);
  instance_create(x,y,Dust);

  with instance_create(x,y,Shell)
  {
    if skill_get(15) = true{sprite_index = global.sprFatShellUpg}else{sprite_index = global.sprFatShell};
    motion_add(other.gunangle - 180 + random_range(-30,30),random_range(4,5));
    image_angle = direction + 90 + random_range(-8,8)
  }
