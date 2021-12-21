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
global.sprAmmo           = sprite_add("sprites/interface/sprSAKammo.png",      8, 9, 9)
global.sprBody           = sprite_add("sprites/interface/sprSAKbody.png",      6, 9, 9)
global.sprMods  	     = sprite_add("sprites/interface/sprSAKmods.png",     12, 9, 9)
global.sprAmmoM          = sprite_add("sprites/interface/sprSAKammoMini.png",  8, 4, 4)
global.sprBodyM          = sprite_add("sprites/interface/sprSAKbodyMini.png",  6, 4, 4)
global.sprModsM  	     = sprite_add("sprites/interface/sprSAKmodsm.png",    12, 4, 4)
global.sprMiniBlank		 = sprite_add("sprites/interface/sprSAKminiBlank.png", 1, 4, 4)
global.sprSelector		 = sprite_add("sprites/interface/sprSAKselectIcon.png", 1, 11, 12)
global.sprStats          = sprite_add("sprites/interface/sprSAKstatIcons.png", 4, 4, 5)

global.loadCounter = 0

global.shellbods = ["shotgun", "eraser", "flak cannon", "pop gun", "shot cannon"]
global.slugbods = ["shotgun", "eraser", "flak cannon", "slugger", "shot cannon"]

maketheoptions()
option_finalize()
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
ds_map_destroy(global.optionMap)
ds_map_destroy(global.gunmap)
ds_map_destroy(global.flakmap)



#define get_default_stat_object()
return {
	ammo : 1,
	reload : 1,
	projcount : 1,
	radsammo : 0,
	radsproj : 0,
	auto: 0
};


#define option_finalize
var keys = ds_map_keys(global.optionMap),
	defaultlq = {
		bodies : -1,
		mods : -1,
		text : "This is the default text, please report this to the devs if you see this.",
		sound : -1,
		sprite : mskNone,
		spritem: mskNone,
		index  : 0,
		namecolor : c_white
	},
	defaultstats = get_default_stat_object();

for (var i = 0, l = array_length(keys); i < l; i++) {
	var opt = global.optionMap[? keys[i]];
	if !(is_array(opt)) {
		for (var d = 0; d < lq_size(defaultlq); d++) {
		    var k = lq_get_key(defaultlq, d);
		    lq_set(opt, k, lq_defget(opt, k, lq_get(defaultlq, k)))
		}
		lq_set(opt, "name", lq_defget(opt, "name", keys[i]))  //set default display name to the key name
		lq_set(opt, "stats", lq_defget(opt, "stats", {}))     //set up stats LWO if its not there
		var _stats = opt.stats
		for (var d = 0; d < lq_size(defaultstats); d++) {
		    var k = lq_get_key(defaultstats, d);
		    lq_set(_stats, k, lq_defget(_stats, k, lq_get(defaultstats, k)))
		}
	}
}

#define maketheoptions()
global.optionMap = ds_map_create();
var a = global.optionMap;

