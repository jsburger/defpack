#define init
global.box = sprite_add_weapon("sprites/sprSAK.png",2,3)
global.guys = [0,0,0,0]
with instances_matching([CustomDraw,CustomStep],"customshell",1){
	instance_destroy()
}
with script_bind_draw(makemycoolgun,-15){
	persistent = 1
	customshell = 1
}
with script_bind_step(birdspread, 0){
	persistent = 1
	customshell = 1
}
global.sprammo = sprite_add("sprites/sprSAKammo.png",8,0,0)
global.sprbody = sprite_add("sprites/sprSAKbody.png",6,0,0)
global.sprmods = sprite_add("sprites/sprSAKmods.png",9,0,0)
global.shellbods = ["shotgun", "eraser", "flak cannon", "pop gun", "shot cannon"]
global.slugbods = ["shotgun", "eraser", "flak cannon", "slugger", "shot cannon"]

makethechoices()
makethetexts()
makethestats()
makethegunsprites()


#define makethegunsprites()
global.gunmap = ds_map_create()
var a = global.gunmap;

//PROJECTILES
global.sprShot 		  = sprite_add("sprites/sak/projectiles/sprShot.png",2,8,8);
global.sprPsyShot   = sprite_add("sprites/sak/projectiles/sprPsyShot.png",2,8,8);
global.sprFireShot  = sprite_add("sprites/sak/projectiles/sprFireShot.png",2,8,8);
global.sprUltraShot = sprite_add("sprites/sak/projectiles/sprUltraShot.png",2,8,8);
global.sprSplitShot = sprite_add("sprites/sak/projectiles/sprSplitShot.png",2,8,8);
global.sprSuperShot      = sprite_add("sprites/sak/projectiles/sprSuperShot.png",2,12,12);
global.sprSuperPsyShot   = sprite_add("sprites/sak/projectiles/sprSuperPsyShot.png",2,12,12);
global.sprSuperFireShot  = sprite_add("sprites/sak/projectiles/sprSuperFireShot.png",2,12,12);
global.sprSuperUltraShot = sprite_add("sprites/sak/projectiles/sprSuperUltraShot.png",2,12,12);
global.sprSuperSplitShot = sprite_add("sprites/sak/projectiles/sprSuperSplitShot.png",2,12,12);
global.sprSuperHeavyShot      = sprite_add("sprites/sak/projectiles/sprSuperHeavyShot.png",2,18,18);
global.sprSuperHeavySplitShot = sprite_add("sprites/sak/projectiles/sprSuperHeavySplitShot.png",2,18,18);
global.sprFlak      = sprFlakBullet
global.sprPsyFlak   = sprite_add("sprites/sak/projectiles/sprPsyFlak.png",2,8,8);
global.sprFireFlak  = sprite_add("sprites/sak/projectiles/sprFireFlak.png",2,8,8);
global.sprUltraFlak = sprite_add("sprites/sak/projectiles/sprUltraFlak.png",2,8,8);
global.sprSplitFlak = sprite_add("sprites/sak/projectiles/sprSplitFlak.png",2,8,8);
global.sprSuperFlak      = sprite_add("sprites/sak/projectiles/sprSuperFlak.png",2,12,12);
global.sprSuperPsyFlak   = sprite_add("sprites/sak/projectiles/sprSuperPsyFlak.png",2,12,12);
global.sprSuperFireFlak  = sprite_add("sprites/sak/projectiles/sprSuperFireFlak.png",2,12,12);
global.sprSuperUltraFlak = sprite_add("sprites/sak/projectiles/sprSuperUltraFlak.png",2,12,12);
global.sprSuperSplitFlak = sprite_add("sprites/sak/projectiles/sprSuperSplitFlak.png",2,12,12);
global.sprSuperHeavyFlak      = sprite_add("sprites/sak/projectiles/sprSuperHeavyFlak.png",2,18,18);
global.sprSuperHeavySplitFlak = sprite_add("sprites/sak/projectiles/sprSuperHeavySplitFlak.png",2,18,18);
global.sprFlakHit      = sprFlakHit
global.sprPsyFlakHit   = sprite_add("sprites/sak/projectiles/sprPsyFlakHit.png",9,8,8);
global.sprFireFlakHit  = sprite_add("sprites/sak/projectiles/sprFireFlakHit.png",9,8,8);
global.sprUltraFlakHit = sprite_add("sprites/sak/projectiles/sprUltraFlakHit.png",9,8,8);
global.sprSplitFlakHit = sprite_add("sprites/sak/projectiles/sprSplitFlakHit.png",9,8,8);

///REGULAR///
a[? "shotgun"]	         = sprShotgun
a[? "double shotgun"]    = sprSuperShotgun
a[? "sawed-off shotgun"] = sprSawnOffShotgun
a[? "auto shotgun"]      = sprAutoShotgun
a[? "assault shotgun"]   = sprite_add_weapon("sprites/sak/sprAssaultShotgun.png",4,2)//
a[? "hyper shotgun"]     = sprite_add_weapon("sprites/sak/sprHyperShotgun.png",3,2)//

