#define init
global.box 		= sprite_add_weapon("sprites/weapons/sprSAK.png",2,3)
global.boxopen  = sprite_add_weapon("sprites/weapons/sprSAKOpen.png",2,3)
global.boxempty = sprite_add_weapon("sprites/weapons/sprSAKEmpty.png",2,3)
with instances_matching([CustomDraw],"customshell",1){
	instance_destroy()
}
if fork(){
    while 1{
        birdspread()
        wait(0)
    }
    exit
}
global.sprAmmo           = sprite_add("sprites/interface/sprSAKammo.png",8,0,0)
global.sprAmmoM          = sprite_add("sprites/interface/sprSAKammoMini.png",9,0,0)
global.sprBodyShell      = sprite_add("sprites/interface/sprSAKbodyShell.png",6,0,0)
global.sprBodySlug       = sprite_add("sprites/interface/sprSAKbodySlug.png",6,0,0)
global.sprBody           = sprite_add("sprites/interface/sprSAKbody.png", 6, 0, 0)
global.sprBodyM          = sprite_add("sprites/interface/sprSAKbodyMini.png",7,0,0)
global.sprMods  	     = sprite_add("sprites/interface/sprSAKmods.png",10,0,0)
global.sprModsM  	     = sprite_add("sprites/interface/sprSAKmodsm.png",11,0,0)
global.sprModsShotgun    = sprite_add("sprites/interface/sprSAKmodsShotgun.png",10,0,0)
global.sprModsPopGun     = sprite_add("sprites/interface/sprSAKmodsPop.png",10,0,0)
global.sprModsEraser     = sprite_add("sprites/interface/sprSAKmodsEraser.png",10,0,0)
global.sprModsSlugger    = sprite_add("sprites/interface/sprSAKmodsSlugger.png",10,0,0)
global.sprModsFlakCannon = sprite_add("sprites/interface/sprSAKmodsFlak.png",10,0,0)
global.sprModsShotCannon = sprite_add("sprites/interface/sprSAKmodsShot.png",10,0,0)
global.sprModsM          = sprite_add("sprites/interface/sprSAKammoMini.png",8,0,0)

global.loadCounter = 0

global.shellbods = ["shotgun", "eraser", "flak cannon", "pop gun", "shot cannon"]
global.slugbods = ["shotgun", "eraser", "flak cannon", "slugger", "shot cannon"]

makethechoices()
makethetexts()
makethestats()
maketheprojectiles()
wait(0)
makethegunsprites()

#macro loadGap 5

#define maketheprojectiles()
global.flakmap = ds_map_create()
var a = global.flakmap;

a[? "shell shot"]			  = sprite_add("sprites/sak/projectiles/sprShot.png", 2, 8, 8);
a[? "psy shell shot"]   	  = sprite_add("sprites/sak/projectiles/sprPsyShot.png", 2, 8, 8);
a[? "flame shell shot"] 	  = sprite_add("sprites/sak/projectiles/sprFireShot.png", 2, 8, 8);
a[? "ultra shell shot"] 	  = sprite_add("sprites/sak/projectiles/sprUltraShot.png", 2, 8, 8);
a[? "split shell shot"] 	  = sprite_add("sprites/sak/projectiles/sprSplitShot.png", 2, 8, 8);
a[? "heavy slug shot"]  	  = sprite_add("sprites/sak/projectiles/sprHeavySlugShot.png", 2, 18, 18);

a[? "super shell shot"]       = sprite_add("sprites/sak/projectiles/sprSuperShot.png", 2, 12, 12);
a[? "slug shot"]        	  = a[? "super shell shot"]
a[? "super psy shell shot"]   = sprite_add("sprites/sak/projectiles/sprSuperPsyShot.png", 2, 12, 12);
a[? "super flame shell shot"] = sprite_add("sprites/sak/projectiles/sprSuperFireShot.png", 2, 12, 12);
a[? "super ultra shell shot"] = sprite_add("sprites/sak/projectiles/sprSuperUltraShot.png", 2, 12, 12);
a[? "super split shell shot"] = sprite_add("sprites/sak/projectiles/SuperSplitShot.png", 2, 12, 12);
a[? "heavy split shell shot"] = a[? "super split shell shot"]
a[? "super heavy slug shot"]  = sprite_add("sprites/sak/projectiles/SuperHeavyShot.png", 2, 23, 23);
a[? "super slug shot"]		  = a[? "heavy slug shot"]
a[? "super heavy split shell shot"]  = sprite_add("sprites/sak/projectiles/sprSuperHeavySplitShot.png", 2, 18, 18);

a[? "shell flak"]       	  = sprFlakBullet
a[? "psy shell flak"]   	  = sprite_add("sprites/sak/projectiles/sprPsyFlak.png", 2, 8, 8);
a[? "flame shell flak"] 	  = sprite_add("sprites/sak/projectiles/sprFireFlak.png", 2, 8, 8);
a[? "ultra shell flak"] 	  = sprite_add("sprites/sak/projectiles/sprUltraFlak.png", 2, 8, 8);
a[? "split shell flak"] 	  = sprite_add("sprites/sak/projectiles/sprSplitFlak.png", 2, 8, 8);

a[? "super shell flak"]       = sprite_add("sprites/sak/projectiles/sprSuperFlak.png", 2, 12, 12);
a[? "slug flak"]        	  = a[? "super shell flak"]
a[? "heavy slug flak"]  	  = sprite_add("sprites/sak/projectiles/sprHeavySlugFlak.png",2,14,14);
a[? "super slug flak"]        = a[? "heavy slug flak"]
a[? "super psy shell flak"]   = sprite_add("sprites/sak/projectiles/sprSuperPsyFlak.png", 2, 12, 12);
a[? "super flame shell flak"] = sprite_add("sprites/sak/projectiles/sprSuperFireFlak.png", 2, 12, 12);
a[? "super ultra shell flak"] = sprite_add("sprites/sak/projectiles/sprSuperUltraFlak.png", 2, 12, 12);
a[? "super split shell flak"] = sprite_add("sprites/sak/projectiles/sprSuperSplitFlak.png", 2, 12, 12);
a[? "heavy split shell flak"]		  = sprite_add("sprites/sak/projectiles/sprSuperSplitFlak.png", 2, 12, 12);
a[? "super heavy slug flak"]  = sprite_add("sprites/sak/projectiles/SuperHeavyFlak.png", 2, 18, 18);
a[? "super heavy split shell flak"]  = sprite_add("sprites/sak/projectiles/SuperHeavySplitFlak.png", 2, 18, 18);

a[? "shell flak hit"]		  = sprFlakHit
a[? "slug flak hit"]		  = sprSuperFlakHit
a[? "heavy flak hit"]		  = sprSuperFlakHit
a[? "psy shell flak hit"]     = sprite_add("sprites/sak/projectiles/sprPsyFlakHit.png",8,16,16);
a[? "flame shell flak hit"]   = sprite_add("sprites/sak/projectiles/sprFireFlakHit.png",8,16,16);
a[? "ultra shell flak hit"]   = sprite_add("sprites/sak/projectiles/sprUltraFlakHit.png",8,16,16);
a[? "split shell flak hit"]   = sprite_add("sprites/sak/projectiles/sprSplitFlakHit.png",8,16,16);
a[? "heavy split shell flak hit"]    = sprite_add("sprites/sak/projectiles/sprSplitSuperFlakHit.png",8,24,24);

a[? "super ultra shell flak hit"] = sprite_add("sprites/sak/projectiles/sprUltraSuperFlakHit.png",9,24,24);
a[? "super flame shell flak hit"] = sprite_add("sprites/sak/projectiles/sprFireSuperFlakHit.png",9,24,24);
a[? "super psy shell flak hit"]   = sprite_add("sprites/sak/projectiles/sprPsySuperFlakHit.png",9,24,24);
a[? "super split shell flak hit"] = sprite_add("sprites/sak/projectiles/sprSplitSuperFlakHit.png",8,24,24);
a[? "super shell flak hit"] 	  = sprSuperFlakHit
a[? "super slug flak hit"]        = sprSuperFlakHit
a[? "super heavy slug flak hit"]  = sprSuperFlakHit
a[? "super heavy split shell flak hit"]  = a[? "super split shell flak hit"];


#define makethegunsprites()
global.gunmap = ds_map_create()
var a = global.gunmap;


///REGULAR///
a[? "shotgun"]	         = sprShotgun
a[? "double shotgun"]    = sprSuperShotgun
a[? "sawed-off shotgun"] = sprSawnOffShotgun
a[? "auto shotgun"]      = sprAutoShotgun
a[? "assault shotgun"]   = sprite_add_patient("sprites/sak/sprAssaultShotgun.png",4,2)//
a[? "hyper shotgun"]     = sprite_add_patient("sprites/sak/sprHyperShotgun.png",3,2)//

a[? "flak cannon"]       = sprFlakCannon
a[? "super flak cannon"] = sprSuperFlakCannon
a[? "auto flak cannon"]  = sprite_add_patient("sprites/sak/sprAutoFlakCannon.png",2,2)//
a[? "hyper flak cannon"] = sprite_add_patient("sprites/sak/sprHyperFlakCannon.png",3,2)//

a[? "shot cannon"] 	     = sprite_add_patient("sprites/sak/sprShotCannon.png",3,2)//
a[? "super shot cannon"] = sprite_add_patient("sprites/sak/sprSuperShotCannon.png",3,2)//
a[? "auto shot cannon"]  = sprite_add_patient("sprites/sak/sprAutoShotCannon.png",3,1)//
a[? "hyper shot cannon"] = sprite_add_patient("sprites/sak/sprHyperShotCannon.png",3,4)//

