#define init
global.sprBigGammaIron = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprHorrorBigIronOn.png", 2, 4);
global.sprGammaBullet = sprite_add("../../sprites/projectiles/iris/horror/sprGammaBullet.png", 2, 8, 8);

#define weapon_name
return "BIG PEST IRON"

#define weapon_sprt
return global.sprBigGammaIron;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 17;

#define weapon_cost
return 10;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "GREEN STREAKS";


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
	{sound : sndSlugger, pitch : 1.1},
	{sound : sndDoubleShotgun, pitch : .6},
	{sound : sndUltraShotgun, pitch : .8},
	{sound : sndHeavyNader, pitch : 1.1},
	{sound : sndUltraPistol, pitch : .6},
	{sound : sndSawedOffShotgun, pitch : .7},
	{sound : sndSuperSlugger, pitch : .5}
];

sound_play_bulk(_sounds, _p, .6)

with instance_create(x + lengthdir_x(24, gunangle), y + lengthdir_y(24, gunangle), CustomObject) {
	depth = -1
	sprite_index = global.sprGammaBullet
	image_speed = .9
	on_step = muzzle_step
	on_draw = muzzle_draw
	image_yscale = .5
	image_angle = other.gunangle
}

repeat(3){
    repeat(4){
        mod_script_call("mod", "defpack tools", "shell_yeah", right * 90, 40, 2 + random(2), c_lime);
        with mod_script_call("mod", "defhitscan", "create_gamma_hitscan_bullet", x + lengthdir_x(12, gunangle), y + lengthdir_y(12, gunangle)){
            direction = other.gunangle + random_range(-22, 22) * other.accuracy;
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
