# stat318

## NOTES
- Ultra Necrozma --> not in anything goes list but also... weird conditions
	- In order to use: must have Dusk Mane or Dawn Wings Necrozma hold Ultra-Necrozium Z and use Ultra Burst in battle.
- Zygarde --> complete forme is not in anything goes list, but 10% forme is
	- added 10% forme manually
- Lycanroc --> has three forms
	- manually added Dusk and Midnight form which are mentioned in anything goes list but not in pokemon stats list
		- Midnight has same stats as normal form
		- dusk form has different stats
- Ultra Beasts --> according to bulbapedia, they are NOT considered legendary pokemon --> should we just mark them as FALSE?		- Added new Ultra Beasts from UltraSun + UltraMoon --> Poipole, Naganadel, Stakataka, Blacephalon
- Marshadow --> new legendary Pokemon; manually added
- Zeraora --> not added bc not released yet


## NOTES FROM WENDY'S MEETING
- AIC has higher R^2 --> so use AIC (or use model with higher AIC)
- look at PRESS --> higher Predictvie power on independent obs. = better model
- make sure you dont compare response with transformed response --> must have same response but can compare different models

- use studentized residual and see patterns there!!!
- use "which" to find outliers !!!

- look at the characteristics in the second group in residual plot --> are they all legendary?

- remove pokemon with usage percentage = 0's

# QUESTIONS?
--> use aic to be less stringent at first, and then bic? when adding interaction terms?
--> pass the transformed fit or regular fit to step() for checking interaction terms?
--> is the slope similar enough? if not, how to check/plot when there are >1 predictor variable 

## TO DO
Model building process
1. Data collection and preparation
	- outliers (Cook's)
	- check assumptions about constant variance, constant slope(?), multicollinearity (independence)
2. Reduction of predictor variables
3. Model refinement and variable selection
	- boxcox?
	- interaction (DONE B-) )
4. Model validation
	- Cross validation
	- leave one out validation method thing?

