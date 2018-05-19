#define init
global.sprRainbowMachinegun = sprite_add_weapon("sprites/sprRainbowMachinegun.png", 0, 3);

#define weapon_name
return "RAINBOW MACHINEGUN"

#define weapon_sprt
return global.sprRainbowMachinegun;

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
return 8;

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
sound_play_pitch(sndTripleMachinegun,random_range(1.3,1.5))
sound_play_pitch(sndCrossReload,random_range(1.7,1.8))
weapon_post(5,-5,7)
switch rainbow_cycle{
	case 0:
	sound_play_pitchvol(sndSwapFlame,random_range(1.4,1.6),.7)
	sound_play_pitchvol(sndIncinerator,1,.2)
		mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,5), c_red)
		with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
			creator = other
			team = other.team
			motion_add(other.gunangle+random_range(-10,10)*other.accuracy,20)
			image_angle = direction
		}
		break
	case 1:
		mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,5), c_yellow)
		with instance_create(x,y,Bullet1){
			creator = other
			team = other.team
			motion_add(other.gunangle+random_range(-10,10)*other.accuracy,20)
			image_angle = direction
		}
		break
	case 2:
	sound_play_pitch(sndToxicBoltGas,random_range(3,3.8))
		mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,5), c_green)
		with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x,y){
			creator = other
			move_contact_solid(other.gunangle,6)
			team = other.team
			motion_add(other.gunangle+random_range(-10,10)*other.accuracy,20)
			image_angle = direction
		}
		break
	case 3:
	if !skill_get(17)sound_play_pitch(sndLightningRifle,random_range(1.4,1.6))else sound_play_pitch(sndLightningRifleUpg,random_range(1.6,1.8))
		mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,5), c_navy)
		with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x,y){
			creator = other
			move_contact_solid(other.gunangle,6)
			team = other.team
			motion_add(other.gunangle+random_range(-10,10)*other.accuracy,20)
			image_angle = direction
		}
		break
	case 4:
	sound_play_pitch(sndSwapCursed,random_range(1.3,1.6))
		mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(2,5), c_purple)
		with mod_script_call("mod", "defpack tools", "create_psy_bullet",x,y){
			creator = other
			move_contact_solid(other.gunangle,6)
			team = other.team
			motion_add(other.gunangle+random_range(-10,10)*other.accuracy,20)
			image_angle = direction
		}
		break
}
rainbow_cycle = ++rainbow_cycle mod 5