a[? "eraser"] 	      = sprEraser
a[? "auto eraser"]    = sprite_add_patient("sprites/sak/sprAutoEraser.png",3,2)//
a[? "assault eraser"] = sprite_add_patient("sprites/sak/sprAssaultEraser.png",3,2)//
a[? "bird"]           = sprite_add_patient("sprites/sak/sprBird.png",3,2)//
a[? "wave gun"]       = sprWaveGun
a[? "hyper eraser"]   = sprite_add_patient("sprites/sak/sprHyperEraser.png",3,3)//

a[? "pop gun"]	      = sprPopGun
a[? "triple pop gun"] = sprite_add_patient("sprites/sak/sprTriplePopGun.png",5,4)//
a[? "pop rifle"]      = sprPopRifle
a[? "hyper pop gun"]  = sprite_add_patient("sprites/sak/sprHyperPopGun.png",4,3)//

///PSY///
a[? "psy shotgun"]	         = sprite_add_patient("sprites/sak/sprPsyShotgun.png",3,2)//
a[? "double psy shotgun"]    = sprite_add_patient("sprites/sak/sprDoublePsyShotgun.png",3,3)//
a[? "sawed-off psy shotgun"] = sprite_add_patient("sprites/sak/sprSawedOffPsyShotgun.png",3,3)//
a[? "auto psy shotgun"]      = sprite_add_patient("sprites/sak/sprAutoPsyShotgun.png",3,1)//
a[? "assault psy shotgun"]   = sprite_add_patient("sprites/sak/sprAssaultPsyShotgun.png",3,2)//
a[? "hyper psy shotgun"]     = sprite_add_patient("sprites/sak/sprHyperPsyShotgun.png",3,3)//

a[? "psy flak cannon"]  	 = sprite_add_patient("sprites/sak/sprPsyFlakCannon.png",3,2)//
a[? "super psy flak cannon"] = sprite_add_patient("sprites/sak/sprSuperPsyFlakCannon.png",4,3)//
a[? "auto psy flak cannon"]  = sprite_add_patient("sprites/sak/sprAutoPsyFlakCannon.png",2,2)//
a[? "hyper psy flak cannon"] = sprite_add_patient("sprites/sak/sprHyperPsyFlakCannon.png",3,2)//

a[? "psy shot cannon"]		 = sprite_add_patient("sprites/sak/sprPsyShotCannon.png",4,2)//
a[? "super psy shot cannon"] = sprite_add_patient("sprites/sak/sprSuperPsyShotCannon.png",4,2)//
a[? "auto psy shot cannon"]  = sprite_add_patient("sprites/sak/sprAutoPsyShotCannon.png",3,1)//
a[? "hyper psy shot cannon"] = sprite_add_patient("sprites/sak/sprHyperPsyShotCannon.png",4,2)//

a[? "psy eraser"]            = sprite_add_patient("sprites/sak/sprPsyEraser.png",2,1)//
a[? "auto psy eraser"]       = sprite_add_patient("sprites/sak/sprAutoPsyEraser.png",2,1)//
a[? "assault psy eraser"]    = sprite_add_patient("sprites/sak/sprAssaultPsyEraser.png",2,1)//
a[? "psy bird"]	  			 = sprite_add_patient("sprites/sak/sprPsyBird.png",4,3)//
a[? "psy wave gun"]          = sprite_add_patient("sprites/sak/sprPsyWaveGun.png",5,3)//
a[? "hyper psy eraser"]      = sprite_add_patient("sprites/sak/sprHyperPsyEraser.png",4,2)//

a[? "psy pop gun"]		     = sprite_add_patient("sprites/sak/sprPsyPopGun.png",3,1)//
a[? "triple psy pop gun"]    = sprite_add_patient("sprites/sak/sprTriplePsyPopGun.png",5,3)//
a[? "psy pop rifle"]		 = sprite_add_patient("sprites/sak/sprPsyPopRifle.png",5,2)//
a[? "hyper psy pop gun"]     = sprite_add_patient("sprites/sak/sprHyperPsyPopGun.png",3,2)//

///SPLIT SHELL///
a[? "split shotgun"] 		   = sprite_add_patient("sprites/sak/sprSplitShotgun.png",3,2)//
a[? "double split shotgun"]    = sprite_add_patient("sprites/sak/sprDoubleSplitShotgun.png",3,2)//
a[? "sawed-off split shotgun"] = sprite_add_patient("sprites/sak/sprSawedOffSplitShotgun.png",3,2)//
a[? "auto split shotgun"]      = sprite_add_patient("sprites/sak/sprAutoSplitShotgun.png",3,1)//
a[? "assault split shotgun"]   = sprite_add_patient("sprites/sak/sprAssaultSplitShotgun.png",3,2)//
a[? "hyper split shotgun"] 	   = sprite_add_patient("sprites/sak/sprHyperSplitShotgun.png",3,3)//

a[? "split flak cannon"]	   = sprite_add_patient("sprites/sak/sprSplitFlakCannon.png",3,2)//
a[? "super split flak cannon"] = sprite_add_patient("sprites/sak/sprSuperSplitFlakCannon.png",3,4)//
a[? "auto split flak cannon"]  = sprite_add_patient("sprites/sak/sprAutoSplitFlakCannon.png",3,2)//
a[? "hyper split flak cannon"] = sprite_add_patient("sprites/sak/sprHyperSplitFlakCannon.png",3,2)//

a[? "split shot cannon"] 	   = sprite_add_patient("sprites/sak/sprSplitShotCannon.png",4,3)//
a[? "super split shot cannon"] = sprite_add_patient("sprites/sak/sprSuperSplitShotCannon.png",5,4)//
a[? "auto split shot cannon"]  = sprite_add_patient("sprites/sak/sprAutoSplitShotCannon.png",4,3)//
a[? "hyper split shot cannon"] = sprite_add_patient("sprites/sak/sprHyperSplitShotCannon.png",4,3)//

a[? "split eraser"] 	       = sprite_add_patient("sprites/sak/sprSplitEraser.png",3,2)//
a[? "auto split eraser"]       = sprite_add_patient("sprites/sak/sprAutoSplitEraser.png",3,1)//
a[? "assault split eraser"]    = sprite_add_patient("sprites/sak/sprAssaultSplitEraser.png",3,2)//
a[? "split bird"]			   = sprite_add_patient("sprites/sak/sprSplitBird.png",3,2)//
a[? "split wave gun"]		   = sprite_add_patient("sprites/sak/sprSplitWaveGun.png",4,4)//
a[? "hyper split eraser"]      = sprite_add_patient("sprites/sak/sprHyperSplitEraser.png",3,3)//

a[? "split pop gun"]		   = sprite_add_patient("sprites/sak/sprSplitPopGun.png",3,2)//
a[? "triple split pop gun"]	   = sprite_add_patient("sprites/sak/sprTripleSplitPopGun.png",6,3)//
a[? "split pop rifle"] 	 	   = sprite_add_patient("sprites/sak/sprAssaultSplitPopGun.png",5,2)//
a[? "hyper split pop gun"]	   = sprite_add_patient("sprites/sak/sprHyperSplitPopGun.png",3,2)//

///FLAME SHELLS///
a[? "flame shotgun"]  	  	   = sprFlameShotgun
a[? "double flame shotgun"]    = sprDoubleFlameShotgun
a[? "sawed-off flame shotgun"] = sprite_add_patient("sprites/sak/sprSawedOffFlameShotgun.png",4,2)//
a[? "auto flame shotgun"]      = sprAutoFlameShotgun
a[? "assault flame shotgun"]   = sprite_add_patient("sprites/sak/sprAssaultFlameShotgun.png",4,2)//
a[? "hyper flame shotgun"]     = sprite_add_patient("sprites/sak/sprHyperFlameShotgun.png",4,2)//

a[? "flame flak cannon"] 	   = sprite_add_patient("sprites/sak/sprFlameFlakCannon.png",2,3)//
a[? "super flame flak cannon"] = sprite_add_patient("sprites/sak/sprSuperFlameFlakCannon.png",3,5)//
a[? "auto flame flak cannon"]  = sprite_add_patient("sprites/sak/sprAutoFlameFlakCannon.png",2,2)//
a[? "hyper flame flak cannon"] = sprite_add_patient("sprites/sak/sprHyperFlameFlakCannon.png",4,3)//

a[? "flame shot cannon"]  	   = sprite_add_patient("sprites/sak/sprFlameShotCannon.png",2,2)//
a[? "super flame shot cannon"] = sprite_add_patient("sprites/sak/sprSuperFlameShotCannon.png",4,3)//
a[? "auto flame shot cannon"]  = sprite_add_patient("sprites/sak/sprAutoFlameShotCannon.png",3,2)//
a[? "hyper flame shot cannon"] = sprite_add_patient("sprites/sak/sprHyperFlameShotCannon.png",4,3)//

a[? "flame eraser"] 		   = sprite_add_patient("sprites/sak/sprFlameEraser.png",3,3)//
a[? "auto flame eraser"]       = sprite_add_patient("sprites/sak/sprAutoFlameEraser.png",3,3)//
a[? "assault flame eraser"]    = sprite_add_patient("sprites/sak/sprAssaultFlameEraser.png",4,2)//
a[? "flame bird"]			   = sprite_add_patient("sprites/sak/sprPhoenix.png",3,2)//
a[? "flame wave gun"] 	  	   = sprite_add_patient("sprites/sak/sprFlameWaveGun.png",3,2)//
a[? "hyper flame eraser"]	   = sprite_add_patient("sprites/sak/sprHyperFlameEraser.png",3,2)//

