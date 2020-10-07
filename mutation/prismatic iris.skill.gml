#define init
global.color = 0                                                                                                                     //variable that keys all these arrays, set by subpicks according to their filename
global.colors = [
	"stock", "pest", "fire", "psy", "thunder", "blind", "bouncer",                                                                   //the actual words used for the gun filenames
	"random", "rad"
]
global.names = [
	"prismatic iris", "pestilent gaze", "blazing visage", "all-seeing eye", "clouded stare", "filtered lens", "quivering sight",     //sub mutation names
	"fantastic refractions", "horrific glare"
]
//global.customs = ["sniper rifle", "bullet cannon", "bullak cannon", "gunhammer"] DEPRECATED                                        //custom guns that need coloring too, make sure to add to the converter switch
global.order = [-1,2,0,4,3,5,1]                                                                                                      //the code goes through the colors array in order, assigning the subpick to the slot numbered here
global.descriptions = [
	"h", "@gTOXIC", "@rFLAMING", "@pHOMING", "@bCHARGED", "@wSOMETHING ELSE", "@yBOUNCY",                                            //shit thats appended to the subpick description
	"EVERYTHING", "@gIRRADIATED"
]
global.colorcount = array_length_1d(global.colors)-3
global.icons = []
global.icon   = sprite_add("../sprites/mutation/sprMutPrismaticIris0.png", 1, 12, 16)
global.arrow  = sprite_add("../sprites/mutation/sprIrisArrow.png", 1, 3, 10)
global.sprRandomGun = sprite_add("../sprites/mutation/sprLensRandomGun.png", 5, 2, 3)
global.effect = sprite_add("../sprites/mutation/sprIrisEffect.png",8,16,11)
for var i = 0; i <= global.colorcount+2; i++{
    array_push(global.icons,sprite_add(`../sprites/mutation/sprMutPrismaticIcon${i}.png`,1,8,7))
}

global.forcecolor = 0
mod_script_call_nc("mod", "defpermissions", "permission_register", "skill", mod_current, "forcecolor", "Force Iris Bullets")

global.new_level = 0
global.randomchoices = [1, 2, 3, 4, 6]                                                                       
global.randomcolor = global.randomchoices[irandom(global.colorcount - 2)]                                                         //other weapons don't exist yet, but once they do, add their index here

#macro current_color global.colors[global.color]
#macro color_index (current_color == "random" ? global.randomcolor : global.color)

#define game_start
global.color = 0

#define sound_play_iris()
with instance_create(0, 0, CustomObject) {
	sound_play_pitch(sndStatueDead,2)
	sound_play_pitchvol(sndStatueCharge,.8,.4)
	sound_play_pitch(sndHeavyRevoler,.6)
	on_step = sound_step
	maxsound = 1
	timer  = 30
	timer2 = 53
	amount = 0
	on_step = sound_step
	return self
}

#define sound_step
timer -= current_time_scale
if timer <= 0 && amount <= 3 {
	amount++;
	timer = 8 - amount;
	sound_play_pitchvol(sndHeavyRevoler, .8 + amount/10, .5 - amount/20)
}
if amount = 2 {
	sound_play_pitchvol(sndMutant2Cptn, 1.1, .5)
}
if amount >= 2 {
	if timer2 > 0
		timer2 -= current_time_scale
	else {
		sound_stop(sndMutant2Cptn);
		instance_destroy()
	}
}

