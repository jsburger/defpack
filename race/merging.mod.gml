#define init
with script_bind_draw(draw_ground_weps, 0){
	with CustomDraw if script[2] = other.script[2]{
		if id != other {instance_destroy()}
	}
	persistent = 1
}
with script_bind_draw(draw_player_bwep, -1){
	with CustomDraw if script[2] = other.script[2]{
		if id != other {instance_destroy()}
	}
	persistent = 1
}
with script_bind_draw(draw_player_wep, -3){
	with CustomDraw if script[2] = other.script[2]{
		if id != other {instance_destroy()}
	}
	persistent = 1
}


#define step
with WepPickup if is_object(wep) && wep.wep = "merged weapon"{
	if fork(){
		var surrf = wep.surf
		var wepo = wep
		wait(0)
		if !instance_exists(self) && !(array_length_1d(instances_matching(Player,"wep",wepo)) || array_length_1d(instances_matching(Player,"bwep",wepo))){
			surface_destroy(surrf)
		}
		exit
	}
}
with Player{
	if(is_object(wep) && wep.wep == "merged weapon"){
	    if wep.smarttime > 0 wep.smarttime -= current_time_scale
	}
	if(is_object(bwep) && bwep.wep == "merged weapon"){
	    if bwep.smarttime > 0 bwep.smarttime -= current_time_scale
	}
}

#define wep_combine(g1,g2)
var a = {
	wep: "merged weapon",
	name: "",
	weps: [],
	cweps: [],
	surf: surface_create(1000,1000),
	ammo: [0,0,0,0,0,0],
	types: [0,0,0,0,0,0],
	merged : 0,
	type: 0,
	yoff: 0,
	load: 0,
	laser: 0,
	auto: 0,
	smartangle : 0,
	smarttime : 0
}
if is_object(g1) && g1.wep = "merged weapon"{
	surface_destroy(g1.surf)
	for (var i = 0; i<array_length_1d(g1.weps); i++){
		array_push(a.weps,g1.weps[i])
	}
	a.merged = 1
}else{
	array_push(a.weps,g1)
}
if is_object(g2) && g2.wep = "merged weapon"{
	surface_destroy(g2.surf)
	for (var i = 0; i<array_length_1d(g2.weps); i++){
		array_push(a.weps,g2.weps[i])
	}
	a.merged = 1
}else{
	array_push(a.weps,g2)
}
for (var i = 0; i<array_length_1d(a.weps); i++){
	var b = a.weps[i]
	a.name += weapon_get_name(b) + " "
	a.ammo[weapon_get_type(b)] += weapon_get_cost(b)
	a.types[weapon_get_type(b)]++
	a.load += weapon_get_load(b)
	a.laser += weapon_get_laser_sight(b)
	a.auto += weapon_get_auto(b)
	if is_string(b) if mod_script_exists("wep",b,"step"){
		array_push(a.cweps,b)
	}
}
var ma = 0
for (var i = 0; i<=5; i++){
	if a.types[i] > ma{
		ma = a.types[i]
		a.type = i
	}
}
a.laser = min(a.laser,1)
if skill_get("doublebrain") a.load /= array_length_1d(a.weps)
else a.load /= sqrt(array_length_1d(a.weps))
a.yoff = min(array_length_1d(a.weps) * (weph/2) + 3, 500)
doublewep_draw_init(a)
return a;


#define drawtext(tx,ty,t)
draw_set_valign(2);
draw_text_nt(tx, ty, t);
draw_set_valign(0);




#define draw_ground_weps
with(WepPickup)
{
	if(visible && is_object(wep) && wep.wep == "merged weapon")
	{
		doublewep_draw(x, y, wep, rotation, 1, image_blend, 0);
	}
}

with(ThrownWep)
{
	with(Player)
	{
		draw_set_visible(index, 1);
	}
	
	if is_object(wep) && (wep.wep == "merged weapon")
	{
		if(instance_exists(Player))
		{
			doublewep_draw(x, y,wep,image_angle, 1, image_blend, 0);
		}
	}
}

