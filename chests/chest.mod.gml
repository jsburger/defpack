#define init
global.sprRockletChest     = sprite_add_weapon("../sprites/chests/sprRockletChest.png", 8, 7);
global.sprRockletChestOpen = sprite_add("../sprites/chests/sprRockletChestOpen.png", 1, 8, 7);

global.sprVectorChest     = sprite_add_weapon("../sprites/chests/sprVectorChest.png", 9, 7);
global.sprVectorChestOpen = sprite_add("../sprites/chests/sprVectorChestOpen.png", 1, 9, 7);

global.sprZenithChest     = sprite_add_weapon("../sprites/chests/sprZenithChest.png", 8, 7);
global.sprZenithChestOpen = sprite_add("../sprites/chests/sprZenithChestOpen.png", 1, 8, 7);

global.sprQuartzChest     = sprite_add_weapon("../sprites/chests/sprQuartzChest.png", 8, 7);
global.sprQuartzChestOpen = sprite_add("../sprites/chests/sprQuartzChestOpen.png", 1, 8, 7);

global.sprRegalChest     = sprite_add_weapon("../sprites/chests/sprRegalChest.png", 8, 7);
global.sprRegalChestOpen = sprite_add("../sprites/chests/sprRegalChestOpen.png", 1, 8, 7);

global.sprUltraChest     = sprite_add_weapon("../sprites/chests/sprUltraChest.png", 8, 7);
global.sprUltraChestOpen = sprite_add("../sprites/chests/sprUltraChestOpen.png", 1, 8, 7);

global.sprToxicChest     = sprite_add_weapon("../sprites/chests/sprToxicChest.png", 8, 6);
global.sprToxicChestOpen = sprite_add("../sprites/chests/sprToxicChestOpen.png", 1, 8, 6);

global.sprComboChest     = sprite_add_weapon("../sprites/chests/sprComboChest.png", 8, 7);
global.sprComboChestOpen = sprite_add("../sprites/chests/sprComboChestOpen.png", 1, 8, 7);

global.sprSmartChest     = sprite_add_weapon("../sprites/chests/sprSmartChest.png", 8, 7);
global.sprSmartChestOpen = sprite_add("../sprites/chests/sprSmartChestOpen.png", 1, 8, 7);

global.sprFlameChest     = sprite_add_weapon("../sprites/chests/sprFlameChest.png", 8, 7);
global.sprFlameChestOpen = sprite_add("../sprites/chests/sprFlameChestOpen.png", 1, 8, 7);

global.sprBloodChest     = sprite_add_weapon("../sprites/chests/sprBloodChest.png", 8, 7);
global.sprBloodChestOpen = sprite_add("../sprites/chests/sprBloodChestOpen.png", 1, 8, 7);

global.sprHyperChest     = sprite_add_weapon("../sprites/chests/sprHyperChest.png", 8, 7);
global.sprHyperChestOpen = sprite_add("../sprites/chests/sprHyperChestOpen.png", 1, 8, 7);

global.sprAutoChest     = sprite_add_weapon("../sprites/chests/sprAutoChest.png", 8, 7);
global.sprAutoChestOpen = sprite_add("../sprites/chests/sprAutoChestOpen.png", 1, 8, 7);

global.sprToolChest     = sprite_add_weapon("../sprites/chests/sprToolChest.png", 10, 7);
global.sprToolChestOpen = sprite_add("../sprites/chests/sprToolChestOpen.png", 1, 10, 7);

global.sprAoEChest     = sprite_add_weapon("../sprites/chests/sprAoEChest.png", 9, 7);
global.sprAoEChestOpen = sprite_add("../sprites/chests/sprAoEChestOpen.png", 1, 9, 7);

