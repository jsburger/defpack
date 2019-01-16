#define init
global.color = 0                                                                                                                                 //variable that keys all these arrays, set by subpicks according to their filename
global.colors = ["stock", "pest", "fire", "psy", "thunder", "blind", "bouncer"]                                                                  //the actual words used for the gun filenames
global.names = ["prismatic iris", "pestilent gaze", "blazing visage", "all-seeing eye", "clouded stare", "filtered lens", "quivering sight"]     //sub mutation names
global.customs = ["sniper rifle", "bullet cannon", "bullak cannon", "gunhammer"]                                                                 //custom guns that need coloring too, make sure to add to the converter switch
global.order = [-1,2,0,4,3,5,1]                                                                                              //the code goes through the colors array in order, assigning the subpick to the slot numbered here
global.descriptions = ["h", "@gTOXIC", "@rFLAMING", "@pHOMING", "@bCHARGED", "@wSOMETHING ELSE", "@yBOUNCY"]                                      //shit thats appended to the subpick description
global.colorcount = array_length_1d(global.colors)-1
global.icons = []
global.icon = sprite_add("sprMutPrismaticIris0.png",1,12,16)
global.effect = sprite_add("sprIrisEffect.png",8,16,11)
for var i = 0; i <= global.colorcount; i++{
    array_push(global.icons,sprite_add(`sprMutPrismaticIcon${i}.png`,1,8,7))
}
#define game_start
global.color = 0

#define sound_play_iris()
var a = instance_create(0,0,CustomObject);
with a
{
  sound_play_pitch(sndStatueDead,2)
  sound_play_pitchvol(sndStatueCharge,.8,.4)
  sound_play_pitch(sndHeavyRevoler,.6)
  on_step = sound_step
  maxsound = 1
  timer  = 30
  timer2 = 53
  amount = 0
  on_step = sound_step
}
return a;

#define sound_step
var i = 0;
timer -= current_time_scale
if timer <= 0 && amount <= 3{amount++;timer = 8-amount;sound_play_pitchvol(sndHeavyRevoler,.8+amount/10,.5-amount/20)}
if amount = 2
{
  sound_play_pitchvol(sndMutant2Cptn,1.1,.5)
}
if amount >= 2
{
  if timer2 > 0 timer2 -= current_time_scale else{sound_play_pitch(sndMutant2Cptn,.0000000000000000000000000001);instance_destroy()}
}

#define skill_take
sound_play_iris()
GameCont.skillpoints++
GameCont.endpoints++
if fork(){
    wait(0)
    GameCont.endpoints--
    with SkillIcon instance_destroy()
    with LevCont{
        maxselect = global.colorcount - 1
    }
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
            text = "@yBULLET@s WEAPONS BECOME " + global.descriptions[i]
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
if global.color > 0 return "@yBULLET@s WEAPONS BECOME " + global.descriptions[global.color]
return "@wREIMAGINE@s YOUR @yBULLET@s WEAPONS"

#define array_index_exists(array,index)
var o = array_length_1d(array);
for var i = 0; i < o; i++{
    if array[i] = index return 1
}
return 0

#define step
//cool iris synergies
//what the fuck is this karm
/*if skill_get("prismatic iris")
{
  if skill_get(21)
  {
    if global.color = 3
    {
      with instances_matching(CustomProjectile,"name","Psy Bullet")
      {
        if timer = 0{timer = -500;force = 3;range = 240}
      }
    }
  }
  if skill_get(15)
  {
    if global.color = 6
    with BouncerBullet
    {
      if "flag" not in self
      {
        flag = "i have seen the truth"
      }
    }
    with instances_matching(CustomProjectile,"name","Bouncer Bullet Flak")
    {
      if "flag" not in self
      {
        flag = "i have seen the truth"
        bounce += 2
      }
    }
    with instances_matching(CustomProjectile,"name","hyper bouncer")
    {
      if "flag" not in self
      {
        flag = "i have seen the truth"
        bounce += 2
      }
    }
  }
  //f skill_get()
}
with BouncerBullet
{
  if "flag" in self
  {
    if "ebounce" not in self ebounce = 2 + (skill_get("10xshotgunshoulders"))
    if place_meeting(x+hspeed,y+vspeed,Wall)
    {
      if ebounce > 0
      {
        move_bounce_solid(false)
        ebounce--
      }
    }
    if place_meeting(x+hspeed,y+vspeed,enemy)
    {
      if instance_nearest(x,y,enemy).my_health -damage <= 0
        if ebounce > 0
        {
          var _c = random_range(-45,45);
          with instance_create(x,y,BouncerBullet)
          {
            //image_index = 1
            team = other.team
            creator = other
            recycle_amount = 0
            motion_add(other.direction - 180 + _c,other.speed)
            sound_play_pitchvol(sndBouncerBounce,random_range(.9,1.1),.3)
            ebounce = other.ebounce -1
          }
        }
    }
    if place_meeting(x+hspeed,y+vspeed,prop)
    {
      if instance_nearest(x,y,prop).my_health -damage <= 0
        if ebounce > 0
        {
          var _c = random_range(-45,45);
          with instance_create(x,y,BouncerBullet)
          {
            //image_index = 1
            team = other.team
            creator = other
            recycle_amount = 0
            motion_add(other.direction - 180 + _c,other.speed)
            sound_play_pitchvol(sndBouncerBounce,random_range(.9,1.1),.3)
            ebounce = other.ebounce -1
          }
        }
    }
  }
}
*/

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
                irischeck = 1
                if color(wep,global.color){
                    sprite_index = weapon_get_sprt(wep)
                    name = weapon_get_name(wep)
                    with instance_create(x,y,ImpactWrists){
                        sprite_index = global.effect
                        sound_play_pitchvol(sndStatueXP,.5*random_range(.8,1.2),.4)
                        image_angle = 0
                    }
                }
            }
        }
    }
}



#define reverse(wep)
switch wep{
    case "bouncer smg":
        return wep_bouncer_smg
    default:
        return wep
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
    case wep_bouncer_smg:
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
var str = weapon_find(wp);
if is_real(str) || array_index_exists(global.customs,str){
    str = string_replace(convert(str),"x ", `${global.colors[col]} `)
}
else{
    for var i = 1; i < array_length_1d(global.colors); i++;{
        str = string_replace(str, global.colors[i], global.colors[col])
    }
}
str = reverse(str)
if (is_real(str) || mod_exists("weapon",str)) && str != weapon_find(wp){
    if is_object(wp){
        weapon_set(wp,str)
    }
    else wep = str
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

#define skill_tip
switch global.colors[global.color]
{
  case "pest"    : return "@sREIGN OF @gTERROR";
  case "fire"    : return "@rBURN @sTHE WORLD DOWN";
  case "psy"     : return "@sIT @pBEGINS";
  case "thunder" : return "@bSTRIKE @s'EM DOWN";
  case "blind"   : return "@dNEVERMIND";
  case "bouncer" : return "@sTHE @ySTARS @sHAVE ALIGNED";
}
return "BELIEVE";
