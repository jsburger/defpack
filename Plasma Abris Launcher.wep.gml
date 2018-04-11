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
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 6;

#define weapon_text
return "HUMORON";

#define weapon_fire
var _strtsize = 44-skill_get(13)*15;
var _endsize  = 22;
with mod_script_call("mod","defpack tools","create_abris",self,44,22,argument0)
{
	circlemass = 8 + skill_get(17)*6
	accspeed = 1.14
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
	with instance_create(mouse_x[index]+lengthdir_x(acc+16+6,offset2),mouse_y[index]+lengthdir_y(acc+16+6,offset2),PlasmaImpact)
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
	if button_check(creator.index, (check = 1? "fire":"spec")){
		if !collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0){
			var radi = acc+accmin;
			mod_script_call("mod", "defpack tools","draw_polygon_striped", 16, radi, 45, mouse_x[index]+1, mouse_y[index]+1, global.stripes, lasercolour1, 0.1+(accbase-acc)/(accbase*5),(current_frame mod 16)*.004);
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,radi+6,1,acc+(image_angle*-1),mouse_x[index],mouse_y[index],lasercolour1,.8)
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,radi,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,1*(accbase-acc))
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",16, accmin,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,.2)
			draw_line_width_colour(x,y,mouse_x[index],mouse_y[index],1,lasercolour1,lasercolour1);
		}
		else{
			var q = instance_create(x,y,CustomObject);
			with q{
				mask_index = sprBulletShell
				image_angle = other.creator.gunangle
				move_contact_solid(image_angle,game_width)
			}
			draw_line_width_colour(x,y,q.x,q.y,1,lasercolour2,lasercolour2)
			with q instance_destroy()
		}
		var comp = (check = 1 ? creator.wep : creator.bwep);
		if popped {comp = wep}
		if wep != comp {instance_destroy()}
	}
}