a[? "flak cannon"]       = sprFlakCannon
a[? "super flak cannon"] = sprSuperFlakCannon
a[? "auto flak cannon"]  = sprite_add_weapon("sprites/sak/sprAutoFlakCannon.png",2,2)//
a[? "hyper flak cannon"] = sprite_add_weapon("sprites/sak/sprHyperFlakCannon.png",3,2)//

a[? "shot cannon"] 	     = sprite_add_weapon("sprites/sak/sprShotCannon.png",3,2)//
a[? "super shot cannon"] = sprite_add_weapon("sprites/sak/sprSuperShotCannon.png",3,2)//
a[? "auto shot cannon"]  = sprite_add_weapon("sprites/sak/sprAutoShotCannon.png",3,1)//
a[? "hyper shot cannon"] = sprite_add_weapon("sprites/sak/sprHyperShotCannon.png",3,4)//

a[? "eraser"] 	    	= sprEraser
a[? "auto eraser"]    = sprite_add_weapon("sprites/sak/sprAutoEraser.png",3,2)//
a[? "assault eraser"] = sprite_add_weapon("sprites/sak/sprAssaultEraser.png",3,2)//
a[? "bird"]           = sprite_add_weapon("sprites/sak/sprBird.png",3,2)//
a[? "wave gun"]       = sprWaveGun
a[? "hyper eraser"]   = sprite_add_weapon("sprites/sak/sprHyperEraser.png",3,3)//

a[? "pop gun"]	      = sprPopGun
a[? "triple pop gun"] = sprite_add_weapon("sprites/sak/sprTriplePopGun.png",5,4)//
a[? "pop rifle"]      = sprPopRifle
a[? "hyper pop gun"]  = sprite_add_weapon("sprites/sak/sprHyperPopGun.png",4,3)//

///PSY///
a[? "psy shotgun"]	         = sprite_add_weapon("sprites/sak/sprPsyShotgun.png",3,2)//
a[? "double psy shotgun"]    = sprite_add_weapon("sprites/sak/sprDoublePsyShotgun.png",3,3)//
a[? "sawed-off psy shotgun"] = sprite_add_weapon("sprites/sak/sprSawedOffPsyShotgun.png",3,3)//
a[? "auto psy shotgun"]      = sprite_add_weapon("sprites/sak/sprAutoPsyShotgun.png",3,1)//
a[? "assault psy shotgun"]   = sprite_add_weapon("sprites/sak/sprAssaultPsyShotgun.png",3,2)//
a[? "hyper psy shotgun"]     = sprite_add_weapon("sprites/sak/sprHyperPsyShotgun.png",3,3)//

a[? "psy flak cannon"]  	   = sprite_add_weapon("sprites/sak/sprPsyFlakCannon.png",3,2)//
a[? "super psy flak cannon"] = sprite_add_weapon("sprites/sak/sprSuperPsyFlakCannon.png",4,3)//
a[? "auto psy flak cannon"]  = sprite_add_weapon("sprites/sak/sprAutoPsyFlakCannon.png",2,2)//
a[? "hyper psy flak cannon"] = sprite_add_weapon("sprites/sak/sprHyperPsyFlakCannon.png",3,2)//

a[? "psy shot cannon"]			 = sprite_add_weapon("sprites/sak/sprPsyShotCannon.png",4,2)//
a[? "super psy shot cannon"] = sprite_add_weapon("sprites/sak/sprSuperPsyShotCannon.png",4,2)//
a[? "auto psy shot can non"] = sprite_add_weapon("sprites/sak/sprAutoPsyShotCannon.png",3,1)//
a[? "hyper psy shot cannon"] = sprite_add_weapon("sprites/sak/sprHyperPsyShotCannon.png",4,2)//

a[? "psy eraser"]         = sprite_add_weapon("sprites/sak/sprPsyEraser.png",2,1)//
a[? "auto psy eraser"]    = sprite_add_weapon("sprites/sak/sprAutoPsyEraser.png",2,1)//
a[? "assault psy eraser"] = sprite_add_weapon("sprites/sak/sprAssaultPsyEraser.png",2,1)//
a[? "psy bird"]	  			  = sprite_add_weapon("sprites/sak/sprPsyBird.png",4,3)//
a[? "psy wave gun"]       = sprite_add_weapon("sprites/sak/sprPsyWaveGun.png",5,3)//
a[? "hyper psy eraser"]   = sprite_add_weapon("sprites/sak/sprHyperPsyEraser.png",4,2)//

a[? "psy pop gun"]		     = sprite_add_weapon("sprites/sak/sprPsyPopGun.png",3,1)//
a[? "triple psy pop gun"]  = sprite_add_weapon("sprites/sak/sprTriplePsyPopGun.png",5,3)//
a[? "psy pop rifle"]			 = sprite_add_weapon("sprites/sak/sprPsyPopRifle.png",5,2)//
a[? "hyper psy pop gun"]   = sprite_add_weapon("sprites/sak/sprHyperPsyPopGun.png",3,2)//

