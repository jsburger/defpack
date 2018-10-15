#define init
global.sprBouncerDiscGun = sprite_add_weapon("sprBouncerDiscGun.png",-3,3)
return "BOUNCER DISC GUN"
#define weapon_type
return 3
#define weapon_cost
return 2
#define weapon_area
return 6
#define weapon_load
return 17
#define weapon_swap
return sndSwapBow
#define weapon_auto
return true
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_sprt
return global.sprBouncerDiscGun
#define weapon_text
return "SORRY"
#define weapon_fire
weapon_post(3,4,0)
sound_play_pitch(sndDiscgun,random_range(.85,.95))
sound_play_pitch(sndBouncerSmg,1.4)
with mod_script_call("mod","defpack tools","create_bouncerdisc",x,y)
{
    creator = other
    team = other.team
    move_contact_solid(other.gunangle,12+other.speed)
    motion_add(other.gunangle+random_range(-8,8)*other.accuracy,4)
    image_angle = direction
}
