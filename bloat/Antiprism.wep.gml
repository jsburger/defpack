#define init
global.sprPrism[0] = sprite_add_weapon("sprites/sprWhitePrism.png", 2, 6);
global.sprPrism[1] = sprite_add_weapon("sprites/sprRedPrism.png", 2, 6);
global.sprPrism[2] = sprite_add_weapon("sprites/sprYellowPrism.png", 2, 6);
global.sprPrism[3] = sprite_add_weapon("sprites/sprGreenPrism.png", 2, 6);
global.sprPrism[4] = sprite_add_weapon("sprites/sprBluePrism.png", 2, 6);
global.sprPrism[5] = sprite_add_weapon("sprites/sprPurplePrism.png", 2, 6);
global.sprPrism[6] = sprite_add_weapon("sprites/sprBlackPrism.png", 2, 6);
//light, fire, regular, toxic, lightning, psy, dark
global.colors = [c_white, c_red, c_yellow, c_lime, c_blue, c_purple, c_black]
global.reloads = [2, 1, 7, 12, 47, 3, 9]
global.tips = ["THE SUN HAS RISEN ONCE MORE", "TO BRAND IS TO CONTROL", "BULLET TYPE AQUEDUCT", "DISGUSTING", "THE ANGER OF ZEUS", "I CAN SEE YOU", "SAFE AT LAST"]


#define weapon_name
return "ANTIPRISM"

#define weapon_sprt
if "AntiCycle" not in self{return global.sprPrism[0]}
else
{
	return global.sprPrism[AntiCycle]
}

#define weapon_type
return 1;

#define weapon_auto
return true

#define weapon_load
if "AntiCycle" in self{
	return global.reloads[AntiCycle]
}
return 1
#define weapon_cost
return 1;

#define weapon_swap
return sndPistol;

#define weapon_area
return -1;

#define step
if button_check(index, "pick") || button_released(index,"pick") script_bind_draw(colorswapper, -16, index)
with instances_matching_ne(CustomProjectile, "pattern", null){
    bullet_step()
}

#define colorswapper(i)
    instance_destroy()

    draw_set_visible_all(0)
    draw_set_visible(i, 1)
    var p = player_find(i)
    var xc = p.x, yc = p.y;
    var n = array_length(global.colors), length = 40, inc = 360/n
    var ang = point_direction(xc,yc,mouse_x[i],mouse_y[i])
    for (var o = 0; o <= 6; o++){
        var ang2 = inc * o
        var picked = abs(angle_difference(ang, ang2)) < inc/2
        var col = picked ? global.colors[o] : merge_color(global.colors[o], c_dkgray, .2)
        var a = .5 + .5*picked
        draw_arc(xc, yc, ang2, length - 10 + 2 * picked, length + 2 * picked, inc, 4, col, a, a)
        if picked and button_released(i, "pick"){
            p.AntiCycle = o
        }
    }
    draw_set_visible_all(1)

#define draw_arc(x, y, angle, innerradius, outerradius, degrees, precision, col, inneralpha, outeralpha)
var r1 = innerradius, r2 = outerradius, ang1 = angle - degrees/2, inc = degrees/precision;
draw_primitive_begin(pr_trianglestrip)
for (var i = 0; i <= precision; i++){
    var xl = lengthdir_x(1, ang1 + inc * i), yl = lengthdir_y(1, ang1 + inc * i)
    draw_vertex_color(x + xl * r1, y + yl * r1, col, inneralpha)
    draw_vertex_color(x + xl * r2, y + yl * r2, col, outeralpha)
}
draw_primitive_end()