///SPLIT SHELL///
a[? "split shotgun"] 		 			 = sprite_add_weapon("sprites/sak/sprSplitShotgun.png",3,2)//
a[? "double split shotgun"]    = sprite_add_weapon("sprites/sak/sprDoubleSplitShotgun.png",3,2)//
a[? "sawed-off split shotgun"] = sprite_add_weapon("sprites/sak/sprSawedOffSplitShotgun.png",3,2)//
a[? "auto split shotgun"]   	 = sprite_add_weapon("sprites/sak/sprAutoSplitShotgun.png",3,1)//
a[? "assault split shotgun"] 	 = sprite_add_weapon("sprites/sak/sprAssaultSplitShotgun.png",3,2)//
a[? "hyper split shotgun"] 		 = sprite_add_weapon("sprites/sak/sprHyperSplitShotgun.png",3,3)//

a[? "split flak cannon"]	   	 = sprite_add_weapon("sprites/sak/sprSplitFlakCannon.png",3,2)//
a[? "super split flak cannon"] = sprite_add_weapon("sprites/sak/sprSuperSplitFlakCannon.png",3,4)//
a[? "auto split flak cannon"]  = sprite_add_weapon("sprites/sak/sprAutoSplitFlakCannon.png",3,2)//
a[? "hyper split flak cannon"] = sprite_add_weapon("sprites/sak/sprHyperSplitFlakCannon.png",3,2)//

a[? "split shot cannon"] 	     = sprite_add_weapon("sprites/sak/sprSplitShotCannon.png",4,3)//
a[? "super split shot cannon"] = sprite_add_weapon("sprites/sak/sprSuperSplitShotCannon.png",5,4)//
a[? "auto split shot cannon"]  = sprite_add_weapon("sprites/sak/sprAutoSplitShotCannon.png",4,3)//
a[? "hyper split shot cannon"] = sprite_add_weapon("sprites/sak/sprHyperSplitShotCannon.png",4,3)//

a[? "split eraser"] 	      = sprite_add_weapon("sprites/sak/sprSplitEraser.png",3,2)//
a[? "auto split eraser"]    = sprite_add_weapon("sprites/sak/sprAutoSplitEraser.png",3,1)//
a[? "assault split eraser"] = sprite_add_weapon("sprites/sak/sprAssaultSplitEraser.png",3,2)//
a[? "split bird"]			 			= sprite_add_weapon("sprites/sak/sprSplitBird.png",3,2)//
a[? "split wave gun"]			  = sprite_add_weapon("sprites/sak/sprSplitWaveGun.png",4,4)//
a[? "hyper split eraser"]   = sprite_add_weapon("sprites/sak/sprHyperSplitEraser.png",3,3)//

a[? "split pop gun"]		 		 = sprite_add_weapon("sprites/sak/sprSplitPopGun.png",3,2)//
a[? "triple split pop gun"]	 = sprite_add_weapon("sprites/sak/sprTripleSplitPopGun.png",6,3)//
a[? "split pop rifle"] 	 		 = sprite_add_weapon("sprites/sak/sprAssaultSplitPopGun.png",5,2)//
a[? "hyper split pop gun"]	 = sprite_add_weapon("sprites/sak/sprHyperSplitPopGun.png",3,2)//

///FLAME SHELLS///
a[? "flame shotgun"]  	  	   = sprFlameShotgun
a[? "double flame shotgun"]    = sprDoubleFlameShotgun
a[? "sawed-off flame shotgun"] = sprite_add_weapon("sprites/sak/sprSawedOffFlameShotgun.png",4,2)//
a[? "auto flame shotgun"]    	 = sprAutoFlameShotgun
a[? "assault flame shotgun"] 	 = sprite_add_weapon("sprites/sak/sprAssaultFlameShotgun.png",4,2)//
a[? "hyper flame shotgun"]  	 = sprite_add_weapon("sprites/sak/sprHyperFlameShotgun.png",4,2)//

a[? "flame flak cannon"] 	     = sprite_add_weapon("sprites/sak/sprFlameFlakCannon.png",2,3)//
a[? "super flame flak cannon"] = sprite_add_weapon("sprites/sak/sprSuperFlameFlakCannon.png",3,5)//
a[? "auto flame flak cannon"]  = sprite_add_weapon("sprites/sak/sprAutoFlameFlakCannon.png",2,2)//
a[? "hyper flame flak cannon"] = sprite_add_weapon("sprites/sak/sprHyperFlameFlakCannon.png",4,3)//

a[? "flame shot cannon"]  	   = sprite_add_weapon("sprites/sak/sprFlameShotCannon.png",3,2)//
a[? "super flame shot cannon"] = sprite_add_weapon("sprites/sak/sprSuperFlameShotCannon.png",4,3)//
a[? "auto flame shot cannon"]  = sprite_add_weapon("sprites/sak/sprAutoFlameShotCannon.png",3,2)//
a[? "hyper flame shot cannon"] = sprite_add_weapon("sprites/sak/sprHyperFlameShotCannon.png",4,3)//

