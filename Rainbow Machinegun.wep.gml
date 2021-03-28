#define init
global.sprRainbowMachinegun = sprite_add_weapon("sprites/weapons/sprRainbowMachinegun.png", 5, 3);
global.sprHUD0 = sprite_add_weapon("sprites/weapons/sprRainbowMachinegun.png", 8, 3);
global.sprHUD1 = sprite_add("sprites/interface/sprRainbowMachinegunHUD1.png", 1, 8, 3);
global.sprHUD2 = sprite_add("sprites/interface/sprRainbowMachinegunHUD2.png", 1, 8, 3);
global.sprHUD3 = sprite_add("sprites/interface/sprRainbowMachinegunHUD3.png", 1, 8, 3);
global.sprHUD4 = sprite_add("sprites/interface/sprRainbowMachinegunHUD4.png", 1, 8, 3);
global.sprHUD5 = sprite_add("sprites/interface/sprRainbowMachinegunHUD5.png", 1, 8, 3);

#define weapon_name
return "RAINBOW MACHINEGUN"

#define weapon_sprt
return global.sprRainbowMachinegun;

#define weapon_sprt_hud
  if "rainbow_cycle" in self switch rainbow_cycle{
      case 0: return global.sprHUD1;
      case 1: return global.sprHUD2;
      case 2: return global.sprHUD3;
      case 3: return global.sprHUD4;
      case 4: return global.sprHUD5;
      default: return global.sprHUD0;
  }else return global.sprHUD0;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 4;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 6;

#define nts_weapon_examine
return{
    "d": "This gun uses a a prism to turn light into various kinds of bullets. ",
}

#define weapon_text
return choose("/CANDELA","0/10 USES TOXIC");

#define weapon_fire
if "rainbow_cycle" not in self{rainbow_cycle = 0}
/*fire
bullet
toxic
lightning
psy*/

sound_play(sndMachinegun)
sound_play_pitchvol(sndTripleMachinegun,random_range(1.3,1.6),.5)
sound_play_pitchvol(sndCrossReload,random_range(1.5,1.9),.5)
weapon_post(5,-6,1)
var b = ["fire", BouncerBullet, "toxic", "lightning", "psy"], c = [c_red, c_yellow, c_green, c_navy, c_purple], a;
if is_string(b[rainbow_cycle]) a = mod_script_call_nc("mod", "defpack tools", `create_${b[rainbow_cycle]}_bullet`,x, y)
else a = instance_create(x, y, b[rainbow_cycle])
with a {
    creator = other
    team = other.team
    motion_add(other.gunangle + random_range(-5, 5) * other.accuracy, 14)
    image_angle = direction
    move_contact_solid(other.gunangle, 6)
}
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,5), c[rainbow_cycle])

/*switch rainbow_cycle{
	case 0:
		mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,5), c_red)
		with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
			creator = other
			team = other.team
			motion_add(other.gunangle+random_range(-10,10)*other.accuracy,12)
			image_angle = direction
		}
		break
	case 1:
		mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,5), c_yellow)
		with instance_create(x,y,BouncerBullet){
			creator = other
			team = other.team
			motion_add(other.gunangle+random_range(-10,10)*other.accuracy,12)
			image_angle = direction
		}
		break
	case 2:
		mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,5), c_green)
		with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x,y){
			creator = other
			move_contact_solid(other.gunangle,6)
			team = other.team
			motion_add(other.gunangle+random_range(-10,10)*other.accuracy,12)
			image_angle = direction
		}
		break
	case 3:
		mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,5), c_navy)
		with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
			creator = other
			move_contact_solid(other.gunangle,6)
			team = other.team
			motion_add(other.gunangle+random_range(-10,10)*other.accuracy,12)
			image_angle = direction
		}
		break
	case 4:
		mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,5), c_purple)
		with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
			creator = other
			move_contact_solid(other.gunangle,6)
			team = other.team
			motion_add(other.gunangle+random_range(-10,10)*other.accuracy,12)
			image_angle = direction
			maxspeed = speed
			timer = 0
		}
		break
}*/
rainbow_cycle = ++rainbow_cycle mod 5