a[? "flame pop gun"] 		   = sprite_add_patient("sprites/sak/sprFlamePopGun.png",3,2)//
a[? "triple flame pop gun"]    = sprIncinerator
a[? "flame pop rifle"] 		   = sprite_add_patient("sprites/sak/sprFlamePopRifle.png",3,2)//
a[? "hyper flame pop gun"]     = sprite_add_patient("sprites/sak/sprHyperFlamePopGun.png",3,2)//

///ULTRA SHELLS///
a[? "ultra shotgun"]  	  	   = sprUltraShotgun
a[? "double ultra shotgun"]    = sprite_add_patient("sprites/sak/sprDoubleUltraShotgun.png",3,3)//
a[? "sawed-off ultra shotgun"] = sprite_add_patient("sprites/sak/sprSawedOffUltraShotgun.png",3,3)//
a[? "auto ultra shotgun"]      = sprite_add_patient("sprites/sak/sprAutoUltraShotgun.png",3,2)//
a[? "assault ultra shotgun"]   = sprite_add_patient("sprites/sak/sprAssaultUltraShotgun.png",3,2)//
a[? "hyper ultra shotgun"]     = sprite_add_patient("sprites/sak/sprHyperUltraShotgun.png",3,4)//

a[? "ultra flak cannon"] 	   = sprite_add_patient("sprites/sak/sprUltraFlakCannon.png",3,3)//
a[? "super ultra flak cannon"] = sprite_add_patient("sprites/sak/sprSuperUltraFlakCannon.png",5,5)//
a[? "auto ultra flak cannon"]  = sprite_add_patient("sprites/sak/sprAutoUltraFlakCannon.png",3,2)//
a[? "hyper ultra flak cannon"] = sprite_add_patient("sprites/sak/sprHyperUltraFlakCannon.png",6,4)//

a[? "ultra shot cannon"] 	   = sprite_add_patient("sprites/sak/sprUltraShotCannon.png",3,2)//
a[? "super ultra shot cannon"] = sprite_add_patient("sprites/sak/sprSuperUltraShotCannon.png",6,3)//
a[? "auto ultra shot cannon"]  = sprite_add_patient("sprites/sak/sprAutoUltraShotCannon.png",3,2)//
a[? "hyper ultra shot cannon"] = sprite_add_patient("sprites/sak/sprHyperUltraShotCannon.png",5,2)//

a[? "ultra eraser"] 		   = sprite_add_patient("sprites/sak/sprUltraEraser.png",3,2)//
a[? "auto ultra eraser"]       = sprite_add_patient("sprites/sak/sprAutoUltraEraser.png",3,2)//
a[? "assault ultra eraser"]    = sprite_add_patient("sprites/sak/sprAssaultUltraEraser.png",11,2)//
a[? "ultra bird"]			   = sprite_add_patient("sprites/sak/sprUltraBird.png",5,3)//
a[? "ultra wave gun"] 		   = sprite_add_patient("sprites/sak/sprUltraWaveGun.png",4,4)//
a[? "hyper ultra eraser"] 	   = sprite_add_patient("sprites/sak/sprHyperUltraEraser.png",7,3)//

a[? "ultra pop gun"] 		   = sprite_add_patient("sprites/sak/sprUltraPopGun.png",3,2)//
a[? "triple ultra pop gun"]    = sprite_add_patient("sprites/sak/sprTripleUltraPopGun.png",6,4)//
a[? "ultra pop rifle"] 	 	   = sprite_add_patient("sprites/sak/sprUltraPopRifle.png",3,2)//
a[? "hyper ultra pop gun"]     = sprite_add_patient("sprites/sak/sprHyperUltraPopGun.png",7,2)//

///SLUGS///
a[? "slug shotgun"] 		   = sprite_add_patient("sprites/sak/sprSlugShotgun.png",3,1)//
a[? "double slug shotgun"] 	   = sprite_add_patient("sprites/sak/sprDoubleSlugShotgun.png",3,1)//
a[? "sawed-off slug shotgun"]  = sprite_add_patient("sprites/sak/sprSawedOffSlugShotgun.png",3,1)//
a[? "auto slug shotgun"]       = sprite_add_patient("sprites/sak/sprAutoSlugShotgun.png",3,0)//
a[? "assault slug shotgun"]    = sprite_add_patient("sprites/sak/sprAssaultSlugShotgun.png",5,1)//
a[? "hyper slug shotgun"]      = sprite_add_patient("sprites/sak/sprHyperSlugShotgun.png",5,3)//

a[? "slug eraser"] 			   = sprite_add_patient("sprites/sak/sprSlugEraser.png",3,2)//
a[? "auto slug eraser"] 	   = sprite_add_patient("sprites/sak/sprAutoSlugEraser.png",2,1)//
a[? "assault slug eraser"]     = sprite_add_patient("sprites/sak/sprAssaultSlugEraser.png",6,2)//
a[? "hyper slug eraser"] 	   = sprite_add_patient("sprites/sak/sprHyperSlugEraser.png",3,4)//
a[? "slug bird"] 	 		   = sprite_add_patient("sprites/sak/sprSlugBird.png",7,4)//
a[? "slug wave gun"] 	 	   = sprite_add_patient("sprites/sak/sprSlugWaveGun.png",5,5)//

a[? "slug flak cannon"] 	   = sprite_add_patient("sprites/sak/sprSlugFlakCannon.png",4,3)//
a[? "super slug flak cannon"]  = sprite_add_patient("sprites/sak/sprSuperSlugFlakCannon.png",4,3)//
a[? "auto slug flak cannon"]   = sprite_add_patient("sprites/sak/sprAutoSlugFlakCannon.png",6,3)//
a[? "hyper slug flak cannon"]  = sprite_add_patient("sprites/sak/sprHyperSlugFlakCannon.png",4,2)//

a[? "super slugger"]   = sprSuperSlugger
a[? "gatling slugger"] = sprGatlingSlugger
a[? "assault slugger"] = sprAssaultSlugger
a[? "hyper slugger"]   = sprHyperSlugger
a[? "slugger"] 		   = sprSlugger

a[? "slug shot cannon"]   	   = sprite_add_patient("sprites/sak/sprSlugShotCannon.png",5,3)//
a[? "super slug shot cannon"]  = sprite_add_patient("sprites/sak/sprSuperSlugShotCannon.png",6,4)//
a[? "auto slug shot cannon"]   = sprite_add_patient("sprites/sak/sprAutoSlugShotCannon.png",5,2)//
a[? "hyper slug shot cannon"]  = sprite_add_patient("sprites/sak/sprHyperShotCannon.png",4,4)//


///HEAVY SLUGS///
a[? "heavy slug shotgun"] 			= sprite_add_patient("sprites/sak/sprHeavySlugShotgun.png",3,2)//
/*
a[? "double heavy slug shotgun"] 	= sprite_add_patient("sprites/sak/sprHeavyDoubleSlugShotgun.png",3,5)//
a[? "sawed-off heavy slug shotgun"] = sprite_add_patient("sprites/sak/sprHeavySawedOffSlugShotgun.png",3,5)//
a[? "auto heavy slug shotgun"]      = sprite_add_patient("sprites/sak/sprHeavyAutoSlugShotgun.png",3,1)//
a[? "assault heavy slug shotgun"]   = sprite_add_patient("sprites/sak/sprHeavyAssaultSlugShotgun.png",5,2)//
a[? "hyper heavy slug shotgun"]     = sprite_add_patient("sprites/sak/sprHeavyHyperSlugShotgun.png",6,4)//
*/
a[? "heavy slug eraser"] 			= sprite_add_patient("sprites/sak/sprHeavySlugEraser.png",3,2)//
/*
a[? "auto heavy slug eraser"] 	    = sprite_add_patient("sprites/sak/sprHeavyAutoSlugEraser.png",7,3)//
a[? "assault heavy slug eraser"]    = sprite_add_patient("sprites/sak/sprHeavyAssaultSlugEraser.png",6,2)//
a[? "hyper heavy slug eraser"] 	    = sprite_add_patient("sprites/sak/sprHeavyHyperSlugEraser.png",3,5)//
a[? "heavy slug bird"] 	 			= sprite_add_patient("sprites/sak/sprHeavySlugBird.png",7,4)//
a[? "heavy slug wave gun"] 	 		= sprite_add_patient("sprites/sak/sprHeavySlugWaveGun.png",5,5)//
*/
a[? "heavy slug flak cannon"] 	 	= sprite_add_patient("sprites/sak/sprHeavySlugFlakCannon.png",4,3)//
/*
a[? "super heavy slug flak cannon"] = sprite_add_patient("sprites/sak/sprHeavySuperSlugFlakCannon.png",4,5)//
a[? "auto heavy slug flak cannon"] 	= sprite_add_patient("sprites/sak/sprHeavyAutoSlugFlakCannon.png",6,3)//
a[? "hyper heavy slug flak cannon"] = sprite_add_patient("sprites/sak/sprHeavyHyperSlugFlakCannon.png",4,4)//

a[? "super heavy slugger"]   = sprite_add_patient("sprites/sak/sprHeavySuperSlugger.png",5,4)//
a[? "gatling heavy slugger"] = sprite_add_patient("sprites/sak/sprHeavyGatlingSlugger.png",5,3)//
a[? "assault heavy slugger"] = sprite_add_patient("sprites/sak/sprHeavyAssaultSlugger.png",5,2)//
a[? "hyper heavy slugger"]   = sprite_add_patient("sprites/sak/sprHeavyHyperSlugger.png",3,5)//
*/
a[? "heavy slugger"] 		 = sprHeavySlugger
a[? "heavy slug shot cannon"]   	= sprite_add_patient("sprites/sak/sprHeavySlugShotCannon.png",5,4)//
/*
a[? "super heavy slug shot cannon"] = sprite_add_patient("sprites/sak/sprHeavySuperSlugShotCannon.png",6,4)
a[? "auto heavy slug shot cannon"]  = sprite_add_patient("sprites/sak/sprHeavyAutoSlugShotCannon.png",5,3)//
a[? "hyper heavy slug shot cannon"] = sprite_add_patient("sprites/sak/sprHeavyHyperSlugShotCannon.png",10,5)//
*/

