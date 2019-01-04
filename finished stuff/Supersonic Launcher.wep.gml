#define init
global.sprSuperSonicLauncher   = sprite_add_weapon("sprSuperSonicLauncher.png", 1, 3);
#define weapon_name
return "SUPERSONIC LAUNCHER"

#define weapon_sprt
return global.sprSuperSonicLauncher ;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 43;

#define weapon_cost
return 4;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 15;

#define weapon_text
return choose("A TRUE BOOMBURST","SHIFT SOME SMOKE","CLOSE COMBAT INFUSION");

#define weapon_fire
sleep(12)
//sound_play_pitch(sndDiscgun,1.6) good pest sound
//sound_play_pitch(sndPortalAppear,3) ancient gunnery
sound_play_pitch(sndUltraShotgun,1.7)
sound_play_pitch(sndHyperLauncher,random_range(.5,.7))
weapon_post(12,-16,23)
motion_add(gunangle -180,6)
with instance_create(x,y,CustomProjectile)
{
		move_contact_solid(other.gunangle,10)
		sleep(55)
		sprite_index = mskNone
		mask_index = sprNuke
		index = other.index
		team  = other.team
		damage = 70
		dir = 0
		image_angle = other.gunangle
		Ring1Amount = 6
		Ring2Amount = 12
		ringoffset	= random(359)
		instance_create(x,y,Smoke)
		repeat(30){with instance_create(x,y,Dust){motion_add(other.direction-random_range(-60,60),random_range(2,5));growspeed = random_range(0.1,0.005)}}
		direction = other.gunangle+random_range(-2,2)*other.accuracy
		if place_meeting(x,y,enemy) || place_meeting(x,y,Wall) //haha yes
		{
			with mod_script_call("mod","defpack tools","create_sonic_explosion",other.x,other.y)
			{
				var scalefac = 1;
				image_xscale = scalefac
				image_yscale = scalefac

				damage = 12
				image_speed = 0.6
				team = other.team

				repeat(scalefac*10){ with instance_create(x,y,Dust) {motion_add(random(360),7)}}
			}
			with mod_script_call("mod","defpack tools","create_sonic_explosion",other.x,other.y)
			{
				var scalefac = 0.8;
				image_xscale = scalefac
				image_yscale = scalefac

				damage = 8
				image_speed = 0.5
				team = other.team

				repeat(scalefac*10){ with instance_create(x,y,Dust) {motion_add(random(360),7)}}
			}
			with mod_script_call("mod","defpack tools","create_sonic_explosion",other.x,other.y)
			{
				var scalefac = 0.5;
				image_xscale = scalefac
				image_yscale = scalefac

				damage = 6
				image_speed = 0.4
				team = other.team

				repeat(scalefac*10){ with instance_create(x,y,Dust) {motion_add(random(360),7)}}
			}
			repeat(Ring1Amount)
			{
				Ring1Amount -= 1
				with mod_script_call("mod","defpack tools","create_sonic_explosion",other.x+lengthdir_x(60,360/6*Ring1Amount+ringoffset),other.y+lengthdir_y(60,360/6*Ring1Amount+ringoffset))
				{
					var scalefac = 0.5;
					image_xscale = scalefac
					image_yscale = scalefac

					damage = 5
					image_speed = 1
					team = other.team

					repeat(scalefac*10){ with instance_create(x,y,Dust) {motion_add(random(360),3)}}
				}
				with mod_script_call("mod","defpack tools","create_sonic_explosion",other.x+lengthdir_x(60,360/6*Ring1Amount+ringoffset),other.y+lengthdir_y(60,360/6*Ring1Amount+ringoffset))
				{
					var scalefac = 0.2;
					image_xscale = scalefac
					image_yscale = scalefac

					damage = 4
					image_speed = 0.8
					team = other.team

					repeat(scalefac*10){ with instance_create(x,y,Dust) {motion_add(random(360),3)}}
				}
			}
			repeat(Ring2Amount)
			{
				Ring2Amount -= 1
				with mod_script_call("mod","defpack tools","create_sonic_explosion",other.x+lengthdir_x(100,360/12*Ring2Amount+ringoffset),other.y+lengthdir_y(100,360/12*Ring2Amount+ringoffset))
				{
					var scalefac = 0.2;
					image_xscale = scalefac
					image_yscale = scalefac

					damage = 3
					image_speed = 0.5
					team = other.team


					repeat(scalefac*10){ with instance_create(x,y,Dust) {motion_add(random(360),3)}}
				}
			}
		sound_play_pitch(sndImpWristKill,1.7)
		sound_play_pitch(sndExplosionS,random_range(.4,.6))
		sound_play_pitch(sndSuperBazooka,2)
		repeat(8){with instance_nearest(x,y,Wall){if distance_to_object(other)<= 32{instance_create(x,y,FloorExplo);instance_destroy()}}}
		instance_destroy();exit
	}
	else {on_step = script_ref_create(sonic_launcher_step)}
}

