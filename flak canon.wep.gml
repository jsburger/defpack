#define init
global.sprFlakCanon = sprite_add_weapon("sprites/sprFlakCanon.png", 4, 4);

#define weapon_name
return curse("FLAK CANON")

#define weapon_sprt
return global.sprFlakCanon;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 47;

#define weapon_cost
return 8;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 11;

#define weapon_text
return curse("PUT ME BACK");

#define curse(text)
var a = []
for var i = 1; i <= string_length(text); i++{
    a[i - 1] = string_char_at(text, i)
}
for var i = 0; i < array_length(a); i++{
    if a[i] != " "
        a[i] = "@q" + a[i]
}
return array_join(a, "")

#define weapon_fire

sound_play(sndMachinegun)
sound_play(sndCrossbow)
sound_play_pitch(sndShotgun,.7)
sound_play_pitch(sndFlakCannon,1.2)
sound_play_pitch(sndSuperFlakCannon,.7)
weapon_post(8,-20,20)
with mod_script_call_self("mod", "defpack tools 2", "create_recursive_flak", x, y){
    motion_set(other.gunangle + random_range(-6,6) * other.accuracy, random_range(10,13))
    creator = other
    team = other.team
    image_angle = direction
    accuracy = other.accuracy
}
#define step
if (current_frame < floor(current_frame) + current_time_scale){
    if argument0 || (!argument0 and race = "steroids") with instance_create(x+lengthdir_x(12,gunangle), y+lengthdir_y(12,gunangle), Curse){
        image_blend = c_black
    }
}