///HEAVY SPLIT SHELLS///
a[? "heavy split shell shotgun"]	 = sprite_add_patient("sprites/sak/sprSplitSlugShotgun.png",3,2)//
/* 
a[? "double split slug shotgun"]	= sprite_add_patient("sprites/sak/sprDoubleSplitSlugShotgun.png",3,3)//
a[? "sawed-off split slug shotgun"] = sprite_add_patient("sprites/sak/sprSawedOffSplitSlugShotgun.png",3,3)//
a[? "auto split slug shotgun"]      = sprite_add_patient("sprites/sak/sprAutoSplitSlugShotgun.png",4,2)//
a[? "assault split slug shotgun"]   = sprite_add_patient("sprites/sak/sprAssaultSplitSlugShotgun.png",3,2)//
a[? "hyper split slug shotgun"]     = sprite_add_patient("sprites/sak/sprHyperSplitSlugShotgun.png",3,4)//
*/
a[? "heavy split shell eraser"] 	 = sprite_add_patient("sprites/sak/sprSplitSlugEraser.png",6,2)//
/*
a[? "auto split slug eraser"] 	    = sprite_add_patient("sprites/sak/sprAutoSplitSlugEraser.png",6,2)//
a[? "assault split slug eraser"]    = sprite_add_patient("sprites/sak/sprAssaultSplitSlugEraser.png",4,2)//
a[? "hyper split slug eraser"] 	    = sprite_add_patient("sprites/sak/sprHyperSplitSlugEraser.png",7,4)//
a[? "split slug bird"] 	 		    = sprite_add_patient("sprites/sak/sprSplitSlugBird.png",7,4)//
a[? "split slug wave gun"] 	 	    = sprite_add_patient("sprites/sak/sprSplitSlugWaveGun.png",5,5)//
*/
a[? "heavy split shell flak cannon"] = sprite_add_patient("sprites/sak/sprSplitSlugFlakCannon.png",5,2)//
/*
a[? "super split slug flak cannon"] = sprite_add_patient("sprites/sak/sprSuperSplitSlugFlakCannon.png",5,4)//
a[? "auto split slug flak cannon"] 	= sprite_add_patient("sprites/sak/sprAutoSplitSlugFlakCannon.png",4,3)//
a[? "hyper split slug flak cannon"] = sprite_add_patient("sprites/sak/sprHyperSplitSlugFlakCannon.png",4,3)//

a[? "super split slugger"]   = sprite_add_patient("sprites/sak/sprSuperSplitSlugger.png",5,4)//
a[? "gatling heavy split shellger"] = sprite_add_patient("sprites/sak/sprGatlingSplitSlugger.png",0,2)//
a[? "assault split slugger"] = sprite_add_patient("sprites/sak/sprAssaultSplitSlugger.png",5,2)//
a[? "hyper split slugger"]   = sprite_add_patient("sprites/sak/sprHyperSplitSlugger.png",3,4)//
a[? "split slugger"] 		 = sprite_add_patient("sprites/sak/sprSplitSlugger.png",1,2)//
*/
a[? "heavy split shell shot cannon"] = sprite_add_patient("sprites/sak/sprSplitSlugShotCannon.png",5,3)//
/*
a[? "super split slug shot cannon"] = sprite_add_patient("sprites/sak/sprSuperSplitSlugShotCannon.png",6,4)//
a[? "auto split slug shot cannon"]  = sprite_add_patient("sprites/sak/sprAutoSplitSlugShotCannon.png",5,3)//
a[? "hyper split slug shot cannon"] = sprite_add_patient("sprites/sak/sprHyperSplitSlugShotCannon.png",4,5)//
*/
#define sprite_add_patient(_path, _xoff, _yoff)
if (++global.loadCounter mod loadGap == 0) {
	wait(0)
}
return sprite_add_weapon(_path, _xoff, _yoff)

#define cleanup
ds_map_destroy(global.textmap)
ds_map_destroy(global.choicemap)
ds_map_destroy(global.stats)
ds_map_destroy(global.gunmap)
ds_map_destroy(global.flakmap)




#define option_finalize
var keys = ds_map_keys(global.optionmap),
defaultlq = {
	bodies : -1,
	mods : -1,
	text : "This is the default text, please report this to the devs if you see this.",
	sound : -1,
	sprite : mskNone,
	spritem: mskNone,
	index  : 0
},
defaultstats = {
	ammo : 1,
	reload : 1,
	projcount : 1,
	radsammo : 0,
	radsproj : 0
};
for (var i = 0, l = array_length(keys); i < l; i++) {
	var opt = global.optionmap[? keys[i]];
	for (var d = 0; d < lq_size(defaultlq); d++) {
	    var k = lq_get_key(defaultlq, d);
	    lq_set(opt, k, lq_defget(opt, k, lq_get(defaultlq, k)))
	}
	lq_set(opt, "name", lq_defget(opt, "name", keys[i]))  //set default display name to the key name
	lq_set(opt, "stats", lq_defget(opt, "stats", {}))     //set up stats LWO if its not there
	opt = opt.stats
	for (var d = 0; d < lq_size(defaultstats); d++) {
	    var k = lq_get_key(defaultstats, d);
	    lq_set(opt, k, lq_defget(opt, k, lq_get(defaultstats, k)))
	}

}

#define maketheoptions()
global.optionmap = ds_map_create();
var a = global.optionmap;

/*stat ref:
	name : display name, automatically defaults to key
	bodies : array of map keys
	mods : as bodies
	stats : {
		ammo
		reload
		projcount
		radsammo (multiplied by final ammo cost, default 0)
		radsproj (multiplied by final projectile count, default 0, rad cost is selected from the lowest calculated number)
	}
	proj : {
		obj : object_index or script reference
		stockspeed : speed used for fixed speed weapons, ex: pop gun. default 0
		speedmin : minimum speed for random speed weapons, ex: shotgun. totalled via addition in assembly, defaults to stockspeed
		speedmax : as speedmin, but the upper limit
		speedmult : multiplies all speeds, default 1, not used but included
	}
	text : string, description displayed in menu
	sound : index, played on firing
	sprite : button sprite
	spritem : miniature icon sprite, also uses index
	index : index used for button sprites
*/
a[? -1] = ["shell", "slug", "heavy slug", "flame shell", "ultra shell", "psy shell", "split shell", "split slug"];

//ammo
a[? "shell"] = {
	bodies : global.shellbods,
	stats : {
		ammo : 1,
		reload : 1
	},
	proj : {
		obj : Bullet2,
		stockspeed : 16,
		speedmin : 12,
		speedmax: 18
	},
	text : "Standard shells",
	sound : sndShotgun,
	sprite : global.sprAmmo,
	index : 0,
	spritem : global.sprAmmoM
}

a[? "slug"] = {
	bodies : global.slugbods,
	stats : {
		ammo : 7,
		reload : 2
	},
	proj : {
		obj : Slug,
		stockspeed : 16
	},
	mods : ["slug_heavy"],
	text : "Really big, expensive",
	sound : sndSlugger,
	sprite : global.sprAmmo,
	index : 1,
	spritem : global.sprAmmoM
}

a[? "flame shell"] = {
	bodies : global.shellbods,
	stats : {
		ammo : 1,
		reload : 1.2,
		projcount : 6/7
	},
	proj : {
		obj : FlameShell,
		stockspeed : 16,
		speedmin : 12,
		speedmax: 18
	},
	text : "Flames deal extra damage, but don't bounce well",
	sound : sndFireShotgun,
	sprite : global.sprAmmo,
	index : 3,
	spritem : global.sprAmmoM
}

a[? "ultra shell"] = {
	bodies : global.shellbods,
	stats : {
		ammo : 3,
		reload : .7,
		projcount: 9/7
		radsammo : 14/3,
		radsproj : 14/9
	},
	proj : {
		obj : UltraShell,
		stockspeed : 16,
		speedmin : 12,
		speedmax: 18
	},
	text : "Radiation makes these shells stronger",
	sound : sndUltraShotgun,
	sprite : global.sprAmmo,
	index : 4,
	spritem : global.sprAmmoM
}

a[? "psy shell"] = {
	bodies : global.shellbods,
	stats : {
		ammo : 2,
		reload : 1.3,
	},
	proj : {
		obj : ["wep", mod_current, "projectile_link", ["create_psy_shell"]],
		stockspeed : 16,
		speedmin : 12,
		speedmax: 18
	},
	text : "Psy shells can home in on enemies",
	sound : sndShotgun,
	sprite : global.sprAmmo,
	index : 5,
	spritem : global.sprAmmoM
}

