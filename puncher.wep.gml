#define init
global.sprPuncher 			= sprite_add_weapon("sprites/weapons/sprPuncher.png",11,3)
global.sprPuncherRocket = sprite_add("sprites/projectiles/sprPuncherRocket.png",0,6,6)
#macro current_frame_active (current_frame < floor(current_frame) + current_time_scale)
#define weapon_name
return "PUNCHER"
#define weapon_type
return 4
#define weapon_cost
return 3
#define weapon_area
return 10
#define weapon_load
return 27
#define weapon_swap
return sndSwapExplosive
#define weapon_auto
return 0
#define weapon_melee
return 0
#define weapon_laser_sight
return 0
#define weapon_sprt
return global.sprPuncher
#define weapon_text
return "breaking through"
#define nts_weapon_examine
return{
    "d": "A rocket launcher from a long-lost war. #Good at breaking through walls and frontlines alike. ",
}

#define weapon_fire
	mod_script_call("mod", "defburst", "burst", 3, 2, self, script_ref_create(fire_burst))

#define fire_burst(_burst)

	var r = random_range(.8, 1.2),
		v = 1,
		i = _burst.shots_fired,
		c = instance_is(self, FireCont) ? creator : self;

	sound_play_pitchvol(sndHeavySlugger,	.75 * r, v);
	sound_play_pitchvol(sndSuperSlugger,	.75 * r, v);
	sound_play_pitchvol(sndNukeFire,		.80 * r, v);
	
	weapon_post(6, 7, 22);
	
	with instance_create(x, y, CustomProjectile){
		
		name			= "Puncher Rocket";
		team			= other.team;
		creator			= c;
		maxspeed		= 25
		damage			= 15
		sprite_index	= global.sprPuncherRocket;
		
		immuneToDistortion = 1; // Goodmod compat
		
		move_contact_solid(creator.gunangle, 8);
		motion_set(creator.gunangle + random_range(-2 - i, 2 + i) * creator.accuracy, 1);
		extradir = random_range(.10, .25) * -sign(creator.gunangle - direction) * creator.accuracy * i;
		image_angle = direction;
		
		// Smoke particles:
		repeat(2){
			with instance_create(x,y,Smoke){
				speed		= random_range(3, 5);
				direction	= other.direction + random_range(-5, 5);
			}
		}
		
		on_destroy  = puncherdie;
		on_step 	= puncherstep;
		on_end_step = puncherendstep;
		on_draw 	= puncherdraw;
	}

	sound_play(sndRocketFly);

#define puncherdraw
draw_self()
draw_sprite_ext(sprRocketFlame, -1, x, y, 1, 1, image_angle, c_white, image_alpha)

#define puncherendstep
with instance_create(x,y,BoltTrail) {
	image_blend = c_yellow
	image_angle = point_direction(x,y,other.xprevious, other.yprevious)
	image_xscale = point_distance(x,y,other.xprevious, other.yprevious)
	image_yscale = 1.4
	if fork() {
	    while instance_exists(self) {
	        image_blend = merge_color(image_blend,c_red,.1*current_time_scale)
	        wait(0)
	    }
	    exit
	}
}

#define puncherstep
if current_frame_active && !irandom(2) instance_create(x, y, Smoke)
direction += extradir * current_time_scale
speed += current_time_scale *.7
image_angle = direction
if speed >= maxspeed speed = maxspeed

#define puncherdie
sound_play(sndExplosion)
instance_create(x,y,Explosion)
for (var i = 1;i <= 3; i++){
	instance_create(x+lengthdir_x(18*i,direction),y+lengthdir_y(18*i,direction),SmallExplosion)
}
//instance_create(x+lengthdir_x(16*4,direction),y+lengthdir_y(16*4,direction),SmallExplosion)
/*instance_create(x+lengthdir_x(16,direction),y+lengthdir_y(16,direction),SmallExplosion)
instance_create(x+lengthdir_x(-16,direction),y+lengthdir_y(16,direction),SmallExplosion)
instance_create(x+lengthdir_x(16,direction),y+lengthdir_y(-16,direction),SmallExplosion)
instance_create(x+lengthdir_x(-16,direction),y+lengthdir_y(-16,direction),SmallExplosion)
*/
