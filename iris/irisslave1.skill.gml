#define init
global.mycolor = real(string_char_at(mod_current,10))
global.sprite = sprite_add("sprMutPrismaticIris"+string(global.mycolor)+".png",1,12,16)

#define skill_take
sound_play_pitchvol(sndBasicUltra,2,.5)
sound_play_pitchvol(sndToxicBoltGas,.6,.4)
sound_play_pitchvol(sndOasisChest,.5,.4)
sound_play_pitchvol(sndOasisExplosion,2,.4)
sound_play_pitchvol(sndOasisExplosionSmall,3,.4)
mod_variable_set("skill","prismatic iris","color",global.mycolor)
skill_set(mod_current,0)

#define skill_avail
return 0

#define skill_button
sprite_index = global.sprite

#define skill_name
return mod_variable_get("skill","prismatic iris","names")[global.mycolor]