a[? "split shell"] = {
	bodies : global.shellbods,
	mods : ["split_heavy"],
	stats : {
		ammo : 2,
		reload : 1.2,
		projcount : 5/7
	},
	proj : {
		obj : ["wep", mod_current, "projectile_link", ["create_split_shell"]],
		stockspeed : 16,
		speedmin : 12,
		speedmax: 18
	},
	text : "Upon impact, splits into two shells",
	sound : sndShotgun,
	sprite : global.sprAmmo,
	spritem : global.sprAmmoM,
	index : 5
}


//bodies
a[? "shotgun"] = {
	mods : ["double", "sawed-off", "auto", "assault", "hyper", "none"],
	stats : {
		ammo : 1,
		reload : 17,
		projcount : 7
	},
	text : "Fires a blast of many shells.",
	sound : sndShotgun,
	sprite : global.sprBody,
	spritem : global.sprBodyM,
	index : 0
}

a[? "eraser"] = {
	mods : ["bird", "wave", "auto", "assault", "hyper", "none"],
	stats : {
		ammo : 2,
		reload : 20,
		projcount: 14
	},
	text : "Fires a tightly packed line of shells.",
	sound : sndEraser,
	sprite : global.sprBody,
	spritem : global.sprBodyM,
	index : 1
}

a[? "flak cannon"] = {
	mods : ["super", "auto", "hyper", "none"],
	stats : {
		ammo : 2,
		reload : 26,
		projcount : 14
	},
	text : "Fires a projectile that bursts into shells!",
	sound : sndFlakCannon,
	sprite : global.sprBody,
	spritem : global.sprBodyM,
	index : 2
}

a[? "pop gun"] = {
	mods : ["triple", "rifle", "hyper", "none"],
	stats : {
		ammo : 1,
		reload : 2,
		projcount : 1
	},
	text : "Uses bullets to fire shells rapidly.",
	sound : sndPopgun,
	sprite : global.sprBody,
	spritem : global.sprBodyM,
	index : 3
}

a[? "slugger"] = {
	mods : ["super", "gatling", "assault", "hyper", "none"],
	stats : {
		ammo : 1/6,
		reload : 11,
		projcount : 1
	},
	text : "Fires a slug straight ahead.",
	sound : sndSlugger,
	sprite : global.sprBody,
	spritem : global.sprBodyM,
	index : 5
}

a[? "shot cannon"] = {
	mods : ["super", "auto", "hyper", "none"],
	stats : {
		ammo : 6,
		reload : 25,
		projcount : 80
	},
	text : "Fires a projectile that disperses shells over time.",
	sound : sndFlakCannon,
	sprite : global.sprBody,
	spritem : global.sprBodyM,
	index : 4
}


//mods
a[? "double"] = {
	stats : {
		ammo : 2,
		reload : 1.6,
		projcount : 2
	},
	text : "Doubles the projectile count, effecient!",
	sound : sndDoubleShotgun,
	sprite : global.sprMods,
	spritem: global.sprModsM,
	index : 0
}

a[? "sawed-off"] = {
	stats : {
		ammo : 2,
		reload : 1.6,
		projcount : 2.9 //gets to 20 from shotgun's 7 projectiles
	},
	text : "Almost triples the shells, but watch the accuracy!",
	sound : sndSawedOffShotgun,
	sprite : global.sprMods,
	spritem: global.sprModsM,
	index  : 1
}

a[? "auto"] = {
	stats : {
		ammo : 1,
		reload : .2,
		projcount : 6/7
	},
	text : "Rapid fire! Accuracy and projectile count go down.",
	sound : sndPopgun,
	sprite : global.sprMods,
	spritem: global.sprModsM,
	index  : 3
}

a[? "gatling"] = lq_clone(a[? "auto"])
with a[? "gatling"] {
	stats.projcount = 1
	stats.reload = .3
	text = "Rapid fire!"
	sound = -1
}

a[? "assault"] = {
	stats : {
		ammo : 3,
		reload : 2,
		projcount : 3
	},
	text : "Fire three times in rapid succession!",
	sound : -1,
	sprite : global.sprMods,
	spritem: global.sprModsM,
	index  : 4
}

a[? "hyper"] = {
	stats : {
		ammo : 1.2,
		reload : 1,
		projcount : 1
	},
	text : "Projectiles travel extremely quickly!",
	sound : -1,
	sprite : global.sprMods,
	spritem: global.sprModsM,
	index  : 5
}

a[? "bird"] = {
	stats : {
		ammo : 1,
		reload : 1.2,
		projcount : 1.3
	},
	text : "Shoot shells in a bizarre forking pattern.",
	sound : -1,
	sprite : global.sprMods,
	spritem: global.sprModsM,
	index  : 7
}

a[? "wave"] = {
	stats : {
		ammo : 1,
		reload : 1.2,
		projcount : 16/17
	},
	text : "Shoot shells in a wonderous waving pattern.",
	sound : -1,
	sprite : global.sprMods,
	spritem: global.sprModsM,
	index  : 8
}

a[? "super"] = {
	stats : {
		ammo : 5,
		reload : 2.3,
		projcount : 5
	},
	text : "Shoot five times the projectiles!",
	sound : sndSuperSlugger,
	sprite : global.sprMods,
	spritem: global.sprModsM,
	index  : 6
}

a[? "rifle"] = {
	stats : {
		ammo : 2,
		reload : 5,
		projcount : 3
	},
	text : "Shoot a burst of 3 shells for 2 bullets.",
	sound : sndSuperSlugger,
	sprite : global.sprMods,
	spritem: global.sprModsM,
	index  : 4
}

a[? "triple"] = {
	stats : {
		ammo : 3,
		reload : 1,
		projcount : 3
	},
	text : "Shoot three times the shells!",
	sound : sndIncinerator,
	sprite : global.sprMods,
	spritem: global.sprModsM,
	index  : 2
}

a[? "split_heavy"] = {
	name : "heavy",
	stats : {
		ammo : 2,
		reload : 1
	},
	proj : {
		stockspeed : 2
	},
	text : "Heavy split shells split an additional time!",
	sound : sndSuperSlugger,
	sprite : global.sprMods,
	spritem: global.sprModsM,
	index  : 11
}

a[? "slug_heavy"] = {
	name : "heavy",
	stats : {
		ammo : 1.8,
		reload : .9
	},
	proj : {
		stockspeed : -3
	},
	text : "Heavy slugs deal incredible amounts of damage, but are very slow.",
	sound : sndHeavySlugger,
	sprite : global.sprMods,
	spritem: global.sprModsM,
	index  : 11
}

a[? "none"] = {
	stats : {
		ammo : 1,
		reload : 1,
		projcount : 1
	},
	text : "No modifier, for those with restraint.",
	sound : -1,
	sprite : global.sprMods,
	spritem: global.sprModsM,
	index  : 10
}

#define makethechoices()
global.choicemap = ds_map_create()
var a = global.choicemap;
var sg = global.slugbods;
var sh = global.shellbods;

//ammo
a[? -1] = ["shell", "slug", "heavy slug", "flame shell", "ultra shell", "psy shell", "split shell", "split slug"]

//bodies
a[? "shell"] = sh
a[? "slug"] = sg
a[? "heavy slug"] = sg
a[? "flame shell"] = sh
a[? "ultra shell"] = sh
a[? "psy shell"] = sh
a[? "split shell"] = sh
a[? "split slug"] = sg

//mods for bodies
a[? "shotgun"] = ["double", "sawed-off", "auto", "assault", "hyper", "none"]
a[? "eraser"] = ["bird", "wave", "auto", "assault", "hyper", "none"]
a[? "flak cannon"] = ["super", "auto", "hyper", "none"]
a[? "pop gun"] = ["triple", "rifle", "hyper", "none"]
a[? "slugger"] = ["super", "gatling", "assault", "hyper", "none"]
a[? "shot cannon"] = ["super", "auto", "hyper", "none"]

#define makethetexts()
global.textmap = ds_map_create()
var a = global.textmap;

//mods
a[? "double"] = "Double gun, slightly better than one."
a[? "sawed-off"] = "Double gun, but faster and inaccurate"
a[? "auto"] = "increased rate of fire and decreased accuracy"
a[? "assault"] = "shoot three times in a row"
a[? "hyper"] = "instant travel with more damage"
a[? "none"] = "no mod because i respect ammo"
a[? "bird"] = "shoot in a forking pattern"
a[? "wave"] = "shoot in a wave pattern"
a[? "triple"] = "shoot three projectiles in a regular spread"
a[? "rifle"] = "shoot three times, for only two ammo"
a[? "super"] = "five times the projectiles"
a[? "gatling"] = a[? "auto"]

//ammos
a[? "shell"] = "Standard shells"
a[? "slug"] = "Really big, expensive"
a[? "heavy slug"] = "massive, slow, very expensive"
a[? "flame shell"] = "flames for damage, dont bounce well"
a[? "ultra shell"] = "uses rads for more damage"
a[? "psy shell"] = "home in, bounce a lot, expensive"
a[? "split shell"] = "deploys duplicates on bounce"
a[? "split slug"] = "has a lot of dupes to deploy"

//bodies
a[? "shotgun"] = "shoot a random spray"
a[? "eraser"] = "shoot a concentrated line"
a[? "flak cannon"] = "shoot a flak projectile"
a[? "pop gun"] = "rapid fire single shot, uses bullets"
a[? "slugger"] = "shoots a single shot"
a[? "shot cannon"] = "shoot a projectile that disperses others"

#define makethestats()
global.stats = ds_map_create()
var a = global.stats;

