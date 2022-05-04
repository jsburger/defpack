
#define init
//guns
global.sprite = sprite_add_weapon("sprites/sprIrisWeapon.png",6,12)

//muzzleflashes
global.sprNormalFlash = sprite_add("sprites/sprNormalMuzzleflash.png", 1, 8, 8);
global.sprPestFlash = sprite_add("sprites/sprPestMuzzleflash.png", 1, 8, 8);
global.sprFireFlash = sprite_add("sprites/sprFlameMuzzleflash.png", 1, 8, 8);
global.sprPsyFlash = sprite_add("sprites/sprPsyMuzzleflash.png", 1, 8, 8);
global.sprBouncyFlash = sprite_add("sprites/sprBouncyMuzzleflash.png", 1, 8, 8);
global.sprLightningFlash = sprite_add("sprites/sprLightningMuzzleflash.png", 1, 8, 8);
global.sprGammaFlash = sprite_add("sprites/sprGammaMuzzleflash.png", 1, 8, 8);

#define weapon_name
return "PRISMATICANNON";

#define weapon_sprt
if (mod_exists("skill", "prismaticiris") && skill_get("prismaticiris") > 0) return mod_script_call("skill", mod_variable_get("skill", "prismaticiris", "color"), "skill_prismaticannon_sprite")
return global.sprite

#define weapon_type
return 5;

#define weapon_auto
return true;

#define weapon_load
return 10;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return -1; // gonna make the iris shrine drop this baby

#define weapon_text
if !skill_get(prismaticiris){
  return "UNFOCUSED";
}
switch mod_variable_get("skill", "prismaticiris", "color"){
    case "quiveringsight": return "@yREFRACTIONS";
    case "blazingvisage" : return "@rSMELTER";
    case "pestilentgaze" : return "@gTOXIC BUBBLES";
    case "cloudedstare"  : return "@bTHUNDERCLOUDS";
    case "allseeingeye"  : return "@pTHE EYE";
    case "fantasticrefractions" : return "@wRAINBOW";
}

#define weapon_fire

  //pushback
  motion_add(gunangle,-2);
  //kick,shift,shake
  weapon_post(6, 8, 5);

  var _iris = mod_variable_get("skill", "prismaticiris", "color"),
      _icol = 0;
  switch _iris{
    case "fantasticrefractions":  _icol = irandom(5); break;
    case "quiveringsight"      : _icol = 0; break;
    case "blazingvisage"       : _icol = 1; break;
    case "pestilentgaze"       : _icol = 2; break;
    case "cloudedstare"        : _icol = 3; break;
    case "allseeingeye"        : _icol = 4; break;
    case "warpedperspective"   : _icol = 5; break;
    default : _icol = 6; break;
  }

  if !skill_get("prismaticiris"){_icol = 6}

  switch _icol{
    case 0: // Bouncer
      sound_play_pitchvol(sndPlasma,random_range(0.75,0.85),1);
      sound_play_pitchvol(sndBouncerShotgun,random_range(0.7,0.8),0.8)

      with mod_script_call("mod","PrismaticannonProjectiles","BouncyBullet_Create",(x+lengthdir_x(13,gunangle)),y+lengthdir_y(13,gunangle)){
        creator = other
        team = other.team
        image_angle = direction
      }
      muzzle_create(global.sprBouncyFlash);
      break;

    case 1: // Fire
      sound_play_pitchvol(sndPlasma,random_range(0.75,0.85),1);
      sound_play_pitchvol(sndBurn,random_range(0.95,1),1);

      with mod_script_call("mod","PrismaticannonProjectiles","FlameBullet_Create",(x+lengthdir_x(13,gunangle)),y+lengthdir_y(13,gunangle)){
    		creator = other
    		team = other.team
    		image_angle = direction
    	}
      muzzle_create(global.sprFireFlash);
      break;

    case 2: // Pest
      sound_play_pitchvol(sndPlasma,random_range(0.75,0.85),1);
      sound_play_pitchvol(sndToxicBoltGas,random_range(0.95,1),1);

      with mod_script_call("mod","PrismaticannonProjectiles","PestBullet_Create",(x+lengthdir_x(13,gunangle)),y+lengthdir_y(13,gunangle)){
    		creator = other
    		team = other.team
    		image_angle = direction
    	}
      muzzle_create(global.sprPestFlash);
      break;

    case 3: // Thunder
      sound_play_pitchvol(sndPlasma,random_range(0.75,0.85),1);
      sound_play_pitchvol(skill_get(mut_laser_brain) > 0 ? sndLightningPistolUpg : sndLightningPistol,random_range(0.7,0.8),0.8)

      with mod_script_call("mod","PrismaticannonProjectiles","LightningBullet_Create",(x+lengthdir_x(13,gunangle)),y+lengthdir_y(13,gunangle)){
        creator = other
        team = other.team
        image_angle = direction
      }
      muzzle_create(global.sprLightningFlash);
      break;

    case 4: // Psy
      sound_play_pitchvol(sndPlasma,random_range(0.75,0.85),1);
      sound_play_pitchvol(sndSwapCursed,random_range(1.4,1.7),1.5);

      with mod_script_call("mod","PrismaticannonProjectiles","PsyBullet_Create",(x+lengthdir_x(13,gunangle)),y+lengthdir_y(13,gunangle)){
    		creator = other
    		team = other.team
    		image_angle = direction
    	}
      muzzle_create(global.sprPsyFlash);
      break;

    case 5: // Gamma
      sound_play_pitchvol(sndPlasma,random_range(0.75,0.85),1.2);
      sound_play_pitchvol(sndRadPickup,random_range(0.85,1),1.7);
      sound_play_pitchvol(sndUltraPistol,random_range(2.5,3),.7);

      with mod_script_call("mod","PrismaticannonProjectiles","GammaBullet_Create",(x+lengthdir_x(13,gunangle)),y+lengthdir_y(13,gunangle)){
    		creator = other
    		team = other.team
    		image_angle = direction
    	}
      muzzle_create(global.sprGammaFlash);
      break;

      case 6: // Normal
        sound_play_pitchvol(sndPlasma,random_range(0.75,0.85),1.2);

        with mod_script_call("mod","PrismaticannonProjectiles","NormalBullet_Create",(x+lengthdir_x(13,gunangle)),y+lengthdir_y(13,gunangle)){
          creator = other
          team = other.team
          image_angle = direction
        }
        muzzle_create(global.sprNormalFlash);
        break;
  }

//Muzzleflash Scripts
#define muzzle_create(SPRITE)
  with instance_create(x+lengthdir_x(15,gunangle),y+ lengthdir_y(15,gunangle),CustomObject)
  {
    depth = -1
    sprite_index = SPRITE;
    image_speed = 0.9;
    image_xscale = 1.4;
    image_yscale = image_xscale;
    on_step = muzzle_step
    on_draw = muzzle_draw
    image_angle = other.gunangle
    flashtimer = 0;
  }

#define muzzle_step
  flashtimer +=1;
  if flashtimer > 1 instance_destroy()

#define muzzle_draw
  draw_set_blend_mode(bm_add);
  draw_sprite_ext(sprite_index, image_index, x, y, 1.2*image_xscale, 1.2*image_yscale, image_angle, image_blend, 0.1);
  draw_set_blend_mode(bm_normal);
