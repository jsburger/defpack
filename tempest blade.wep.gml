#define init
global.sprTempestBlade = sprite_add_weapon("sprites/sprTempestBlade.png",0,7)
global.sprAirSlash 	   = sprite_add("sprites/projectiles/sprAirSlash.png",4,0,24)
global.mskAirSlash     = sprite_add("comboweps/rapiermask.png",3,3,28)
#define weapon_name
return "TEMPEST BLADE"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return 11
#define weapon_load
return 20
#define weapon_swap
return sndSwapSword
#define weapon_auto
return 0
#define weapon_melee
return 1
#define weapon_laser_sight
return 0
#define weapon_fire
if "tempest" not in self {tempest = 2}
tempest = ++tempest mod 3
motion_add(gunangle,2)
weapon_post(10,0,5)
wepangle*=-1
if tempest = 2{
    reload+= 6
    sound_play_pitch(sndBlackSword,random_range(1,1.2))
}
else{
    sound_play_pitch(sndBlackSword,random_range(1.2,1.5))
}
if tempest = 1 reload+= 3
with instance_create(x+lengthdir_x(20*skill_get(13),direction),y+lengthdir_y(20*skill_get(13),direction),Slash)
{
	sprite_index = global.sprAirSlash
	motion_add(other.gunangle,1 + skill_get(13)*2)
	projectile_init(other.team,other)
	image_yscale = -sign(other.wepangle)
	image_angle = direction
	image_speed = .4
	damage = 4
	if other.tempest = 2{
	    sleep(100)
	    with mod_script_call("mod","defpack tools", "create_lightning",x+lengthdir_x(30,direction),y+lengthdir_y(30,direction)){
            team = other.team
            motion_set(other.direction,other.speed)
            image_xscale/=1.5
            image_yscale/=1.5
        }
        play_sound_lightning()
	}
}

//if rapiers != 2{reload+=6}



#define play_sound_lightning()
sound_play_pitch(sndExplosion,2)
sound_play_pitch(sndExplosionS,.7)
sound_play_pitchvol(sndExplosionL,.5,.6)
sound_set_track_position(sndExplosionL,.3)
sound_play_pitch(sndSuperBazooka,.5)
if skill_get(17){
	sound_play_pitchvol(sndLightningCannonEnd,.8,.7)
	sound_play_pitchvol(sndLightningRifleUpg,.7,.6)
}
else{
	sound_play_pitchvol(sndLightningRifle,.7,.6)
}


#define weapon_sprt
return global.sprTempestBlade
#define weapon_text
return choose("A sorcerous @wblade @simbued#with the power of gale-force @wwinds")