//[ammo*, reload*, sound, rads*]
//based off of firing a shotgun of said type (the cost of 7 projectiles)
a[? "shell"] = [1, 1, sndShotgun, 0]
a[? "slug"] = [7, 2, sndSlugger, 0]
a[? "heavy slug"] = [13, 1.8, sndHeavySlugger, 0]
a[? "flame shell"] = [1, 1.2, sndFireShotgun, 0]
a[? "ultra shell"] = [3, .7, sndUltraShotgun, 9]
a[? "psy shell"] = [2, 1.3, sndShotgun, 0]
a[? "split shell"] = [2.8, 1.2, sndShotgun, 0]
a[? "split slug"] = [5.6, 1.2, sndSlugger, 0]

//[ammo, reload base, sound]
a[? "shotgun"] = [1, 17, sndShotgun]
a[? "eraser"] = [2, 20, sndEraser]
a[? "flak cannon"] = [2, 26, sndFlakCannon]
a[? "pop gun"] = [1, 2, sndPopgun]
a[? "slugger"] = [1/6, 11, sndSlugger]
a[? "shot cannon"] = [6, 25, sndFlakCannon]

//[ammo*, reload*, sound]
a[? "double"] = [2, 1.6, sndDoubleShotgun]
a[? "sawed-off"] = [2, 1.6, sndSawedOffShotgun]
a[? "auto"] = [1, .2, sndPopgun]
a[? "assault"] = [3, 2, -1]
a[? "hyper"] = [1.2, 1, sndHyperSlugger]
a[? "none"] = [1, 1, -1]
a[? "bird"] = [1, 1.2, -1]
a[? "wave"] = [1, 1.2, sndWaveGun]
a[? "triple"] = [3, 1, sndIncinerator]
a[? "rifle"] = [2, 5, -1]
a[? "super"] = [5, 2.3, sndSuperSlugger]
a[? "gatling"] = [1, .3, -1]


#define take_wave(w)
w.sounds = [sndWaveGun]
#define take_pop_gun(w)
w.type = 1
w.rads = ceil(w.rads/7)
w.auto = 1
#define take_assault(w)
w.shots = 3
w.time = 3
#define take_rifle(w)
w.shots = 3
w.auto = 1
w.time = 2
#define take_auto(w)
w.auto = 1
#define take_gatling(w)
w.auto = 1


#define weapon_name(w)
if is_object(w){
	if w.done return w.name
}
return `@(color:${make_color_rgb(255, 156, 0)})SHOTGUN ASSEMBLY KIT`

#define weapon_type(w)
if is_object(w){
	if w.done return w.type
}
return 2

#define weapon_cost(w)
if is_object(w){
	if w.done return w.ammo
}
return 0

#define weapon_rads(w)
if is_object(w){
	if w.done return w.rads
}
return 0


#define weapon_area
return 12

#define weapon_load(w)
if is_object(w){
	if w.done return w.load
}
return 1

#define weapon_swap
return sndSwapShotgun

#define weapon_auto(w)
if is_object(w){
	if w.done return w.auto
}

return 0

#define weapon_melee
return 0

#define weapon_laser_sight
return 0

#define weapon_fire(w)
if is_object(w){
	if w.done{
		if fork(){
			repeat(w.shots){
				for (var i = 0; i<array_length_1d(w.sounds); i++){
					sound_play_pitch(w.sounds[i],random_range(.8,1.2)) //XX
				}
				var num = sqrt(w.ammo + w.load)
				weapon_post(num, num, num*2)
				mod_script_call_self("weapon",mod_current,string_replace(w.info[2]," ","_"),w.info[1],w.info[3])
				if w.time wait(w.time)
			}
			exit
		}
	}
}else{
    sound_play_gun(sndShotgun,.1,.8)
    repeat(7){
        with instance_create(x,y,Shell){
            motion_set(other.gunangle + random_range(-20,20), 12 + random(4))
            projectile_init(other.team,other)
            image_angle = direction
        }
    }
}

#define pop_gun(p,m)
switch m{
	case "triple":
		for (var i = -1; i<= 1; i++){
			with proj_legacy(p){
				fset(23,3,i,1)
				speed = stockspeed
			}
		}
		break
	case "rifle":
	    with proj_legacy(p){
	        set(8)
            speed = stockspeed
	    }
	    break
	default:
		with proj_legacy(p){
			set(4)
			speed = stockspeed
			if m = "hyper" hyper_travel()
		}
		break
}

#define eraser(p,m)
switch m {
	case "bird":
		if fork(){
			repeat(5){
				for (var i = -1; i<= 1; i++){
					with proj_legacy(p){
						fset(13,2*abs(i) + 2,i,1);
						if i != 0 {birdspeed = i* .5* other.accuracy}
					}
				}
				wait(1)
			}
			exit
		}
		break
	case "wave":
		if fork(){
			for (var i = -3/8; i<= 3; i+= 3/8){
				with proj_legacy(p){
					direction = other.gunangle + 15*sin(i) *other.accuracy;
					image_angle = direction
					creator = other
					team = other.team
					speed = stockspeed
				}
				with proj_legacy(p){
					direction = other.gunangle - 15*sin(i) *other.accuracy;
					image_angle = direction
					creator = other
					team = other.team
					speed = stockspeed
				}
				wait(1)
			}
			exit
		}
		break
	case "auto":
		repeat(15){
			with proj_legacy(p){
				set(1)
				speed += random_range(-2,2)
			}
		}
		break
	default:
		repeat(17){
			with proj_legacy(p){
				set(1)
				speed += random_range(-2,2)
				if m = "hyper" hyper_travel()
			}
		}
		break
}

#define slugger(p,m)
switch m{
	case "super":
		for (var i = -2; i<= 2; i++){
			with proj_legacy(p) {
				fset(12,3,i,1)
			}
		}
		break
	default:
		with proj_legacy(p){
			set(m == "auto" ? 8 : 5)
			if m = "hyper" hyper_travel()
		}
		break
}

#define flak_cannon(p,m)
switch m{
	case "super":
	    with superflak(p){
			set(4)
			speed = random_range(10,11)
			if m = "hyper"{
				hyper = 1
				//hyper_travel()
			}
		}
		break
	default:
		with flak(p){
		    if m == "auto" ammo -= 3
			set(3)
			speed = random_range(11,13)
			if m = "hyper"{
				hyper = 1
				//hyper_travel()
			}
		}
}

#define shot_cannon(p,m)
switch m{
	case "super":
    	sound_play_pitchvol(sndSuperFlakExplode,random_range(.4,.6),.7)
    	sound_play_pitchvol(sndDoubleShotgun,.8,7)
        with supershotcannon(p){
            set(0)
            speed = 12 + random(1)
        }
        break
    case "auto":
		sound_play_pitchvol(sndFlakExplode,random_range(.4,.7),.7)
		sound_play_pitchvol(sndDoubleShotgun,1.4,7)
        with shotcannon(p){
            set(2)
            timer -= 2
            speed = 14 + random(2)
            if m = "hyper"{
                hyper = 1
            }
        }
        break
    default:
		sound_play_pitchvol(sndFlakExplode,random_range(.4,.7),.7)
		sound_play_pitchvol(sndDoubleShotgun,1.2,7)
        with shotcannon(p){
            set(0)
            speed = 15 + random(2)
            if m = "hyper"{
                hyper = 1
            }
        }
}


#define shotgun(p,m)
switch m{
	case "double":
		repeat(14){
			with proj_legacy(p) {
				set(30)
				speed += random_range(-2,1)
			}
		}
		break
	case "sawed-off":
		repeat(20){
			with proj_legacy(p) {
				set(45)
				speed += random_range(-2,1)
			}
		}
		break
	default:
		repeat(7){
			with proj_legacy(p){
				set(20)
				speed += random_range(-2,1)
				if m = "hyper" hyper_travel()
			}
		}
		break
}

//The idea here is that the proj scripts need to have a specific syntax, so an intermediary script is needed to get all the arguments out of the array.
#define projectile_link(x, y, _args, _modifier) //These are the arguments always passed to all ammo.proj scripts
	var _scriptname = (_modfier == "heavy" ? string_replace(_args[0], "create_", "create_heavy_"));
	return mod_script_call_self("mod", "defpack tools", _scriptname, x, y)

#define proj_create(_wep)
var _p = -4, _proj = _wep.proj;
	if is_real(_proj.obj) {
		_p = instance_create(x, y, _proj.obj)
	}
	else if is_array(_proj.obj) {
		_p = mod_script_call_self(_proj.obj[0], _proj.obj[1], _proj.obj[2], x, y, _proj.obj[3], _wep.mod) //_proj
	}
	with _p {
		speed = random_range(_proj.speedmin, _proj.speedmax)
		stockspeed = _proj.stockspeed
	}


#define proj_legacy(thing)
switch thing{
	case "shell":
		var a = instance_create(x,y,Bullet2)
		with a{
			speed = random_range(12,18)
			stockspeed = 16
		}
		return a
	case "slug":
		var a = instance_create(x,y,Slug);
		with a{
			speed = 16
			stockspeed = speed
		}
		return a
	case "heavy slug":
		with instance_create(x,y,HeavySlug){
			speed = 13
			stockspeed = speed
			return id
		}
	case "flame shell":
		with instance_create(x,y,FlameShell){
			speed = random_range(12,18)
			stockspeed = 16
			return id
		}
	case "ultra shell":
		with instance_create(x,y,UltraShell){
			speed = random_range(12,18)
			stockspeed = 16
			return id
		}
	case "psy shell":
		with mod_script_call("mod", "defpack tools", "create_psy_shell",x,y){
			speed = random_range(12,18)
			stockspeed = 16
			return id
		}
	case "split shell":
		with mod_script_call("mod", "defpack tools", "create_split_shell",x,y){
			speed = random_range(15,18)
			stockspeed = 17
			ammo = 2
			return id
		}
	case "split slug":
		with mod_script_call("mod", "defpack tools", "create_heavy_split_shell",x,y){
			speed = random_range(17,20)
			stockspeed = 19
			return id
		}
}