#define skill_take
sound_play_iris()
GameCont.skillpoints++
GameCont.endpoints++
if fork(){
    wait(0)
    GameCont.endpoints--
    var _destiny = (crown_current == crwn_destiny);
    var _horror = (player_count_race(char_horror) > 0)
    var _maxselect = 0;
    with SkillIcon instance_destroy()
    with LevCont{
        maxselect = (_destiny ? 1 : global.colorcount) - 1 + _horror
        _maxselect = maxselect
    }
    var p = player_find(player_find_local_nonsync()), q;
    if (!_destiny){
        for var i = 1; i <= global.colorcount; i++{
            var skil = `irisslave${i}`
            with instance_create(0, 0, SkillIcon){
                creator = LevCont
                coolbutton = 1
                num = global.order[i]
                alarm0 = num + 3
                skill = skil
                sprite_index = mod_variable_get("skill", skil, "sprite")
                name = `${global.names[i]}`
                text = "@yBULLET@s WEAPONS BECOME " + global.descriptions[i] + "@s"
                if instance_exists(p){
                    if global.colors[i] != "blind" { //not filtered lens
                         //smartest code youll ever see
                        q = get_colored(p.wep, i);
                        if q[1]{
                            text += `#@0(${weapon_get_sprite(p.wep)}:0)   @0(${global.arrow}:0)   @0(${weapon_get_sprite(q[0])}:0)`
                        }
                        q = get_colored(p.bwep, i);
                        if q[1]{
                            text += `#@0(${weapon_get_sprite(p.bwep)}:0)   @0(${global.arrow}:0)   @0(${weapon_get_sprite(q[0])}:0)`
                        }
                    }
                    else {
                        if weapon_get_type(p.wep) == 1{
                            text += `#@0(${weapon_get_sprite(p.wep)}:0)   @0(${global.arrow}:0)   @0(${global.sprRandomGun}:-1)`
                        }
                        if weapon_get_type(p.bwep) == 1{
                            text += `#@0(${weapon_get_sprite(p.bwep)}:0)   @0(${global.arrow}:0)   @0(${global.sprRandomGun}:-1)`
                        }
                    }
                }
            }
        }
    }
    else {
    	var skil = "irisslave7"
    	with instance_create(0, 0, SkillIcon){
    		creator = LevCont
    		coolbutton = 1
    		num = 0
    		alarm0 = num + 3
    		skill = skil
    		sprite_index = mod_variable_get("skill", skil, "sprite")
    		name = `@w${global.names[global.colorcount+1]}`
    		text = "@yBULLET@s WEAPONS BECOME " + global.descriptions[global.colorcount+1] + "@s"
    		 //weapon previews done in step
    	}
    }
    if(_horror){
    	var skil = "irisslave8"
    	with instance_create(0, 0, SkillIcon){
    		creator = LevCont
    		coolbutton = 1
    		num = _maxselect
    		alarm0 = num + 3
    		skill = skil
    		sprite_index = mod_variable_get("skill", skil, "sprite")
    		name = `${global.names[global.colorcount+2]}`
    		text = "@yBULLET@s WEAPONS BECOME " + global.descriptions[global.colorcount+2] + "@s"
    		 //no preview because Karm didn't tell me what it does
    	}
    }
    exit
}
if fork(){
    while global.color = 0 && instance_exists(SkillIcon){
        wait(0)
    }
    global.randomcolor = global.randomchoices[irandom(global.colorcount - 2)]
    wait(0)
    with Player{
        if current_color != "blind"{
        	 //i hate this but wont change it
            color(wep, color_index)
            var we = wep;
            wep = bwep
            color(bwep, color_index)
            bwep = wep
            wep = we
        }
    }
    exit
}

#define skill_wepspec
return global.color != 0

#define skill_name
return "PRISMATIC IRIS"

#define skill_button
sprite_index = global.icon

#define skill_icon
return global.icons[global.color]

#define skill_text
if global.color == 7 return "@yBULLET@s WEAPONS BECOME " + `@(color:${make_color_hsv(current_frame * 9 % 256, 255, 255)})` + global.descriptions[global.colorcount+1] + "@s"
if global.color > 0 return "@yBULLET@s WEAPONS BECOME " + global.descriptions[global.color]
return "@wREIMAGINE@s YOUR @yBULLET@s WEAPONS"

#define array_index_exists(array,index)
var o = array_length_1d(array);
for var i = 0; i < o; i++{
    if array[i] = index return 1
}
return 0

#define step

 //The main thing iris does, replacing weapons.
if global.color > 0 and instance_exists(Player){
	with instances_matching(WepPickup, "irischeck", null){
		if distance_to_object(Player) < 100{
			irischeck = 1
			if current_color == "blind" {
				if weapon_get_type(wep) == 1 {
					var weps = [];
					with instance_nearest(x, y, Player) if race != "steroids"{
						array_push(weps, wep)
						array_push(weps, bwep)
					}
					scrGimmeWep(x, y, 6 * ultra_get("robot", 1), GameCont.hard + array_length(instances_matching(Player, "race", "robot")) + (2 * curse), curse, weps)
					with instance_create(x,y,ImpactWrists){
	                    sprite_index = global.effect
	                    sound_play_pitchvol(sndStatueXP, .5 * random_range(.8, 1.2), .4)
	                    image_angle = 0
	                }
	                instance_destroy()
				}
			}
			else{
				if is_string(wep){
					for var i = 1; i <= global.colorcount; i++{
						if get_colored(string_replace(wep, global.colors[i], "x"), i)[1]{
							break;
						}
					}
					
					if i <= global.colorcount{
						continue;
					}
				}
				
				if color(wep, color_index){
					chargecheck = 0
					// sprite_index = weapon_get_sprt(wep)
					// name = weapon_get_name(wep)
            		with instance_create(x,y,ImpactWrists){
                		sprite_index = global.effect
                    	sound_play_pitchvol(sndStatueXP, .5 * random_range(.8, 1.2), .4)
                    	image_angle = 0
                	}
				}
			}
		}
	}
}

