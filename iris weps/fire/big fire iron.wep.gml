#define init
global.sprBigFireIron = sprite_add_weapon("../../sprites/weapons/iris/fire/sprFireBigIron.png", 2, 4);
global.FireBullet = sprite_add("../../sprites/projectiles/iris/fire/sprFireBullet.png", 2, 8, 8);

#define weapon_name
return "BIG FIRE IRON"

#define weapon_sprt
return global.sprBigFireIron;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 12;

#define weapon_cost
return 10;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define nts_weapon_examine
return{
    "d": "Internal pressure keeps this weapon hot forever. ",
}

#define weapon_text
return "STRIKE WHILE IT'S HOT";


#define sound_play_hit_ext(_sound, _pitch, _vol)
var _s = sound_play_hit(_sound, 0);
sound_pitch(_s, _pitch);
sound_volume(_s, _vol);


#define sound_play_bulk(_sounds, _pitch, _vol)
for (var i = 0, _l = array_length(_sounds); i < _l; i++){
	sound_play_hit_ext(_sounds[i].sound, lq_defget(_sounds[i], "pitch", 1) * _pitch, lq_defget(_sounds[i], "volume", 1) * _vol)
}

#define weapon_fire
weapon_post(7, 18, 34)
sleep(30)
var _p = random_range(.7, 1.3)
var _sounds = [
	{sound : sndSlugger, pitch : 1.2},
	{sound : sndDoubleFireShotgun, pitch : .8},
	{sound : sndIncinerator, pitch : .7},
	{sound : sndHeavyNader, pitch : 1.2},
	{sound : sndMachinegun, pitch : .6},
	{sound : sndSawedOffShotgun, pitch : .7},
	{sound : sndSuperSlugger, pitch : .5}
];

sound_play_bulk(_sounds, _p, .6)

with instance_create(x + lengthdir_x(24, gunangle), y + lengthdir_y(24, gunangle), CustomObject) {
	depth = -1
	sprite_index = global.FireBullet
	image_speed = .9
	on_step = muzzle_step
	on_draw = muzzle_draw
	image_yscale = .5
	image_angle = other.gunangle
}

repeat(3){
    repeat(2){
        mod_script_call("mod", "defpack tools", "shell_yeah", right * 90, 40, 2 + random(2), c_red);
        with mod_script_call("mod", "defhitscan", "create_fire_hitscan_bullet", x + lengthdir_x(12, gunangle), y + lengthdir_y(12, gunangle)){
            direction = other.gunangle + random_range(-28, 28) * other.accuracy;
            image_angle = direction;
            creator = other
            team = other.team
        }
    }
    wait(1)
    if !instance_exists(self) exit
}

#define muzzle_step
if image_index > 1{instance_destroy()}

#define muzzle_draw
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2.5*image_xscale, 2*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);
