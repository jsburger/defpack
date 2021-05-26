#define init
global.sprMegaFireRevolver    = sprite_add_weapon("../../sprites/weapons/iris/fire/sprMegaFireRevolver.png", -1, 3);
global.sprMegaFireRevolverHUD = sprite_add("../../sprites/interface/sprMegaFireRevolverHUD.png", 1, -1, 3);
global.sprMegaFireBullet   = sprite_add("../../sprites/projectiles/iris/fire/sprMegaFireBullet.png",3,18,18)
#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)
#define weapon_name
return "MEGA FIRE REVOLVER";

#define weapon_sprt
return global.sprMegaFireRevolver;

#define weapon_sprt_hud
return global.sprMegaFireRevolverHUD;

#define weapon_type
return 1;

#define weapon_auto
return 0;

#define weapon_load
return 10;

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
return "BRANDISH THE GIANTS"

#define weapon_fire
weapon_post(9,-40,30)
motion_add(gunangle-180,3)
var _p = random_range(.8,1.2)
mod_script_call("mod","defpack tools", "shell_yeah_big", 100, 12, 4+random(1), c_red)
sound_play_pitch(sndDoubleFireShotgun,.7*_p)
sound_play_pitch(sndIncinerator,.7*_p)
sound_play_pitch(sndSawedOffShotgun,.5*_p)
sound_play_pitch(sndHeavySlugger,.8*_p)
sound_play_gun(sndClickBack,1,0)
sound_stop(sndClickBack)
with instance_create(x,y,CustomProjectile)
{
    name = "mega fire bullet"
    typ = 1
    sprite_index = global.sprMegaFireBullet
    mask_index = mskHeavyBullet
    image_speed = 0;
    recycle_amount = 5
	damage = 5
	falloff = 5
	fallofftime = current_frame + 5
    team = other.team
    defbloom = {
        xscale : 2,
        yscale : 2,
        alpha : .1
    }
	defbloom.alpha = .2
    force = 12
    frames = 6
    timer  = 3
    creator = other
    move_contact_solid(other.gunangle,12)
    motion_add(other.gunangle+random_range(-10,10)*other.accuracy,20)
    image_angle = direction
    on_destroy = mega_destroy
    on_wall    = mega_wall
    on_anim    = mega_anim
    on_step    = mega_step
    on_hit     = mega_hit
}
#define mega_hit
if current_frame_active{
  mod_script_call("mod","defpack tools","create_miniexplosion",x,y)
    frames--
    if skill_get(mut_recycle_gland) and recycle_amount > 0 and irandom(9) < 5{
        instance_create(x, y, RecycleGland)
        sound_play(sndRecGlandProc)
        recycle_amount -= 1
        with creator ammo[1] = min(ammo[1] + 1, typ_amax[1])
    }

    repeat(2) instance_create(x+random_range(-8,8),y+random_range(-8,8),Smoke)
    projectile_hit(other,damage,force,direction)
    sleep(5)
    view_shake_at(x,y,12)
    if frames <= 0 instance_destroy()
}

#define mega_wall
with other{instance_create(x,y,FloorExplo);instance_destroy()}
instance_destroy()

#define mega_destroy
instance_create(x,y,SmallExplosion)
sound_play(sndExplosionS)
repeat(3) instance_create(x+random_range(-8,8),y+random_range(-8,8),Smoke)
with instance_create(x,y,BulletHit){sprite_index = sprSlugHit;image_index = 1}

#define mega_step

if (fallofftime >= current_frame){
	image_index = 1;
}
if (fallofftime < current_frame && defbloom.alpha != .1) {
	defbloom.alpha = .1;
	image_index = 2;
	repeat(16){
		with instance_create(x, y, Flame){
			team = other.team;
			creator = other.creator;
			motion_add(random(360), random_range(8,10))
			friction = .7;
		}
	}
}

if timer > 0 timer -= current_time_scale
else if current_frame_active
{
  repeat(3)
  with instance_create(x+random_range(-4,4),y+random_range(-4,4),Flame)
  {
    team = other.team
    motion_add(other.direction-180+random_range(-32,32),choose(2,3,3,3,4,4,5))
  }
}

#define mega_anim
image_index = 1
image_speed = 0
sleep(15)

#define step
  with instances_matching(Player, "wep", mod_current){speed *= min(1, .8 + .2 * (skill_get(mut_extra_feet)))}
  with instances_matching(instances_matching(Player, "race", "steroids"), "bwep", mod_current){speed *= min(1, .8 + .2 * (skill_get(mut_extra_feet)))}
