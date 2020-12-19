#define init
global.sprSuperAbrisLauncher = sprite_add_weapon("sprites/weapons/sprSuperAbrisLauncher.png", 3, 4);
//global.sprDanger 					 = sprite_add("sprites/projectiles/Danger.png",0,1,29);

#define weapon_name
return "SUPER ABRIS LAUNCHER"

#define weapon_sprt
return global.sprSuperAbrisLauncher;

#define weapon_type
return 4;

#define weapon_auto
return 1;

#define weapon_load
return 72;

#define weapon_cost
return 6;

#define weapon_chrg
return true;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 12;

#define weapon_reloaded
weapon_post(-1,-3,0)
sound_play_pitchvol(sndNadeReload,1.4,.6)

#define weapon_text
return "HAIL MARY";

#define weapon_fire
var _strtsize = 34;
var _endsize  = 64;
with mod_script_call("mod","defpack tools","create_abris",self,_strtsize,_endsize,argument0){
    //sound_set_track_position(sndVanWarning,1.2)
    accspeed = 1.1
    payload = script_ref_create(pop)
    damage = 15
    maxdamage = 35
    name = mod_current
    olddraw = on_draw
    on_draw = abris_draw_super
}
//nonono this isnt working no no no
sound_play_pitch(sndSniperTarget,1.075)

#define pop
sound_play_pitch(sndGrenadeRifle,random_range(.5,.8))
sleep(200)
with instance_create(x, y, CustomObject){
  creator = other.creator
  team = other.team
  accmin = other.accmin
  acc = other.acc
  timer = 1;
  n = 24//3
  radius = 0;
  offset = random(360)

  on_step = pop_step
}

#define pop_step
if !instance_exists(creator){instance_delete(self);exit}
if timer-- <= 0
{
  /*sound_play(sndExplosionL)
  sound_play_pitch(sndGrenadeShotgun,random_range(.5,.8))
  sound_play_pitch(sndGrenadeRifle,random_range(.5,.8))
  sound_play_pitch(sndUltraGrenade,.9)
  sound_play_pitch(sndHeavyNader,.7)
  sound_play_pitch(sndIDPDNadeExplo,.7)
  if instance_is(creator, Player) with creator{weapon_post(12,80,244)}
  with creator{motion_add(gunangle,-5)}
  var r = acc + accmin - 5 + radius, r2 = r - 30 + radius, i = 0
  repeat(8){
    i++;
  	if n > 2{
      if i = 1{
        sound_play(sndExplosionXL)
        sound_play_pitch(sndVanWarning,1000)
      }
      with instance_create(x + lengthdir_x(r, offset), y + lengthdir_y(r, offset), Explosion)
  	    hitid = [sprite_index,"explosion"]
    }
  	with instance_create(x + lengthdir_x(r2, offset), y + lengthdir_y(r2, offset), SmallExplosion)
  	    hitid = [sprite_index,"small explosion"]
    offset += 45
  }
  radius += 24*/
  timer = 1 + irandom(2)//6
  var _d = random(360), _r = (random(accmin) + random(acc)) * .9;
	instance_create(x + lengthdir_x(_r, _d), y + lengthdir_y(_r, _d), SmallExplosion)
	sound_play_pitchvol(sndExplosionS, .8 + (18 - n) / 45, 1.2)
	view_shake_at(x, y, 12)
  if n <= 12{
	instance_create(x + lengthdir_x(_r, _d), y + lengthdir_y(_r, _d), Explosion)
	instance_create(x + lengthdir_x(_r, _d), y + lengthdir_y(_r, _d), SmallExplosion)
	sound_play_pitchvol(sndExplosion, .8 + (18 - n) / 50, .5)
  }if n <= 6{
  	instance_create(x + lengthdir_x(_r, _d), y + lengthdir_y(_r, _d), GreenExplosion)
	instance_create(x + lengthdir_x(_r, _d), y + lengthdir_y(_r, _d), Explosion)
	sound_play_pitchvol(sndExplosionL, .8 + (18 - n) / 50, .5)
	if n = 1{timer = 8}
  }
  n--
  if n = 0{
  	sound_play_pitchvol(sndExplosionXL,  1, 2)
	sound_play_pitchvol(sndExplosionCar,.7, 2)
  	sleep(150)
  	view_shake_at(x, y, 128)
  	repeat(8)instance_create(x + random_range(-4, 4), y + random_range(-4, 4), GreenExplosion)
  }
} if n <= 0 instance_destroy()

#define abris_draw_super
  if current_frame % 25 <= current_time_scale {
      //sound_play_pitch(sndVanWarning,.6)
      var q = audio_play_sound(sndVanWarning, 1, 0);
      audio_sound_set_track_position(q, 1.2)
      audio_sound_pitch(q, .6)
  }
  mod_script_call_self(olddraw[0], olddraw[1], olddraw[2])
  var r = accmin + acc,
      c = mod_variable_get("mod", "defpack tools", "AbrisCustomColor") = true && instance_is(creator, Player) ? player_get_color(creator.index) : ringcolour;
  draw_circle_color(x, y, 3, c, c, 0)
  for var i = 0; i <= 2; i++{
      mod_script_call_nc("mod", "defpack tools", "draw_arc", x, y, image_angle + 120 * i, 8, r - 8, 45, 2, c, 1, 1)
      //draw_sprite_ext(global.sprDanger, 0, x, y, r/80, r/80, image_angle + 120 * i, c_red, accbase-acc)
  }
