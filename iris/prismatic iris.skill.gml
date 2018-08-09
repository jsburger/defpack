#define init
global.color = 0                                                                                                                                 //variable that keys all these arrays, set by subpicks according to their filename
global.colors = ["stock", "pest", "fire", "psy", "thunder", "blind", "bouncer"]                                                                  //the actual words used for the gun filenames
global.names = ["prismatic iris", "pestilent gaze", "blazing visage", "all-seeing eye", "clouded stare", "filtered lens", "quivering sight"]     //sub mutation names
global.customs = ["sniper rifle", "bullet cannon", "bullak cannon", "gunhammer"]                                                                 //custom guns that need coloring too, make sure to add to the converter switch
global.order = [-1,0,1,2,3,5,4]                                                                                                                  //the code goes through the colors array in order, assigning the subpick to the slot numbered here
global.descriptions = ["h", "@gTOXIC", "@rFLAMING", "@pHOMING", "@bCHARGED", "@SOMETHING NEW", "@yBOUNCY"]                                       //shit thats appended to the subpick description
global.colorcount = array_length_1d(global.colors)-1
global.icons = []
global.icon = sprite_add("sprMutPrismaticIris0.png",1,12,16)
global.effect = sprite_add("sprIrisEffect.png",1,16,11)
for var i = 0; i <= global.colorcount; i++{
    array_push(global.icons,sprite_add(`sprMutPrismaticIcon${i}.png`,1,7,8))
}
#define game_start
global.color = 0

#define skill_take
GameCont.skillpoints++
if fork(){
    wait(0)
    with SkillIcon instance_destroy()
    LevCont.maxselect = global.colorcount - 1
    for var i = 1; i <= global.colorcount; i++{
        var skil = `irisslave${i}`
        with instance_create(0,0,SkillIcon){
            creator = LevCont
            coolbutton = 1
            num = global.order[i]
            alarm0 = num + 3
            skill = skil
            sprite_index = mod_variable_get("skill",skil,"sprite")
            name = `${global.names[i]}`
            text = "@yBULLET@w WEAPONS BECOME " + global.descriptions[i]
        }
    }
    exit
}
if fork(){
    while global.color = 0 && instance_exists(SkillIcon){
        wait(0)
    }
    wait(0)
    with Player{
        if !(global.colors[global.color] = "blind"){
            color(wep,global.color)
            var we = wep;
            wep = bwep
            color(bwep,global.color)
            bwep = wep
            wep = we
        }
    }
    exit
}

#define skill_name
return "PRISMATIC IRIS"

#define skill_button
sprite_index = global.icon

#define skill_icon
return global.icons[global.color]

#define skill_text
if global.color > 0 return "@yBULLET@w WEAPONS BECOME " + global.descriptions[i]
return "@pREIMAGINE@w YOUR @yBULLET@w WEAPONS"

#define array_index_exists(array,index)
var o = array_length_1d(array);
for var i = 0; i < o; i++{
    if array[i] = index return 1
}
return 0

#define step
if global.colors[global.color] = "blind"{
    with instances_matching(WepPickup,"irischeck",null){
        irischeck = 1
        if weapon_get_type(wep) = 1{
            var weps = []
            with Player{
                array_push(weps,wep)
                array_push(weps,bwep)
            }
            scrGimmeWep(x,y,0,GameCont.hard,curse,weps)
            with instance_create(x,y,ImpactWrists){
                sprite_index = global.effect
            }
            instance_destroy()
        }
    }
}
else{
    if global.color > 0 && instance_exists(Player){
        with instances_matching(WepPickup,"irischeck",null){
            if distance_to_object(instance_nearest(x,y,Player)) < 100{
                irischeck = 1
                if color(wep,global.color){
                    sprite_index = weapon_get_sprt(wep)
                    name = weapon_get_name(wep)
                    with instance_create(x,y,ImpactWrists){
                        sprite_index = global.effect
                    }
                }
            }
        }
    }
}

#define convert(wep)
switch wep{
    case wep_revolver:
        return "x revolver"
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
    case wep_triple_machinegun:
        return "triple x machinegun"
    case wep_quadruple_machinegun:
        return "quad x machinegun"
    case wep_smart_gun:
        return "smart x gun"
    case wep_hyper_rifle:
        return "hyper x rifle"
    case "sniper rifle":
        return "sniper x rifle"
    case "bullet cannon":
        return "x bullet cannon"
    case "bullak cannon":
        return "x bullak cannon"
    case "gunhammer":
        return "x gunhammer"
    default:
        return weapon_get_name(wep)
}

#define color(wp,col)
var str = wp;
var obj = 0
while is_object(str){
    obj++
    str = str.wep    
}
if is_real(str) || array_index_exists(global.customs,str){
    str = string_replace(convert(str),"x ", `${global.colors[col]} `)
}
else{
    for var i = 1; i < array_length_1d(global.colors); i++;{
        str = string_replace(str, global.colors[i], global.colors[col])
    }
}
if mod_exists("weapon",str){
   if obj with wep set_nest(wep,str)
   else wep = str
   return 1
}
return 0

#define set_nest(destination,payload)
if is_object(destination){
    with destination set_nest(destination,payload)
}
else destination = payload

//thanks YOKIN you are truly my greatest ally
// Spawns a Random WepPickup & Takes Into Account More Spawn Conditions: `with(Player) scrGimmeWep(x, y, 0, GameCont.hard, curse, [wep, bwep]);`
#define scrGimmeWep(_x, _y, _minhard, _maxhard, _curse, _nowep)
    var _list = ds_list_create(),
		s = weapon_get_list(_list, _minhard, _maxhard);

	ds_list_shuffle(_list);

	with(instance_create(_x, _y, WepPickup)){
		curse = _curse;
		ammo = 1;

        for(i = 0; i < s; i++) {
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