/*stat ref:
	name : display name, automatically defaults to key
	namecolor : the color of the name when displayed, defaults to white
	bodies : array of map keys
	mods : as bodies
	stats : {
		ammo
		reload
		projcount
		radsammo (multiplied by final ammo cost, default 0, final multiplier calculated via addition)
		radsproj (multiplied by final projectile count, default 0, rad cost is selected from the lowest calculated number)
		auto (max of all parts)
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
a[? -1] = ["shell", "slug", "flame shell", "ultra shell", "psy shell", "split shell"];

//ammo
a[? "shell"] = {
	namecolor : merge_colour(c_yellow, c_orange, .5),
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
	text : "Standard shells.",
	sound : sndShotgun,
	sprite : global.sprAmmo,
	index : 0,
	spritem : global.sprAmmoM
}

a[? "slug"] = {
	namecolor : merge_colour(c_yellow, c_orange, .5),
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
	text : "Really big, expensive.",
	sound : sndSlugger,
	sprite : global.sprAmmo,
	index : 1,
	spritem : global.sprAmmoM
}

a[? "flame shell"] = {
	namecolor : merge_colour(c_red, c_orange, .3),
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
	text : "Flames deal extra damage, but don't bounce off walls well.",
	sound : sndFireShotgun,
	sprite : global.sprAmmo,
	index : 3,
	spritem : global.sprAmmoM
}

a[? "ultra shell"] = {
	namecolor : merge_colour(c_yellow, c_lime, .7),
	bodies : global.shellbods,
	stats : {
		ammo : 3,
		reload : .7,
		projcount: 9/7,
		radsammo : 14/3,
		radsproj : 14/9
	},
	proj : {
		obj : UltraShell,
		stockspeed : 16,
		speedmin : 12,
		speedmax: 18
	},
	text : "Radiation makes these shells stronger.",
	sound : sndUltraShotgun,
	sprite : global.sprAmmo,
	index : 4,
	spritem : global.sprAmmoM
}

a[? "psy shell"] = {
	namecolor : merge_colour(c_fuchsia, c_navy, .2),
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
	text : "Psy shells can home in on enemies.",
	sound : sndShotgun,
	sprite : global.sprAmmo,
	index : 5,
	spritem : global.sprAmmoM
}

a[? "split shell"] = {
	namecolor : merge_colour(c_aqua, c_blue, .1),
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
	text : "Upon impact, splits into two shells.",
	sound : sndShotgun,
	sprite : global.sprAmmo,
	spritem : global.sprAmmoM,
	index : 6
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
		projcount : 1,
		auto : true
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
	text : "Fires a projectile that spits out shells over time.",
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
	text : "Doubles the projectile count, efficient!",
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
		projcount : 6/7,
		auto: true
	},
	text : "Rapid fire! Reduces accuracy and projectile count.",
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
if instance_is(self, WepPickup) {
	return `@(color:${make_color_rgb(255, 156, 0)})SHOTGUN ASSEMBLY KIT`
}
return "SHOTGUN ASSEMBLY KIT"

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

//The idea here is that the proj scripts need to have a specific syntax, so an intermediary script is needed to get all the arguments out of the array.
#define projectile_link(x, y, _args, _modifier) //These are the arguments always passed to all ammo.proj scripts
	var _scriptname = (_modfier == "heavy" ? string_replace(_args[0], "create_", "create_heavy_") : _scriptname);
	return mod_script_call_self("mod", "defpack tools", _scriptname, x, y)

#define proj_create(_wep)
var _p = -4, _proj = _wep.proj;
	if is_real(_proj.obj) {
		_p = instance_create(x, y, _proj.obj)
	}
	else if is_array(_proj.obj) {
		_p = mod_script_call_self(_proj.obj[0], _proj.obj[1], _proj.obj[2], x, y, _proj.obj[3], _wep.modifier) //_proj
	}
	with _p {
		speed = random_range(_proj.speedmin, _proj.speedmax)
		stockspeed = _proj.stockspeed
	}

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

#define draw_sprite_shadowed(spr, index, x, y, col)
	draw_sprite_ext(spr, index, x + 1, y + 1, 1, 1, 0, c_black, 1)
	draw_sprite_ext(spr, index, x    , y + 1, 1, 1, 0, c_black, 1)
	draw_sprite_ext(spr, index, x + 1, y    , 1, 1, 0, c_black, 1)
	draw_sprite_ext(spr, index, x    , y    , 1, 1, 0, col, 1)

#define getNewSak()
	return {
		name: "Custom Shotgun",
		wep: mod_current,
		selections: [],
		stats: {},
		proj: {},
		isDone: false,
		done: false
	}

#define step(q)
if (q && !is_object(wep)) || button_pressed(index, "horn"){
	wep = getNewSak()
}
if q && is_object(wep) && wep.wep = mod_current && !wep.isDone{
    script_bind_draw(sakBuilder, -17, index, wep)
}
if is_object(q ? wep : bwep) {
	script_bind_draw(scrDebugDraw, -17, q ? wep : bwep)
}

#define scrDebugDraw(wep)
	instance_destroy()
	draw_set_halign(0)
	draw_set_font(fntSmall)
	trace_lwo_start(wep, view_xview_nonsync + 60, view_yview_nonsync + 30)
	draw_set_font(fntM)

//Distance between buttons, doesn't really need to be a macro but it was this way when I found it
#macro buttonSpace 22

#define sakBuilder(indexIn, wepIn)
	instance_destroy();
	draw_set_halign(0);
	
	draw_set_visible_all(false)
	draw_set_visible(indexIn, true)
	
	//Various, useful variables
	var l = array_length(wepIn.selections),
		selectionIndex = l,
		user = player_find(indexIn),
		isLocal = player_is_local_nonsync(indexIn);
	//The choices to select from
	var options;
	if (l > 0) {
		//Before the mod selection phase, get bodies from the projectile
		if (l == 1) {
			options = global.optionMap[? wepIn.selections[0]].bodies;
		}
		//During and after the mod selection phase, get mods from projectiles and bodies
		else {
			options = [];
			with (wepIn.selections) {
				var opt = global.optionMap[? self];
				if (opt.mods != -1) with (opt.mods) {
					array_push(options, self);
				}
			}
		}
	}
	else {
		//The first step, projectile selection
		options = global.optionMap[? -1];
	}
	
	//Coordinates
	var _l = array_length(options);
	var xCenter = view_xview[indexIn] + game_width/2,
		leftSide = xCenter - _l * buttonSpace/2,
		rightSide = xCenter + _l * buttonSpace/2,
		yCenter = view_yview[indexIn] + 60,
		yTop = yCenter - buttonSpace/2,
		yBottom = yCenter + buttonSpace/2;
	
	//Prompt
	draw_set_halign(1);
	draw_text_nt(xCenter, yCenter - buttonSpace, "CREATE YOUR GUN");
	draw_set_halign(0);
	
	//Backdrop
	draw_set_alpha(.4);
	draw_roundrect_color(leftSide - 1, yTop - 1, rightSide, yBottom, 0, 0, false);
	draw_set_alpha(1);
	
	//Populate the mini icons, drawn later, modified in button loop below
	var miniIcons = [],
		miniIndexes = [];
	with (wepIn.selections) {
		var opt = global.optionMap[? self]
		array_push(miniIcons, opt.spritem)
		array_push(miniIndexes, opt.index)
	}
	while (array_length(miniIcons) < 3) {
		array_push(miniIcons, global.sprMiniBlank)
		array_push(miniIndexes, 0)
	}
	
	var statParts = array_clone(wepIn.selections),
		partText = -1,
		miniBlink = false;
	
	var buttonX = leftSide + buttonSpace/2;
	for (var i = 0; i < _l; i++) {
		//Setting up button variables
		var buttonChoice = global.optionMap[? options[i]],
			buttonSpr = buttonChoice.sprite,
			buttonIndex = buttonChoice.index,
			buttonLeft = buttonX - sprite_get_xoffset(buttonSpr) - 2,
			buttonRight = buttonLeft + sprite_get_width(buttonSpr) + 2,
			buttonTop = yCenter - sprite_get_yoffset(buttonSpr),
			buttonBottom = buttonTop + sprite_get_height(buttonSpr);
			
		//Input
		var hovering = point_in_rectangle(mouse_x[indexIn], mouse_y[indexIn], buttonLeft, buttonTop, buttonRight, buttonBottom),
			pushing = button_pressed(indexIn, "key" + string(i + 1)) || button_released(indexIn, "key" + string(i + 1)),
			selected = button_released(indexIn, "fire") || button_released(indexIn, "key" + string(i + 1));
			
		//Nothing going on, just draw the button.
		if !(hovering || pushing) {
			draw_sprite_ext(buttonSpr, buttonIndex, buttonX, yCenter, 1, 1, 0, c_gray, 1)
		}
		else {
			//'Pushing' the button
			if (button_check(indexIn, "fire") || pushing) {
				draw_sprite_ext(buttonSpr, buttonIndex, buttonX, yCenter, 1, 1, 0, c_ltgray, 1)
			}
			//Just looking
			else {
				draw_sprite(buttonSpr, buttonIndex, buttonX, yCenter - 1)
			}
			//Draw little select indicator
			draw_sprite(global.sprSelector, 0, buttonX, yCenter)
			
			//Draw Name
			var _name = `@(color:${buttonChoice.namecolor})` + buttonChoice.name;
			draw_text_nt(leftSide + 1, yBottom + 16, _name)
			
			//Add this part to the stats for preview
			array_push(statParts, options[i])
			miniIcons[selectionIndex] = buttonChoice.spritem
			miniIndexes[selectionIndex] = buttonChoice.index
			
			//Save the text so it is drawn later
			partText = buttonChoice.text
			//Allow the mini icon to blink in the preview
			miniBlink = true
			
			//Selection
			if (selected) {
				array_push(wepIn.selections, options[i])
				draw_sprite(buttonSpr, buttonIndex, buttonX, yCenter - 2)
				
				//For debugging
				wepIn.stats = calculate_stats(wepIn.selections)
				//Prevents sounds for playing for players that can't see the menu (nonsync)
				if (isLocal) {
					sound_play(sndClick)
				}
				if (array_length(wepIn.selections) >= 3) {
					wepIn.isDone = true;
				}
			}
			
		}
		
		buttonX += buttonSpace
	}
	
	//Sub menu icons can have little mouseover texts
	var cursorText = -1,
		cursorTextX = mouse_x_nonsync + 6,
		cursorTextY = mouse_y_nonsync + 6;
	
	//Draw mini icons
	var iconYCenter = yBottom + 6,
		iconSpace = 9,
		_ml = array_length(miniIcons),
		iconXLeft = xCenter - (_ml - 1)*iconSpace/2;
	for (var i = 0; i < _ml; i++) {
		//Draw icon
		draw_sprite_ext(miniIcons[i], miniIndexes[i], iconXLeft + iconSpace*i + 1, iconYCenter + 1, 1, 1, 0, c_black, 1)
		draw_sprite_ext(miniIcons[i], miniIndexes[i], iconXLeft + iconSpace*i, iconYCenter, 1, 1, 0,
				i == selectionIndex && miniBlink ? merge_color(c_black, c_white, dsin(current_frame * 5)/8 + 7/8) : c_white,
				1
			)
		//Mouseover text to tell you previous selections
		if (i < selectionIndex && point_in_rectangle(
				mouse_x_nonsync, mouse_y_nonsync,
				iconXLeft + iconSpace*(i - .5), iconYCenter - iconSpace/2,
				iconXLeft + iconSpace*(i + .5), iconYCenter + iconSpace/2
			)) {
				cursorText = global.optionMap[? wepIn.selections[i]].name
				cursorTextX = xCenter + (xCenter - iconXLeft) + 8
				cursorTextY = iconYCenter - 2
		}
	}

	//Dividing line
	var _lineY = yBottom + 12;
	draw_line_width_color(leftSide, _lineY + 1, rightSide + 1, _lineY + 1, 1, c_black, c_black)
	draw_line_width_color(leftSide - 1, _lineY, rightSide, _lineY, 1, c_white, c_white)
	
	//Description
	var _barGap = 27;
	if (partText != -1) {
		draw_set_font(fntSmall)
		var _textboxWidth = rightSide - leftSide + 12;
		draw_text_ext_shadow(leftSide + 1, yBottom + 25, partText, 7, _textboxWidth)
		_barGap += string_height_ext(partText, 7, _textboxWidth)
		draw_set_font(fntM)
	}

	//Another dividing line
	var _lineLeft = leftSide + 4,
		_lineRight = rightSide - 4,
		_lineY = yBottom + _barGap;
	draw_line_width_color(_lineLeft + 1, _lineY + 1, _lineRight + 1, _lineY + 1, 1, c_black, c_black)
	draw_line_width_color(_lineLeft, _lineY, _lineRight, _lineY, 1, c_white, c_white)


	//Draw stat preview
	var _stats, _forceDraw = false;
	//Gather Stats
	if (array_length(statParts) > 0) {
		_stats = calculate_stats(statParts)
	}
	else {
		_stats = calculate_stats(-1)
		//Makes the rad icon draw, so people can identify it
		_forceDraw = true
	}
	var _statY = yBottom + _barGap + 8,
		_statWidth = 32,
		_statCount = 3 + (_stats.rads > 0 || _forceDraw),
		_statLeft = xCenter - (_statCount - 1) * _statWidth/2,
		_statList = [_stats.ammo, _stats.reload, _stats.projcount, _stats.rads],
		_statName = ["ammo cost", "reload time", "projectile count", "rad cost"];
		
	draw_set_font(fntSmall)
	draw_set_valign(1)
	for (var s = 0; s < _statCount; s++) {
		var _statX = _statLeft + _statWidth * s;
		draw_sprite_shadowed(global.sprStats, s, _statX, _statY, c_white)
		
		//Check for mouse to display stat name
		if (point_in_rectangle(
			mouse_x_nonsync, mouse_y_nonsync,
			_statX - 6, _statY - 5,
			_statX + 6, _statY + 5
			)) {
			cursorText = _statName[s]
			cursorTextX = _statX + 5
			cursorTextY = _statY + 5
		}
		
		var _statRounded = string_replace(string_format(_statList[s], 1, 1), ".0", "");
		//Warn if ammo cost is above max
		if (s == 0 && instance_exists(user) && user.typ_amax[2] < _statList[s]) {
			draw_text_nt(_statX + 6, _statY, "@r@q" + _statRounded)
		}
		else {
			draw_text_nt(_statX + 6, _statY, _statRounded)
		}
	}
	draw_set_font(fntM)
	draw_set_valign(0)

	//Mouseover tooltips
	if (cursorText != -1) {
		draw_set_font(fntSmall)
		var _width = string_width(cursorText);
		
		//Backdrop
		draw_set_alpha(.4)
		draw_roundrect_color(cursorTextX - 3, cursorTextY - 2, cursorTextX + _width, cursorTextY + 6, c_black, c_black, false)
		draw_set_alpha(1)
		//Text
		draw_text_nt(cursorTextX, cursorTextY, `@(color:${merge_color(c_white, c_black, .1)})` + cursorText)
		
		draw_set_font(fntM)
	}
	
	
	draw_set_visible_all(true)
	draw_set_halign(1);


//'Parts' are keys for the option map
#define calculate_stats(partList)
	//Blank stats object for the basic display
	if (!is_array(partList)) {
		return {
			ammo: 0,
			reload: 0,
			projcount: 0,
			rads: 0,
			radsproj: 0,
			radsammo: 0
		}
	}
	var finalStats = get_default_stat_object();
	//Iterate through all parts
	with (partList) {
		//Get their reference stats, apply them to the final stats
		with (global.optionMap[? self].stats) {
			finalStats.reload *= reload
			finalStats.ammo *= ammo
			finalStats.projcount *= projcount
			finalStats.radsammo += radsammo
			finalStats.radsproj += radsproj
			finalStats.auto = max(finalStats.auto, auto)
		}
	}
	//Calculate rads based on projectile/ammo count
	finalStats.rads = calculate_rad_cost(finalStats)
	return finalStats;
	
#define calculate_rad_cost(statObject)
	return min(statObject.ammo * statObject.radsammo, statObject.projcount * statObject.radsproj)

#define sak_sprite(w)
w.sprite = global.gunmap[? w.name]

#define sak_stats

#define make_gun_random
var w = getNewSak();
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

#define trace_lwo_start(lwo, _x, _y)
	trace_lwo(lwo, {x: _x, y: _y})

#define trace_lwo(lwo, pos)
	for (var i = 0, l = lq_size(lwo); i < l; i++) {
		var value = lq_get_value(lwo, i),
			key =   lq_get_key(lwo, i) + " : ";
		
		if is_object(value) {
			key += "{"
		}
		else {
			key += string(value)
		}
		
		draw_line_pos(pos, key)

		if is_object(value) {
			pos.x += 6
			trace_lwo(value, pos)
			pos.x -= 6
			draw_line_pos(pos, "}")
		}
	}
	
#define draw_line_pos(pos, text)
	draw_text_nt(pos.x, pos.y, text)
	pos.y += string_height(text) + 1