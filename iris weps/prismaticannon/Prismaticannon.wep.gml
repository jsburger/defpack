
#define init
//guns
global.sprite = sprite_add_weapon("sprites/sprIrisWeapon.png",6,12)

//muzzleflashes
global.sprNormalFlash = sprite_add("sprites/sprNormalMuzzleflash.png", 1, 8, 8);

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
return 15;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapEnergy;

#define weapon_area
return -1; // gonna make the iris shrine drop this baby

#define weapon_text
if skill_get(prismaticiris){
    return mod_script_call("skill", mod_variable_get("skill", "prismaticiris", "color"), "skill_prismaticannon_text");
}
return "UNFOCUSED";

#define weapon_fire

    //pushback
    motion_add(gunangle,-2);
    //kick,shift,shake
    weapon_post(6, 8, 5);
    if (!skill_get("prismaticiris")){
        
        sound_play_pitchvol(sndPlasma,random_range(0.75,0.85),1.2);
    
        with mod_script_call("mod","PrismaticannonProjectiles","NormalBullet_Create",(x+lengthdir_x(13,gunangle)),y+lengthdir_y(13,gunangle)){
            creator = other
            team = other.team
            image_angle = direction
        }
        muzzle_create(global.sprNormalFlash);
    }else{
        
        mod_script_call("skill", mod_variable_get("skill", "prismaticiris", "color"), "skill_prismaticannon_fire");
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
