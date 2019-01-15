#define init
global.sprSmarterGun 	  = sprite_add_weapon("sprites/sprSmarterGun.png",9,7)
global.sprSmarterGunHUD = sprite_add_weapon("sprites/sprSmarterGun.png",1,4)
#define weapon_name
return "SMARTER GUN"
#define weapon_type
return 1
#define weapon_cost
return 0
#define weapon_area
return 15
#define weapon_load
return 4
#define weapon_swap
return sndSwapMachinegun
#define weapon_auto
return 1
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire
if instance_is(self,Player){
    if ammo[weapon_type()] >= 1 or infammo != 0 reload -= weapon_load()
}
#define shoot(_x,_y,angle)
weapon_post(0,0,5)
sound_play_gun(sndSmartgun,.1,.7)
sound_play_gun(sndHitMetal,1.7,.1)
sound_play_pitch(sndGruntFire,random_range(1.2,1.4))
with instance_create(_x,_y,Bullet1)
{
	sprite_index = sprIDPDBullet
	creator = other
	team = other.team
	motion_set(angle,16)
	image_angle = direction
}
if infammo = 0 ammo[1]--

#define step(w)
if w && reload <= 0 && (ammo[1] || infammo != 0){
    var _truex = x+sprite_get_width(sprite_index)/2-wkick*right;
	var _truey = y-8+sin(current_frame/10)*5;
	var _canshoot = button_check(index,"fire");
	var ang = gunangle;
    if instance_exists(enemy){
		var target = instance_nearest(_truex,_truey,enemy);
		if !collision_line(_truex,_truey,target.x,target.y,Wall,0,0) and !collision_line(_truex,_truey,target.x,target.y,PopoShield,0,0){
		    _canshoot = 1
		    ang = point_direction(_truex,_truey,target.x+target.hspeed,target.y+target.vspeed);
		}
    }
    if _canshoot {
        wkick = 2
        reload = weapon_load()
        shoot(_truex,_truey,ang)
    }
}
if !w && breload <= 0 && (ammo[1] || infammo != 0){
    var _truex = x-sprite_get_width(sprite_index)/2-bwkick*right;
	var _truey = y-8-sin(current_frame/10)*5;
	var _canshoot = 0;
	if race = "steroids" _canshoot = button_check(index,"spec")
	var ang = gunangle;
    if instance_exists(enemy){
		var target = instance_nearest(_truex,_truey,enemy);
		if !collision_line(_truex,_truey,target.x,target.y,Wall,0,0) and !collision_line(_truex,_truey,target.x,target.y,PopoShield,0,0){
		    _canshoot = 1
		    ang = point_direction(_truex,_truey,target.x+target.hspeed,target.y+target.vspeed);
		}
    }
    if _canshoot {
        bwkick = 2
        breload = weapon_load()
        shoot(_truex,_truey,ang)
    }
}

if !w && race != "steroids" && breload > 0{
	breload -= current_time_scale * reloadspeed
	if skill_get(mut_stress) breload -= (1 - my_health/maxhealth) * current_time_scale
	if race = "venuz"
	{
		breload -= .2 * current_time_scale
		if ultra_get(race,1) breload -= .4 * current_time_scale
	}
}


#define weapon_sprt_hud
return global.sprSmarterGunHUD

#define weapon_sprt(w)
if instance_is(self,Player)
{
	if wep = w{
		draw_sprite_ext(global.sprSmarterGun,0,x+sprite_get_width(sprite_index)/2-wkick*right,y-8+sin(current_frame/10)*5,right,1,0,c_white,1)
	}
	if bwep = w
	{
		draw_sprite_ext(global.sprSmarterGun,0,x-sprite_get_width(sprite_index)/2-bwkick*right,y-8+sin(current_frame/-10)*5,right,1,0,c_white,1)
	}
	return mskNothing
}
else{return global.sprSmarterGun}


#define weapon_text
return "massive brain"