a[? "flame eraser"] 		    = sprite_add_weapon("sprites/sak/sprFlameEraser.png",3,3)//
a[? "auto flame eraser"]    = sprite_add_weapon("sprites/sak/sprAutoFlameEraser.png",3,3)//
a[? "assault flame eraser"] = sprite_add_weapon("sprites/sak/sprAssaultFlameEraser.png",4,2)//
a[? "flame bird"]			      = sprite_add_weapon("sprites/sak/sprPhoenix.png",3,2)//
a[? "flame wave gun"] 	  	= sprite_add_weapon("sprites/sak/sprFlameWaveGun.png",3,2)//
a[? "hyper flame eraser"]	  = sprite_add_weapon("sprites/sak/sprHyperFlameEraser.png",3,2)//

a[? "flame pop gun"] 		 		 = sprite_add_weapon("sprites/sak/sprFlamePopGun.png",3,2)//
a[? "triple flame pop gun"]  = sprIncinerator
a[? "flame pop rifle"] 			 = sprite_add_weapon("sprites/sak/sprFlamePopRifle.png",3,2)//
a[? "hyper flame pop gun"]   = sprite_add_weapon("sprites/sak/sprHyperFlamePopGun.png",3,2)//

///ULTRA SHELLS///
a[? "ultra shotgun"]  	  	   = sprUltraShotgun
a[? "double ultra shotgun"]    = sprite_add_weapon("sprites/sak/sprDoubleUltraShotgun.png",3,3)//
a[? "sawed-off ultra shotgun"] = sprite_add_weapon("sprites/sak/sprSawedOffUltraShotgun.png",3,3)//
a[? "auto ultra shotgun"]   	 = sprite_add_weapon("sprites/sak/sprAutoUltraShotgun.png",3,2)//
a[? "assault ultra shotgun"] 	 = sprite_add_weapon("sprites/sak/sprAssaultUltraShotgun.png",3,2)//
a[? "hyper ultra shotgun"]   	 = sprite_add_weapon("sprites/sak/sprHyperUltraShotgun.png",3,4)//

a[? "ultra flak cannon"] 	     = sprite_add_weapon("sprites/sak/sprUltraFlakCannon.png",3,2)//
a[? "super ultra flak cannon"] = sprite_add_weapon("sprites/sak/sprSuperUltraFlakCannon.png",3,1)//
a[? "auto ultra flak cannon"]  = sprite_add_weapon("sprites/sak/sprAutoUltraFlakCannon.png",3,2)//
a[? "hyper ultra flak cannon"] = sprite_add_weapon("sprites/sak/sprHyperUltraFlakCannon.png",5,3)//

a[? "ultra shot cannon"] 	     = sprite_add_weapon("sprites/sak/sprUltraShotCannon.png",3,2)//
a[? "super ultra shot cannon"] = sprite_add_weapon("sprites/sak/sprSuperUltraShotCannon.png",6,3)//
a[? "auto ultra shot cannon"]  = sprite_add_weapon("sprites/sak/sprAutoUltraShotCannon.png",3,2)//
a[? "hyper ultra shot cannon"] = sprite_add_weapon("sprites/sak/sprHyperUltraShotCannon.png",5,2)//

a[? "ultra eraser"] 		 		= sprite_add_weapon("sprites/sak/sprUltraEraser.png",3,2)//
a[? "auto ultra eraser"]    = sprite_add_weapon("sprites/sak/sprAutoUltraEraser.png",3,2)//
a[? "assault ultra eraser"] = sprite_add_weapon("sprites/sak/sprAssaultUltraEraser.png",11,2)//
a[? "ultra bird"]			 			= sprite_add_weapon("sprites/sak/sprUltraBird.png",5,3)//
a[? "ultra wave gun"] 		  = sprite_add_weapon("sprites/sak/sprUltraWaveGun.png",4,4)//
a[? "hyper ultra eraser"] 	= sprite_add_weapon("sprites/sak/sprHyperUltraEraser.png",7,3)//

a[? "ultra pop gun"] 		 		 = sprite_add_weapon("sprites/sak/sprUltraPopGun.png",3,2)//
a[? "triple ultra pop gun"]  = sprite_add_weapon("sprites/sak/sprTripleUltraPopGun.png",6,4)//
a[? "ultra pop rifle"] 	 		 = sprite_add_weapon("sprites/sak/sprUltraPopRifle.png",3,2)//
a[? "hyper ultra pop gun"]   = sprite_add_weapon("sprites/sak/sprHyperUltraPopGun.png",7,2)//

