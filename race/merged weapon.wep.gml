#define weapon_name(_wep)
return is_object(_wep) ? _wep.name : "what the fuck happened here Burg this is system is chunky wtf";

#define weapon_type(_wep)
return is_object(_wep) ? _wep.type : 0;

#define weapon_melee(_wep)
return 0;

#define weapon_laser_sight(_wep)
if is_object(_wep){
	return _wep.laser
}
else return 0;

#define weapon_sprt
return mskNone

#define weapon_cost(_wep)
return 0

#define weapon_auto(_wep)
if is_object(_wep){
	return _wep.auto
}
else return 0

#define step(w)
if w{
	var a = wep;
	for (var i = 0; i<array_length_1d(a.cweps); i++){
		mod_script_call("wep",a.cweps[i],"step",1)
	}
}
else{
	var a = bwep;
	for (var i = 0; i<array_length_1d(a.cweps); i++){
		mod_script_call("wep",a.cweps[i],"step",0)
	}
}

//look at this fat chunk of code, wew laddie
with(AmmoPickup){
	if distance_to_object(other)<=14{
		mask_index = mskNone;
		if(distance_to_object(other) <= 0) with(other){
		    var n = other.num;
			if (is_object(wep) && wep.wep = mod_current) && (is_object(bwep) && bwep.wep = mod_current){
				var a = choose(wep,bwep);
				sound_play(sndAmmoPickup)
				for (var i = 1; i<=5; i++){
					if a.ammo[i]{
						ammo[i] += typ_ammo[i] * a.types[i] * n
						if ammo[i] >= typ_amax[i]{
							ammo[i] = typ_amax[i]
							with instance_create(x,y,PopupText){
								target = other.index
								text = "MAX " + other.typ_name[i]
							}
						}
						else{
							with instance_create(x,y,PopupText){
								target = other.index
								text = "+" + string(other.typ_ammo[i] * a.types[i] * n) + " " + other.typ_name[i]
							}
						}
					}
				}
			}
			else{
				if irandom(1) || bwep != 0{
					var a = (w ? wep : bwep)
					sound_play(sndAmmoPickup)
					for (var i = 1; i<=5; i++){
						if a.ammo[i]{
							ammo[i] += typ_ammo[i] * a.types[i] * n
							if ammo[i] >= typ_amax[i]{
								ammo[i] = typ_amax[i]
								with instance_create(x,y,PopupText){
									target = other.index
									text = "MAX " + other.typ_name[i]
								}
							}
							else{
								with instance_create(x,y,PopupText){
									target = other.index
									text = "+" + string(other.typ_ammo[i] * a.types[i] * n) + " " + other.typ_name[i]
								}
							}
						}
					}
				}
				else{
					sound_play(sndAmmoPickup)
					var a = (w ? bwep : wep)
					var typ = weapon_get_type(a)
					if typ = 0{
						typ = irandom(4) + 1
					}
					ammo[typ] += typ_ammo[typ] * n
					var i = typ; //changing to i for supreme copy pasting
					if ammo[i] >= typ_amax[i]{
						ammo[i] = typ_amax[i]
						with instance_create(x,y,PopupText){
							target = other.index
							text = "MAX " + other.typ_name[i]
						}
					}
					else{
						with instance_create(x,y,PopupText){
							target = other.index
							text = "+" + string(other.typ_ammo[i] * n) + " " + other.typ_name[i]
						}
					}
				}
			}
			with other instance_destroy()
		}
	}
}



#define weapon_fire(_wep)
var a = wep
var wepbackup = wep;
var ang = gunangle;


if string_count("SMART",a.name) && instance_exists(enemy){
	ang = point_direction(x,y,instance_nearest(mouse_x[index],mouse_y[index],enemy).x,instance_nearest(mouse_x[index],mouse_y[index],enemy).y)
	a.smarttime = 2
}

var am = 1
for (var i = 1; i<=5; i++){
	if ammo[i] < a.ammo[i] am = 0
}

//no point in this, skeleton cant blood gamble it anyway, if someone makes that work later, use this shit, though youll need to add damnation into account
/*var btn = [button_check(index,"fire"),button_check(index,"spec")]
if race = "skeleton" && btn[1]{
	var type,sum;
	for (var i = 1; i<=5; i++){
		sum+=a.ammo[i]
		type += typ_ammo[i]
	}
	if random(sum) > type{
		if skill_get(5) && !irandom(2){
			break
		}
		my_health--
		sound_play(snd_hurt)
	}
}*/


if am || infammo !=0{
	for (var i = 0; i<array_length_1d(a.weps); i++){
		wep = a.weps[i]
		player_fire(ang)
		a.weps[i] = wep
	}
	reload = a.load
	wep = wepbackup
}
else if button_pressed(index,"fire") || (race = "steroids" && button_pressed(index,"spec")){
	with instance_create(x,y,PopupText){
		mytext = "NOT ENOUGH AMMO"
	}
	wkick -= 2
	sound_play(sndEmpty)
}
a.smartangle = gunangle
wep = a