#define flak(p)
with instance_create(x,y,CustomProjectile){
	mask_index = mskFlakBullet
	if string_count(p, "slug") mask_index = mskSuperFlakBullet
	var str = p + " flak"
	sprite_index = global.flakmap[? str]
	spr_dead = global.flakmap[? str + " hit"]
	on_destroy = flakpop
	on_step = flakstep
	defbloom = {
	    xscale: 2,
	    yscale: 2,
	    alpha: .2
	}
	with proj_legacy(p){
	    other.damage = damage * 4
	    instance_delete(self)
	}
	payload = p
	friction = .4
	ammo = 14
	hyper = 0
	return id
}

#define superflak(p)
with instance_create(x,y,CustomProjectile){
	mask_index = mskSuperFlakBullet
	var str = "super " + p + " flak"
	sprite_index = global.flakmap[? str]
	spr_dead = global.flakmap[? str + " hit"]
	on_destroy = superflakpop
	on_step = superflakstep
	defbloom = {
	    xscale: 2,
	    yscale: 2,
	    alpha: .2
	}
    with proj_legacy(p){
	    other.damage = damage * 15
	    instance_delete(self)
	}
	payload = p
	friction = .4
	ammo = 5
	hyper = 0
	return id
}


#define flakdraw
draw_self()
draw_set_blend_mode(bm_add)
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale * 2, image_yscale * 2, image_angle, image_blend, image_alpha * .2)
draw_set_blend_mode(bm_normal)

#define superflakstep
if random(100) < 40*current_time_scale instance_create(x,y,Smoke)
flakstep()

#define flakstep
if random(100) < 40*current_time_scale instance_create(x,y,Smoke)
image_speed = speed/10
if speed < .01{
	instance_destroy()
}


#define superflakpop
with instance_create(x,y,BulletHit) sprite_index = other.spr_dead
view_shake_at(x,y,12)
sound_play_hit_big(sndSuperFlakExplode,.1)
var ang = random(360)
for var i = 0; i< 360; i+=360/ammo{
	with (flak(payload)){
		direction = ang + i
		image_angle = direction
		motion_set(direction, 12)
		creator = other.creator
		hyper = other.hyper
		team = other.team
		if other.hyper hyper_travel()
	}
}


#define flakpop
with instance_create(x,y,BulletHit) sprite_index = other.spr_dead
sound_play_hit_big(sndFlakExplode,.1)
view_shake_at(x,y,6)
if skill_get(mut_eagle_eyes){
    var ang = random(360)
	for var i = 0; i< 360; i+=360/ammo{
		with (proj_legacy(payload)){
			direction = i + ang
			image_angle = i + ang
			creator = other.creator
			team = other.team
			if other.hyper hyper_travel()
		}
	}
}
else{
	repeat(ammo){
		with proj_legacy(payload){
			direction = random(360)
			image_angle = direction
			creator = other.creator
			team = other.team
			if other.hyper hyper_travel()
		}
	}
}

#define shotcannon(p)
with instance_create(x,y,CustomProjectile) {
	var str = p + " shot"
	sprite_index = global.flakmap[? str]
	mask_index = mskFlakBullet
	with proj_legacy(p){
	    other.damage = damage
	    other.force = force
	    instance_delete(self)
	}
	image_speed = .4
	timer = 16
	ftimer = 1.5
	time = ftimer
	canshoot = 0
	dirfac = random(360)
	payload = p
	hyper = 0
	on_hit  = cannon_hit
	on_wall = cannon_wall
	on_step = cannon_step
	on_draw = cannon_draw
	on_anim = cannon_anim
	on_shoot = script_ref_create(shotfire)

	return id
}

#define supershotcannon(p)
with instance_create(x,y,CustomProjectile) {
	var str = "super " + p + " shot"
	sprite_index = global.flakmap[? str]
	mask_index = mskSuperFlakBullet
	with proj_legacy(p){
	    other.damage = damage * 5
	    other.force = force
	    instance_delete(self)
	}
	image_speed = .4
	timer = 7
	ftimer = 2
	time = ftimer
	canshoot = 0
	dirfac = random(360)
	payload = p
	hyper = 0
	on_hit = script_ref_create(cannon_hit)
	on_wall = script_ref_create(cannon_wall)
	on_step = script_ref_create(cannon_step)
	on_draw = script_ref_create(cannon_draw)
	on_anim = cannon_anim
	on_shoot = script_ref_create(supershotfire)

	return id
}

#define supershotfire(p)
dirfac += 360/4.22
var ang = dirfac
sound_play_hit(sndShotgun, .4)
view_shake_at(x,y,5)
repeat(3){
    with shotcannon(p){
        motion_set(ang,11)
        team = other.team
        creator = other.creator
        image_angle = direction
        hyper = other.hyper
        timer /= 4
        ang += 360/3
        //if other.hyper hyper_travel()
    }
}


#define cannon_anim
image_index = image_speed

#define cannon_wall
view_shake_at(x,y,12)
sound_play_pitch(sndShotgunHitWall,.8)
if skill_get(15){speed ++;image_index = 0}
move_bounce_solid(1)
speed *= .8
repeat(irandom(1)+2){
	with proj_legacy(payload){
		motion_set(random(360), random_range(8, 12))
		projectile_init(other.team,other.creator)
		image_angle = direction
	}
}

#define cannon_hit
x = xprevious
y = yprevious
projectile_hit_push(other,damage,force)
script_ref_call(on_shoot,payload)
timer -= 1;
if timer <= 0{
	instance_destroy()
}


#define shotfire(p)
dirfac += 12
var ang = dirfac
sound_play_hit(sndShotgun, .4)
view_shake_at(x,y,5)
repeat(5){
    with proj_legacy(p){
        motion_set(ang,stockspeed-5)
        team = other.team
        creator = other.creator
        image_angle = direction
        ang += 72
        if other.hyper hyper_travel()
    }
}

#define cannon_step
image_angle += (6 + speed*3) * current_time_scale
time -= current_time_scale

image_xscale = clamp(image_xscale + (random_range(-.05, .05) * current_time_scale), 1.2, 1.4)
image_yscale = image_xscale
if timer = 4 ftimer = 3
speed /= power(1.1, current_time_scale)
if speed <= 1 {canshoot = 1; speed = 0}

while time <= 0{
    time += ftimer
    if canshoot{
        script_ref_call(on_shoot,payload)
		timer -= 1;
		if timer <= 0{
			instance_destroy()
			exit
		}
    }
}

#define cannon_draw
if image_index < image_speed {var i = .5}else{var i = .1}
draw_sprite_ext(sprite_index, image_index, x, y, .7*image_xscale+i, .7*image_yscale+i, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 1.25*image_xscale+i*2, 1.25*image_yscale+i*2, image_angle, image_blend, i);
draw_set_blend_mode(bm_normal);


#define hyper_travel
damage = floor(damage*1.1)
var xl = lengthdir_x(8, direction), yl = lengthdir_y(8, direction);
var dir = 100
do {
    var man = instance_place(x, y, hitme);
    x += xl
    y += yl
    if !irandom(2) instance_create(x + random_range(-4,4), y + random_range(-4,4), Smoke);
}
until (instance_exists(man) && man.team != team) || place_meeting(x,y,Wall) || --dir <= 0
x -= hspeed
y -= vspeed
xprevious = x - xl/4
yprevious = y - yl/4


#define fset(range,subrange,n,acc)
direction = other.gunangle + (range*n)*(acc ? other.accuracy : 1) + random_range(-subrange,subrange)*other.accuracy
team = other.team
creator = other
image_angle = direction

#define set(range)
direction = other.gunangle + random_range(-range,range)*other.accuracy
team = other.team
creator = other
image_angle = direction


#define weapon_sprt(w)
if is_object(w){
	if w.done{
	    if sprite_exists(w.sprite)
	    	return w.sprite
	    sak_sprite(w)
	}
}
if instance_is(self,Player) return global.boxopen
return global.box

#define weapon_text
return choose("Gunlocker, eat your heart out","essence of shell")

#define birdspread
with instances_matching_ne(projectile,"birdspeed",null){
	direction += birdspeed * current_time_scale * speed
	image_angle = direction
}

#define draw_text_ext_shadow(x, y, str, sep, width)
draw_set_color(c_black)
draw_text_ext(x + 1, y + 1, str, sep, width)
draw_text_ext(x + 1, y, str, sep, width)
draw_text_ext(x, y + 1, str, sep, width)
draw_set_color(c_white)
draw_text_ext(x, y, str, sep, width)

#define get_blank()
return {
	wep: mod_current,
	ammo: 1,
	type: 2,
	load: 1,
	shots: 1,
	sounds: [],
	rads: 0,
	sprite: sprShotgun,
	auto: 0,
	time: 0,
	info: [-1,0,0],
	numbers: [0,0,0],
	name: "Custom Shotgun!",
	phase: 0,
	done: 0
}

#define step(q)
if q && !is_object(wep){
	wep = get_blank()
}
if q && is_object(wep) && wep.wep = mod_current && !wep.done{
    script_bind_draw(makemycoolgun, -17, index, wep)
}