///SLUGS///
a[? "slug shotgun"] 				  = sprite_add_weapon("sprites/sak/sprSlugShotgun.png",3,1)//
a[? "double slug shotgun"] 		= sprite_add_weapon("sprites/sak/sprDoubleSlugShotgun.png",3,1)//
a[? "sawed-off slug shotgun"] = sprite_add_weapon("sprites/sak/sprSawedOffSlugShotgun.png",3,1)//
a[? "auto slug shotgun"]      = sprite_add_weapon("sprites/sak/sprAutoSlugShotgun.png",3,0)//
a[? "assault slug shotgun"]   = sprite_add_weapon("sprites/sak/sprAssaultSlugShotgun.png",5,1)//
a[? "hyper slug shotgun"]     = sprite_add_weapon("sprites/sak/sprHyperSlugShotgun.png",5,3)//

a[? "slug eraser"] 				 = sprite_add_weapon("sprites/sak/sprSlugEraser.png",3,2)//
a[? "auto slug eraser"] 	 = sprite_add_weapon("sprites/sak/sprAutoSlugEraser.png",2,1)//
a[? "assault slug eraser"] = sprite_add_weapon("sprites/sak/sprAssaultSlugEraser.png",6,2)//
a[? "hyper slug eraser"] 	 = sprite_add_weapon("sprites/sak/sprHyperSlugEraser.png",3,4)//
a[? "slug bird"] 	 				 = sprite_add_weapon("sprites/sak/sprSlugBird.png",7,4)//
a[? "slug wave gun"] 	 		 = sprite_add_weapon("sprites/sak/sprSlugWaveGun.png",5,5)//

a[? "slug flak cannon"] 	 		= sprite_add_weapon("sprites/sak/sprSlugFlakCannon.png",4,3)//
a[? "super slug flak cannon"] = sprite_add_weapon("sprites/sak/sprSuperSlugFlakCannon.png",4,3)//
a[? "auto slug flak cannon"] 	= sprite_add_weapon("sprites/sak/sprAutoSlugFlakCannon.png",6,3)//
a[? "hyper slug flak cannon"] = sprite_add_weapon("sprites/sak/sprHyperSlugFlakCannon.png",4,2)//

a[? "super slugger"]   = sprSuperSlugger
a[? "gatling slugger"] = sprGatlingSlugger
a[? "assault slugger"] = sprAssaultSlugger
a[? "hyper slugger"]   = sprHyperSlugger
a[? "slugger"] 			   = sprSlugger

a[? "slug shot cannon"]   		 = sprite_add_weapon("sprites/sak/sprSlugShotCannon.png",5,3)//
a[? "super slug shot cannon"]  = sprite_add_weapon("sprites/sak/sprSuperSlugShotCannon.png",6,4)//
a[? "auto slug shot cannon"]   = sprite_add_weapon("sprites/sak/sprAutoSlugShotCannon.png",5,2)//
a[? "hyper slug shot cannon"]  = sprite_add_weapon("sprites/sak/sprHyperShotCannon.png",4,4)//


///HEAVY SLUGS///
a[? "heavy slug shotgun"] 				  = sprite_add_weapon("sprites/sak/sprHeavySlugShotgun.png",3,2)//
a[? "double heavy slug shotgun"] 		= sprite_add_weapon("sprites/sak/sprHeavyDoubleSlugShotgun.png",3,5)//
a[? "sawed-off heavy slug shotgun"] = sprite_add_weapon("sprites/sak/sprHeavySawedOffSlugShotgun.png",3,5)//
a[? "auto heavy slug shotgun"]      = sprite_add_weapon("sprites/sak/sprHeavyAutoSlugShotgun.png",3,1)//
a[? "assault heavy slug shotgun"]   = sprite_add_weapon("sprites/sak/sprHeavyAssaultSlugShotgun.png",5,1)//
a[? "hyper heavy slug shotgun"]     = sprite_add_weapon("sprites/sak/sprHeavyHyperSlugShotgun.png",6,4)//

a[? "heavy slug eraser"] 				 = sprite_add_weapon("sprites/sak/sprHeavySlugEraser.png",3,2)//
a[? "auto heavy slug eraser"] 	 = sprite_add_weapon("sprites/sak/sprHeavyAutoSlugEraser.png",7,3)//
a[? "assault heavy slug eraser"] = sprite_add_weapon("sprites/sak/sprHeavyAssaultSlugEraser.png",6,2)//
a[? "hyper heavy slug eraser"] 	 = sprite_add_weapon("sprites/sak/sprHeavyHyperSlugEraser.png",3,5)//
a[? "heavy slug bird"] 	 				 = sprite_add_weapon("sprites/sak/sprHeavySlugBird.png",7,4)//
a[? "heavy slug wave gun"] 	 		 = sprite_add_weapon("sprites/sak/sprHeavySlugWaveGun.png",5,5)//

a[? "heavy slug flak cannon"] 	 		= sprite_add_weapon("sprites/sak/sprHeavySlugFlakCannon.png",4,3)//
a[? "super heavy slug flak cannon"] = sprite_add_weapon("sprites/sak/sprHeavySuperSlugFlakCannon.png",4,5)//
a[? "auto heavy slug flak cannon"] 	= sprite_add_weapon("sprites/sak/sprHeavyAutoSlugFlakCannon.png",6,3)//
a[? "hyper heavy slug flak cannon"] = sprite_add_weapon("sprites/sak/sprHeavyHyperSlugFlakCannon.png",4,4)//

