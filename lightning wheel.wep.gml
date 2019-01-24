#define init
global.sprLightningWheel        = sprite_add_weapon("sprites/sprLightningWheel.png",9,8);
global.sprLightningWheelHUD     = sprite_add_weapon("sprites/sprLightningWheel.png",3,5);
global.sprLightningWheelProj    = sprite_add("sprites/sprLightningWheelProj.png",2,10,10);
global.sprLightningWheelProjUpg = sprite_add("sprites/sprLightningWheelProjUpg.png",2,13,13);

#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)

#define weapon_name
return "LIGHTNING WHEEL";

#define weapon_sprt_hud
return global.sprLightningWheelHUD;

#define weapon_type
return 5;

#define weapon_chrg
return 1;

#define weapon_cost
return 1;

#define weapon_area
return 2;

#define weapon_load
return 16;//???

#define weapon_swap
return sndSwapHammer;

#define weapon_auto
return false;

#define weapon_melee
return true;

#define weapon_laser_sight
return false;

#define weapon_fire
var _p = random_range(.8,1.2);
sound_play_pitch(sndChickenThrow,_p)
sound_play_pitch(sndAssassinHit,1.2*_p)
sound_play_gun(sndClickBack,1,.4)
sound_stop(sndClickBack)
if !skill_get(17)
{
  sound_play_pitch(sndLightningShotgun,2*_p)
  sound_play_pitch(sndEnergyScrewdriver,.7*_p)
}
else
{
  sound_play_pitch(sndLightningShotgunUpg,2*_p)
  sound_play_pitch(sndEnergyScrewdriverUpg,1.4*_p)

}
with instance_create(x,y,CustomObject){
    team = other.team
    creator = other
    sprite_index = skill_get(mut_laser_brain) ? global.sprLightningWheelProjUpg : global.sprLightningWheelProj
    mask_index = sprMapDot
    image_speed = .4
    curse = other.curse
    wep = other.wep
    other.curse = 0
    other.wep = 0
    maxspeed = 14 + skill_get(mut_long_arms)*6
    phase = 0
    ang = 0
    image_alpha = 0
    friction = 1.2
    timer[0] = 15 //ammo timer
    timer[1] = 3-skill_get(mut_laser_brain)
    btn = other.specfiring ? "spec" : "fire"
    damage = 3
    force = 2
    motion_add(other.gunangle, 14)
    grabbed = 0
    walled = 0
    with instances_matching_ne(hitme, "team", team){
        if distance_to_object(other) <=14+speed+skill_get(mut_laser_brain)*6{
            direction = other.direction
            sleep(20)
            view_shake_at(x,y,5)
            with other{
                projectile_hit(other, damage, force, point_direction(x,y,other.x,other.y))
            x -= hspeed*2/3
            y -= vspeed*2/3
          }
        }
    }
    on_end_step = lring_step
    on_draw = boom_draw
    on_destroy = lring_destroy

    with instance_create(x,y,MeleeHitWall) image_angle = other.direction + 180
}

#define chance(percent)
return (random(100) <= percent * current_time_scale)

#define lring_destroy
if !grabbed{
    with instance_create(x,y,WepPickup){
        wep = other.wep
        curse = other.curse
        motion_add(other.direction + random_range(-20,20), 2)
        sprite_index = global.sprLightningWheel
    }
}


#define lring_step
if !instance_exists(creator){
    instance_destroy()
    exit
}
if speed <= friction and chance(17 + 5*skill_get(mut_laser_brain)){
    sound_play_pitchvol(sndLightningReload,random_range(.8,1.2),.2*(1-distance_to_object(creator)/200))
    if chance(100) {
        with instance_create(x,y,Lightning){
            image_angle = random(360)
            direction = image_angle
            team = other.team
            creator = other.creator
            ammo = choose(2,4) + 2*skill_get(mut_laser_brain)
            alarm0 = 1
            visible = 0
            with instance_create(x ,y, LightningHit) image_angle = other.image_angle
        }
    }
}
var _m = 0
if speed > friction _m = 1 else _m = 6
var _d = random(360)
var _s = random_range(4,9)
if chance(3) with instance_create(x+lengthdir_x(_s, _d), y+lengthdir_y(_s, _d), LightningSpawn) image_angle = _d

