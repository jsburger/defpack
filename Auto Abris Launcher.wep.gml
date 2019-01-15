#define init
global.sprAutoAbrisLauncher = sprite_add_weapon("sprites/sprAutoAbrisLauncher.png", 0, 2);
global.stripes 							= sprite_add("defpack tools/BIGstripes.png",1,1,1)

#define weapon_name
return "AUTO ABRIS LAUNCHER"

#define weapon_sprt
return global.sprAutoAbrisLauncher;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 13;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 10;

#define weapon_reloaded
weapon_post(-1,-3,0)
sound_play_pitchvol(sndNadeReload,1.4,.6)

#define weapon_text
return "RECOVERY FUEL";

#define weapon_fire
var _strtsize = 30;
var _endsize  = 14;
sound_play_pitch(sndSniperTarget,3)
with mod_script_call("mod","defpack tools","create_abris",self,_strtsize,_endsize,argument0){
	accspeed = 1.2
	payload = script_ref_create(pop)
	auto = 1
	damage = 3
	maxdamage = 7
}
sound_play_pitch(sndSniperTarget,1/accuracy+3)

#define pop
sound_play_pitch(sndGrenadeRifle,random_range(.5,.8))
sound_play_pitch(sndGrenadeShotgun,random_range(.5,.8))
sound_play(sndExplosionS)
with creator weapon_post(5,25,5)
instance_create(explo_x+lengthdir_x(acc,offset),explo_y+lengthdir_y(acc,offset),Explosion)
repeat(3)
{
	instance_create(explo_x+lengthdir_x(acc+12,offset),explo_y+lengthdir_y(acc+12,offset),SmallExplosion)
	offset = random(360)
}
/*#define weapon_fire
with instance_create(x,y,CustomObject)
{
	creator = other
	index = creator.index
	accbase = 55*creator.accuracy
	acc = accbase
	on_step = GoldenAbrisPistol_step
	on_draw = GoldenAbrisPistol_draw
	lasercolour1 = c_red
	lasercolour = lasercolour1
	lasercolour2 = c_maroon
}
#define GoldenAbrisPistol_step
if instance_exists(creator)
{
	image_angle += 5
	creator.reload = 2
	acc /= 1.93
	//else{acc /= 3.5}
	x = creator.x
	y = creator.y
	offset = random(359)
	if collision_line(x,y,explo_x,explo_y,Wall,0,0) >= 0
	{
		if acc < accbase{acc += abs(creator.accuracy*3)}else{acc = accbase}
	}
	if acc <= 0.09
	{
		if creator.ammo[4] >= 2
		{
			if creator.infammo = 0{creator.ammo[4] -= 2}
			if collision_line(x,y,explo_x,explo_y,Wall,0,0) < 0
			{
				sound_play(sndGrenadeRifle)
				sound_play(sndExplosionS)
				creator.wkick = 5
				repeat(3)
				{
					instance_create(explo_x+lengthdir_x(acc+12,offset),explo_y+lengthdir_y(acc+12,offset),SmallExplosion)
					offset = random(360)
				}
				instance_create(explo_x+lengthdir_x(acc,offset),explo_y+lengthdir_y(acc,offset),Explosion)
			}
			else
			{
				if creator.infammo = 0{creator.ammo[4] += 2}
			}
		}
	instance_destroy()
	}
}
else{instance_destroy()}

#define GoldenAbrisPistol_draw
if creator.ammo[4] < 1{instance_destroy()}
else
if instance_exists(creator)
{
	if collision_line(x,y,explo_x,explo_y,Wall,0,0) < 0
	{
		lasercolour = merge_colour(lasercolour1,lasercolour,.11)
		draw_line_width_colour(x,y,explo_x,explo_y,1,lasercolour,lasercolour);
		mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,acc,1,acc+image_angle,explo_x,explo_y,lasercolour1,1*(accbase-acc))
		mod_script_call("mod", "defpack tools","draw_polygon_striped", 2, acc,acc-image_angle, explo_x+1, explo_y+1, global.stripes, lasercolour,(accbase-acc)/(accbase*6));
	}
	else
	{
		var hitwall = collision_line(x,y,explo_x,explo_y,Wall,0,0)//there is currently a bug where this chooses the furthest wall if you aim through multiple walls pls fix
	}
	lasercolour = merge_colour(lasercolour,lasercolour2,.33)
	draw_line_width_colour(x,y,x+lengthdir_x(point_distance(x,y,hitwall.x,hitwall.y),creator.gunangle),y+lengthdir_y(point_distance(x,y,hitwall.x,hitwall.y),creator.gunangle),1,lasercolour,lasercolour)
	if weapon_get_name(creator.wep) != "AUTO ABRIS LAUNCHER"{instance_destroy()}
}