a[? "super heavy slugger"]   = sprite_add_weapon("sprites/sak/sprHeavySuperSlugger.png",5,4)//
a[? "gatling heavy slugger"] = sprite_add_weapon("sprites/sak/sprHeavyGatlingSlugger.png",5,3)//
a[? "assault heavy slugger"] = sprite_add_weapon("sprites/sak/sprHeavyAssaultSlugger.png",5,2)//
a[? "hyper heavy slugger"]   = sprite_add_weapon("sprites/sak/sprHeavyHyperSlugger.png",3,5)//
a[? "heavy slugger"] 			   = sprHeavySlugger

a[? "heavy slug shot cannon"]   		 = sprite_add_weapon("sprites/sak/sprHeavySlugShotCannon.png",5,4)//
a[? "super heavy slug shot cannon"]  = sprite_add_weapon("sprites/sak/sprHeavySuperSlugShotCannon.png",6,4)
a[? "auto heavy slug shot cannon"]   = sprite_add_weapon("sprites/sak/sprHeavyAutoSlugShotCannon.png",5,3)//
a[? "hyper heavy slug shot cannon"]  = sprite_add_weapon("sprites/sak/sprHeavyHyperSlugShotCannon.png",10,5)//

///SPLIT SLUGS///
a[? "split slug shotgun"] 				  = sprite_add_weapon("sprites/sak/sprSplitSlugShotgun.png",3,2)//
a[? "double split slug shotgun"] 		= sprite_add_weapon("sprites/sak/sprDoubleSplitSlugShotgun.png",3,3)//
a[? "sawed-off split slug shotgun"] = sprite_add_weapon("sprites/sak/sprSawedOffSplitSlugShotgun.png",3,3)//
a[? "auto split slug shotgun"]      = sprite_add_weapon("sprites/sak/sprAutoSplitSlugShotgun.png",4,2)//
a[? "assault split slug shotgun"]   = sprite_add_weapon("sprites/sak/sprAssaultSplitSlugShotgun.png",3,2)//
a[? "hyper split slug shotgun"]     = sprite_add_weapon("sprites/sak/sprHyperSplitSlugShotgun.png",3,4)//

a[? "split slug eraser"] 				 = sprite_add_weapon("sprites/sak/sprSplitSlugEraser.png",6,2)//
a[? "auto split slug eraser"] 	 = sprite_add_weapon("sprites/sak/sprAutoSplitSlugEraser.png",6,2)//
a[? "assault split slug eraser"] = sprite_add_weapon("sprites/sak/sprAssaultSplitSlugEraser.png",4,2)//
a[? "hyper split slug eraser"] 	 = sprite_add_weapon("sprites/sak/sprHyperSplitSlugEraser.png",7,4)//
a[? "split slug bird"] 	 				 = sprite_add_weapon("sprites/sak/sprSplitSlugBird.png",7,4)//
a[? "split slug wave gun"] 	 		 = sprite_add_weapon("sprites/sak/sprSplitSlugWaveGun.png",5,5)//

a[? "split slug flak cannon"] 	 		= sprite_add_weapon("sprites/sak/sprSplitSlugFlakCannon.png",5,2)//
a[? "super split slug flak cannon"] = sprite_add_weapon("sprites/sak/sprSuperSplitSlugFlakCannon.png",5,4)//
a[? "auto split slug flak cannon"] 	= sprite_add_weapon("sprites/sak/sprAutoSplitSlugFlakCannon.png",4,3)//
a[? "hyper split slug flak cannon"] = sprite_add_weapon("sprites/sak/sprHyperSplitSlugFlakCannon.png",4,3)//

a[? "super split slugger"]   = sprite_add_weapon("sprites/sak/sprSuperSplitSlugger.png",5,4)//
a[? "gatling split slugger"] = sprite_add_weapon("sprites/sak/sprGatlingSplitSlugger.png",0,2)//
a[? "assault split slugger"] = sprite_add_weapon("sprites/sak/sprAssaultSplitSlugger.png",5,2)//
a[? "hyper split slugger"]   = sprite_add_weapon("sprites/sak/sprHyperSplitSlugger.png",3,4)//
a[? "split slugger"] 			   = sprite_add_weapon("sprites/sak/sprSplitSlugger.png",1,2)//

a[? "split slug shot cannon"]   		 = sprite_add_weapon("sprites/sak/sprSplitSlugShotCannon.png",5,3)//
a[? "super split slug shot cannon"]  = sprite_add_weapon("sprites/sak/sprSuperSplitSlugShotCannon.png",6,4)//
a[? "auto split slug shot cannon"]   = sprite_add_weapon("sprites/sak/sprAutoSplitSlugShotCannon.png",5,3)//
a[? "hyper split slug shot cannon"]  = sprite_add_weapon("sprites/sak/sprHyperSplitSlugShotCannon.png",4,5)//

