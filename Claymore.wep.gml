#define init
global.sprClaymore   = sprite_add_weapon("sprites/Claymore.png", 4, 4);
global.sprLunatic 	 = sprite_add_weapon("sprites/sprLunatic.png", 1, 13);

#define weapon_name
if instance_is(self,Player)
{
	if string_upper(alias) = "SAIX"{return "LUNATIC"}
}
return "CLAYMORE";

#define weapon_sprt
if instance_is(self,Player){
	if string_upper(alias) = "SAIX"{
		return global.sprLunatic;
	}
}
return global.sprClaymore;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 23;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return 8;

#define weapon_melee
return 1

#define weapon_text
//fucking kingdom hearts reference that nobody will understand. what the fuck karm why is this in? people will think we cant spell
//im furious
//fucking "claymores in kingdom hearts have moon themes"
//i cant believe this
//im going to scream until the sky itself parts and lets loose a cascade of justice upon Karmelyth
//those who create flavor texts such as this deserve to be smitten by only the highest powers
return "ABSOLUTELY LUNATIC";

#define weapon_fire

sound_play(sndHammer)
weapon_post(8,10,5)

with instance_create(x,y,Slash)
{
	sprite_index = sprHeavySlash
	damage = 12
	creator = other
	motion_add(other.gunangle, 2 + (skill_get(13) * 3))
	image_angle = direction
	team = other.team
	image_xscale *= 1.1
	image_yscale *= 1.2
	if skill_get(13) {
		x += 4 *hspeed;
		y += 4 *vspeed
	}
	flip = -sign(other.wepangle)
	if fork(){
		wait(3)
		if !instance_exists(self) exit
		sound_play(sndExplosionS)
		instance_create(x+lengthdir_x(40,direction-20*flip),y+lengthdir_y(40,direction-20*flip),SmallExplosion)
		wait(1)
		if !instance_exists(self) exit
		sound_play(sndExplosionS)
		instance_create(x+lengthdir_x(45,direction),y+lengthdir_y(45,direction),Explosion)
		wait(1)
		if !instance_exists(self) exit
		sound_play(sndExplosionS)
		instance_create(x+lengthdir_x(40,direction+20*flip),y+lengthdir_y(40,direction+20*flip),SmallExplosion)
		exit
	}

}
wepangle = -wepangle
motion_add(gunangle,5)
sound_play(sndExplosion)
