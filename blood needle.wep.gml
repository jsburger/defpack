#define init
  global.sprHexNeedle      = sprite_add_weapon("sprites/weapons/sprHexNeedle.png",       4, 6);
  global.sprHexNeedleHUD   = sprite_add_weapon("sprites/weapons/sprHexNeedle.png",       0, 5);
  global.sprHexNeedleWall  = sprite_add_weapon("sprites/weapons/sprHexNeedle.png",      14, 5);
  global.sprHexNeedleStick = sprite_add_weapon("sprites/weapons/sprHexNeedle.png",      24, 5);
  global.mskHexNeedle      = sprite_add_weapon("sprites/projectiles/mskHexNeedle.png",  20, 6);
  global.sprHexNeedleShank = sprite_add("sprites/projectiles/sprHexNeedleShank.png", 4, -6, 4);

#macro  current_frame_active (current_frame % 1) < current_time_scale

// V. 1: on hit -> curse enemies in area to take 20 damage after delay, throwable
// V. 2: on hit -> curse enemies in area to take 20 damage after short delay
// V. 3: on kill -> create splinters on top of enemies (is aoe yes but splinters have trouble hitting)
// V. 4: on kill -> create blood explo on top of enemies (covered by the bones)
// V. 5: on kill -> +1 HP
// V. 6: on kill -> 3 more kills

#define weapon_name
  return "CORPSE NEEDLE";

#define weapon_type
  return 0;

#define weapon_cost
  return 0;

#define weapon_area
  return 5;

#define weapon_load
  return 14;

#define weapon_swap
  return sndSwapSword;

#define weapon_auto
  return false;

#define weapon_melee
  return false;

#define weapon_laser_sight
  return false;

#define weapon_sprt
  return global.sprHexNeedle;

#define weapon_sprt_hud
  return global.sprHexNeedleHUD;

#define nts_weapon_examine
return{
    "d": "A point-blank melee weapon. #Kill enemies to claim their blood for you. ",
}

#define weapon_text
  return "WHERE DO THESE CORPSES COME FROM";

#define weapon_fire
  var _offset = 12 + skill_get(mut_long_arms) * 8;
  var _p = random_range(.8, 1.2);

  sound_play_pitchvol(sndScrewdriver, 1.2 * _p, .8);
  sound_play_pitchvol(sndBlackSword, 2 * _p, .8);
  sound_play_pitchvol(sndAssassinAttack, 1.7 * _p, 1.5);
  sound_play_pitchvol(sndCrystalShield,  2 * _p, 1);


  weapon_post(-_offset, _offset * 3 / 5, 0);
  sleep(5);

  with instance_create(x+lengthdir_x(_offset, gunangle), y+lengthdir_y(_offset, gunangle), CustomSlash){
      sprite_index = global.mskHexNeedle;
      mask_index   = global.mskHexNeedle;
      image_speed  = 2;
      image_alpha  = 0;

      team       = other.team;
      creator    = other;
      damage     = 16;
      force      = 4;
      can_fix    = false;
      canreflect = false;
      with instance_create(x, y, Wind){
        sprite_index = global.sprHexNeedleShank;
        image_angle = other.creator.gunangle;
        image_speed = .5;
      }

    direction = creator.gunangle + random_range(-8, 8) * creator.accuracy;
    speed = .0001;
    image_angle = direction;

    on_hit        = needle_hit;
    on_grenade    = needle_projectile;
    on_projectile = needle_projectile;
}

#define needle_hit
  var _e = other,
      _c = creator;
  if projectile_canhit_melee(_e) = true{
    if !instance_is(_e, prop) repeat(3) with instance_create((other.x*other.size+x)/(other.size+1),(other.y*other.size+y)/(other.size+1),determine_gore(other)){image_angle = random(360)}
    projectile_hit(_e, damage, force, direction);
    if _e.my_health <= 0 && !instance_is(_e, prop){
    	
    	repeat(3){
    		
    		with instance_create(other.x, other.y, other.object_index){
    			
    			raddrop = 0;
    			projectile_hit(self, maxhealth, 5 + irandom(5), random(360));
    		}
    	}
    	
        view_shake_at(x, y, 16);
        sleep(10 + min(_e.size, 3) * 12);


	    if other.my_health <= 0{
	        view_shake_at(x, y, 16);
            sleep(10 + min(_e.size, 3) * 12);

	    }
            /*sound_play(sndBloodlustProc);
            with _c{
               var _a = my_health < maxhealth,
                   _d = "+1 HP";
               if _a{
                   my_health++;
                }else{
                    _d = "MAX HP";
                }
                with instance_create(_c.x, _c.y, PopupText){
                    target = _c.index;
                    text   = _d;
                }
            }*/
        }
    }

#define needle_projectile
  with other instance_destroy();

#define determine_gore(_id) return mod_script_call("mod", "defpack tools", "determine_gore", _id);