if global.color == 0 and instance_exists(SkillIcon){
	var p = player_find(player_find_local_nonsync()), q, c;
	with instances_matching(SkillIcon, "skill", "irisslave7"){
		text = "@yBULLET@s WEAPONS BECOME " + `@(color:${make_color_hsv(current_frame * 9 % 256, 255, 255)})` + global.descriptions[global.colorcount+1] + "@s"
		if instance_exists(p){
			c = global.randomchoices[current_frame div 1 mod (global.colorcount - 1)];
			q = get_colored(p.wep, c);
	        if q[1]{
	            text += `#@0(${weapon_get_sprite(p.wep)}:0)   @0(${global.arrow}:0)   @0(${weapon_get_sprite(q[0])}:0)`
	        }
	        q = get_colored(p.bwep, c);
	        if q[1]{
	            text += `#@0(${weapon_get_sprite(p.bwep)}:0)   @0(${global.arrow}:0)   @0(${weapon_get_sprite(q[0])}:0)`
	        }
		}
	}
}

if instance_exists(GenCont) and !global.new_level{
	global.new_level = 1
}

else if global.new_level{
	global.new_level = 0
	global.randomcolor = global.randomchoices[irandom(global.colorcount - 2)]
}


/*
if global.colors[global.color] = "blind" and instance_exists(Player){
    with instances_matching(WepPickup,"irischeck",null){
        if distance_to_object(instance_nearest(x,y,Player)) < 100{
            irischeck = 1
            if weapon_get_type(wep) = 1{
                var weps = []
                with instance_nearest(x,y,Player) if race != "steroids"{
                    array_push(weps,wep)
                    array_push(weps,bwep)
                }
                scrGimmeWep(x,y,0,GameCont.hard,curse,weps)
                with instance_create(x,y,ImpactWrists){
                    sprite_index = global.effect
                    sound_play_pitchvol(sndStatueXP,.5*random_range(.8,1.2),.4)
                    image_angle = 0
                }
                instance_destroy()
            }
        }
    }
}
else{
    if global.color > 0 && instance_exists(Player){
        with instances_matching(WepPickup,"irischeck",null){
            if distance_to_object(instance_nearest(x,y,Player)) < 100{
                irischeck = 1;
                if color(wep,global.color){
                    // sprite_index = weapon_get_sprt(wep)
                    // name = weapon_get_name(wep)
                    with instance_create(x,y,ImpactWrists){
                        sprite_index = global.effect
                        sound_play_pitchvol(sndStatueXP,.5*random_range(.8,1.2),.4)
                        image_angle = 0
                    }
                }
            }
        }
    }
}*/


//swapping bullets to the iris equivalent for the "Force Iris Bullets" option
if global.forcecolor and current_color != "blind"{
	var _color = color_index
    //leading in innovation with EPIC copy pasting
    with HeavyBullet {
        with heavy_bullet_color(_color){
            creator = other.creator
            team = other.team
            speed = other.speed
            direction = other.direction
            image_angle = other.direction
        }
        instance_delete(self)
    }
    if global.colors[_color] != "bouncer"{
        with BouncerBullet {
            with bullet_color(_color){
                creator = other.creator
                team = other.team
                speed = other.speed
                direction = other.direction
                image_angle = other.direction
            }
            instance_delete(self)
        }
    }
    with Bullet1 {
        with bullet_color(_color){
            creator = other.creator
            team = other.team
            speed = other.speed
            direction = other.direction
            image_angle = other.direction
        }
        instance_delete(self)
    }
}

#define heavy_bullet_color(color)
return mod_script_call_nc("mod", "defpack tools", "create_heavy_"+global.colors[color]+"_bullet", x, y)

#define bullet_color(color)
if color <= 4
    return mod_script_call_nc("mod", "defpack tools", "create_"+global.colors[color]+"_bullet", x, y)
if color == 6
    return instance_create(x, y, BouncerBullet)

#define reverse(wep)
switch wep{
    case "bouncer smg":
        return wep_bouncer_smg
    case "bouncer shotgun":
        return wep_bouncer_shotgun
    default:
        return wep
}

