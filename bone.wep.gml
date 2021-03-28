#define init
global.sprBone = sprite_add_weapon("sprites/weapons/sprBone.png",0,2)
global.mskBone = sprite_add_weapon("sprites/projectiles/mskBone.png",20,2)

#define weapon_name
return "BONE"
#define weapon_type
return 0
#define weapon_cost
return 0
#define weapon_area
return 4;
#define weapon_load
return 10
#define weapon_swap
return sndSwapSword
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_fire
sound_play_pitch(sndScrewdriver,random_range(.6,.8))
sound_play_pitch(sndBloodHammer,random_range(1.6,2.2))
weapon_post(-12 - (20*skill_get(13)),10,0)
with instance_create(x+lengthdir_x(12+(20*skill_get(13)),gunangle),y+lengthdir_y(12+(20*skill_get(13)),gunangle),CustomSlash){
	sprite_index = sprShank
	image_alpha = 0
	damage = 34
	if skill_get(13) = true mask_index = global.mskBone mask_index = global.sprBone
	image_speed = .4
	creator = other
	team = other.team
	hit = 0
	image_angle = other.gunangle
	direction = image_angle
	canfix = false
	with instance_create(x,y,BloodStreak){
		image_angle = other.image_angle
		image_xscale = .5
	}
	on_grenade = bone_grenade
	on_projectile = bone_projectile
	on_destroy = bone_destroy
	on_hit = bone_hit
	on_wall = bone_wall
	on_anim = bone_anim
}
#define weapon_sprt
return global.sprBone
#define weapon_text
return "GHOULISH"
#define nts_weapon_examine
return{
    "d": "A point-blank melee weapon. #Missing with this will hurt the wielder. ",
}
#define bone_wall
speed = 0

#define bone_destroy
if !hit with creator if instance_is(self,hitme){
    projectile_hit(self,1)
    lasthit = [global.sprBone,"BONE"]
}

#define bone_projectile
with other if typ > 0 instance_destroy()

#define bone_grenade
with other instance_destroy()

#define bone_anim
instance_destroy()

#define bone_hit
var _splat = -4;
_splat = determine_gore(other)
repeat(3) with instance_create((other.x*other.size+x)/(other.size+1),(other.y*other.size+y)/(other.size+1),_splat){image_angle = random(360)}
	    
	    
hit = 1
sound_play_pitchvol(sndHammerHeadEnd,random_range(1.23,1.33),20)
sound_play_pitch(sndGruntHurtF,.8)
sound_play_pitchvol(sndCursedPickup,2,20)
projectile_hit(other,damage,12,direction)
sleep(150)
view_shake_at(x,y,150)
for (var i = 1; i <= 3; i++){
	sound_play_gun(sndClickBack,1,.4)
	sound_stop(sndClickBack)
    with instance_create(x+lengthdir_x(18*i, direction),y+lengthdir_y(18*i, direction), MeatExplosion){
        creator = other.creator
        team = other.team
        if !place_meeting(x,y,Floor) instance_destroy()
    }
}
instance_destroy()

#define determine_gore(_id) return mod_script_call("mod", "defpack tools", "determine_gore", _id);