#define weapon_text
if "AntiCycle" not in self{return "PRESS E TO WITNESS THE TRUE POWER"}
else if irandom(1) = 0
{
    return global.tips[AntiCycle]
}
else{return "PRESS E TO WITNESS THE TRUE POWER"}
#define weapon_fire
sound_play(sndLaserUpg)
weapon_post(4,-12,9)
if "AntiCycle" not in self{AntiCycle = 0}
if AntiCycle = 0//light bullet
{
	with mod_script_call("mod","defpack tools","create_"+"light"+"_bullet",x,y){
		motion_add(other.gunangle+random_range(-1,1),12)
		_direction = direction
		pattern = "helix"
		image_angle = direction
		team = other.team
		creator = other
		dir = -1
		cycle = 80
		damage += 2
	}
	with mod_script_call("mod","defpack tools","create_"+"light"+"_bullet",x,y){
		motion_add(other.gunangle+random_range(-1,1),12)
		_direction = direction
		pattern = "helix"
		image_angle = direction
		team = other.team
		creator = other
		dir = 1
		cycle = 80
		damage += 2
	}
}
if AntiCycle = 1//fire bullet
{
	repeat(2)
	with mod_script_call("mod","defpack tools","create_"+"fire"+"_bullet",x,y){
		motion_add(other.gunangle+random_range(-1,1),random_range(16,19))
		//_direction = direction
		_spd = speed
		pattern = "wide"
		image_angle = direction
		team = other.team
		creator = other
		range = random_range(0,7)
		dir = choose(-1,1)
	}
}
if AntiCycle = 2//regular bullet
{
	repeat(6)
	with instance_create(x,y,Bullet1){
		motion_add(other.gunangle+random_range(-1,1),random_range(18,19))
		image_angle = direction
		team = other.team
		creator = other
		//damage += 2
	}
}
if AntiCycle = 3//toxic bullet
{
	ang = random_range(-3,3)*(1-skill_get(19))
		repeat(18)
		{
			//with other weapon_post(4,-12,9)
			with mod_script_call("mod","defpack tools","create_"+"toxic"+"_bullet",x,y){
			creator = other
			motion_add(creator.gunangle+other.ang,random_range(8,22))
			//pattern = "pline"
			dir = choose(-1,1)
			image_angle = direction
			team = other.team
		}
	}
}
if AntiCycle = 4//lightning bullet
{
	with instance_create(x,y,CustomObject)
	{
		creator = other
		motion_add(other.gunangle,3)
		move_contact_solid(direction,34)
		team = other.team
		mask_index = sprLightning
		on_step = lt_step
		if place_meeting(x,y,Wall){exit}
		repeat(14)
		{
			repeat(4)
			with mod_script_call("mod","defpack tools","create_"+"lightning"+"_bullet",x,y){
				creator = other.creator
				motion_add(creator.gunangle,random_range(5,14))
				if !skill_get(19){radius = random_range(.6,.9)}else{radius = random_range(.8,.96)}
				_spd = speed
				parent = other
				pattern = "cloud"
				_direction = direction
				newdir = 45
				dir = choose(-1,1)
				image_angle = direction
				team = other.team
			}
			wait(1)
		}
	}
}
if AntiCycle = 5//psy bullet
{
	ang = random_range(-3,3)*(1-skill_get(19))
	//with other weapon_post(4,-12,9)
	with mod_script_call("mod","defpack tools","create_"+"psy"+"_bullet",x,y){
	creator = other
	motion_add(creator.gunangle+other.ang,3)
	timer1 = choose(5,7,7,10)
	timer2 = choose(20,30,30)
	dir = choose(-1,1)
	image_angle = direction
	team = other.team
	newdir = 45
	newdir2 = 45
	pattern = "tree"
	}
}
if AntiCycle = 6//dark bullet
{
		if "angprev" not in self{angprev = choose(2,3)}
		if angprev = 2{ang = 3}else{ang = 2}
		if ang = 2
		{
			with mod_script_call("mod", "defpack tools", "create_"+"dark"+"_bullet",x+lengthdir_x(-10,gunangle),y+lengthdir_y(-10,gunangle)){
			    creator = other
			    team = other.team
			    motion_set(other.gunangle-10*other.accuracy,22-other.ang)
					move_contact_solid(direction,12)
					image_angle = direction
					damage = 5
			}
			with mod_script_call("mod", "defpack tools", "create_"+"dark"+"_bullet",x+lengthdir_x(-10,gunangle),y+lengthdir_y(-10,gunangle)){
			    creator = other
			    team = other.team
			    motion_set(other.gunangle+10*other.accuracy,22-other.ang)
					move_contact_solid(direction,12)
					image_angle = direction
					damage = 5
			}
			with mod_script_call("mod", "defpack tools", "create_"+"dark"+"_bullet",x+lengthdir_x(-10,gunangle),y+lengthdir_y(-10,gunangle)){
			    creator = other
			    team = other.team
			    motion_set(other.gunangle-29*other.accuracy,17-other.ang)
					move_contact_solid(direction,12)
					image_angle = direction
					damage = 5
			}
			with mod_script_call("mod", "defpack tools", "create_"+"dark"+"_bullet",x+lengthdir_x(-10,gunangle),y+lengthdir_y(-10,gunangle)){
			    creator = other
			    team = other.team
			    motion_set(other.gunangle+29*other.accuracy,17-other.ang)
					move_contact_solid(direction,12)
					image_angle = direction
					damage = 5
			}
	}
	else
	{
		with mod_script_call("mod", "defpack tools", "create_"+"dark"+"_bullet",x+lengthdir_x(-10,gunangle),y+lengthdir_y(-10,gunangle)){
				creator = other
				team = other.team
				motion_set(other.gunangle+1*other.accuracy,22-other.ang)
				move_contact_solid(direction,12)
				image_angle = direction
				damage = 5
		}
		with mod_script_call("mod", "defpack tools", "create_"+"dark"+"_bullet",x+lengthdir_x(-10,gunangle),y+lengthdir_y(-10,gunangle)){
				creator = other
				team = other.team
				motion_set(other.gunangle-21*other.accuracy,18-other.ang)
				move_contact_solid(direction,12)
				image_angle = direction
				damage = 5
		}
		with mod_script_call("mod", "defpack tools", "create_"+"dark"+"_bullet",x+lengthdir_x(-10,gunangle),y+lengthdir_y(-10,gunangle)){
				creator = other
				team = other.team
				motion_set(other.gunangle+21*other.accuracy,18-other.ang)
				move_contact_solid(direction,12)
				image_angle = direction
				damage = 5
		}
	}
	angprev = ang
}

