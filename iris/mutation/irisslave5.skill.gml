#define init
global.mycolor = real(string_char_at(mod_current,10))
global.sprite = sprite_add("sprites/sprMutPrismaticIris"+string(global.mycolor)+".png",1,12,16)

#define game_start
skill_set_active(mut_recycle_gland,1)

#define skill_take
sound_play_pitchvol(sndBasicUltra,2,.5)
skill_set_active(mut_recycle_gland,0)
mod_variable_set("skill","prismatic iris","color",global.mycolor)
skill_set(mod_current,0)

#define skill_avail
return 0

#define skill_button
sprite_index = global.sprite

#define skill_name
return mod_variable_get("skill","prismatic iris","names")[global.mycolor]