global.chests = ds_map_create()
chest_add("Ultra",   14, [wep_ultra_shovel,wep_ultra_shotgun,wep_ultra_laser_pistol,wep_ultra_revolver,wep_ultra_crossbow,wep_ultra_grenade_launcher,"ultra spam gun","ultra hand","defender","ultra gunhammer"])
chest_add("AoE",     6,  ["buster","blaster","puncher"])
chest_add("Rocklet", 9,  ["rocklet pistol","rocklet rifle","rocklet cannon","super rocklet cannon","rocklet minigun"])
chest_add("Toxic",   3,  ["toxicthrower","cobra","toxic carronader",wep_toxic_bow,"heavy toxic crossbow",wep_toxic_launcher,"toxic cannon"])
chest_add("Tool",    3,  [wep_wrench,wep_screwdriver,wep_jackhammer,"chainsaw","nail gun","rivet gun"])
chest_add("Combo",   6,  ["rapier","rebounce axe","mega hammer"])
chest_add("Vector",  6,  ["vector shotgun","vector rifle","vector cannon"])
chest_add("Regal",   5,  ["chris knife","apergig tanat","kemosabe"])
chest_add("Smart",   7,  [wep_smart_gun,"heavy smart gun", "smarter gun", "smart nuke launcher"])
chest_add("Auto",    6,  [wep_auto_shotgun,wep_auto_crossbow,wep_auto_grenade_shotgun,wep_heavy_auto_crossbow,"auto abris launcher","auto screwdriver","auto grenade launcher","auto knife thrower"])
chest_add("Quartz",  10, ["quartz machinegun","quartz shotgun","quartz crossbow","quartz laser","quartz launcher"])
chest_add("Flame",   8,  [wep_flare_gun,wep_dragon,wep_flamethrower,wep_flame_cannon,"firestorm"])
chest_add("Blood",   9,  [wep_blood_hammer,"bone","big bone",wep_blood_launcher,wep_blood_cannon,"blood abris launcher","blood crossbow"])
chest_add("Hyper",   9,  [wep_hyper_rifle,wep_hyper_slugger,wep_hyper_launcher,"hyper crossbow"])
chest_add("Zenith",  13, ["herald","andromeda launcher","stopwatch","sak",/*"antiprism",*/"defender","flex","punisher","rapier"])

#define step
     // replacing chests
    if !instance_exists(GenCont){
        with instances_matching(WeaponChest, "defcustomchestcheck", null){
            defcustomchestcheck = 1
            if random(100) <= 8 and !instance_is(self, BigWeaponChest) and !instance_is(self, BigCursedChest) and !instance_is(self, GiantWeaponChest) && skill_get(mut_open_mind) > 0{
                var q = get_chests(0, GameCont.hard + array_length(instances_matching(Player, "race", "robot")))
                if array_length(q){
                    customchest_create(x, y, q[irandom(array_length(q) - 1)])
                    instance_delete(self)
                }
            }
        }
    }

     // chest step
    with instances_matching(chestprop, "name", "DefCustomChest"){
        if place_meeting(x, y, Player) || place_meeting(x, y, PortalShock) || instance_exists(BigPortal){
             // run open code
            script_execute(on_open)

             // fx
            instance_create(x, y, FXChestOpen);
            with instance_create(x, y, ChestOpen)
                sprite_index = other.spr_open;

            instance_delete(id);
        }
    }
if button_pressed(0, "horn") == true and string_lower(player_get_alias(0)) == "karmelyth"{
    with ds_map_keys(global.chests){
        customchest_create(mouse_x[0], mouse_y[0], self)
    }
}


#define chest_add(Name, Hard, Weapons)
global.chests[? Name] = {
    name : Name,
    spr_idle : mod_variable_get("mod", mod_current, "spr"+Name+"Chest"),
    spr_open : mod_variable_get("mod", mod_current, "spr"+Name+"ChestOpen"),
    weps : Weapons,
    difficulty : Hard
}

#define get_chests(areamin, areamax)
var q = ds_map_values(global.chests), a = [];
with q{
    if difficulty >= areamin and difficulty <= areamax array_push(a, name)
}
return a

#define customchest_create(xx, yy, Type)
    var o = instance_create(xx, yy, chestprop);
    with(o){
        name = "DefCustomChest";
        type = Type// specifc chest type
        var q = global.chests[? Type]
        spr_open = q.spr_open
        sprite_index = q.spr_idle
        weps = q.weps
        on_open = customchest_open;
    }
    return o;

#define customchest_open
var _w = wep_screwdriver
sound_play(sndAmmoChest);
_w = weps[irandom(array_length(weps)-1)]
with instance_create(x,y,WepPickup){
    wep = _w
    if weapon_get_type(wep) != 0 ammo = 1
}
