#define init
global.sprMegaRevolver = sprite_add_weapon("sprites/sprMegaRevolver.png", -1, 3);
global.sprMegaBullet   = sprite_add("sprites/projectiles/sprMegaBullet.png",2,18,18)
#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)
#define weapon_name
return "MEGA REVOLVER";

#define weapon_sprt
return global.sprMegaRevolver;

#define weapon_type
return 1;

#define weapon_auto
return 0;

#define weapon_load
return 8;

#define weapon_cost
return 5;

#define weapon_swap
return sndSwapPistol

#define weapon_melee
return 0;

#define weapon_area
return 14;

#define weapon_text
return "TOO BIG FOR THE HOLSTER"

#define weapon_fire
weapon_post(7,0,28)
sleep(5)
motion_add(gunangle-180,3)
mod_script_call("mod","defpack tools", "shell_yeah_big", 100, 12, 4+random(1), c_yellow)
sound_play_pitch(sndSawedOffShotgun,random_range(.6,.7))
sound_play_pitch(sndHeavySlugger,random_range(.7,.9))
with instance_create(x,y,CustomProjectile)
{
    typ = 1
    sprite_index = global.sprMegaBullet
    mask_index = mskHeavyBullet
    recycle_amount = 5
    damage = 6
    team = other.team
    force = 16
    frames = 6
    image_speed = 1
    creator = other
    move_contact_solid(other.gunangle,12)
    motion_add(other.gunangle+random_range(-3,3)*other.accuracy,20)
    image_angle = direction
    on_destroy = mega_destroy
    on_wall    = mega_wall
    on_anim    = mega_anim
    on_draw    = mega_draw
    on_hit     = mega_hit
    repeat(4)with instance_create(x+lengthdir_x(5,direction),y+lengthdir_y(5,direction),Smoke){
        gravity = -.1
        image_xscale /=2
        image_yscale/=2
    }
}
#define mega_hit
if current_frame_active{
    frames--
    repeat(3) instance_create(x+random_range(-8,8),y+random_range(-8,8),Smoke)
    projectile_hit(other,damage,force,direction)
    sleep(30)
    view_shake_at(x,y,12)
    if frames <= 0 instance_destroy()
}

#define mega_wall
with other{instance_create(x,y,FloorExplo);instance_destroy()}
instance_destroy()

#define mega_destroy
repeat(3) instance_create(x+random_range(-8,8),y+random_range(-8,8),Smoke)
with instance_create(x,y,BulletHit){sprite_index = sprSlugHit;image_index = 1}

#define mega_anim
image_index = 1
image_speed = 0

#define mega_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.1);
draw_set_blend_mode(bm_normal);
