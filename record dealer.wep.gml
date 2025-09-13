#define init
global.sprRecordDealer    = sprite_add_weapon("sprites/weapons/sprRecordDealer.png",6,4)
global.sprRecordDealerHUD = sprite_add_weapon("sprites/weapons/sprRecordDealer.png",10,3)

global.sprVinyl           = sprite_add("sprites/projectiles/sprVinyl.png",2,7,7)
global.sprGoldVinyl       = sprite_add("sprites/projectiles/sprGoldVinyl.png",2,7,7)
global.sprStickyVinyl     = sprite_add("sprites/projectiles/sprStickyVinyl.png",2,7,7)
global.sprBouncerVinyl    = sprite_add("sprites/projectiles/sprBouncerVinyl.png",2,7,7)
global.sprMegaVinyl       = sprite_add("sprites/projectiles/sprMegaVinyl.png",2,12,12)
global.sprNTVinyl         = sprite_add("sprites/projectiles/sprNTVinyl.png",2,12,12)

// Contains all the disc creation functions:
global.DiscArray = [];
disc_add("weapon", mod_current, "create_disc");
disc_add("weapon", mod_current, "create_disc_gold");
disc_add("weapon", mod_current, "create_disc_sticky");
disc_add("weapon", mod_current, "create_disc_bouncer");
disc_add("weapon", mod_current, "create_disc_mega");

// Use this function to add your own disc firing scripts to this weapon:
#define disc_add(ModType, ModName, FunctionName)
    array_push(global.DiscArray, {
        type: ModType,
        name: ModName,
        func: FunctionName,
    })

#define weapon_name
return "RECORD DEALER";

#define weapon_type
return 3;

#define weapon_cost
return 2;

#define weapon_area
return 12;

#define weapon_load
return 32;

#define weapon_swap
return sndSwapBow;

#define weapon_auto
return false;

#define weapon_melee
return false;

#define weapon_laser_sight
return false;

#define weapon_sprt
return global.sprRecordDealer;

#define weapon_sprt_hud
return global.sprRecordDealerHUD;

#define nts_weapon_examine
return{
    "d": "The various symphonies of neverending pain. ",
}

#define weapon_text
return "WRITE A LOVE SONG";

#define weapon_fire
    sound_play_pitchvol(sndDiscgun, 1.2, .7);
    weapon_post(12, 28, 6);
	mod_script_call("mod", "defburst", "burst", 4, 2, self, script_ref_create(fire_burst))
	
#define fire_burst(_burst)

    // Set the disc:
   if "disc" not in _burst{
        _burst.disc = global.DiscArray[irandom(array_length_1d(global.DiscArray) - 1)];
        sound_play_slowdown(sndSuperDiscGun, .6);
        
        var c = instance_is(self, FireCont) ? creator : self;
        _burst.angle = c.gunangle;
    }
    
    with mod_script_call(_burst.disc.type, _burst.disc.name, _burst.disc.func, instance_is(self, FireCont) ? creator : self, x, y){
        direction = _burst.angle;
        image_angle = direction;
    }
    
#define create_disc(Creator, X, Y)

    with instance_create(X, Y, Disc){
        sprite_index = global.sprVinyl
        hitid = [sprite_index, "VINYL"];
        speed = 5;
        
        projectile_init(Creator.team, Creator);
        move_contact_solid(other.gunangle, min(sprite_width, 14));
        
        return self;
    }
    
#define create_disc_gold(Creator, X, Y)    
    with instance_create(X, Y, Disc){
        sprite_index = global.sprGoldVinyl
        hitid = [sprite_index, "GOLDEN VINYL"]
        speed = 8;
        
        projectile_init(Creator.team, Creator);
        move_contact_solid(other.gunangle, min(sprite_width, 14));
        
        return self;
    }
    
#define create_disc_sticky(Creator, X, Y)
    with mod_script_call_nc("mod", "defpack tools", "create_stickydisc", X, Y){
        sprite_index = global.sprStickyVinyl;
        hitid = [sprite_index, "STICKY VINYL"];
        speed = 4;
        orspeed = speed;
        
        projectile_init(Creator.team, Creator);
        move_contact_solid(other.gunangle, min(sprite_width, 14));
        
        return self;
    }
    
#define create_disc_bouncer(Creator, X, Y)
    with mod_script_call_self("mod", "defpack tools", "create_bouncerdisc", X, Y){
        sprite_index = global.sprBouncerVinyl;
        hitid = [sprite_index, "BOUNCER VINYL"];
        speed = 4;
        
        projectile_init(Creator.team, Creator);
        move_contact_solid(other.gunangle, min(sprite_width, 14));
        
        return self;
    }
    
#define create_disc_mega(Creator, X, Y)
    with mod_script_call_nc("mod", "defpack tools", "create_megadisc", X, Y){
        sprite_index = (irandom(99) == 0) ? global.sprNTVinyl : global.sprMegaVinyl
        hitid[0] = sprite_index
        hitid[1] = sprite_index = global.sprMegaVinyl ? "MEGA VINYL" : "THE NUCLEAR THRONE#SOUNDTRACK"
        speed = 4
        maxspeed = speed
        cansplat = false;
        hitid = [sprite_index, name];
        turn = 0;
        
        projectile_init(Creator.team, Creator);
        move_contact_solid(other.gunangle, min(sprite_width, 14));
        
        return self;
    }

#define sound_play_slowdown(_snd,_vol)
with instance_create(x,y,CustomObject){
  with instances_matching(CustomObject, "name", "record dealer sound"){
    instance_delete(self);
  }
  name = "record dealer sound";
  pitch = 1.7
  decel = random_range(.08, .125)
  p = random_range(.8,1.2)
  lifetime = pitch/decel + 1
  vol = _vol
  snd = _snd
  on_step = sound_step
  persistent = 1
}

#define sound_step
if frac(current_frame) < current_time_scale{
    pitch -= decel
    sound_play_pitchvol(snd, pitch*p, vol)
    lifetime -= 1
    if lifetime <= 0 {

      sound_stop(snd)
      instance_destroy()
    }
}