#define sak_stats(w)
var sts = global.stats;
w.load = max(1, floor(sts[? w.info[2]][1] * sts[? w.info[1]][1] * sts[? w.info[3]][1]))
w.ammo = max(1, floor(sts[? w.info[2]][0] * sts[? w.info[1]][0] * sts[? w.info[3]][0]))
var radbase = sts[? w.info[1]][3]
if radbase > 0 w.rads = max(1, floor(radbase * sts[? w.info[2]][0] * sts[? w.info[3]][0]))
for (var i = 1; i<= 3; i++){
	array_push(w.sounds,sts[? w.info[i]][2])
	if mod_script_exists("weapon", mod_current, "take_"+string_replace(w.info[i]," ","_")) mod_script_call("weapon", mod_current, "take_"+string_replace(w.info[i]," ","_"),w)
}

//this thing is the distance between shit
#macro gx 22

#define makemycoolgun(index, wep)
instance_destroy()
draw_set_halign(0)
with player_find(index){
    var w = wep
	var tex = global.textmap;
	var cho = global.choicemap;
	var sts = global.stats;
	var width = array_length(cho[? w.info[w.phase]]);
	var height = 50;
	var _x 		= view_xview[index]+game_width/2 - width*gx/2;
	var _X 		= view_xview[index]+game_width/2 + width*gx/2-3;
	var _y 		= view_yview[index] + 50;
	var _Yline1 = view_yview[index] + 75;
	var _Yline2 = view_yview[index] + 53;

	var _a_index = 0
	switch w.info[1]
	{
		case "shell" 	    : _a_index = 1 break;
		case "slug"  	    : _a_index = 2 break;
		case "heavy slug"   : _a_index = 3 break;
		case "flame shell"  : _a_index = 4 break;
		case "ultra shell"  : _a_index = 5 break;
		case "psy shell"    : _a_index = 6 break;
		case "split shell"  : _a_index = 7 break;
		case "split slug"   : _a_index = 8 break;
		default : _a_index = 0 break;
	}
	var _b_index = 0
	switch w.info[2]
	{
		case "shotgun" 	   : _b_index = 1 break;
		case "eraser"  	   : _b_index = 2 break;
		case "flak cannon" : _b_index = 3 break;
		case "pop gun"     : _b_index = 4 break;
		case "shot cannon" : _b_index = 5 break;
		case "slugger"     : _b_index = 6 break;
		default : _b_index = 0 break;
	}

	var _str = "CREATE YOUR GUN"
	draw_text_nt(floor((_X+_x)/2-string_width(_str)/2),_y-15,_str)

	var _m_index = 0

	draw_set_color(c_black)
	draw_set_alpha(.3)
	draw_rectangle(_x,_Yline1,_X,_Yline2+2,0)
	draw_set_alpha(1)

	draw_sprite_ext(global.sprAmmoM,_a_index,(_x+_X)/2-18,_y-5,1,1,0,c_black,1)
	draw_sprite_ext(global.sprBodyM,_b_index,(_x+_X)/2-4,_y-5,1,1,0,c_black,1)
	draw_sprite_ext(global.sprModsM,_m_index,(_x+_X)/2+11,_y-5,1,1,0,c_black,1)
	draw_sprite(global.sprAmmoM,_a_index,(_x+_X)/2-18,_y-6)
	draw_sprite(global.sprBodyM,_b_index,(_x+_X)/2-4,_y-6)
	draw_sprite(global.sprModsM,_m_index,(_x+_X)/2+11,_y-6)

	draw_line_width_color(_x,_Yline2+1,_X+2,_Yline2+1,1,c_black,c_black)
	draw_line_width_color(_x-2,_Yline2,_X+1,_Yline2,1,c_white,c_white)

	draw_line_width_color(_x,_Yline1+1,_X+2,_Yline1+1,1,c_black,c_black)
	draw_line_width_color(_x-2,_Yline1,_X+1,_Yline1,1,c_white,c_white)

	draw_set_color(make_color_rgb(9, 15, 25))

	draw_set_color(c_white)
	for (var i = 0; i< width; i++)
	{
		var x1 = _x+gx*i +1;
		var y1 = _y + 6;
		var x2 = _x+gx*(i+1) +1;
		var y2 = y1 + 18;
		var push = button_pressed(index,"key"+string(i+1));
		var _btn = mskNone

		switch w.phase
		{
			case 0 : var _btn = global.sprAmmo break;
			case 1 : var _btn = global.sprBodyShell break;
			case 2 : var _btn = global.sprMods break;
		}
		if w.phase = 1{if w.info[1] = "slug" || w.info[1] = "heavy slug" || w.info[1] = "split slug" _btn = global.sprBodySlug}
		if w.phase = 2
		{
			switch w.info[2]
			{
				case "shotgun"		: _btn = global.sprModsShotgun break;
				case "pop gun"		: _btn = global.sprModsPopGun break;
				case "slugger"		: _btn = global.sprModsSlugger break;
				case "eraser" 		: _btn = global.sprModsEraser break;
				case "flak cannon"  : _btn = global.sprModsFlakCannon break;
				case "shot cannon"  : _btn = global.sprModsShotCannon break;
			}
		}
		if point_in_rectangle(mouse_x[index], mouse_y[index], x1, y1, x1 + 18, y1 + 18) || push
		{
			if !button_check(index, "fire"){
				draw_sprite(_btn,i,x1,y1-1)
			}
			else{
				draw_sprite_ext(_btn,i,x1,y1,1,1,0,c_ltgray,1)
			}

			var access = cho[? w.info[w.phase]][i]

			var p = ""
			switch access{
				case "shell"      :case "slug"    :case "heavy slug": p = `@(color:${merge_colour(c_yellow,c_orange,.5)})` break;
				case "flame shell": p = `@(color:${merge_colour(c_red,c_orange,.3)})` break;
				case "ultra shell": p = `@(color:${merge_colour(c_yellow,c_lime,.7)})` break;
				case "psy shell"  : p = `@(color:${merge_colour(c_fuchsia,c_navy,.2)})` break;
				case "split shell":case "split slug": p = `@(color:${merge_colour(c_aqua,c_blue,.1)})` break;
			}

			draw_text_nt(_x+1,y2+5,p+access)

			draw_set_font(fntSmall)

            var rel  = sts[? access][1]
            var cost = sts[? access][0]
            for var o = w.phase; o > 0; o--{
                rel *= sts[? w.info[o]][1]
                cost *= sts[? w.info[o]][0]
            }
            var t = tex[? access]
            t += "#@sReload:@w " + string(w.phase = 0 ? rel : max(1, floor(rel)))
            t += "#@sCost:@w " + string(w.phase = 0 ? cost : max(1, floor(cost)))
            var ammo = w.phase == 0 ? access : w.info[1]
            var rad = max(1, floor(sts[? ammo][3] * cost/sts[? ammo][0]))
            if rad > 1 t += "#@sRads:@w " + string(rad)

            draw_text_nt(_x+1, y2+16, t)

			draw_set_font(fntM)

			if button_released(index, "fire") || push{
				weapon_post(-2,8,0)
				sleep(9)
				repeat(5) instance_create(x+random_range(-5,5),y+random_range(-5,5),Dust)
				view_shake_at(x,y,3)
				draw_sprite_ext(_btn,i,x1,y1-2,1,1,0,c_white,1)
				w.info[++w.phase] = access
				w.numbers[w.phase-1] = i
				sound_play(sndClick)
				if w.phase = 3{
					with instance_create(x,y,Shell){
						image_speed = 0
						sprite_index = global.boxempty
						image_angle = random(360)
						speed = 5
						friction = .2
						creator = other
						team = other.team
						direction = other.gunangle
					}
					w.done = 1;
					sak_stats(w)
					sak_name(w)
					sak_sprite(w)
				}
			}
		}
		else{
			draw_sprite_ext(_btn,i,x1,y1,1,1,0,c_gray,1)
		}
	}
}
draw_set_halign(1)

#define sak_sprite(w)
w.sprite = global.gunmap[? w.name]

#define make_gun_random
var w = get_blank()
var cho = global.choicemap;
for (var i = 0; i< 3; i+=0){
	var n = irandom(array_length(cho[? w.info[i]]) -1);
	w.numbers[i] = n
	w.info[++i] = cho[? w.info[i-1]][n]
}
w.done = 1
sak_stats(w)
sak_name(w)
sak_sprite(w)
return w

#define sak_name(w)
w.name = `${w.info[3]} ${w.info[1]} ${w.info[2]}`
if w.info[3] = "wave" || w.info[3] = "bird"{
	w.name = `${w.info[1]} ${w.info[3]}`
	if w.info[3] = "wave" w.name += " gun"
}
if w.info[3] = "rifle"{
    w.name = string_replace(w.name, "rifle ", "")
    w.name = string_replace(w.name, "gun", "rifle")
}
w.name = string_replace(w.name, "none ", "")
w.name = string_replace(w.name, "shell ", "")
if w.info[2] = "slugger" w.name = string_replace(w.name, "slug ", "")

#define weapon_reloaded(w)
var b, c, d;
if w{b = wep}else{b = bwep}
c = weapon_get_cost(b);
d = weapon_get_type(b);
if is_object(b) && b.done
{
	sound_play(sndShotReload)
	weapon_post(-1,0,0)
	var e;
	if d = 1 e = 0 else e = 1
	repeat(max(1,c*e))
	{
    	with instance_create(x,y,Shell){
        	if d = 2 {if skill_get(mut_shotgun_shoulders) = false sprite_index = sprShotShell else sprite_index = sprShotShellBig}else{sprite_index = sprBulletShell}
        	motion_add(other.gunangle + (other.right * 90) + random_range(-40, 40),2 + random(2))
    	}
    }
}
