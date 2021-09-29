#define create_new_splash(x, y)
	with instance_create(x, y, CustomObject) {
		name = "SodaPopup"

		text = "Default Text"
		subtext = "Default Subtext"
		shake = shake_base
		subshake = shake_base

		time = 100
		depth = -10
		on_step = sodatext_step
		on_draw = sodatext_draw

		sound_play_pitch(sndRecGlandProc, 1.5)

		return id
	}

#macro subtext_time 85
#macro shake_base 6

#define sodatext_step
	time -= current_time_scale
	shake = max(shake - current_time_scale, 0)
	if time < subtext_time {
		subshake = max(subshake - current_time_scale, 0)
		if subshake = shake_base - current_time_scale {
			sound_play_pitch(sndRecGlandProc, 1.75)
		}
	}
	if time <= 0 instance_destroy()

#define sodatext_draw
	var h = draw_get_halign()
	draw_set_halign(1)
	if time > 30 or time mod 3 < 2 {
		draw_text_tilt_shadow(x + random(shake), y + random(shake), text, image_angle, image_blend)

		if time < subtext_time {
			draw_text_tilt_shadow(x + random(subshake) + lengthdir_x(8, image_angle - 90), y + random(subshake) + lengthdir_y(8, image_angle - 90), subtext, image_angle, image_blend)
		}
	}
	draw_set_halign(h)

#define draw_text_tilt_shadow(x, y, str, angle, color)
	draw_text_transformed_color(x + 1, y + 1, str, 1, 1, angle, c_black, c_black, c_black, c_black, 1)
	draw_text_transformed_color(x, y, str, 1, 1, angle, color, color, color, color, 1)

// #define step
// if button_pressed(0, "horn") mod_script_call("mod","sodaeffect","drink",mouse_x_nonsync, mouse_y_nonsync)

#define drink(_x,_y)

	var angle = random_range(45,135);
	var length = random_range(30,50);
	with create_new_splash(_x + lengthdir_x(length, angle), _y + lengthdir_y(length, angle) - 20) {
		text = (choose("DELICIOUS", "YEAH!", "REFRESHING", "RADICAL", "OH YEAH", "DELECTABLE", "SWEET") + "!")
	    image_angle = random_range(5, 2) * choose(-1, 1)
		return id
	}

#define sound_play_drink()
	sound_play_pitch(sndHPPickup, 1.4)
	sound_play_pitch(sndOasisCrabAttack, random_range(.6, .8))
	sound_play_pitch(sndToxicBoltGas, random_range(1.2, 1.4))
	repeat(7) with instance_create(x, y, Bubble) {
		image_speed *= 1.6
	}

#define sound_play_soda()
	sound_play_pitch(sndToxicBoltGas, random_range(2.3, 2.4))
	sound_play_pitch(sndOasisCrabAttack, random_range(.5, .6))
	return -1

#define soda_swap()
	wep = 0
	wep = bwep
	bwep = 0
	curse = bcurse
	reload = max(breload, 10)
