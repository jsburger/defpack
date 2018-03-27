#define init
global.sprSFC = sprite_add_weapon("sprites/SFC.png", 9, 8);

#define weapon_name
return "SUPER FLAME CANNON";

#define weapon_sprt
return global.sprSFC;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 155;

#define weapon_cost
return 8;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 15;

#define weapon_text
return "X MARKS THE SUN";

#define weapon_fire
weapon_post(15,-30,15)
sound_play(sndHeavyNader)
sound_play(sndFlameCannon)
with instance_create(x,y, CustomProjectile){
	motion_set(other.gunangle, 1.6)
	ogdamage = 10
	force = 7
	sprite_index = sprFlameBall
	image_xscale = 3
	image_yscale = 3
	sound_loop(sndFlameCannonLoop)
	team = other.team
	creator = other
	on_step = script_ref_create(cannon_step)
	on_hit = script_ref_create(cannon_hit)
	on_destroy = cannon_die
	on_wall = script_ref_create(cannon_wall)
	on_draw = script_ref_create(cannon_draw)
}

#define cannon_die
repeat(20){
	with instance_create(x,y,Flame){
		motion_set(random(359),random_range(3,5))
		team = other.team
		creator = other.creator
	}
}
sound_stop(sndFlameCannonLoop)
sound_play(sndFlameCannonEnd)

#define cannon_step
image_angle += 4 *image_xscale
var ang = 0
repeat(round(8*image_xscale)){
	with instance_create(x,y,Flame){
		motion_set(other.image_angle + ang, 3*other.image_xscale)
		team = other.team
		creator = other.creator
	}
	ang += 90
}
image_yscale = image_xscale
if image_xscale <= .2 {instance_destroy()}

#define cannon_hit
damage = ogdamage * image_xscale
force = 7 * image_xscale
with other if team != other.team {
	projectile_hit_push(self,round(other.damage),other.force)
	other.image_xscale -= .05
}

#define cannon_wall
with instance_nearest(x,y,Wall){
	instance_create(x,y,FloorExplo)
	instance_destroy()
}
image_xscale -= .05

#define cannon_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 1.5*image_xscale, 1.5*image_yscale, image_angle, image_blend, 0.1);
draw_set_blend_mode(bm_normal);
