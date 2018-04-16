#define init
global.sprPhlogenitator = sprite_add_weapon("sprites/Phlogenitator.png", 4, 4);

#define weapon_name
return "PHLOGENITATOR"

#define weapon_sprt
return global.sprPhlogenitator;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 50;

#define weapon_cost
return 16;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 15;

#define weapon_text
return "OH @rYEAH";

#define weapon_fire

sound_play(sndMachinegun)
sound_play(sndCrossbow)
sound_play(sndShotgun)
sound_play(sndSuperFlakCannon)
sound_play(sndIncinerator)
sound_play(sndFlameCannonEnd)
weapon_post(10,-30,25)
repeat(6)
{
	mod_script_call("mod", "defpack tools 2","create_flak",0,80,13,random_range(0.4,0.85),FlameShell,25,id)
}
