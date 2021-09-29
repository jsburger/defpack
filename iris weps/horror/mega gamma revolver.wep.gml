#define init
global.sprMegaHorrorRevolver    = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprMegaHorrorRevolverOn.png", -1, 3);
global.sprMegaHorrorRevolverHUD = sprite_add("../../sprites/interface/sprMegaHorrorRevolverOnHUD.png", 1, -1, 3);
global.sprMegaHorrorBullet   = sprite_add("../../sprites/projectiles/iris/horror/sprMegaHorrorBullet.png",2,18,18)
#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)
#define weapon_name
return "MEGA GAMMA REVOLVER";

#define weapon_sprt
return global.sprMegaHorrorRevolver;

//#define weapon_sprt_hud
//return global.sprMegaHorrorRevolverHUD;

#define weapon_type
return 1;

#define weapon_auto
return 0;

#define weapon_load
return 8;

#define weapon_cost
return 5;

#define weapon_swap
if instance_is(self, Player){
	view_shake_at(x, y, 20);
	sleep(10);
}
sound_play_pitchvol(sndBasicUltra, 1.2, .6);
sound_play_pitch(sndSwapPistol, .9);
return -4;


#define weapon_melee
return 0;

#define weapon_area
return -1;

#define weapon_text
return "TOO BIG FOR THE HOLSTER"

#define weapon_iris
return "mega x revolver"

#define weapon_fire
weapon_post(9,-40,30)
motion_add(gunangle-180,3)
mod_script_call("mod","defpack tools", "shell_yeah_big", 100, 12, 4+random(1), c_lime)
sound_play_pitch(sndSawedOffShotgun,random_range(.5,.6))
sound_play_pitch(sndHeavySlugger,random_range(.5,.7))
sound_play_pitch(sndUltraPistol,random_range(1.2,1.4))
sound_play_gun(sndClickBack,1,0)
sound_stop(sndClickBack)
repeat(2)with instance_create(x,y,CustomProjectile)
{
    name = "mega gamma bullet"
    typ = 1
    sprite_index = global.sprMegaHorrorBullet
    mask_index = mskHeavyBullet
    recycle_amount = 5
    damage = 2
    team = other.team
    force = 16
    frames = 16
    image_speed = 1
    defbloom = {
        xscale : 2,
        yscale : 2,
        alpha : .1
    }
    creator = other
    move_contact_solid(other.gunangle,12)
    motion_add(other.gunangle+random_range(-12,12)*other.accuracy,20)
    image_angle = direction
    on_destroy = mega_destroy
    on_wall    = mega_wall
    on_anim    = mega_anim
    on_step    = mega_step
    on_hit     = mega_hit
    repeat(4)with instance_create(x+lengthdir_x(5,direction),y+lengthdir_y(5,direction),Smoke){
        gravity = -.1
        image_xscale /=2
        image_yscale/=2
    }
}

#define mega_step
with instances_matching_ne(projectile, "team", team){
	if distance_to_object(other) <= 0{
		instance_destroy()
	}
}

#define mega_hit
if current_frame_active{
    x -= lengthdir_x(speed / 5, direction) * clamp(other.size, 2, 4)
    y -= lengthdir_y(speed / 5, direction) * clamp(other.size, 2, 4)
    frames--
    if skill_get(mut_recycle_gland) and recycle_amount > 0 and irandom(9) < 5{
        instance_create(x, y, RecycleGland)
        sound_play(sndRecGlandProc)
        recycle_amount -= 1
        with creator ammo[1] = min(ammo[1] + 1, typ_amax[1])
    }
    repeat(3) instance_create(x+random_range(-8,8),y+random_range(-8,8),Smoke)
    if current_frame mod 2 <= current_time_scale {
    	projectile_hit(other,damage,force,direction)
    	sleep(3)
    	view_shake_at(x,y,5)
    }
    if frames <= 0 instance_destroy()
}

#define mega_wall
with other{instance_create(x,y,FloorExplo);instance_destroy()}
instance_destroy()

#define mega_destroy
repeat(3)
{
  instance_create(x+random_range(-8,8),y+random_range(-8,8),Smoke)
}
with instance_create(x,y,BulletHit){sprite_index = sprSlugHit;image_index = 1}

#define mega_anim
image_index = 1
image_speed = 0
sleep(15)

#define step
  //with instances_matching(Player, "wep", mod_current){speed *= min(1, .8 + .2 * (skill_get(mut_extra_feet)))}
  //with instances_matching(instances_matching(Player, "race", "steroids"), "bwep", mod_current){speed *= min(1, .8 + .2 * (skill_get(mut_extra_feet)))}
