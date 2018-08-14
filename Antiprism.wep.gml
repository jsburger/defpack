#define init
global.sprPrism[0] = sprite_add_weapon("sprites/sprWhitePrism.png", 2, 6);
global.sprPrism[1] = sprite_add_weapon("sprites/sprBlackPrism.png", 2, 6);
global.sprPrism[2] = sprite_add_weapon("sprites/sprBluePrism.png", 2, 6);
global.sprPrism[3] = sprite_add_weapon("sprites/sprYellowPrism.png", 2, 6);
global.sprPrism[4] = sprite_add_weapon("sprites/sprGreenPrism.png", 2, 6);
global.sprPrism[5] = sprite_add_weapon("sprites/sprPurplePrism.png", 2, 6);
global.sprPrism[6] = sprite_add_weapon("sprites/sprRedPrism.png", 2, 6);
//0 = light 1 = dark 2 = lightning 3 = regular 4 = pest 5 = psy 6 = fire




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
if "AntiCycle" not in self
{
	if wep = "black prism"{reload = weapon_get_load(wep)}
	if bwep = "black prism"{reload = weapon_get_load(bwep)}
}
else
{
	if AntiCycle = 0{return 2}
	if AntiCycle = 1{return 1}
	if AntiCycle = 2{return 7}
	if AntiCycle = 3{return 12}
	if AntiCycle = 4{return 47}
	if AntiCycle = 5{return 3}
	if AntiCycle = 6{return 9}
}
#define weapon_cost
return 1;

#define weapon_swap
return sndPistol;

#define weapon_area
return -1;

#define step
//if button_released(index, "fire") && wep = "black prism" && "AntiCycle" in self{if AntiCycle <= 5{AntiCycle++}else{AntiCycle = 0};trace(AntiCycle)}
if "PrismText" not in self{PrismText = false}
if PrismText = false
{
	if button_pressed(index,"horn")
	{
		with instance_create(x,y,CustomObject)
		{
			owner = other
			depth = -16
			on_step = gui_step
			ammomax = 7
			ammo = 1
			owner.PrismText = true
			hbox_left[1]  = -79 //taste the pet mod coding experience(TM)
			hbox_right[1] = hbox_left[1]+20
			hbox_left[2]  = hbox_right[1]+2
			hbox_right[2] = hbox_left[2]+20
			hbox_left[3]  = hbox_right[2]+2
			hbox_right[3] = hbox_left[3]+20
			hbox_left[4]  = hbox_right[3]+2
			hbox_right[4] = hbox_left[4]+20
			hbox_left[5]  = hbox_right[4]+2
			hbox_right[5] = hbox_left[5]+20
			hbox_left[6]  = hbox_right[5]+2
			hbox_right[6] = hbox_left[6]+20
			hbox_left[7]  = hbox_right[6]+2
			hbox_right[7] = hbox_left[7]+20
			GuiCol[1] = c_white
			GuiCol[2] = c_red
			GuiCol[3] = c_yellow
			GuiCol[4] = c_green
			GuiCol[5] = c_blue
			GuiCol[6] = c_purple
			GuiCol[7] = merge_colour(c_dkgray,c_black,.7)
			GuiName[1] = "@wLIGHT"
			GuiName[2] = "@rFIRE"
			GuiName[3] = "@yREGULAR"
			GuiName[4] = "@gPEST"
			GuiName[5] = "@bTHUNDER"
			GuiName[6] = "@pPSY"
			GuiName[7] = "@dDARK"
			offset = 0
			on_draw = gui_draw
		}
	}
}

#define gui_step
if !instance_exists(owner) || !button_check(owner.index,"horn") || button_pressed(owner.index,"fire") || (owner.wep != "antiprism" && owner.bwep != "antiprism"){owner.PrismText = false;instance_destroy();exit}
x = owner.x
y = owner.y

#define gui_draw
//draw_rectangle_colour(owner.x-80,owner.y+4,owner.x+74,owner.y+26,c_ltgray,c_ltgray,c_ltgray,c_ltgray,false)
repeat(ammomax)
{
	if point_in_rectangle(mouse_x[owner.index],mouse_y[owner.index],owner.x+hbox_left[ammo], owner.y+5, owner.x+hbox_right[ammo], owner.y+25)
	{
		offset = 2
		if button_released(owner.index,"fire")
		{
			owner.PrismText = false
			owner.AntiCycle = ammo-1
			instance_destroy()
			exit
		}
		draw_text_nt(owner.x,owner.y+26+string_height(GuiName[ammo])/2,GuiName[ammo])
	}
	else
	{
		draw_set_alpha(.85)
		offset = 0
		draw_rectangle_colour(owner.x+hbox_left[ammo],owner.y+25,owner.x+hbox_right[ammo],owner.y+25+2,merge_colour(c_black,GuiCol[ammo],.7),merge_colour(c_black,GuiCol[ammo],.7),merge_colour(c_black,GuiCol[ammo],.7),merge_colour(c_black,GuiCol[ammo],.7),false)
	}
	draw_rectangle_colour(owner.x+hbox_left[ammo],owner.y+5+offset,owner.x+hbox_right[ammo],owner.y+25+offset,c_black,c_black,c_black,c_black,false)
	draw_rectangle_colour(owner.x+hbox_left[ammo],owner.y+5+offset,owner.x+hbox_right[ammo],owner.y+25+offset,GuiCol[ammo],GuiCol[ammo],GuiCol[ammo],GuiCol[ammo],false)
	draw_set_alpha(1)
	ammo++;
}
ammo = 1

#define weapon_text
if "AntiCycle" not in self{return "PRESS B TO WITNESS THE TRUE POWER"}
else if irandom(1) = 0
{
	if AntiCycle = 0{return "THE SUN HAS RISEN ONCE MORE"};
	if AntiCycle = 1{return "TO BRAND IS TO CONTROL"};
	if AntiCycle = 2{return "BULLET TYPE AQUEDUCT"};
	if AntiCycle = 3{return "DISGUSTING"};
	if AntiCycle = 4{return "THE ANGER OF ZEUS"};
	if AntiCycle = 5{return "I CAN SEE YOU"};
	if AntiCycle = 6{return "SAFE AT LAST"};
}
else{return "PRESS B TO WITNESS THE TRUE POWER"}
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

#define destroy
if place_meeting(x,y,Wall){instance_destroy()}

#define lt_step
if collision_circle(x,y,16,Wall,false,true)
{repeat(4)with instance_nearest(x,y,Wall){if distance_to_object(other)<= 32{instance_create(x,y,FloorExplo);instance_destroy()}}instance_destroy()}