#define cleanup
ds_map_destroy(global.textmap)
ds_map_destroy(global.choicemap)
ds_map_destroy(global.stats)
ds_map_destroy(global.gunmap)

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
a[? "auto"] = "shoot fast, eat ass"
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
var a = global.stats

//[ammo, reload, sound, rads]
//based off of firing a shotgun of said type (the cost of 7 projectiles)
a[? "shell"] = [1, 1, sndShotgun, 0]
a[? "slug"] = [7, 2, sndSlugger, 0]
a[? "heavy slug"] = [13, 1.8, sndHeavySlugger, 0]
a[? "flame shell"] = [1, 1.2, sndFireShotgun, 0]
a[? "ultra shell"] = [3, .7, sndUltraShotgun, 9]
a[? "psy shell"] = [2, 1.3, sndShotgun, 0]
a[? "split shell"] = [2, 1.2, sndShotgun, 0]
a[? "split slug"] = [4, 1.5, sndSlugger, 0]

//[ammo, reload base, sound]
a[? "shotgun"] = [1, 17, sndShotgun]
a[? "eraser"] = [2, 20, sndEraser]
a[? "flak cannon"] = [2, 26, sndFlakCannon]
a[? "pop gun"] = [1, 2, sndPopgun]
a[? "slugger"] = [1/6, 11, sndSlugger]
a[? "shot cannon"] = [4, 25, sndFlakCannon]

//[ammo, reload, sound]
a[? "double"] = [2, 1.6, sndDoubleShotgun]
a[? "sawed-off"] = [2, 1.6, sndSawedOffShotgun]
a[? "auto"] = [1, .4, sndPopgun]
a[? "assault"] = [3, 2, -1]
a[? "hyper"] = [1, 1, sndHyperSlugger]
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
					sound_play(w.sounds[i])
				}
				weapon_post(w.ammo * 2,w.ammo,w.ammo)
				mod_script_call_self("weapon",mod_current,string_replace(w.info[2]," ","_"),w.info[1],w.info[3])
				if w.time wait(w.time)
			}
			exit
		}
	}
}else{
	wep = wep_shotgun
	player_fire()
	wep = w
}

#define pop_gun(p,m)
switch m{
	case "triple":
		for (var i = -1; i<= 1; i++){
			with proj(p){
				fset(23,3,i,1)
				if "stockspeed" in self speed = stockspeed
			}
		}
		break
	case "rifle":
	    with proj(p){
	        set(8)
            if "stockspeed" in self speed = stockspeed
	    }
	    break
	default:
		with proj(p){
			set(4)
			if "stockspeed" in self speed = stockspeed
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
					with proj(p){
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
				with proj(p){
					direction = other.gunangle + 15*sin(i) *other.accuracy;
					image_angle = direction
					creator = other
					team = other.team
					if "stockspeed" in self speed = stockspeed
				}
				with proj(p){
					direction = other.gunangle - 15*sin(i) *other.accuracy;
					image_angle = direction
					creator = other
					team = other.team
					if "stockspeed" in self speed = stockspeed
				}
				wait(1)
			}
			exit
		}
		break
	case "auto":
		repeat(15){
			with proj(p){
				set(1)
				speed += random_range(-2,2)
			}
		}
		break
	default:
		repeat(17){
			with proj(p){
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
			with proj(p) {
				fset(12,3,i,1)
			}
		}
		break
	default:
		with proj(p){
			set(5)
			if m = "hyper" hyper_travel()
		}
		break
}

#define flak_cannon(p,m)
switch m{
	case "super":
	default:
		with flak(){
			payload = p
			set(3)
			speed = random_range(11,13)
			if m = "hyper"{
				hyper = 1
				hyper_travel()
			}
		}
}



#define shotgun(p,m)
switch m{
	case "double":
		repeat(14){
			with proj(p) {
				set(30)
				speed += random_range(-2,1)
			}
		}
		break
	case "sawed-off":
		repeat(20){
			with proj(p) {
				set(45)
				speed += random_range(-2,1)
			}
		}
		break
	default:
		repeat(7){
			with proj(p){
				set(20)
				if m = "hyper" hyper_travel()
				speed += random_range(-2,1)
			}
		}
		break
}

#define proj(thing)
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
		}
		return a
	case "heavy slug":
		with instance_create(x,y,HeavySlug){
			speed = 13
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
		with mod_script_call("mod", "defpack tools", "create_split_shell",x,y){
			speed = random_range(17,20)
			stockspeed = 19
			ammo = 3
			damage = 7
			falloff = 2
			return id
		}
}

#define flak
with instance_create(x,y,CustomProjectile){
	sprite_index = sprFlakBullet
	mask_index = mskFlakBullet
	on_destroy = flakpop
	on_step = flakstep
	damage = 8
	payload = "shell"
	friction = .4
	ammo = 14
	hyper = 0
	return id
}

#define flakstep
if speed < .01{
	instance_destroy()
}

