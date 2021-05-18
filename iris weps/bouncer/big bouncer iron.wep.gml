#define init
global.sprBigBouncerIron = sprite_add_weapon("../../sprites/weapons/iris/bouncer/sprBouncerBigIron.png", 2, 4);

#define weapon_name
return "BIG BOUNCER IRON"

#define weapon_sprt
return global.sprBigBouncerIron;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 22;

#define weapon_cost
return 10;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define nts_weapon_examine
return{
    "d": "Using rubber rounds, these babies cause chaos all around the wasteland. ",
}

#define weapon_text
return "NO NEED TO AIM";


#define sound_play_hit_ext(_sound, _pitch, _vol)
var _s = sound_play_hit(_sound, 0);
sound_pitch(_s, _pitch);
sound_volume(_s, _vol);


#define sound_play_bulk(_sounds, _pitch, _vol)
for (var i = 0, _l = array_length(_sounds); i < _l; i++){
	sound_play_hit_ext(_sounds[i].sound, lq_defget(_sounds[i], "pitch", 1) * _pitch, lq_defget(_sounds[i], "volume", 1) * _vol)
}

#define weapon_fire
weapon_post(7, 32, 28)
sleep(30)
var _p = random_range(.7, 1.3)
var _sounds = [
	{sound : sndSlugger, pitch : 1.2},
	{sound : sndDoubleShotgun, pitch : .8},
	{sound : sndBouncerShotgun, pitch : .8},
	{sound : sndHeavyNader, pitch : 1.3},
	{sound : sndBouncerSmg, pitch : .7},
	{sound : sndSawedOffShotgun, pitch : .7},
	{sound : sndSuperSlugger, pitch : .6}
];

sound_play_bulk(_sounds, _p, .6)

/*
sound_play_pitchvol(sndSlugger,1.2*_p,.6)
sound_play_pitchvol(sndDoubleShotgun,.8*_p,.6)
sound_play_pitchvol(sndShotgun,.8*_p,.6)
sound_play_pitchvol(sndHeavyNader,1.3*_p,.6)
sound_play_pitchvol(sndMachinegun,.6*_p,.6)
sound_play_pitchvol(sndSawedOffShotgun,.8*_p,.6)
sound_play_pitchvol(sndSuperSlugger,.7*_p,.6)
*/
with instance_create(x + lengthdir_x(24, gunangle), y + lengthdir_y(24, gunangle), CustomObject) {
	depth = -1
	sprite_index = sprBullet1
	image_speed = .9
	on_step = muzzle_step
	on_draw = muzzle_draw
	image_yscale = .5
	image_angle = other.gunangle
}

repeat(3){
    repeat(2){
        with instance_create(x, y, Shell) {
        	motion_add(other.gunangle + 90 + random_range(-40, 40), 2 + random(2))
        }
        with mod_script_call("mod", "defhitscan", "create_bouncer_hitscan_bullet"){
            direction = other.gunangle + random_range(-18, 18) * other.accuracy;
            image_angle = direction;
            creator = other
            team = other.team
            move_contact_solid(other.gunangle, 12);
            damage++
			pierce++
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
