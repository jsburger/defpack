#define init
global.sprBouncerDiscGun = sprite_add_weapon("sprites/weapons/sprBouncerDiscGun.png",-3,3)
return "BOUNCER DISC GUN"
#define weapon_type
return 3
#define weapon_cost
return 2
#define weapon_area
return 8
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
return "OOPS"
#define nts_weapon_examine
return{
    "d": "The faster the Disc, the higher the damage. ",
}
#define weapon_fire
weapon_post(3,4,0)
sound_play_pitch(sndDiscgun,random_range(.85,.95))
sound_play_pitch(sndBouncerSmg,1.4)
with mod_script_call_self("mod","defpack tools","create_bouncerdisc",x,y)
{
    creator = other
    team = other.team
    move_contact_solid(other.gunangle,12)
    motion_add(other.gunangle+random_range(-8,8)*other.accuracy,4)
    image_angle = direction
}
