#define init
global.mycolor = real(string_char_at(mod_current,10))
global.sprite = sprite_add("sprMutPrismaticIris"+string(global.mycolor)+".png",1,12,16)

#define skill_take
mod_variable_set("skill","prismatic iris","color",global.mycolor)
skill_set(mod_current,0)

#define skill_avail
return 0

#define skill_button
sprite_index = global.sprite