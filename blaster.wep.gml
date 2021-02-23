#define init
global.sprBlaster = sprite_add_weapon("sprites/weapons/sprBlaster.png", 2, 3);

#define weapon_name
return "BLASTER";

#define weapon_sprt
return global.sprBlaster;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 8;

#define weapon_cost
return 1;

#define weapon_melee
return 0;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 5;

#define weapon_text
return "HEAT WAVES";

#define nts_weapon_examine
return{
    "d": "A combat pistol from a long-lost war. #Can be charged for more range. ",
}

#define weapon_chrg
return true;

#define weapon_fire
with instance_create(x,y,CustomObject){
	name    = "blaster charge"
	creator = other
	charge    = 0
    maxcharge = 18
    defcharge = {
        style : 0,
        width : 12,
        charge : 0,
        power : 10,
        maxcharge : maxcharge
    }
	charged = 0
	depth = TopCont.depth
	index = creator.index
  accuracy = other.accuracy
	on_step    = blaster_step
	on_destroy = blaster_destroy
	reload = -1
	btn = other.specfiring ? "spec" : "fire"
	hand = other.specfiring and other.race == "steroids"
}

#define blaster_step
  if !instance_exists(creator){instance_delete(self);exit}
	if button_check(creator.index, "swap") && (creator.canswap = true || creator.bwep != 0){
	  var _t = weapon_get_type(mod_current);
	  creator.ammo[_t] += weapon_get_cost(mod_current)
	  if creator.ammo[_t] > creator.typ_amax[_t] creator.ammo[_t] = creator.typ_amax[_t]
	  instance_delete(self)
	  exit
	}
  var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
  with creator{
    weapon_post(3 * other.charge / other.maxcharge, 0, 0);
  }
  if button_check(index,"swap"){instance_destroy();exit}
  if reload = -1{
      reload = hand ? creator.breload : creator.reload
      reload += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale
  }
  else{
      if hand creator.breload = max(creator.breload, reload)
      else creator.reload = max(reload, creator.reload)
  }
  defcharge.charge = charge
  if button_check(index, btn){
      if charge < maxcharge{
          charge += mod_script_call_nc("mod", "defpack tools", "get_reloadspeed", creator) * timescale;
          charged = 0
          sound_play_pitchvol(sndGrenadeHitWall, charge/maxcharge * 1.2 + .3, .4)
          sound_play_pitchvol(sndNadeReload, charge/maxcharge * 1.2 + .5, .6)
      }
      else{
          if current_frame mod 6 < current_time_scale {
              creator.gunshine = 1
              with defcharge blinked = 1
          }
          charge = maxcharge;
          if charged = 0{
              mod_script_call_self("mod","defpack tools", "weapon_charged", creator, 12)
              charged = 1
          }
      }
  }
  else{instance_destroy()}

#define blaster_destroy
  var _h = hand;
  var _c = max(1, floor(charge / maxcharge) + 1);
  with creator{
  var things = [SmallExplosion,CustomObject,Explosion],
      lengths = [27,55,100],
      ang = gunangle,
      _x = x, _y = y;

      for (var i = 0; i < (_c + 1); i++){
          if instance_exists(self){
              var _pitch = random_range(.8,1.2);
               if i = 2{
                  sleep(30)
                  _pitch += .1
                  if _h = true breload += 12 else reload += 12;
              }
              if _c > 1 if fork(){
                wait(1);
                sleep(40);
                weapon_post(12,24,4);
                motion_add(gunangle - 180, 2);
                sound_play_pitchvol(sndExplosionL,1.2*_pitch, .4)
                exit
              }
              if _c <= 1 weapon_post(8,8,4);
              sound_play_pitch(sndGrenadeRifle,.8*_pitch)
              sound_play_pitch(sndGrenadeShotgun,1.5*_pitch)
              sound_play_pitch(sndExplosion,_pitch)
              with instance_create(_x+lengthdir_x(lengths[i] + speed,ang),_y+lengthdir_y(lengths[i]+speed,ang),things[i]){
                  if i = 0 team = other.team
                  if i = 0 damage += 3;
                  creator = other
                  if i > 0{
                      repeat(2 + (1 * (GameCont.crown == crwn_death)))with instance_create(x,y,SmallExplosion) creator = other.creator
                      if i = 1 instance_destroy()
                  }
              }
          }
          wait(2)
       }
    }




/*with instance_create(x+lengthdir_x(26,gunangle),y+lengthdir_y(26,gunangle),SmallExplosion){damage = round(damage/2);team = other.team}
repeat(6)
{
	repeat(2)with instance_create(x+lengthdir_x(2,direction)+random_range(-2,2),y+lengthdir_y(2,direction)+random_range(-2,2),Smoke)motion_set(other.gunangle + random_range(-8,8), 1+random(3))
	repeat(4)with instance_create(x,y,Flame){move_contact_solid(other.gunangle,2)team = other.team;motion_add(other.gunangle+random_range(-14,14)*(1-skill_get(19)),3+random(6))}
}
*/