#define flakpop
sound_play_hit(sndFlakExplode,.1)
if skill_get(mut_eagle_eyes){
	for var i = 0; i< 360; i+=360/ammo{
		with (proj(payload)){
			direction = i
			image_angle = i
			creator = other.creator
			team = other.team
			if other.hyper hyper_travel()
		}
	}
}
else{
	repeat(ammo){
		with proj(payload){
			direction = random(360)
			image_angle = direction
			creator = other.creator
			team = other.team
			if other.hyper hyper_travel()
		}
	}
}

#define super_flak
with instance_create(x,y,CustomProjectile){}



#define hyper_travel
x+=lengthdir_x(sprite_width-sprite_xoffset,direction)
y+=lengthdir_y(sprite_width-sprite_xoffset,direction)
damage = floor(damage*1.1)
var move = 1;
for(var i = 0;i<=100;i++){
	var xx = x+lengthdir_x(8 * i,direction), yy = y+lengthdir_y(8 * i,direction);
	var man = instance_place(xx,yy,hitme);
	if (instance_exists(man) && man.team != team) || place_meeting(xx,yy,Wall){
		var _x = x, _y = y;
		x += lengthdir_x(8 * i, direction);
		y += lengthdir_y(8 * i, direction);
		move = 0
		xprevious += lengthdir_x(8 * (i-1), direction);
		yprevious += lengthdir_y(8 * (i-1), direction);
		for(var o = 0;o <= i;o++){
			if !random(1) instance_create(_x + lengthdir_x(8 * o,direction) + random_range(-4,4), _y + lengthdir_y(8 * o,direction) + random_range(-4,4), Dust);
		}
		break;
	}
}
if move{
	x = xx
	y = yy
}
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
	    sprite(w)
	}
}
return global.box

#define weapon_text
return choose("Gunlocker, eat your heart out","essence of shell")

#define birdspread
with instances_matching_ne(projectile,"birdspeed",null){
	direction+=birdspeed * current_time_scale * speed
	image_angle = direction
}

#define step(q)
if button_pressed(index,"horn")&&q{
	wep = mod_current
}
if q && !is_object(wep){
	wep = {
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
}

#define stats(w)
var sts = global.stats;
w.load = floor(sts[? w.info[2]][1] * sts[? w.info[1]][1] * sts[? w.info[3]][1])
w.ammo = floor(sts[? w.info[2]][0] * sts[? w.info[1]][0] * sts[? w.info[3]][0])
w.rads = sts[? w.info[1]][3]
for (var i = 1; i<= 3; i++){
	array_push(w.sounds,sts[? w.info[i]][2])
	if mod_script_exists("weapon", mod_current, "take_"+string_replace(w.info[i]," ","_")) mod_script_call("weapon", mod_current, "take_"+string_replace(w.info[i]," ","_"),w)
}

//this thing is the distance between shit
#macro gx 22

#define makemycoolgun
draw_set_halign(0)
with Player if is_object(wep) && wep.wep = mod_current && !wep.done{
	var w = wep;
	var tex = global.textmap;
	var cho = global.choicemap;
	var width = array_length_1d(cho[? w.info[w.phase]]);
	var height = 50;
	var _x = view_xview[index]+game_width/2 - width*gx/2;
	var _y = view_yview[index] + 50;
	draw_set_color(make_color_rgb(47, 50, 56))
	draw_rectangle(_x,_y,_x + gx*width, _y + height,0)
	draw_set_color(make_color_rgb(9, 15, 25))
	draw_rectangle(_x+1,_y+5,_x + gx*width -1, _y + 25,0)
	draw_set_color(c_white)
	for (var i = 0; i< width; i++){
		var x1 = _x+gx*i + 2;
		var y1 = _y + 6;
		var x2 = _x+gx*(i+1) - 2;
		var y2 = y1 + 18;
		draw_sprite_ext(global.sprammo,i,x1,y1,1,1,0,c_gray,1)
		var push = button_pressed(index,"key"+string(i+1));
		if point_in_rectangle(mouse_x[index], mouse_y[index], x1, y1, x2, y2) || push{
			if !button_check(index, "fire"){
				draw_sprite(global.sprammo,i,x1,y1)
			}
			draw_set_font(fntSmall)
			var access = cho[? w.info[w.phase]][i]
			draw_text(_x+1,y2+3,access)
			draw_text_ext(_x+1,y2+9,tex[? access], 6, 22*width)
			if button_released(index, "fire") || push{
				sound_play(sndClick)
				w.info[++w.phase] = access
				w.numbers[w.phase-1] = i
				if w.phase = 3{
					w.done = 1;
					stats(w)
					name(w)
					sprite(w)
				}
			}
		}
	}
}
draw_set_halign(1)

#define sprite(w)
w.sprite = global.gunmap[? w.name]

#define make_gun_random
var w = {
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
var cho = global.choicemap;
for (var i = 0; i< 3; i+=0){
	var n = irandom(array_length_1d(cho[? w.info[i]]) -1);
	w.numbers[i] = n
	w.info[++i] = cho[? w.info[i-1]][n]
}
w.done = 1
stats(w)
name(w)
sprite(w)
return w

#define name(w)
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

#define weapon_reloaded
