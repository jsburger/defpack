#define init
global.sprPlasmaAbrisLauncher = sprite_add_weapon("sprites/sprPlasmaAbrisLauncher.png", 0, 3);
global.stripes 								= sprite_add("defpack tools/BIGstripes.png",1,1,1)

#define weapon_name
return "PLASMA ABRIS LAUNCHER"

#define weapon_sprt
return global.sprPlasmaAbrisLauncher;

#define weapon_type
return 5;

#define weapon_auto
return false;

#define weapon_load
return 19;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 6;

#define weapon_text
return "HUMORON";

#define weapon_fire
var _strtsize = 12;
var _endsize  = 12;
with mod_script_call("mod","defpack tools","create_abris",self,_strtsize,_endsize,argument0)
{
	circlemass = 8 + skill_get(17)*6
	accspeed = .9
	maxradius = 70
	payload = script_ref_create(pop)
	lasercolour1 = $00FF00
	lasercolour = lasercolour1
	lasercolour2 = $00AF00
	offset2 = random(360)
	on_draw = abris_draw_plasma
}
sound_play_pitch(sndSniperTarget,exp((_strtsize-_endsize)/room_speed/current_time_scale/accuracy*(1.14)))

#define pop
sound_play(sndPlasma)
sound_play_pitch(sndPlasmaHit,random_range(1.2,1.4))
if !skill_get(17){sound_play_pitch(sndPlasmaBigExplode,1.2)}
creator.wkick = 4
repeat(circlemass)
{
	with instance_create(explo_x+lengthdir_x(acc+16+6,offset2),explo_y+lengthdir_y(acc+16+6,offset2),PlasmaImpact)
	{
		image_xscale = .5
		image_yscale = .5
		image_speed = random_range(.3,.7)
		if !place_meeting(x,y,Floor){instance_destroy()}
	}
	offset2 += 360/circlemass
}

#define abris_draw_plasma
if instance_exists(creator) && check{
	x = creator.x
	y = creator.y
	if mod_script_call("mod","defpack tools","collision_line_first",x,y,mouse_x[index],mouse_y[index],Wall,0,0) > -4
	{
		var _wall = mod_script_call("mod","defpack tools","collision_line_first",x,y,mouse_x[index],mouse_y[index],Wall,0,0);
		var _tarx = x + lengthdir_x(point_distance(x,y,_wall.x,_wall.y),creator.gunangle);
		var _tary = y + lengthdir_y(point_distance(x,y,_wall.x,_wall.y),creator.gunangle);
	}
	else
	{
		var _tarx = mouse_x[index];
		var _tary = mouse_y[index];
	}
	if button_check(creator.index, (check = 1? "fire":"spec")){
			var radi = acc+accmin;
			mod_script_call("mod", "defpack tools","draw_polygon_striped", 16, radi, 45, _tarx+1, _tary+1, global.stripes, lasercolour1,1-(accbase-acc)/(accbase*5),(current_frame mod 16)*.004);
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,radi+6,1,acc+(image_angle*-1),_tarx,_tary,lasercolour1,.8)
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,radi,1,acc+image_angle,_tarx,_tary,lasercolour1,1-1*(accbase-acc))
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",16, accmin,1,acc+image_angle,_tarx,_tary,lasercolour1,.2)
			draw_line_width_colour(x,y,_tarx,_tary,1,lasercolour1,lasercolour1);
		}
		}
		var comp = (check = 1 ? creator.wep : creator.bwep);
		if popped {comp = wep}
		if wep != comp {instance_destroy()}