#define draw_player_wep
with(Player) if !back
{
	if(is_object(wep)
	&& wep.wep == "merged weapon")
	{
		doublewep_draw(x-lengthdir_x(wkick, gunangle), y-lengthdir_y(wkick, gunangle),wep,wep.smarttime ? wep.smartangle : gunangle, right, c_white, 0);
	}
}

#define draw_player_bwep
with(Player) if back || race = "steroids"
{

	if(is_object(bwep)
	&& bwep.wep == "merged weapon")
	{
		if(race == "steroids")
		{
		    var ang = bwep.smarttime ? bwep.smartangle : gunangle
			doublewep_draw(x-lengthdir_x(bwkick, ang), y-4-lengthdir_y(bwkick, ang), bwep, ang, -right, c_white, 0);
		}
		else
		{
			doublewep_draw(x, y,bwep,90+20*right, right, c_gray, 0);
		}
	}
	
	if(is_object(wep)
	&& wep.wep == "merged weapon")
	{
	    var ang = wep.smarttime ? wep.smartangle : gunangle
		doublewep_draw(x-lengthdir_x(wkick, ang), y-lengthdir_y(wkick, ang), wep, ang, right, c_white, 0);
	}
	

}

#define curp()
var n = 0;
for (var i=0; i<maxp; i++){
	if player_is_active(i) n++
}
return n

#define draw_gui
draw_set_halign(0);
draw_set_font(fntM);

with(Player)
{	
	with(Player)
	{
		draw_set_visible(index, 0);
	}
	draw_set_visible(index, 1);
	
	var _x = 24
	if curp() > 1 _x -= 19
	var _y = 24
	var x2 = _x + 18
	
	if(is_object(wep)
	&& wep.wep == "merged weapon")
	{
		for(var i = 0; i < 360; i += 90)
		{
			doublewep_draw(_x+lengthdir_x(1, i), _y+lengthdir_y(1, i),wep,0, 1, (curse ? c_purple : c_white), 1);
		}
		
		doublewep_draw(_x, _y,wep,0, 1, c_black, 1);
		var num = 0
		if wep.ammo[1] drawtext(x2,29,string(ammo[1]))
		if curp() > 1 x2 += 19
		for (var i = 2; i<=5;i++){	
			if wep.ammo[i]{
				drawtext(x2+12,42 + 7*(num),string(ammo[i]))
				num++
			}
		}
		
	}
	if(is_object(bwep)
	&& bwep.wep == "merged weapon")
	{
		_x +=44
		x2 += 44
		if race = "steroids" for(var i = 0; i < 360; i += 90)
		{
			doublewep_draw(_x+lengthdir_x(1, i), _y+lengthdir_y(1, i), bwep, 0, 1, (bcurse ? c_purple : c_white), 1);
		}
		
		doublewep_draw(_x, _y, bwep, 0, 1, c_black, 1);
		var num = 0
		for (var i = 1; i<=5;i++){	
			if bwep.ammo[i]{
				drawtext(x2,29 + 7*(num),string(ammo[i]))
				num++
			}
		}
	}
	with(Player)
	{
		draw_set_visible(index, 1);
	}
}

#define doublewep_draw(wx, wy, wepn, a, r, color, d3d)
// x, y, weapon, angle, right, color, d3d
if(visible || d3d)
{
	
	if(d3d)
	{
		d3d_set_fog(1, color, 0, 1);
	}
	if !surface_exists(wepn.surf){
		doublewep_draw_init(wepn)
	}
	draw_surface_ext(wepn.surf,wx+lengthdir_x(wepn.yoff,90*r+a),wy+lengthdir_y(wepn.yoff,90*r+a),1,r,a,color,1)
	if(d3d)
	{
		d3d_set_fog(0, 0, 0, 0);
	}
}

#macro weph 3

#define doublewep_draw_init(a)
surface_set_target(a.surf)
draw_clear_alpha(c_white,0)
for (var i = 0; i<array_length_1d(a.weps); i++){
	var spr = weapon_get_sprite(a.weps[i])
	var _x = sprite_get_xoffset(spr)
	var _y = sprite_get_yoffset(spr)
	draw_sprite(spr,0,_x,_y+(weph*i))
}
surface_reset_target()

