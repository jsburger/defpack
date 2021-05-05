#define init
global.sprBigThunderIron = sprite_add_weapon("../../sprites/weapons/iris/thunder/sprThunderBigIron.png", 4, 3);
global.ThunderBullet = sprite_add("../../sprites/projectiles/iris/thunder/sprThunderBullet.png", 2, 8, 8);

#define weapon_name
return "BIG THUNDER IRON"

#define weapon_sprt
return global.sprBigThunderIron;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 20;

#define weapon_cost
return 20;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "SHOCKER";


#define sound_play_hit_ext(_sound, _pitch, _vol)
var _s = sound_play_hit(_sound, 0);
sound_pitch(_s, _pitch);
sound_volume(_s, _vol);


#define sound_play_bulk(_sounds, _pitch, _vol)
for (var i = 0, _l = array_length(_sounds); i < _l; i++){
	sound_play_hit_ext(_sounds[i].sound, lq_defget(_sounds[i], "pitch", 1) * _pitch, lq_defget(_sounds[i], "volume", 1) * _vol)
}

#define weapon_fire
repeat(2){
  weapon_post(7, 24, 16)
  sleep(30)
  var _p = random_range(.8, 1.2)
  var _sounds1 = [
    {sound : sndSlugger, pitch : 1.2},
    {sound : sndDoubleShotgun, pitch : .8},
    {sound : sndGammaGutsKill, pitch : 1.5},
    {sound : sndHeavyNader, pitch : 1.3},
    {sound : sndMachinegun, pitch : .6},
    {sound : sndLightningCannonEnd, pitch : 1.8},
    {sound : sndSuperSlugger, pitch : .7}
  ];
  var _sounds2 = [
  	{sound : sndSlugger, pitch : 1.2},
  	{sound : sndDoubleShotgun, pitch : .8},
  	{sound : sndGammaGutsKill, pitch : 1.2},
  	{sound : sndHeavyNader, pitch : 1.3},
  	{sound : sndMachinegun, pitch : .6},
  	{sound : sndLightningCannonEnd, pitch : .8},
    {sound : sndSuperSlugger, pitch : .7},
  	{sound : sndLightningReload, pitch : .5},
    {sound : sndLightningPistol, pitch : .6}
  ];

  sound_play_bulk(skill_get(mut_laser_brain)>0 ? _sounds2 : _sounds1, _p, .6)

  with instance_create(x + lengthdir_x(24, gunangle), y + lengthdir_y(24, gunangle), CustomObject) {
  	depth = -1
  	sprite_index = global.ThunderBullet
  	image_speed = .9
  	on_step = muzzle_step
  	on_draw = muzzle_draw
  	image_yscale = .5
  	image_angle = other.gunangle
  }

    repeat(4){
        mod_script_call("mod", "defpack tools", "shell_yeah", right * 90, 40, 2 + random(2), c_navy);
        with mod_script_call("mod", "defhitscan", "create_thunder_hitscan_bullet", x + lengthdir_x(12, gunangle), y + lengthdir_y(12, gunangle)){
            direction = other.gunangle + random_range(-24, 24) * other.accuracy;
            image_angle = direction;
            creator = other
            team = other.team
        }
    }
    wait(3)
    if !instance_exists(self) exit
}

#define muzzle_step
if image_index > 1{instance_destroy()}

#define muzzle_draw
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2.5*image_xscale, 2*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);
