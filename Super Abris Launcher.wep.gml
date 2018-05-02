#define init
global.sprSuperAbrisLauncher = sprite_add_weapon("sprites/sprSuperAbrisLauncher.png", 1, 4);
global.sprDanger 						 = sprite_add("sprites/projectiles/Danger.png",0,1,29);
global.stripes 							 = sprite_add("defpack tools/BIGstripes.png",1,1,1)

#define weapon_name
return "SUPER ABRIS LAUNCHER"

#define weapon_sprt
return global.sprSuperAbrisLauncher;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 44;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 12;

#define weapon_text
return "BLESS WALLS";

#define weapon_fire
var _strtsize = 100-skill_get(13)*15;
var _endsize  = 72;
with mod_script_call("mod","defpack tools","create_abris",self,100,72,argument0){
sound_set_track_position(sndVanWarning,1.2)
accspeed = 1.04
payload = script_ref_create(pop)
on_draw = abris_draw_super
image_speed = .55
}
//nonono this isnt working no no no
sound_play_pitch(sndSniperTarget,exp((_strtsize-_endsize)/room_speed/current_time_scale/accuracy*(1.07))/12)

#define pop
sound_set_track_position(sndVanWarning,0)
sound_play_pitch(sndGrenadeRifle,.4)
sound_play_pitch(sndNukeExplosion,.8)
with creator{weapon_post(12,0,244)}
sleep(200)
with creator{motion_add(gunangle,-5)}
repeat(8)
{
	with instance_create(mouse_x[index]+lengthdir_x(acc+48,offset),mouse_y[index]+lengthdir_y(acc+48,offset),Explosion){hitid = [sprite_index,"explosion"]}
	with instance_create(mouse_x[index]+lengthdir_x(acc+12,offset),mouse_y[index]+lengthdir_y(acc+12,offset),SmallExplosion){hitid = [sprite_index,"small explosion"]}
	offset += 45
}

#define abris_draw_super
if instance_exists(creator) && check{
	if current_frame % 30 = 0{sound_play_pitch(sndVanWarning,.55);sound_set_track_position(sndVanWarning,1.2)}
	x = creator.x
	y = creator.y
	if button_check(creator.index, (check = 1? "fire":"spec")){
		if !collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0){
			var radi = acc+accmin;
			mod_script_call("mod", "defpack tools","draw_polygon_striped", 16, radi, 45, mouse_x[index]+1, mouse_y[index]+1, global.stripes, lasercolour1, 0.1+(accbase-acc)/(accbase*5),(current_frame mod 16)*.004);
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,radi,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,1*(accbase-acc))
			mod_script_call("mod", "defpack tools","draw_circle_width_colour",16, accmin,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,.2)
			draw_sprite_ext(global.sprDanger,image_index,mouse_x[index],mouse_y[index],radi/80,radi/80,60-image_angle,c_red,1*(accbase-acc))
			draw_sprite_ext(global.sprDanger,image_index,mouse_x[index],mouse_y[index],radi/80,radi/80,180-image_angle,c_red,1*(accbase-acc))
			draw_sprite_ext(global.sprDanger,image_index,mouse_x[index],mouse_y[index],radi/80,radi/80,300-image_angle,c_red,1*(accbase-acc))
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
			with q {instance_destroy()}
		}
		var comp = (check = 1 ? creator.wep : creator.bwep);
		if popped {comp = wep}
		if wep != comp {sound_set_track_position(sndVanWarning,0);instance_destroy()}
	}
}
/*
#define weapon_fire
with instance_create(x,y,CustomObject)
{
	creator = other
	index = creator.index
	accbase = 100*creator.accuracy
	acc = accbase
	on_step = GoldenAbrisPistol_step
	on_draw = GoldenAbrisPistol_draw
	lasercolour1 = c_red
	lasercolour = lasercolour1
	lasercolour2 = c_maroon
	sprite_index = global.sprDanger
	image_speed = .55
	image_alpha = 0
}

#define GoldenAbrisPistol_step
if instance_exists(creator)
{
	image_angle += .46
	creator.reload = weapon_get_load(creator.wep)
	if skill_get(19) = false{acc /= 1.07}
	else{acc /= 3.5}
	x = creator.x
	y = creator.y
	offset = random(359)
	if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) >= 0
	{
		if acc < accbase{acc += abs(creator.accuracy*3)}else{acc = accbase}
	}
	if button_released(creator.index, "fire")
	{
		if creator.ammo[4] >= 1
		{
			if creator.infammo <= 0{creator.ammo[4] -= 4}
			if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) < 0
			{
				sound_play(sndGrenadeRifle)
				sound_play(sndExplosionXL)
				creator.wkick = 12
				repeat(8)
				{
					instance_create(mouse_x[index]+lengthdir_x(acc+48,offset),mouse_y[index]+lengthdir_y(acc+48,offset),Explosion)
					instance_create(mouse_x[index]+lengthdir_x(acc+12,offset),mouse_y[index]+lengthdir_y(acc+12,offset),SmallExplosion)
					offset += 45
				}
			}
			else
			{
				if creator.infammo <= 0{creator.ammo[4] += 4}
			}
		}
	instance_destroy()
	}
}
else{instance_destroy()}

#define GoldenAbrisPistol_draw
if creator.ammo[4] < 4{instance_destroy()}
else
if instance_exists(creator)
{
	if collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0) < 0
	{
		lasercolour = merge_colour(lasercolour1,lasercolour,.11)
		draw_line_width_colour(x,y,mouse_x[index],mouse_y[index],1,lasercolour,lasercolour);
		mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,acc+72,2,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,1*(accbase-acc))
		mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,72,2,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,.2)
		mod_script_call("mod", "defpack tools","draw_polygon_striped", 16, acc+72, 45, mouse_x[index]+1, mouse_y[index]+1, global.stripes, lasercolour, 0.1+(accbase-acc)/(accbase*6));
		draw_sprite_ext(sprite_index,image_index,mouse_x[index],mouse_y[index],acc/19+2,acc/19+2,0,c_red,1*(accbase-acc))
	}
	else
	{
		var hitwall = collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0)//there is currently a bug where this chooses the furthest wall if you aim through multiple walls pls fix
	}
	lasercolour = merge_colour(lasercolour,lasercolour2,.33)
	draw_line_width_colour(x,y,x+lengthdir_x(point_distance(x,y,hitwall.x,hitwall.y),creator.gunangle),y+lengthdir_y(point_distance(x,y,hitwall.x,hitwall.y),creator.gunangle),1,lasercolour,lasercolour)
	if weapon_get_name(creator.wep) != "SUPER ABRIS LAUNCHER"{instance_destroy()}
}