#define convert(wep)
if is_string(wep) return mod_script_call_nc("weapon", wep, "weapon_iris")
switch wep{
    case wep_revolver:
        return "x revolver"
    case wep_golden_revolver:
        return "golden x revolver"
    case wep_rusty_revolver:
        return "rusty x revolver"
    case wep_golden_machinegun:
        return "golden x machinegun"
    case wep_golden_assault_rifle:
        return "golden assault x rifle"
    case wep_rogue_rifle:
        return "x rogue rifle"
    case wep_machinegun:
        return "x machinegun"
    case wep_assault_rifle:
        return "assault x rifle"
    case wep_double_minigun:
        return "double x minigun"
    case wep_minigun:
        return "x minigun"
    case wep_smg:
        return "x smg"
    case wep_bouncer_smg:
        return "x smg"
    case wep_triple_machinegun:
        return "triple x machinegun"
    case wep_quadruple_machinegun:
        return "quad x machinegun"
    case wep_smart_gun:
        return "smart x gun"
    case wep_bouncer_shotgun:
        return "x shotgun"
    case wep_hyper_rifle:
        return "hyper x rifle"
    case wep_heavy_assault_rifle:
        return "heavy assault x rifle"
    case wep_heavy_machinegun:
        return "heavy x machinegun"
    case wep_heavy_revolver:
        return "heavy x revolver"
    default:
        return "yeah"
}

#define get_colored(wp, col)
var str = weapon_find(wp);
if is_real(str) or (is_string(str) and mod_script_exists("weapon", str, "weapon_iris")){
    var q = convert(str);
    if q == str return [str, 0]
    str = string_replace(q, "x ", `${global.colors[col]} `)
}
else{
    for var i = 1; i <= global.colorcount; i++;{
        str = string_replace(str, global.colors[i], global.colors[col])
    }
}
str = reverse(str)
return [str, str != weapon_find(wp) and weapon_exists(str)]

#define weapon_exists(str)
return is_real(str) or mod_exists("weapon", str)

#define color(wp, col)
var str = get_colored(wp, col);
if str[1] {
    if is_object(wp){
        weapon_set(wp, str[0])
    }
    else wep = str[0]
    return 1
}
return 0

#define weapon_find(w)
if is_object(w){
    if is_string(w.wep){
        if mod_script_exists("weapon",w.wep,"weapon_wep") return weapon_find(lq_get(w, mod_script_call_nc("weapon", w.wep, "weapon_wep", w)))
    }
    return weapon_find(w.wep)
}
return w


#define weapon_set(w, val)
if is_string(w.wep){
    if mod_script_exists("weapon",w.wep,"weapon_wep"){
        lq_set(w, mod_script_call_nc("weapon", w.wep, "weapon_wep", w), val)
        exit
    }
}
if is_object(w.wep){
    weapon_set(w.wep, val)
    exit
}
w.wep = val

//thanks YOKIN you are truly my greatest ally
// Spawns a Random WepPickup & Takes Into Account More Spawn Conditions: `with(Player) scrGimmeWep(x, y, 0, GameCont.hard, curse, [wep, bwep]);`
#define scrGimmeWep(_x, _y, _minhard, _maxhard, _curse, _nowep)
    var _list = ds_list_create(),
		s = weapon_get_list(_list, _minhard, _maxhard);

	ds_list_shuffle(_list);

	with(instance_create(_x, _y, WepPickup)){
		curse = _curse;
		ammo = 1;

        for(var i = 0; i < s; i++) {
            var	w = ds_list_find_value(_list, i),
            	c = 0;

			 // Weapon Exceptions:
			if(is_array(_nowep) && array_find_index(_nowep, w) >= 0) c = 1;
			if(w == _nowep) c = 1;

            //Prismatic Iris Denounces Bullet Weapons
            if weapon_get_type(w) = 1 c = 1

			 // Specific Weapon Spawn Conditions:
			if(!is_string(w)) switch(w){
				case wep_super_disc_gun:        if(curse <= 0)			c = 1; break;
                case wep_golden_nuke_launcher:  if(!UberCont.hardmode)	c = 1; break;
                case wep_golden_disc_gun:       if(!UberCont.hardmode)	c = 1; break;
                case wep_gun_gun:               if(GameCont.crown != 5)	c = 1; break;
            }

            if(c) continue;
            break;
        }

		 // Set Weapon:
        if(!c) wep = w;
        else wep = wep_screwdriver; // Default

		ds_list_destroy(_list);

        return id;
	}

#define skill_tip
switch global.colors[global.color]
{
  case "pest"    : return "@sREIGN OF @gTERROR";
  case "fire"    : return "@rBURN @sTHE WORLD DOWN";
  case "psy"     : return "@sIT @pBEGINS";
  case "thunder" : return "@bSTRIKE @s'EM DOWN";
  case "blind"   : return "@dNEVERMIND";
  case "bouncer" : return "@sTHE @ySTARS @sHAVE ALIGNED";
  case "random"  : return "ROLL YOUR @wDICE@s,#MOVE YOUR @wMICE@s"
  case "rad"     : return "EVEN THE @wWEAPONS @gMUTATED@s"
}
return "BELIEVE";