PLAN:
	- multicollinearity (independence)
	[MODEL COMPARISON / VARIABLE SELECTION]
		- t-test?/partial f-test
	- outliers (Cook's)
	- (model diagnostics) check assumptions about constant variance, constant slope(?) (check residuals)
	- boxcox?
	- Cross validation
	- leave one out validation method thing?
Predicted power? vs significance 


MANUALLY CHANGED .csv & .txt FILES
- MATCH EACH OTHER IN POKÉMON NAMES & REPLACING EMPTY TYPE 2 VALUES WITH "NONE"
- REMOVED ALL % IN DATA, RENAMED COLUMNS HEADERS WITH ".PER" FOR RAW AND REAL
- RENAMED "#" TO "NUM"


**** WHAT TO DO? ****
DARMANITAN
  --> Original mode
  --> Zen mode (ability), different stats
MELOETTA
  --> Aria forme
  --> Piroutte forme (move), different stats
AEGISSLASH
  --> Blade forme
  --> Shield forme (move type), swap attack and defense

-- average stats
-- take higher stats
-- remove completely
-- two data points (with duplicated battle data)
  NOTE: would have to modify total number of battles

SPECIAL CASES:
MEGA/PRIMAL/AVERAGE (& other sizes)
	VenasaurMega
MEGAS X & Y (Charizard, Mewtwo)
	CharizardMegaX
FORMES (Deoxys, Shaymin, Tornadus, Thundurus, Landorus, Giritina)
  ShayminSky
  (note: DeoxysNormal)

SINGLE CASES:
ARCEUS (Others & Normal)  
NIDORAN F/M
PIKACHU-ORIGINAL
WORMADAM CLOAKS
	WormadamTrash
KYUREM BLACK/WHITE/none
ZYGARDE50%
ROTOM ___ ROTOM
collapse KELDEO from RESOLUTE & ORDINARY FORMES
collapse MEOWSTIC from MALE & FEMALE
FLABÉBÉ --> FLABEBE
HOOPA (remove second HOOPA), CONFINED/UNBOUND


IGNORE (do not modify, will not be accessed in dictionary):
PIKACHU (Original, Partner, Regions, etc.)
ALOLA (not in .csv)
GRENINJA ASH (not in .csv)


                                         ``,;''''';.                                     
                                    ,';;;;;;;;;;'+';;;;;                                 
                                 ;;;;;;;;;;;;;;;;;;;;;+;;;+                              
                              ,;;'+;;;;;;;;;;;;;;;;;;;;;;+;;'`                           
                            ';';;;;;;;'+;;;;;;;,```.';;;;;;';;'                          
                          ';';;;;;;+;;;;;:,.`````..``.`:.:;`:+;;,                        
                        ';;;;;;;+;;;.```````....```````;;;.```,;;+                       
                      ,;;;;;;;';,```.:;;;;;;;;;;;;;;;;,`.;;+:`;`;;'                      
                     ++;;;;;';``````,:;;;;;'''''''''';;;;;;;;;,;,`;'                     
                   `+;;;;;+;;;`,;;;'+'''''''''+++''''''''''';;;;;;`,'      ,'',          
                  .';;;;';;;.:,,';;;;;;;;;''''''''++'''''''''''';;;.`'    ''::+'         
                  +;+;;';;`;;+`;;;;;;''+'''''''''''''+'''''''''''';;:,`  :':`';''`       
                 +;;;;;;;;;'.;;;''+'::::.;'''''''''''''+``+'''''+''';;+  .''.''''        
                '';;';;;;'.;;''''::::::::`.+''''''''''+`````++'#'''''';  ,''''''+,       
               '';;+;;;;`;''''''::+::::::`,`+''''++'''`.:````:```+++'''  +''''''';       
              ':;;+;;;';'''''' :::::::::.``::  `+'''',`++,```````+'+,    ''''''''        
             +.;;+;;;:''''+   ;::;:::::.``::::    ;,:```','```'.`+.      +'''''''        
            ::;;+;;;''''+    '::::::::```:::::'    ;:``;':```::`+       ,''#''''         
           `'+;+;;;''''      :::::::.,``:::::::     +.;```````;`;      `''''++#`         
           +`;';;;'''+      '::::;:':``.`:::::::   '+:'`````;``'      `''''++            
          . ;;;;;''':       ``:::':;;:``::::::::`,.`.;,:`:,````.      ''''++`            
           :;';;+'',        .`:`;:+:+`::::+::':::````````.```.::     '''''+;             
           ;+;;+'',         `:``'+'+```:;::::;:::``````,,;,,`       '''''++              
          .;;;;'':         `::..``:```:`#;:;:::;',`````````+.    ' '''''++               
          +';;+'+          ':;::```'`;+,'::':;;;''```````,'''''''''''''++`               
          ;;;''+           ::;::.`+`,,`;''::;;;'',```````'''''''''+''''+'                
          ;;;+'            ':':';,'```````::;;';,````..`.'''''''''''''++                 
         .;;''+            ::':';,;`:.````:';`````;.,,,,,++''''''''''++                  
         ';;''            ;':::;;;``,.`,``,`````````,,,,;#++++++++++++,                  
         ';;++             ::::;+;'``:`.````;````````,:::``. .:''''';                    
         ';'+               ''+,'';;',``:````'````````:::::'                             
         ';'+          '    '';;;;'';'' ``````;```````.`;@@.                             
         ';''       '''''   +;;+;;.;;   ```````;```````#@@'                              
         ';'        +''''+  '';,';`,   ;,:``````````````,,;                              
         +;'        '''''' `+;'';``   ``````````,,,.`````,;                              
         :;'        ''''''  '';```;   ```````,,,+,.``````.                               
         `;'        +''''''`+#,,,;;  ,````.,,+,;::`````,``'                              
          ;'         ''''''''+++++' .````,,,,+`;:::````````.                             
          +';    '';'+''''''''''#+':```.,+:;;:``::.`.`;;````                             
          `;'   '   ;' '''''''''```````,:+++`+`:::`,`:```:```                            
           +':  :   ;;  :''''''.``````,,++'++,`:+''`;```,,.'`                            
            ''      .'    +''''``````,,,+,,+++:+:`:`'`++++',:                            
             +'.    +.     +'''``.```,,,+..,++;.`,:,+++++++:,'                           
              `++. ;:       #+',``,,,,,;+...;+`.,,.+++:,,++,,,`                          
                             ;++,,,,,,'++,`````,:'`++,,.,++::,,                          
                               +#+',,,`''`````:,'';.`;...++;,',:                         
                                 ',.```'``;:``:';'`````;.++:,,',                         
                                  :;:.'``:  :``''```````'++:,,,,                         
                                     ;:`:   '````````````++:,,,;;                        
                                      ``    :;```````````++:`,,:,                        
                                      ``:   ::````````````:```,;,                        
                                      ,``   ::``````:+,#````,``+:                        
                                      ,``;  `.`````+```````:::::;;.                      
                                    :;,``.````````````````````+++                        
                                :.  ;```:``````````````````.`'+++'                       
                                  ,``````;,,,,```````.````.''''+++'',                    
                             ,``:`````````,::````;```````::;'''+++''''+                  
                      .:,````````````````.,`:`````,;;``.,#''':''++'''''''                
                    ````````````````````:`````.;:``.,;;   '''''+#++''''''''              
                 ;````..```````````````.````';``....```   .''::::+++'''''''''            
             .+'',```,,`````````````````:`````.````````;   ';:''::#+++''''''''+          
          +''''',```,,,```````````````.,,;``:``;`````'``   ':'::':++++++''''''+'''       
         '''''''```,,,,.```````````.,,,,;````.``:````.``,  ::;::':#++++++'''''+'''''.    
     `+'''''''''``,,,,,,,,,,,,,,,,,,,;+  ```.`````````;`.  ;':::;:++  ;++++'''+''''''';  
  .'+'''+'''''''..,,,,,,,,,,,,,,,,,+'+   ```,```,````` ``  '''+'::++     ,++++++'''''''+
 +'''+'+#'''''''+,,,,,,,,,,,,''''''++'   .```',;``````,``  '''+::+++`      ++;#+++''''''.
 '''''++++''''+++++,,';:;:`   :''++'`     .``;'...```````'++:'::+'+++           ;++++''''
;''''++++++++':.``                        .```; ,''..````..```:''+++#             `#++'''
 '''++++.                              `''.````'   :;,```.'+''''++#+.               `++'
 `'++#                              `':':;::```.   ':````  ;+'+#+':                      
                                    :':;::;'+'.      ';``                                
                                    `';:;'.           ;:                                 
