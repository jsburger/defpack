#define init
global.sprAssaultAbrisSonicLauncher  = sprite_add_weapon("sprites/Assault Abris Sonic Launcher.png", 2, 2);
global.stripes = sprite_add("defpack tools/BIGstripes.png",1,1,1)
global.scale = 50

#define weapon_name
return "ASSAULT ABRIS SONIC LAUNCHER"

#define weapon_sprt
return global.sprAssaultAbrisSonicLauncher;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 19;

#define weapon_cost
return 0;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 9;

#define weapon_text
return choose("MACH 3","WHAT A @wBREEZE");

#define weapon_fire
mod_script_call("mod","defpack tools","create_abris",x,y,other,"assault abris sonic launcher",75,2,1.5,2.7,4)

#define PayloadStep
sound_play(sndGrenadeRifle)
sound_play(sndExplosionS)
repeat(3){
	sound_play(sndHyperLauncher)
	with creator{
		weapon_post(0,0,12)
		if other.check = 1 {wkick = 4}
		if other.check = 2 {bwkick = 4}
	}
	with mod_script_call("mod","defpack tools","create_sonic_explosion",explo_x+lengthdir_x(acc+(global.scale/2),offset),explo_y+lengthdir_y(acc+(global.scale/2),offset)){
		var scalefac = random_range(0.5,0.65);
		image_xscale = scalefac
		image_yscale = scalefac
		team = other.team
		repeat(round(scalefac*10)){
			with instance_create(x,y,Dust){
				motion_add(random(359),3)
			}
		}
	}
	offset += 120
	wait(4)
}

#define PayloadDraw
if !collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0){
	var radi = acc+global.scale;
	mod_script_call("mod", "defpack tools","draw_polygon_striped", 16, radi, 45, mouse_x[index]+1, mouse_y[index]+1, global.stripes, lasercolour1, 0.1+(accbase-acc)/(accbase*4));
	mod_script_call("mod", "defpack tools","draw_circle_width_colour",16,radi,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,1*(accbase-acc))
	mod_script_call("mod", "defpack tools","draw_circle_width_colour",16, global.scale,1,acc+image_angle,mouse_x[index],mouse_y[index],lasercolour1,.2)
	radi = acc+global.scale/2;
	var alph = .8*((accbase-acc)/accbase);
	mod_script_call("mod", "defpack tools","draw_circle_width_colour",12,radi,1,acc+image_angle,mouse_x[index]+lengthdir_x(radi,offset+image_angle),mouse_y[index]+lengthdir_y(radi,offset+image_angle),lasercolour,alph)
	mod_script_call("mod", "defpack tools","draw_circle_width_colour",12,radi,1,acc+image_angle,mouse_x[index]+lengthdir_x(radi,offset+image_angle+120),mouse_y[index]+lengthdir_y(radi,offset+image_angle+120),lasercolour,alph)
	mod_script_call("mod", "defpack tools","draw_circle_width_colour",12,radi,1,acc+image_angle,mouse_x[index]+lengthdir_x(radi,offset+image_angle+120+120),mouse_y[index]+lengthdir_y(radi,offset+image_angle+120+120),lasercolour,alph)
	draw_line_width_colour(x,y,mouse_x[index],mouse_y[index],1,lasercolour1,lasercolour1);
}
else{
	var hitwall = collision_line(x,y,mouse_x[index],mouse_y[index],Wall,0,0)//there is currently a bug where this chooses the furthest wall if you aim through multiple walls pls fix
	draw_line_width_colour(x,y,x+lengthdir_x(point_distance(x,y,hitwall.x,hitwall.y),creator.gunangle),y+lengthdir_y(point_distance(x,y,hitwall.x,hitwall.y),creator.gunangle),1,lasercolour2,lasercolour2)
}