#define sonic_launcher_step
sound_play_pitch(sndImpWristKill,1.7)
sound_play_pitch(sndExplosionS,random_range(.4,.6))
sound_play_pitch(sndSuperBazooka,2)
damage = 25
do
{
	dir += 1 x += lengthdir_x(1,direction) y += lengthdir_y(1,direction)
	if irandom(1) = 0 with instance_create(x,y,Dust){motion_add(other.direction-random_range(-80,80),random_range(2,7));growspeed = random_range(0.1,0.005)}
	if place_meeting(x,y,enemy) || place_meeting(x,y,Wall)
	{
		with mod_script_call("mod","defpack tools","create_sonic_explosion",other.x,other.y)
		{
			if !place_meeting(x,y,Floor){instance_destroy()}
			var scalefac = 1;
			image_xscale = scalefac
			image_yscale = scalefac

			damage = 12
			image_speed = 0.6
			team = other.team

			repeat(scalefac*10){ with instance_create(x,y,Dust) {motion_add(random(360),7)}}
		}
		with mod_script_call("mod","defpack tools","create_sonic_explosion",other.x,other.y)
		{
			if !place_meeting(x,y,Floor){instance_destroy()}
			var scalefac = 0.8;
			image_xscale = scalefac
			image_yscale = scalefac

			damage = 8
			image_speed = 0.5
			team = other.team

			repeat(scalefac*10){ with instance_create(x,y,Dust) {motion_add(random(360),7)}}
		}
		with mod_script_call("mod","defpack tools","create_sonic_explosion",other.x,other.y)
		{
			if !place_meeting(x,y,Floor){instance_destroy()}
			var scalefac = 0.5;
			image_xscale = scalefac
			image_yscale = scalefac

			damage = 6
			image_speed = 0.4
			team = other.team

			repeat(scalefac*10){ with instance_create(x,y,Dust) {motion_add(random(360),7)}}
		}

	repeat(Ring1Amount)
	{
		other.Ring1Amount -= 1
		with mod_script_call("mod","defpack tools","create_sonic_explosion",other.x+lengthdir_x(60,360/6*Ring1Amount+ringoffset),other.y+lengthdir_y(60,360/6*Ring1Amount+ringoffset))
		{
			var scalefac = 0.5;
			image_xscale = scalefac
			image_yscale = scalefac

			damage = 5
			image_speed = 1
			team = other.team

			if !place_meeting(x,y,Floor){instance_destroy()}else{repeat(scalefac*10){ with instance_create(x,y,Dust) {motion_add(random(360),3)}}}
		}
		with mod_script_call("mod","defpack tools","create_sonic_explosion",other.x+lengthdir_x(60,360/6*Ring1Amount+ringoffset),other.y+lengthdir_y(60,360/6*Ring1Amount+ringoffset))
		{
			var scalefac = 0.2;
			image_xscale = scalefac
			image_yscale = scalefac

			damage = 4
			image_speed = 0.8
			team = other.team

			if !place_meeting(x,y,Floor){instance_destroy()}else{repeat(scalefac*10){ with instance_create(x,y,Dust) {motion_add(random(360),3)}}}
		}
	}
	repeat(Ring2Amount)
	{
		other.Ring2Amount -= 1
		with mod_script_call("mod","defpack tools","create_sonic_explosion",other.x+lengthdir_x(100,360/12*Ring2Amount+ringoffset),other.y+lengthdir_y(100,360/12*Ring2Amount+ringoffset))
		{
			var scalefac = 0.2;
			image_xscale = scalefac
			image_yscale = scalefac

			damage = 3
			image_speed = 0.5
			team = other.team


			if !place_meeting(x,y,Floor){instance_destroy()}else{repeat(scalefac*10){ with instance_create(x,y,Dust) {motion_add(random(360),3)}}}
		}
	}
	}
}
while instance_exists(self) and !place_meeting(x,y,Wall) and !place_meeting(x,y,enemy) and dir < 1000
speed = other.speed+1
mask_index = other.mask_index
repeat(8){with instance_nearest(x,y,Wall){if distance_to_object(other)<= 32{instance_create(x,y,FloorExplo);instance_destroy()}}}
instance_destroy()