if current_frame mod _m < current_time_scale{
    if skill_get(17){sound_play_pitchvol(sndPlasmaBigExplodeUpg,1,.1*(1-distance_to_object(creator)/200))}
    sound_play_pitchvol(sndBouncerBounce,.1,(1-distance_to_object(creator)/200))
    sound_play_pitchvol(sndGrenadeHitWall,.1,.15*(1-distance_to_object(creator)/200))
}

if timer[1] > 0 timer[1] -= current_time_scale
else{
    timer[1] = _m
    with instances_matching_ne(hitme, "team", team){
        if distance_to_object(other) <=14+speed+skill_get(mut_laser_brain)*6{
            direction = other.direction
            sleep(20)
            view_shake_at(x,y,5)
            with other{
                if _m = 3 damage = 2 else damage = 3
                projectile_hit(other, damage, force, point_direction(x,y,other.x,other.y))
            x -= hspeed*2/3
            y -= vspeed*2/3
          }
        }
    }
}
with instances_matching_ne(projectile, "team", team){
    if distance_to_object(other) <= 7+skill_get(mut_laser_brain)*2{
        if typ instance_destroy()
    }
}

if curse and current_frame_active instance_create(x + random_range(-5,5), y + random_range(-5, 5), Curse)
ang += 18 * current_time_scale

if phase = 0 and speed <= friction{
    if button_check(creator.index, btn) and creator.mask_index != mskNone{
        speed = 0
        ang += 10 * current_time_scale
        if timer[0] > 0 timer[0] -= current_time_scale
        else{
            timer[0] = 10
            if creator.infammo = 0{
                if creator.ammo[5] > 0{
                    creator.ammo[5]--
                    var angl = point_direction(creator.x, creator.y, x, y)
                    if fork(){
                        repeat(irandom_range(1,4)){
                            if !instance_exists(self) || !instance_exists(creator) exit
                            with mod_script_call_self("mod", "defparticles", "create_spark", creator.x+random_range(-4,4), creator.y+random_range(-4,4)){
                                color = c_blue
                                fadecolor = c_aqua
                                gravity = 0
                                var n = irandom_range(5,9)
                                fadespeed = .2 + random(.4)
                                age = n
                                motion_set(angl, point_distance(x,y,other.x,other.y)/n)
                            }
                            wait(1)
                        }
                        exit
                    }
                }
                else{
                    instance_destroy()
                    exit
                }
            }
        }
    }
    else{
        phase = 1
        friction *= -1
    }
}
if phase = 1{
    motion_add(point_direction(x, y, creator.x, creator.y), 14*current_time_scale)
    if point_distance(creator.x, creator.y, x, y) < 24 + 6*skill_get(mut_long_arms){
      grabbed = true
      var _r = weapon_get_load(mod_current)
      if creator.wep  = 0{creator.reload += _r;sleep(30);creator.curse = curse;sound_play(sndSwapHammer);instance_create(x,y,WepSwap);creator.wep = mod_current;instance_destroy();exit}
      if creator.bwep = 0{creator.breload += _r;sleep(30);creator.bcurse = curse;sound_play(sndSwapHammer);instance_create(x,y,WepSwap);creator.bwep = mod_current;instance_destroy();exit}
        else if creator.wep = 0{
            instance_destroy()
            exit
        }
        if creator.wep != 0 && creator.bwep != 0
        {
          with instance_create(x,y,ThrownWep)
          {
            sprite_index = global.sprLightningWheel
            wep = mod_current
            curse = other.curse
            motion_add(other.direction-180+random_range(-30,30),2)
            team = other.team
            creator = other.creator
          }
          instance_destroy()
          exit
        }
    }
}
speed = min(speed, maxspeed)
if place_meeting(x+hspeed, y + vspeed, Wall){
    if collision_line(x,y,creator.x, creator.y, Wall, 0, 0){
        instance_destroy()
        exit
    }
    else speed = 0
}
if place_meeting(x,y,Wall){x -= lengthdir_x(speed * 2,direction);y -= lengthdir_y(speed * 2,direction)}

#define lring_projectile
with other if typ{
    instance_destroy()
}

#define weapon_sprt
return global.sprLightningWheel

#define weapon_text
return choose("HOLD FIRE TO HOLD THE SPIN","TESLA COIL")

#define boom_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, ang, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, (1.5+skill_get(17)*.16)*image_xscale, (1.5+skill_get(17)*.16)*image_yscale, ang, image_blend, 0.15);
draw_set_blend_mode(bm_normal);