//ill get to this later
#define bullet_step
if pattern = "helix"
{
	cycle = (cycle + 9) mod 360
	direction = dsin(cycle*pi)*(32-skill_get(19)*20)*dir+_direction
	image_angle = direction
}
if pattern = "tree"
{
	if timer1 > 0{timer1--}else
	{
		dir *= -1
		motion_set(direction+newdir*dir,speed)
		newdir = 0
		image_angle = direction
		newdir2 = 45
		if timer2 > 0{timer2--}else
		{
			if irandom(9) != 0 motion_set(direction+newdir2*dir*-1,speed)
			image_angle = direction
			newdir2 = 0
			timer1 = choose(10,12,12,15)
			newdir1 = 45
		}
	}
}
if pattern = "wide"
{
	motion_add(direction+range*dir*creator.accuracy,speed)
	if range > 1{range /= 1.05}
	if speed > _spd{speed = _spd}
	image_angle = direction
}
if pattern = "cloud"
{
	if instance_exists(parent){motion_add(point_direction(x,y,parent.x,parent.y)+50,_spd*radius)}
	image_angle = direction
	if speed > _spd{speed = _spd}
	if irandom(79) = 0{parent = -99999}
}

#define destroy
if place_meeting(x,y,Wall){instance_destroy()}

#define lt_step
if collision_circle(x,y,16,Wall,false,true)
{repeat(4)with instance_nearest(x,y,Wall){if distance_to_object(other)<= 32{instance_create(x,y,FloorExplo);instance_destroy()}}instance_destroy()}
