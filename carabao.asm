.model small
.stack 100h

.data
    ;Leaderboard Page
    strLeadTest db "LEADERBOARD HERE!!!",13,10
    strLeadTest_length equ $ - strLeadTest

    ;Instruction Page
    strInstructionTitle1 db "               ### #   #  ### ### ###  # # ### ### ###  ##  #   #                ",13,10
    strInstructionTitle1_length equ $ - strInstructionTitle1

    strInstructionTitle2 db "                #  ##  # #     #  #  # # # #    #   #  #  # ##  #                ",13,10
    strInstructionTitle2_length equ $ - strInstructionTitle2

    strInstructionTitle3 db "                #  # # #  ##   #  ###  # # #    #   #  #  # # # #                ",13,10
    strInstructionTitle3_length equ $ - strInstructionTitle3

    strInstructionTitle4 db "                #  #  ##    #  #  # #  # # #    #   #  #  # #  ##                ",13,10
    strInstructionTitle4_length equ $ - strInstructionTitle4

    strInstructionTitle5 db "               ### #   # ###   #  #  # ### ###  #  ###  ##  #   #                ",13,10
    strInstructionTitle5_length equ $ - strInstructionTitle5

    strInstructionLine1 db "Welcome to Carabao Crossing! In this game, you take on the role of a",13,10
    strInstructionLine1_length equ $ - strInstructionLine1

    strInstructionLine2 db "carabao attempting to navigate accross a river while avoiding obstacles.",13,10
    strInstructionLine2_length equ $ - strInstructionLine2

    strInstructionLine3 db "Here's how to play:",13,10
    strInstructionLine3_length equ $ - strInstructionLine3

    strInstructionLine4 db "Objective:",13,10
    strInstructionLine4_length equ $ - strInstructionLine4

    strInstructionLine5 db "Your goal is to safely guide the carabao accross the river and gain",13,10
    strInstructionLine5_length equ $ - strInstructionLine5

    strInstructionLine6 db "points. Each successful river crossing earns you one point. The game ends",13,10
    strInstructionLine6_length equ $ - strInstructionLine6

    strInstructionLine7 db "if the carabao collides with an obstacle.",13,10
    strInstructionLine7_length equ $ - strInstructionLine7

    strInstructionLine8 db "Controls:",13,10
    strInstructionLine8_length equ $ - strInstructionLine8

    strInstructionLine9 db "Use the arrow keys to move the carabao:",13,10
    strInstructionLine9_length equ $ - strInstructionLine9

    strInstructionLine10 db "Press the UP arrow key to move forward.",13,10
    strInstructionLine10_length equ $ - strInstructionLine10

    strInstructionLine11 db "Press the DOWN arrow key to move backward.",13,10
    strInstructionLine11_length equ $ - strInstructionLine11

    strInstructionLine12 db "Press the LEFT arrow key to move left.",13,10
    strInstructionLine12_length equ $ - strInstructionLine12

    strInstructionLine13 db "Press the RIGHT arrow key to move right.",13,10
    strInstructionLine13_length equ $ - strInstructionLine13

    strInstructionLine14 db "Scoring:",13,10
    strInstructionLine14_length equ $ - strInstructionLine14

    strInstructionLine15 db "Successfully crossing the river without hitting any obstacles earns",13,10
    strInstructionLine15_length equ $ - strInstructionLine15

    strInstructionLine16 db "you one point.The game ends if the carabao collides with logs or bees.",13,10
    strInstructionLine16_length equ $ - strInstructionLine16

    strInvalidResponse db "INVALID RESPONSE!!!",13,10
    strInvalidResponse_length equ $ - strInvalidResponse


    cellsCount equ 2080             ; total number of cells in the game grid
    backgroundColor equ 02h         ; background color
    playerColor equ 7               ; player color (carabao)
    playerPosition dw  3920         ; player's starting position in the game
    obstaclePosition dw  390, 780, 1010, 1240, 1310, 1700, 1930, 2160, 2390, 2620, 2850, 3080, 3310, 3540, 3770         ; obstacle position
    logPosition dw       390, 780, 1010, 1240, 1310, 1700, 1930, 2160, 2390, 2620, 2850, 3080, 3310, 3540, 3770         ; log position
    obstacleMovement dw -8, 6, 8, -4, 4, 4, -4, -4, 2, 6, -4, -4, 8, 2, 2                                               ; direction of each obstacle
    obtacleLowLimits dw  320, 640, 960, 1120, 1280, 1600, 1920, 2080, 2240, 2560, 2720, 3040, 3200, 3520, 3680          
    obstacleHighLimits dw  476, 796, 1116, 1276, 1436, 1756, 2076, 2236, 2396, 2716, 2876, 3196, 3356, 3676, 3836       
    currentDeciSec db ?             
    currentSec db ?                 
    gameScore db 0                  
    playerHitLog db 0               
    playerPress db ?                
    waterPosition db 0              ; position of the water
    MilliSecSpeed db 6              
    lastFourMultipleScore db 0      
    collisionDetected db 0          ; used to detect collisions when the player moves
    text_main_menu_title DB 00h, 00h, 0fh, 0fh, 04h ;MAIN MENU Text_Main_Menu_Title
    text_main_menu_playgame DB 'Press P to Play', '$' ;Press P To Start 
    text_main_menu_instruction DB 'Press I for Instruction', '$' ; I for INSTRUCTION
    text_main_menu_exit DB 'Press E to Exit:', '$' ; E FOR TANGINA

    ;imagewidth EQU 320
    ;imageheight EQU 200
    ;menuimage DB 'trydesign.bin', 0
    ;imagedata DB imageheight * imagewidth dup(0)

    current_screen DB 0	;Index for current scene(0 - MAIN MENU, 1 - GAME)

.code
    main_menu_page:
	    call cls
        
        MOV AX, 0B800h
        MOV ES, AX
	    ;159 yung pinaka right 
	
	    ;Row 3 
		;C
        mov es:[350], BYTE PTR 220   ; Draw a solid block
        mov es:[351], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[352], BYTE PTR 220   ; Draw a solid block
        mov es:[353], BYTE PTR 1h  ; Set the color to cyan gray
        mov es:[354], BYTE PTR 220   ; Draw a solid block
        mov es:[355], BYTE PTR 1h  ; Set the color to cyan gray
        mov es:[356], BYTE PTR 220   ; Draw a solid block
        mov es:[357], BYTE PTR 1h  ; Set the color to cyan gray
	
		;B
        mov es:[410], BYTE PTR 220   ; Draw a solid block
        mov es:[411], BYTE PTR 1h  ; Set the color to cyan gray
        mov es:[412], BYTE PTR 220   ; Draw a solid block
        mov es:[413], BYTE PTR 1h  ; Set the color to cyan gray
	
        ;Row4 WHITE
        ;C
        mov es:[506], BYTE PTR 220   ; Draw a solid block
        mov es:[507], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[508], BYTE PTR 220   ; Draw a solid block
        mov es:[509], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[510], BYTE PTR 220   ; Draw a solid block
        mov es:[511], BYTE PTR 10h  ; Set the color to cyan gray
        mov es:[516], BYTE PTR 220   ; Draw a solid block
        mov es:[517], BYTE PTR 10h  ; Set the color to cyan gray
        mov es:[518], BYTE PTR 220   ; Draw a solid block
        mov es:[519], BYTE PTR 10h  ; Set the color to cyan gray
	
        ;A 
        mov es:[524], BYTE PTR 220   ; Draw a solid block
        mov es:[525], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[526], BYTE PTR 220   ; Draw a solid block
        mov es:[527], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[528], BYTE PTR 220   ; Draw a solid block
        mov es:[529], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[530], BYTE PTR 220   ; Draw a solid block
        mov es:[531], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[532], BYTE PTR 220   ; Draw a solid block
        mov es:[533], BYTE PTR 01h  ; Set the color to cyan gray
	
        ;R 
        mov es:[540], BYTE PTR 220   ; Draw a solid block
        mov es:[541], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[542], BYTE PTR 220   ; Draw a solid block
        mov es:[543], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[546], BYTE PTR 220   ; Draw a solid block
        mov es:[547], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[548], BYTE PTR 220   ; Draw a solid block
        mov es:[549], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[550], BYTE PTR 220   ; Draw a solid block
        mov es:[551], BYTE PTR 01h  ; Set the color to cyan gray
	
		;A 
        mov es:[556], BYTE PTR 220   ; Draw a solid block
        mov es:[557], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[558], BYTE PTR 220   ; Draw a solid block
        mov es:[559], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[560], BYTE PTR 220   ; Draw a solid block
        mov es:[561], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[562], BYTE PTR 220   ; Draw a solid block
        mov es:[563], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[564], BYTE PTR 220   ; Draw a solid block
        mov es:[565], BYTE PTR 01h  ; Set the color to cyan gray
	
        ;B 
        mov es:[570], BYTE PTR 220   ; Draw a solid block
        mov es:[571], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[572], BYTE PTR 220   ; Draw a solid block
        mov es:[573], BYTE PTR 11h  ; Set the color to cyan gray
	
		;A 
        mov es:[586], BYTE PTR 220   ; Draw a solid block
        mov es:[587], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[588], BYTE PTR 220   ; Draw a solid block
        mov es:[589], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[590], BYTE PTR 220   ; Draw a solid block
        mov es:[591], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[592], BYTE PTR 220   ; Draw a solid block
        mov es:[593], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[594], BYTE PTR 220   ; Draw a solid block
        mov es:[595], BYTE PTR 01h  ; Set the color to cyan gray
	
		;O 
        mov es:[560], BYTE PTR 220   ; Draw a solid block
        mov es:[561], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[602], BYTE PTR 220   ; Draw a solid block
        mov es:[603], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[604], BYTE PTR 220   ; Draw a solid block
        mov es:[605], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[606], BYTE PTR 220   ; Draw a solid block
        mov es:[607], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[608], BYTE PTR 220   ; Draw a solid block
        mov es:[609], BYTE PTR 01h  ; Set the color to cyan gray
	
	
        ;Row 5 BLUE
        mov es:[666], BYTE PTR 220   ; Draw a solid block
        mov es:[667], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[668], BYTE PTR 220   ; Draw a solid block
        mov es:[669], BYTE PTR 11h  ; Set the color to cyan gray
	
        ;A 
        mov es:[684], BYTE PTR 220   ; Draw a solid block
        mov es:[685], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[686], BYTE PTR 220   ; Draw a solid block
        mov es:[687], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[688], BYTE PTR 220   ; Draw a solid block
        mov es:[689], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[690], BYTE PTR 220   ; Draw a solid block
        mov es:[691], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[692], BYTE PTR 220   ; Draw a solid block
        mov es:[693], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[694], BYTE PTR 220   ; Draw a solid block
        mov es:[695], BYTE PTR 11h  ; Set the color to cyan gray
	
        ;R 
        mov es:[700], BYTE PTR 220   ; Draw a solid block
        mov es:[701], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[702], BYTE PTR 220   ; Draw a solid block
        mov es:[703], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[704], BYTE PTR 220   ; Draw a solid block
        mov es:[705], BYTE PTR 10h  ; Set the color to cyan gray
	
		;A 
        mov es:[716], BYTE PTR 220   ; Draw a solid block
        mov es:[717], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[718], BYTE PTR 220   ; Draw a solid block
        mov es:[719], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[720], BYTE PTR 220   ; Draw a solid block
        mov es:[721], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[722], BYTE PTR 220   ; Draw a solid block
        mov es:[723], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[724], BYTE PTR 220   ; Draw a solid block
        mov es:[725], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[726], BYTE PTR 220   ; Draw a solid block
        mov es:[727], BYTE PTR 11h  ; Set the color to cyan gray
	
        ;B 
        mov es:[730], BYTE PTR 220   ; Draw a solid block
        mov es:[731], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[732], BYTE PTR 220   ; Draw a solid block
        mov es:[733], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[734], BYTE PTR 220   ; Draw a solid block
        mov es:[735], BYTE PTR 10h  ; Set the color to cyan gray
        mov es:[736], BYTE PTR 220   ; Draw a solid block
        mov es:[737], BYTE PTR 10h  ; Set the color to cyan gray
        mov es:[738], BYTE PTR 220   ; Draw a solid block
        mov es:[739], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[740], BYTE PTR 220   ; Draw a solid block
        mov es:[741], BYTE PTR 01h  ; Set the color to cyan gray
	
        ;A 
        mov es:[746], BYTE PTR 220   ; Draw a solid block
        mov es:[747], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[748], BYTE PTR 220   ; Draw a solid block
        mov es:[749], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[750], BYTE PTR 220   ; Draw a solid block
        mov es:[751], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[752], BYTE PTR 220   ; Draw a solid block
        mov es:[753], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[754], BYTE PTR 220   ; Draw a solid block
        mov es:[755], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[756], BYTE PTR 220   ; Draw a solid block
        mov es:[757], BYTE PTR 11h  ; Set the color to cyan gray
        
		;O 
        mov es:[760], BYTE PTR 220   ; Draw a solid block
        mov es:[761], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[762], BYTE PTR 220   ; Draw a solid block
        mov es:[763], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[768], BYTE PTR 220   ; Draw a solid block
        mov es:[769], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[770], BYTE PTR 220   ; Draw a solid block
        mov es:[771], BYTE PTR 11h  ; Set the color to cyan gray
	
	    ;Row 6 
		;C 
        mov es:[826], BYTE PTR 220   ; Draw a solid block
        mov es:[827], BYTE PTR 10h  ; Set the color to cyan gray
        mov es:[828], BYTE PTR 220   ; Draw a solid block
        mov es:[829], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[830], BYTE PTR 220   ; Draw a solid block
        mov es:[831], BYTE PTR 01h  ; Set the color to cyan gray
        
        mov es:[836], BYTE PTR 220   ; Draw a solid block
        mov es:[837], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[838], BYTE PTR 220   ; Draw a solid block
        mov es:[839], BYTE PTR 01h  ; Set the color to cyan gray
	
		;A 
        mov es:[842], BYTE PTR 220   ; Draw a solid block
        mov es:[843], BYTE PTR 10h  ; Set the color to cyan gray
        mov es:[844], BYTE PTR 220   ; Draw a solid block
        mov es:[845], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[846], BYTE PTR 220   ; Draw a solid block
        mov es:[847], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[848], BYTE PTR 220   ; Draw a solid block
        mov es:[849], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[850], BYTE PTR 220   ; Draw a solid block
        mov es:[851], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[852], BYTE PTR 220   ; Draw a solid block
        mov es:[853], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[854], BYTE PTR 220   ; Draw a solid block
        mov es:[855], BYTE PTR 11h  ; Set the color to cyan gray
	
		;R 
        mov es:[860], BYTE PTR 220   ; Draw a solid block
        mov es:[861], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[862], BYTE PTR 220   ; Draw a solid block
        mov es:[863], BYTE PTR 11h  ; Set the color to cyan gray
	
		;A 
        mov es:[874], BYTE PTR 220   ; Draw a solid block
        mov es:[875], BYTE PTR 10h  ; Set the color to cyan gray
        mov es:[876], BYTE PTR 220   ; Draw a solid block
        mov es:[877], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[878], BYTE PTR 220   ; Draw a solid block
        mov es:[879], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[880], BYTE PTR 220   ; Draw a solid block
        mov es:[881], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[882], BYTE PTR 220   ; Draw a solid block
        mov es:[883], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[884], BYTE PTR 220   ; Draw a solid block
        mov es:[885], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[886], BYTE PTR 220   ; Draw a solid block
        mov es:[887], BYTE PTR 11h  ; Set the color to cyan gray
	
        ;B 
        mov es:[890], BYTE PTR 220   ; Draw a solid block
        mov es:[891], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[892], BYTE PTR 220   ; Draw a solid block
        mov es:[893], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[894], BYTE PTR 220   ; Draw a solid block
        mov es:[895], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[896], BYTE PTR 220   ; Draw a solid block
        mov es:[897], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[898], BYTE PTR 220   ; Draw a solid block
        mov es:[899], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[900], BYTE PTR 220   ; Draw a solid block
        mov es:[901], BYTE PTR 10h  ; Set the color to cyan gray
        
        ;A 
        mov es:[904], BYTE PTR 220   ; Draw a solid block
        mov es:[905], BYTE PTR 10h  ; Set the color to cyan gray
        mov es:[906], BYTE PTR 220   ; Draw a solid block
        mov es:[907], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[908], BYTE PTR 220   ; Draw a solid block
        mov es:[909], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[910], BYTE PTR 220   ; Draw a solid block
        mov es:[911], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[912], BYTE PTR 220   ; Draw a solid block
        mov es:[913], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[914], BYTE PTR 220   ; Draw a solid block
        mov es:[915], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[916], BYTE PTR 220   ; Draw a solid block
        mov es:[917], BYTE PTR 11h  ; Set the color to cyan gray
        
        ;O 
        mov es:[920], BYTE PTR 220   ; Draw a solid block
        mov es:[921], BYTE PTR 10h  ; Set the color to cyan gray
        mov es:[922], BYTE PTR 220   ; Draw a solid block
        mov es:[923], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[924], BYTE PTR 220   ; Draw a solid block
        mov es:[925], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[926], BYTE PTR 220   ; Draw a solid block
        mov es:[927], BYTE PTR 01h  ; Set the color to cyan gray
        mov es:[928], BYTE PTR 220   ; Draw a solid block
        mov es:[929], BYTE PTR 11h  ; Set the color to cyan gray
        mov es:[930], BYTE PTR 220   ; Draw a solid block
        mov es:[931], BYTE PTR 10h  ; Set the color to cyan gray
        
        ;Row 7 
        ;C
        mov es:[990], BYTE PTR 220   ; Draw a solid block
        mov es:[991], BYTE PTR 10h  ; Set the color to cyan gray
        mov es:[992], BYTE PTR 220   ; Draw a solid block
        mov es:[993], BYTE PTR 10h  ; Set the color to cyan gray
        mov es:[994], BYTE PTR 220   ; Draw a solid block
        mov es:[995], BYTE PTR 10h  ; Set the color to cyan gray
        mov es:[996], BYTE PTR 220   ; Draw a solid block
        mov es:[997], BYTE PTR 10h  ; Set the color to cyan gray
        
        ;B 
        ;Row 8
        ;C
        mov es:[1160], BYTE PTR 220   ; Draw a solid block
        mov es:[1161], BYTE PTR 0Eh  ;
        mov es:[1162], BYTE PTR 223   ; Draw a solid block
        mov es:[1163], BYTE PTR 0Eh  ; 
        mov es:[1164], BYTE PTR 223   ; Draw a solid block
        mov es:[1165], BYTE PTR 0Eh  ; 
        mov es:[1166], BYTE PTR 220   ; Draw a solid block
        mov es:[1167], BYTE PTR 0Eh  ; 
	
		;R 
        mov es:[1170], BYTE PTR 220   ; Draw a solid block
        mov es:[1171], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1174], BYTE PTR 220   ; Draw a solid block
        mov es:[1175], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1176], BYTE PTR 220   ; Draw a solid block
        mov es:[1177], BYTE PTR 0Eh  ; Set the color to cyan gray
	
		;o 
        mov es:[1182], BYTE PTR 220   ; Draw a solid block
        mov es:[1183], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1184], BYTE PTR 220   ; Draw a solid block
        mov es:[1185], BYTE PTR 0Eh  ; Set the color to cyan gray
	
		;s
        mov es:[1192], BYTE PTR 220   ; Draw a solid block
        mov es:[1193], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1194], BYTE PTR 220   ; Draw a solid block
        mov es:[1195], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1196], BYTE PTR 220   ; Draw a solid block
        mov es:[1197], BYTE PTR 0Eh  ; Set the color to cyan gray
	
		;s
        mov es:[1202], BYTE PTR 220   ; Draw a solid block
        mov es:[1203], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1204], BYTE PTR 220   ; Draw a solid block
        mov es:[1205], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1206], BYTE PTR 220   ; Draw a solid block
        mov es:[1207], BYTE PTR 0Eh  ; Set the color to cyan gray
	
		;i
        mov es:[1210], BYTE PTR 220   ; Draw a solid block
        mov es:[1211], BYTE PTR 0Eh  ; Set the color to cyan gray
	
		;n 
        mov es:[1216], BYTE PTR 220   ; Draw a solid block
        mov es:[1217], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1218], BYTE PTR 220   ; Draw a solid block
        mov es:[1219], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1220], BYTE PTR 220   ; Draw a solid block
        mov es:[1221], BYTE PTR 0Eh  ; Set the color to cyan gray
	
		;g 
        mov es:[1228], BYTE PTR 220   ; Draw a solid block
        mov es:[1229], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1230], BYTE PTR 220   ; Draw a solid block
        mov es:[1231], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1232], BYTE PTR 220   ; Draw a solid block
        mov es:[1233], BYTE PTR 0Eh  ; Set the color to cyan gray
	
	    ;Row 9
		;C 
        mov es:[1320], BYTE PTR 219   ; Draw a solid block
        mov es:[1321], BYTE PTR 0Eh  ; Set the color to cyan gray
	
        ;r 
        mov es:[1330], BYTE PTR 219   ; Draw a solid block
        mov es:[1331], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1332], BYTE PTR 223   ; Draw a solid block
        mov es:[1333], BYTE PTR 0Eh  ; Set the color to cyan gray
	
		;o
        mov es:[1340], BYTE PTR 219   ; Draw a solid block
        mov es:[1341], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1346], BYTE PTR 219   ; Draw a solid block
        mov es:[1347], BYTE PTR 0Eh  ; Set the color to cyan gray
	
		;s
        mov es:[1350], BYTE PTR 223   ; Draw a solid block
        mov es:[1351], BYTE PTR 0Eh  ; Set the color to cyan gray'
        mov es:[1352], BYTE PTR 220   ; Draw a solid block
        mov es:[1353], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1354], BYTE PTR 220   ; Draw a solid block
        mov es:[1355], BYTE PTR 0Eh  ; Set the color to cyan gray
        
		;s
        mov es:[1360], BYTE PTR 223   ; Draw a solid block
        mov es:[1361], BYTE PTR 0Eh  ; Set the color to cyan gray'
        mov es:[1362], BYTE PTR 220   ; Draw a solid block
        mov es:[1363], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1364], BYTE PTR 220   ; Draw a solid block
        mov es:[1365], BYTE PTR 0Eh  ; Set the color to cyan gray
	
		;i 
        mov es:[1370], BYTE PTR 220   ; Draw a solid block
        mov es:[1371], BYTE PTR 0Eh  ; Set the color to cyan gray
	
		;n 
        mov es:[1374], BYTE PTR 219   ; Draw a solid block
        mov es:[1375], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1382], BYTE PTR 219   ; Draw a solid block
        mov es:[1383], BYTE PTR 0Eh  ; Set the color to cyan gray
		
		;g 
        mov es:[1386], BYTE PTR 219   ; Draw a solid block
        mov es:[1387], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1394], BYTE PTR 219   ; Draw a solid block
        mov es:[1395], BYTE PTR 0Eh  ; Set the color to cyan gray
	
    	;Row 10
		;C
        mov es:[1480], BYTE PTR 223   ; Draw a solid block
        mov es:[1481], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1482], BYTE PTR 220   ; Draw a solid block
        mov es:[1483], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1484], BYTE PTR 220   ; Draw a solid block
        mov es:[1485], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1486], BYTE PTR 223   ; Draw a solid block
        mov es:[1487], BYTE PTR 0Eh  ; Set the color to cyan gray
	
		;R 
        mov es:[1490], BYTE PTR 219   ; Draw a solid block
        mov es:[1491], BYTE PTR 0Eh  ; Set the color to cyan gray
	
		;0
        mov es:[1500], BYTE PTR 223   ; Draw a solid block
        mov es:[1501], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1502], BYTE PTR 220   ; Draw a solid block
        mov es:[1503], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1504], BYTE PTR 220   ; Draw a solid block
        mov es:[1505], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1506], BYTE PTR 223   ; Draw a solid block
        mov es:[1507], BYTE PTR 0Eh  ; Set the color to cyan gray
		
		;S 
        mov es:[1510], BYTE PTR 220   ; Draw a solid block
        mov es:[1511], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1512], BYTE PTR 220   ; Draw a solid block
        mov es:[1513], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1514], BYTE PTR 220   ; Draw a solid block
        mov es:[1515], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1516], BYTE PTR 223   ; Draw a solid block
        mov es:[1517], BYTE PTR 0Eh  ; Set the color to cyan gray
	
		;S 
        mov es:[1520], BYTE PTR 220   ; Draw a solid block
        mov es:[1521], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1522], BYTE PTR 220   ; Draw a solid block
        mov es:[1523], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1524], BYTE PTR 220   ; Draw a solid block
        mov es:[1525], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1526], BYTE PTR 223   ; Draw a solid block
        mov es:[1527], BYTE PTR 0Eh  ; Set the color to cyan gray
	
		;i 
        mov es:[1530], BYTE PTR 219   ; Draw a solid block
        mov es:[1531], BYTE PTR 0Eh  ; Set the color to cyan gray
	
		;n
        mov es:[1534], BYTE PTR 219   ; Draw a solid block
        mov es:[1535], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1542], BYTE PTR 219   ; Draw a solid block
        mov es:[1543], BYTE PTR 0Eh  ; Set the color to cyan gray
	
		;g
        mov es:[1546], BYTE PTR 223   ; Draw a solid block
        mov es:[1547], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1548], BYTE PTR 220   ; Draw a solid block
        mov es:[1549], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1550], BYTE PTR 220   ; Draw a solid block
        mov es:[1551], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1552], BYTE PTR 220   ; Draw a solid block
        mov es:[1553], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1554], BYTE PTR 219   ; Draw a solid block
        mov es:[1555], BYTE PTR 0Eh  ; Set the color to cyan gray
	
	    ;Row 11
		;g 
        mov es:[1708], BYTE PTR 220   ; Draw a solid block
        mov es:[1709], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1710], BYTE PTR 220   ; Draw a solid block
        mov es:[1711], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1712], BYTE PTR 220   ; Draw a solid block
        mov es:[1713], BYTE PTR 0Eh  ; Set the color to cyan gray
        mov es:[1714], BYTE PTR 223   ; Draw a solid block
        mov es:[1715], BYTE PTR 0Eh  ; Set the color to cyan gray
            
        ;PLAY GAME 
        mov es:[2300], BYTE PTR 'P'
        mov es:[2301], BYTE PTR 04h
        mov es:[2302], BYTE PTR 'r'
        mov es:[2303], BYTE PTR 04h
        mov es:[2304], BYTE PTR 'e'
        mov es:[2305], BYTE PTR 04h
        mov es:[2306], BYTE PTR 's'
        mov es:[2307], BYTE PTR 04h
        mov es:[2308], BYTE PTR 's'
        mov es:[2309], BYTE PTR 04h
        mov es:[2310], BYTE PTR 0
        mov es:[2311], BYTE PTR 04h
        mov es:[2312], BYTE PTR 'P'
        mov es:[2313], BYTE PTR 0Ch
        mov es:[2314], BYTE PTR 0
        mov es:[2315], BYTE PTR 04h
        mov es:[2316], BYTE PTR 't'
        mov es:[2317], BYTE PTR 04h
        mov es:[2318], BYTE PTR 'o'
        mov es:[2319], BYTE PTR 04h
        mov es:[2320], BYTE PTR 0
        mov es:[2321], BYTE PTR 04h
        mov es:[2322], BYTE PTR 'P'
        mov es:[2323], BYTE PTR 04h
        mov es:[2324], BYTE PTR 'l'
        mov es:[2325], BYTE PTR 04h
        mov es:[2326], BYTE PTR 'a'
        mov es:[2327], BYTE PTR 04h
        mov es:[2328], BYTE PTR 'y'
        mov es:[2329], BYTE PTR 04h

        ;I for instruction
        mov es:[2460], BYTE PTR 'P'
        mov es:[2461], BYTE PTR 04h
        mov es:[2462], BYTE PTR 'r'
        mov es:[2463], BYTE PTR 04h
        mov es:[2464], BYTE PTR 'e'
        mov es:[2465], BYTE PTR 04h
        mov es:[2466], BYTE PTR 's'
        mov es:[2467], BYTE PTR 04h
        mov es:[2468], BYTE PTR 's'
        mov es:[2469], BYTE PTR 04h
        mov es:[2470], BYTE PTR ' '
        mov es:[2471], BYTE PTR 04h
        mov es:[2472], BYTE PTR 'I'
        mov es:[2473], BYTE PTR 0Ch
        mov es:[2474], BYTE PTR ' '
        mov es:[2475], BYTE PTR 04h
        mov es:[2476], BYTE PTR 'f'
        mov es:[2477], BYTE PTR 04h
        mov es:[2478], BYTE PTR 'o'
        mov es:[2479], BYTE PTR 04h
        mov es:[2480], BYTE PTR 'r'
        mov es:[2481], BYTE PTR 04h
        mov es:[2482], BYTE PTR ' '
        mov es:[2483], BYTE PTR 04h
        mov es:[2484], BYTE PTR 'I'
        mov es:[2485], BYTE PTR 04h
        mov es:[2486], BYTE PTR 'n'
        mov es:[2487], BYTE PTR 04h
        mov es:[2488], BYTE PTR 's'
        mov es:[2489], BYTE PTR 04h
        mov es:[2490], BYTE PTR 't'
        mov es:[2491], BYTE PTR 04h
        mov es:[2492], BYTE PTR 'r'
        mov es:[2493], BYTE PTR 04h
        mov es:[2494], BYTE PTR 'u'
        mov es:[2495], BYTE PTR 04h
        mov es:[2496], BYTE PTR 'c'
        mov es:[2497], BYTE PTR 04h
        mov es:[2498], BYTE PTR 't'
        mov es:[2499], BYTE PTR 04h
        mov es:[2500], BYTE PTR 'i'
        mov es:[2501], BYTE PTR 04h
        mov es:[2502], BYTE PTR 'o'
        mov es:[2503], BYTE PTR 04h
        mov es:[2504], BYTE PTR 'n'
        mov es:[2505], BYTE PTR 04h

        ;E to Exit
        mov es:[2620], BYTE PTR 'P'
        mov es:[2621], BYTE PTR 04h
        mov es:[2622], BYTE PTR 'r'
        mov es:[2623], BYTE PTR 04h
        mov es:[2624], BYTE PTR 'e'
        mov es:[2625], BYTE PTR 04h
        mov es:[2626], BYTE PTR 's'
        mov es:[2627], BYTE PTR 04h
        mov es:[2628], BYTE PTR 's'
        mov es:[2629], BYTE PTR 04h
        mov es:[2630], BYTE PTR ' '
        mov es:[2631], BYTE PTR 04h
        mov es:[2632], BYTE PTR 'E'
        mov es:[2633], BYTE PTR 0Ch
        mov es:[2634], BYTE PTR ' '
        mov es:[2635], BYTE PTR 04h
        mov es:[2636], BYTE PTR 't'
        mov es:[2637], BYTE PTR 04h
        mov es:[2638], BYTE PTR 'o'
        mov es:[2639], BYTE PTR 04h
        mov es:[2640], BYTE PTR ' '
        mov es:[2641], BYTE PTR 04h
        mov es:[2642], BYTE PTR 'E'
        mov es:[2643], BYTE PTR 04h
        mov es:[2644], BYTE PTR 'x'
        mov es:[2645], BYTE PTR 04h
        mov es:[2646], BYTE PTR 'i'
        mov es:[2647], BYTE PTR 04h
        mov es:[2648], BYTE PTR 't'
        mov es:[2649], BYTE PTR 04h

        ;Group 1
        mov es:[3732], BYTE PTR 'G'
        mov es:[3733], BYTE PTR 0Eh
        mov es:[3734], BYTE PTR 'r'
        mov es:[3735], BYTE PTR 0Eh
        mov es:[3736], BYTE PTR 'o'
        mov es:[3737], BYTE PTR 0Eh
        mov es:[3738], BYTE PTR 'u'
        mov es:[3739], BYTE PTR 0Eh
        mov es:[3740], BYTE PTR 'p'
        mov es:[3741], BYTE PTR 0Eh
        mov es:[3742], BYTE PTR ' '
        mov es:[3743], BYTE PTR 0Eh
        mov es:[3744], BYTE PTR '2'
        mov es:[3745], BYTE PTR 0Eh
        mov es:[3746], BYTE PTR ':'
        mov es:[3747], BYTE PTR 0Eh
        mov es:[3748], BYTE PTR ' '
        mov es:[3749], BYTE PTR 0Eh
        mov es:[3750], BYTE PTR 'A'
        mov es:[3751], BYTE PTR 0Eh
        mov es:[3752], BYTE PTR 'r'
        mov es:[3753], BYTE PTR 0Eh
        mov es:[3754], BYTE PTR 'c'
        mov es:[3755], BYTE PTR 0Eh
        mov es:[3756], BYTE PTR 'a'
        mov es:[3757], BYTE PTR 0Eh
        mov es:[3758], BYTE PTR 'd'
        mov es:[3759], BYTE PTR 0Eh
        mov es:[3760], BYTE PTR 'e'
        mov es:[3761], BYTE PTR 0Eh
        mov es:[3762], BYTE PTR ' '
        mov es:[3763], BYTE PTR 0Eh
        mov es:[3764], BYTE PTR 'G'
        mov es:[3765], BYTE PTR 0Eh
        mov es:[3766], BYTE PTR 'a'
        mov es:[3767], BYTE PTR 0Eh
        mov es:[3768], BYTE PTR 'm'
        mov es:[3769], BYTE PTR 0Eh
        mov es:[3770], BYTE PTR 'e'
        mov es:[3771], BYTE PTR 0Eh
        mov es:[3772], BYTE PTR ' '
        mov es:[3773], BYTE PTR 0Eh
        mov es:[3774], BYTE PTR 'P'
        mov es:[3775], BYTE PTR 0Eh
        mov es:[3776], BYTE PTR 'r'
        mov es:[3777], BYTE PTR 0Eh
        mov es:[3778], BYTE PTR 'o'
        mov es:[3779], BYTE PTR 0Eh
        mov es:[3780], BYTE PTR 'j'
        mov es:[3781], BYTE PTR 0Eh
        mov es:[3782], BYTE PTR 'e'
        mov es:[3783], BYTE PTR 0Eh
        mov es:[3784], BYTE PTR 'c'
        mov es:[3785], BYTE PTR 0Eh
        mov es:[3786], BYTE PTR 't'
        mov es:[3787], BYTE PTR 0Eh
    
    menu_page_start:
        call resp 
            
        cmp al, 'P'
            je short_jump_to_main
        cmp al, 'p'
            je short_jump_to_main
        ;cmp al, 'L'
        ;    je short_jump_to_lead
        ;cmp al, 'l'
        ;    je short_jump_to_lead
        cmp al, 'I'
            je short_jump_to_instruction
        cmp al, 'i'
            je short_jump_to_instruction
        cmp al, 'E'
            je short_jump_to_quit
        cmp al, 'e'
            je short_jump_to_quit
        jmp main_menu_page
        
    short_jump_to_main:
        jmp main
        
    ;short_jump_to_lead:
    ;    jmp lead_page_start
        
    short_jump_to_instruction:
        jmp instruction_page_start
        
    short_jump_to_quit:
        jmp quit_game

    instruction_page_start:
        call cls

        mov ax, @data
        mov es, ax
        
       mov ax, 03h
        int 10h

        mov bl, 0Eh ;color

        mov dh, 1   ;row
        mov dl, 0   ;column
        mov cx, strInstructionTitle1_length
        lea bp, strInstructionTitle1
        call str_out
            
        mov dh, 2   ;row
        mov cx, strInstructionTitle2_length
        lea bp, strInstructionTitle2
        call str_out

        mov dh, 3   ;row
        mov cx, strInstructionTitle3_length
        lea bp, strInstructionTitle3
        call str_out

        mov dh, 4   ;row
        mov cx, strInstructionTitle4_length
        lea bp, strInstructionTitle4
        call str_out

        mov dh, 5   ;row
        mov cx, strInstructionTitle5_length
        lea bp, strInstructionTitle5
        call str_out

        mov bl, 0Fh ;color

        mov dh, 7
        mov dl, 5   ;column
        mov cx, strInstructionLine1_length
        lea bp, strInstructionLine1
        call str_out
        
        mov dh, 8
        mov dl, 3   ;column
        mov cx, strInstructionLine2_length
        lea bp, strInstructionLine2
        call str_out

        mov dh, 9
        mov dl, 30   ;column
        mov cx, strInstructionLine3_length
        lea bp, strInstructionLine3
        call str_out

        mov bl, 0Eh ;color

        mov dh, 10
        mov dl, 3   ;column
        mov cx, strInstructionLine4_length
        lea bp, strInstructionLine4
        call str_out

        mov bl, 0Fh ;color

        mov dh, 11
        mov dl, 5   ;column
        mov cx, strInstructionLine5_length
        lea bp, strInstructionLine5
        call str_out
        
        mov dh, 12
        mov dl, 3   ;column
        mov cx, strInstructionLine6_length
        lea bp, strInstructionLine6
        call str_out

        mov dh, 13
        mov cx, strInstructionLine7_length
        lea bp, strInstructionLine7
        call str_out

        mov bl, 0Eh ;color

        mov dh, 15
        mov cx, strInstructionLine8_length
        lea bp, strInstructionLine8
        call str_out

        mov bl, 0Fh ;color

        mov dh, 16
        mov dl, 5   ;column
        mov cx, strInstructionLine9_length
        lea bp, strInstructionLine9
        call str_out

        mov dh, 17
        mov dl, 8   ;column
        mov cx, strInstructionLine10_length
        lea bp, strInstructionLine10
        call str_out

        mov dh, 18
        mov cx, strInstructionLine11_length
        lea bp, strInstructionLine11
        call str_out

        mov dh, 19
        mov cx, strInstructionLine12_length
        lea bp, strInstructionLine12
        call str_out

        mov dh, 20
        mov cx, strInstructionLine13_length
        lea bp, strInstructionLine13
        call str_out

        mov bl, 0Eh ;color

        mov dh, 22
        mov dl, 3   ;column
        mov cx, strInstructionLine14_length
        lea bp, strInstructionLine14
        call str_out

        mov bl, 0Fh ;color

        mov dh, 23
        mov dl, 5   ;column
        mov cx, strInstructionLine15_length
        lea bp, strInstructionLine15
        call str_out

        mov dh, 24
        mov dl, 3   ;column
        mov cx, strInstructionLine16_length
        lea bp, strInstructionLine16
        call str_out

        call resp
        cmp al, 'B'
            je short_jump_to_main_menu
        cmp al, 'b'
            je short_jump_to_main_menu
        jmp instruction_page_start
    
    ;lead_page_start:
    ;    call cls

    ;   mov dh, 16
    ;    mov dl, 12
    ;    mov cx, strLeadTest_length
    ;    lea bp, strLeadTest
    ;    call str_out

    ;    call resp
    ;    cmp al, 'B'
    ;        je short_jump_to_main_menu
    ;    cmp al, 'b'
    ;        je short_jump_to_main_menu

    quit_game:
        call cls
        mov ah, 4ch
        int 21h

	short_jump_to_main_menu:
        jmp main_menu_page

    MAIN:
    MOV AX, @DATA
    MOV DS, AX

    ; Store video memory address in the extra segment
    MOV AX, 0B800h
    MOV ES, AX

    JMP InitializeGame

RetryGameSelected:      ; Executed when the "retry game" option is selected
    CALL FAR PTR retryGame

InitializeGame:         ; Draws the initial game scene
	CALL cls
	CMP current_screen, 00h
	JMP show_game
		
show_game:
	CALL FAR PTR initialGameScreen
    
GameLoop:
; Here we calculate the time change to move the obstacle as follows:
        ; If the seconds are different (the current second and the recorded second), we move the obstacle
        ; If the seconds are the same, we compare the fraction of a second
        ; If the difference is greater than 600 milliseconds, we move the obstacle
        ; The fraction of a second (MilliSecSpeed) controls the speed

CheckTileMovement:
    mov ah, 2Ch          ; Get the current time
    int 21h              ; Interrupt to get the time

    cmp dh, currentSec   ; Compare with the recorded second
    jne MoveTheTiles     ; If different, move the tiles

    mov cl, currentDeciSec ; If seconds are the same, get the fraction of a second
    add cl, MilliSecSpeed ; Add the speed factor
    cmp dl, cl           ; Compare the current fraction of a second with the adjusted value
    ja MoveTheTiles      ; If the difference is greater than the speed factor, move the tiles

    jmp CheckForUserInput ; If no movement, check for user input

MoveTheTiles:
    mov currentDeciSec, dl ; Save the new fraction of a second
    mov currentSec, dh     ; Save the new second
    call far ptr movingObstacle ; Call the routine to move all tiles

checkingCollision:
        ; Here we check if the player has collided with the moving deadly rectangles by doing the following:
        ; If the color at the cell (center) of the player is red
    mov si, playerPosition         ; Load player position into SI
    mov al, es:[si+1]         ; Get the color at the player's position
    cmp al, BYTE PTR 0h       ; Compare it with the red color (assuming 0h is red)
    jne CheckForUserInput     ; If it's not red, continue to check for user input
    call far ptr DrawPlayer   ; If it is red, draw the player (this seems redundant if game over follows)
    jmp gameOver              ; Jump to game over routine

CheckForUserInput:
        ; If it comes here, it means no collision has occurred
    mov ax, 0
    mov ah, 1             ; Check if a key has been pressed
    int 16h               ; BIOS keyboard interrupt
    mov playerPress, ah   ; Store the key press in PlayerPress
    jnz GetUserInput      ; If a key was pressed, jump to GetUserInput
    jmp CHECKYELLOW       ; Otherwise, jump to CHECKYELLOW

GetUserInput:
        ; Make sure the exit key wasn't pressed
    cmp playerPress, 10h     ; Compare with the exit key code (assuming 10h is the exit key)
    jne checkRetryPressed    ; If not, jump to checkRetryPressed

consumeLetterBeforeQuit:
    mov ah, 0                ; Prepare to consume the letter before quitting
    int 16h                  ; BIOS keyboard interrupt to consume the key press
    jmp exit                 ; Jump to exit

checkRetryPressed:
        ; Make sure the retry game key wasn't pressed
    cmp playerPress, 13h      ; Compare with the retry key code (assuming 13h is the retry key)
    jne CheckArrowUP          ; If not, jump to CheckArrowUP

consumeLetterBeforeRetry:
    mov ah, 0                 ; Prepare to consume the letter before retrying
    int 16h                   ; BIOS keyboard interrupt to consume the key press
    jmp RetryGameSelected     ; Jump to retry game selected routine

CheckArrowUP:
        ; Check if the up arrow key was pressed
        ; If pressed, ensure the move is valid (i.e., does not move the player out of screen bounds)
        ; If the player's center is past the first two rows of the screen, the player can move up
    cmp playerPress, 48h      ; Compare with the up arrow key code (assuming 48h is the up arrow key)
    jne CheckArrowDown        ; If not, jump to CheckArrowDown

CheckUpValidMove:
    mov ax, playerPosition         ; Load player position
    cmp ax, BYTE PTR 320      ; Compare with the boundary (assuming 320 is the boundary value)
    jb DisapproveUpMove       ; If the player is above the boundary, disapprove the move

    mov di, playerPosition         ; Load player position into DI
    sub di, 160               ; Subtract 160 to move the player up
    call far ptr collisionPlayer  ; Call the routine to move the player

DisapproveUpMove:
    jmp consumeTheLetter      ; Remove the key press from the keyboard queue

CheckArrowDown:
        ; Check if the down arrow key was pressed
        ; If pressed, ensure the move is valid (i.e., does not move the player out of screen bounds)
        ; If the player's center is before the last row of the screen, the player can move down
    cmp PlayerPress, 50h       ; Compare with the down arrow key code (assuming 50h is the down arrow key)
    jne CheckArrowLeft         ; If not, jump to CheckArrowLeft

CheckDownValidMove:
    mov ax, playerPosition         ; Load player position
    cmp ax, WORD PTR 3840      ; Compare with the boundary (assuming 3840 is the boundary value)
    jae DisapproveDownMove     ; If the player is below the boundary, disapprove the move

    mov di, playerPosition         ; Load player position into DI
    add di, 160                ; Add 160 to move the player down
    call far ptr collisionPlayer    ; Call the routine to move the player

DisapproveDownMove:
    jmp consumeTheLetter       ; Remove the key press from the keyboard queue

CheckArrowLeft:
        ; Check if the left arrow key was pressed
        ; If pressed, ensure the move is valid (i.e., does not move the player out of screen bounds)
        ; If the player's center is not at multiples of 160, the player cannot move left
    cmp playerPress, 4Bh       ; Compare with the left arrow key code (assuming 4Bh is the left arrow key)
    jne CheckArrowRight         ; If not, jump to CheckArrowRight

CheckLeftValidMove:
    mov ax, playerPosition         ; Load player position
    mov dl, 160                ; Load 160 into DL (row size)
    div dl                     ; Divide AX (player position) by DL (row size)
    mov dl, ah                 ; Move the remainder (AH) to DL
    cmp dl, 0                  ; Compare with 0 to check if it's at multiples of 160
    je DisapproveLeftMove      ; If it's at multiples of 160, disapprove the move

    mov di, playerPosition         ; Load player position into DI
    sub di, BYTE PTR 2         ; Subtract 2 to move the player left
    call far ptr collisionPlayer    ; Call the routine to move the player

DisapproveLeftMove:
    jmp consumeTheLetter       ; Remove the key press from the keyboard queue

CheckArrowRight:
        ; Check if the right arrow key was pressed
        ; If pressed, ensure the move is valid (i.e., does not move the player out of screen bounds)
        ; If the player is at center position number 158 of any row, the player cannot move right
    cmp playerPress, 4Dh           ; Compare with the right arrow key code (assuming 4Dh is the right arrow key)
    jne consumeTheLetter           ; If not, it means a key other than the four arrow keys was pressed, so consume the letter

CheckRightValidMove:
    mov ax, playerPosition              ; Load player position
    cmp ax, 158                    ; Compare with the position 158
    je DisapproveRightMove         ; If at position 158, disapprove the move
    cmp ax, 158                    ; Check if below position 158
    jb approveRightMove            ; If below, approve the move

    sub ax, 158                    ; Subtract 158 from the player position
    mov dl, 160                    ; Load 160 into DL (row size)
    div dl                         ; Divide AX (player position) by DL (row size)
    mov dl, ah                     ; Move the remainder (AH) to DL
    cmp dl, 0                      ; Check if it's a multiple of 160
    je DisapproveRightMove         ; If multiple of 160, disapprove the move

approveRightMove:
    mov di, playerPosition             ; Load player position into DI
    add di, BYTE PTR 2             ; Add 2 to move the player right
    call far ptr collisionPlayer        ; Call the routine to move the player

DisapproveRightMove:
    ; No action needed, just mark the end of the disapproved move section


consumeTheLetter:
    mov ah, 0           ; Prepare to consume the letter
    int 16h             ; BIOS keyboard interrupt to consume the key press

checkCollisionAfterPlayerMove:
    mov al, collisionDetected   ; Load collisionDetected into AL
    cmp al, 1                   ; Compare with 1
    jne CHECKYELLOW             ; If collision not detected, jump to CHECKYELLOW
    int 3                       ; Otherwise, generate a breakpoint interrupt
    jmp gameOver                ; Jump to game over


CHECKYELLOW:
        ; Check if the player has reached the yellow line
        ; If so, draw the yellow line on the opposite side, increase the game score
        ; and change the speed of the moving rectangles
    mov ax, playerPosition        ; Load player position into AX
    cmp waterPosition, 0       ; Compare with 0 to determine if the yellow line is at the top or bottom
    jne YellowIsAtTheBottom    ; If not 0, jump to YellowIsAtTheBottom

YellowIsAtTheTop:
    cmp ax, WORD PTR 320       ; Compare player position with screen boundary (assuming 320 is the boundary value)
    jb YesHeReachedYellowTop   ; If player is below the boundary, jump to YesHeReachedYellowTop
    jmp CheckSpeed             ; Otherwise, the yellow line is above and player hasn't reached it yet

YesHeReachedYellowTop:
    inc gameScore              ; Increase the game score
    call far ptr drawWaterLine ; Draw the yellow line at the bottom and erase it from the top
    jmp CheckSpeed             ; Jump to CheckSpeed

YellowIsAtTheBottom:
    cmp ax, WORD PTR 3840      ; Compare player position with screen boundary (assuming 3840 is the boundary value)
    jae YesHeReachedYellowBottom; If player is above the boundary, jump to YesHeReachedYellowBottom
    jmp CheckSpeed             ; Otherwise, the yellow line is below and player hasn't reached it yet

YesHeReachedYellowBottom:
    inc gameScore              ; Increase the game score
    call far ptr drawWaterLine ; Draw the yellow line at the top and erase it from the bottom

CheckSpeed:
    ; Redraw the player
    call far ptr DrawPlayer

    ; Adjust the speed of the rectangles relative to the game score and MilliSecSpeed
    ; based on the ratio between the score and a predefined value (lastFourMultipleSCore)
    ; Whenever the score increases by multiples of two, decrease the MilliSecSpeed
    ; until it reaches one

    mov al, gameScore                 ; Load the game score into AL
    sub al, lastFourMultipleSCore     ; Subtract lastFourMultipleSCore from AL
    cmp al, 02h                       ; Compare AL with 2
    jae YESIncreaseSpeed              ; If greater than or equal to 2, jump to YESIncreaseSpeed

NODontIncreaseSpeed:
    jmp continueGameLoop              ; Otherwise, continue without increasing speed

YESIncreaseSpeed:
    mov al, MilliSecSpeed             ; Load MilliSecSpeed into AL
    cmp al, 1                         ; Compare AL with 1
    je DontIncreaseAlsoReachedOne     ; If equal to 1, jump to DontIncreaseAlsoReachedOne
    dec al                            ; Otherwise, decrease MilliSecSpeed
    mov MilliSecSpeed, al             ; Move the new value back to MilliSecSpeed

DontIncreaseAlsoReachedOne:
    mov ax, WORD PTR gameScore        ; Load the game score into AX
    mov lastFourMultipleSCore, al     ; Move the value of AX to lastFourMultipleSCore

continueGameLoop:
    call far ptr drawScore            ; Draw the score
    jmp GameLoop                      ; Jump back to GameLoop

gameOver:
    ; Draw the game over message
    call far ptr drawGameOver

gameOverWait:
        ; Wait for player action: retry or exit
    getDecision:
    mov ax, 0
    mov ah, 1             ; Check if a key has been pressed
    int 16h               ; BIOS keyboard interrupt
    jz getDecision        ; If no key was pressed, check again

    ; Player has pressed a key
    mov playerPress, ah   ; Store the key press in playerPress

consumeLetter:
    ; Consume the key press
    mov ah, 0             ; Prepare to consume the letter
    int 16h               ; BIOS keyboard interrupt to consume the key press

    ; Check if the player wants to retry or exit
    cmp playerPress, 10h  ; Compare with the exit key code (assuming 10h is the exit key)
    jne checkRetry        ; If not, check if it's the retry key
    jmp exit              ; If it's the exit key, exit the game

checkRetry:
    cmp playerPress, 13h  ; Compare with the retry key code (assuming 13h is the retry key)
    jne gameOverWait      ; If not, go back to waiting for player input
    jmp RetryGameSelected ; If it's the retry key, jump to RetryGameSelected

exit:
        MOV AH, 4Ch     ; Service 4Ch - Terminate with Error Code
        MOV AL, 0       ; Error code
        INT 21h         ; Interrupt 21h - DOS General Interrupts

initialGameScreen PROC FAR
    ; Set black background for the entire screen
	CALL cls
    mov cx, WORD PTR cellsCount  ; Number of cells
    mov di, 00h                         ; Point to the first cell

DrawGreySCREEN:
    mov es:[di], BYTE PTR 219               ; ASCII character
    mov es:[di+1], BYTE PTR backgroundColor ; Background color
    add di, 2                               ; Move to the next cell
    loop DrawGreySCREEN                     ; Repeat for the next cell until cx (loop counter) becomes zero

    ; Draw the status line
    mov cx, WORD PTR 80                  ; 80 characters in a row
    mov di, 00h                          ; Point to the first cell

drawStatusLine:
    mov es:[di], BYTE PTR 219            ; ASCII character
    mov es:[di+1], BYTE PTR 00           ; Color (black)
    add di, 2                            ; Move to the next cell
    loop drawStatusLine                  ; Repeat for the next cell until cx (loop counter) becomes zero

    ; Draw the yellow goal line
    mov cx, WORD PTR 80                  ; 80 characters in a row
    mov di, WORD PTR 160                 ; Point to the first cell in the second row

drawGoalLineOne:
    mov es:[di], BYTE PTR 219            ; ASCII character
    mov es:[di+1], BYTE PTR 01h          ; Yellow color
    add di, 2                            ; Move to the next cell
    loop drawGoalLineOne                 ; Repeat for the next cell until cx (loop counter) becomes zero

    ; Draw the white stripes on the road
    call far ptr drawLog
    ; Draw the player, represented as a blue cell
    call far ptr DrawPlayer

    ; Initialize the timer to keep track of seconds and hundredths of a second
    ; for use in moving the deadly red cells
    call far ptr gameTimer
    ret         ; Return from the procedure

initialGameScreen ENDP

drawObstacle PROC FAR
    ; Draw a single stripe of white color on a black background

    push cx         ; Preserve CX register
    push bx         ; Preserve BX register

    mov cx, 8       ; Number of cells per stripe (length of the stripe)
    add bx, 154     ; End point of the stripe in the row

drawSingleStripeLoop:
    cmp di, bx      ; Compare the current position with the end point
    jae exitDSS     ; If DI is greater than or equal to BX, exit the loop

    mov es:[di], BYTE PTR 219     ; Draw a solid block
    mov es:[di+1], BYTE PTR 06h   ; Set the color to white on a black background
    add di, 2h                     ; Move to the next cell
    loop drawSingleStripeLoop      ; Repeat for the next cell until CX (loop counter) becomes zero

exitDSS:
    pop bx          ; Restore BX register
    pop cx          ; Restore CX register
    ret             ; Return from the drawSingleStripe procedure
drawObstacle ENDP

drawObstacles PROC FAR

    mov es:[di], BYTE PTR 178   ; Draw a solid block
    mov es:[di+1], BYTE PTR 0h  ; Set the color to black

    mov es:[di+2], BYTE PTR 178 ; Draw a solid block
    mov es:[di+3], BYTE PTR 0Eh  ; Set the color to black

    mov es:[di+4], BYTE PTR 178   ; Draw a solid block
    mov es:[di+5], BYTE PTR 0h  ; Set the color to black
   

    ret ; Return from the procedure
drawObstacles ENDP

drawScore PROC FAR
    ; Draw the game score and the quit and retry messages

    push ax     ; Preserve AX register
    push bx     ; Preserve BX register

    ; Calculate the tens and units digits of the game score
    mov ah, 0               ; Clear AH register
    mov al, gameScore      ; Load the game score into AL
    mov bl, BYTE PTR 10     ; Divide by 10
    div bl                  ; AL = quotient, AH = remainder

    ; Convert tens and units digits to ASCII characters
    add ah, '0'             ; Convert tens digit to ASCII
    add al, '0'             ; Convert units digit to ASCII

    ; Draw the score label
    mov es:[0], BYTE PTR 'I'       ; Draw 'S'
    mov es:[1], BYTE PTR 0Eh       ; Set the color to green on black background
    mov es:[2], BYTE PTR 'S'       ; Draw 'C'
    mov es:[3], BYTE PTR 0Eh        ; Set the color to green on black background
    mov es:[4], BYTE PTR 'K'       ; Draw 'O'
    mov es:[5], BYTE PTR 0Eh        ; Set the color to green on black background
    mov es:[6], BYTE PTR 'O'       ; Draw 'R'
    mov es:[7], BYTE PTR 0Eh        ; Set the color to green on black background
    mov es:[8], BYTE PTR 'R'       ; Draw 'E'
    mov es:[9], BYTE PTR 0Eh        ; Set the color to green on black background
    mov es:[10], BYTE PTR ':'      ; Draw ':'
    mov es:[11], BYTE PTR 0Eh       ; Set the color to green on black background
    mov es:[12], BYTE PTR ' '      ; Draw a space
    mov es:[13], BYTE PTR 0Eh       ; Set the color to green on black background
    mov es:[14], al                ; Draw units digit of the score
    mov es:[15], BYTE PTR 0Eh       ; Set the color to green on black background
    mov es:[16], ah                ; Draw tens digit of the score
    mov es:[17], BYTE PTR 0Eh      ; Set the color to green on black background

    ; Draw the quit message
    mov es:[120], BYTE PTR 'Q'     ; Draw 'Q'
    mov es:[121], BYTE PTR 0Ah     ; Set the color to green on black background
    mov es:[122], BYTE PTR ':'     ; Draw ':'
    mov es:[123], BYTE PTR 0Ah     ; Set the color to green on black background
    mov es:[124], BYTE PTR 'Q'     ; Draw 'Q'
    mov es:[125], BYTE PTR 0Ah     ; Set the color to green on black background
    mov es:[126], BYTE PTR 'U'     ; Draw 'U'
    mov es:[127], BYTE PTR 0Ah     ; Set the color to green on black background
    mov es:[128], BYTE PTR 'I'     ; Draw 'I'
    mov es:[129], BYTE PTR 0Ah     ; Set the color to green on black background
    mov es:[130], BYTE PTR 'T'     ; Draw 'T'
    mov es:[131], BYTE PTR 0Ah     ; Set the color to green on black background


    ; Draw the retry message
    mov es:[134], BYTE PTR 'R'     ; Draw 'R'
    mov es:[135], BYTE PTR 0Ah     ; Set the color to green on black background
    mov es:[136], BYTE PTR ':'     ; Draw ':'
    mov es:[137], BYTE PTR 0Ah     ; Set the color to green on black background
    mov es:[138], BYTE PTR 'R'     ; Draw 'R'
    mov es:[139], BYTE PTR 0Ah     ; Set the color to green on black background
    mov es:[140], BYTE PTR 'E'     ; Draw 'E'
    mov es:[141], BYTE PTR 0Ah     ; Set the color to green on black background
    mov es:[142], BYTE PTR 'T'     ; Draw 'T'
    mov es:[143], BYTE PTR 0Ah     ; Set the color to green on black background
    mov es:[144], BYTE PTR 'R'     ; Draw 'R'
    mov es:[145], BYTE PTR 0Ah     ; Set the color to green on black background
    mov es:[146], BYTE PTR 'Y'     ; Draw 'Y'
    mov es:[147], BYTE PTR 0Ah     ; Set the color to green on black background

    pop bx      ; Restore BX register
    pop ax      ; Restore AX register
    ret         ; Return from the procedure

drawScore ENDP

drawGameOver PROC FAR
    ; Draw the game over message

    mov es:[68], BYTE PTR 'H'      ; Draw 'G'
    mov es:[69], BYTE PTR 0Ch      ; Set the color to red on black background
    mov es:[70], BYTE PTR 'A'      ; Draw 'A'
    mov es:[71], BYTE PTR 0Ch      ; Set the color to red on black background
    mov es:[72], BYTE PTR 'H'      ; Draw 'M'
    mov es:[73], BYTE PTR 0Ch      ; Set the color to red on black background
    mov es:[74], BYTE PTR 'A'      ; Draw 'E'
    mov es:[75], BYTE PTR 0Ch      ; Set the color to red on black background
    mov es:[76], BYTE PTR ' '      ; Draw a space
    mov es:[77], BYTE PTR 0Ch      ; Set the color to red on black background
    mov es:[78], BYTE PTR 'K'      ; Draw 'O'
    mov es:[79], BYTE PTR 0Ch      ; Set the color to red on black background
    mov es:[80], BYTE PTR 'A'      ; Draw 'V'
    mov es:[81], BYTE PTR 0Ch      ; Set the color to red on black background
    mov es:[82], BYTE PTR 'W'      ; Draw 'E'
    mov es:[83], BYTE PTR 0Ch      ; Set the color to red on black background
    mov es:[84], BYTE PTR 'A'      ; Draw 'R'
    mov es:[85], BYTE PTR 0Ch      ; Set the color to red on black background
    mov es:[86], BYTE PTR 'W'      ; Draw a space
    mov es:[87], BYTE PTR 0Ch      ; Set the color to red on black background
    mov es:[88], BYTE PTR 'A'      ; Draw ':'
    mov es:[89], BYTE PTR 0Ch  
    mov es:[90], BYTE PTR ' '      ; Draw a space
    mov es:[91], BYTE PTR 0Ch      ; Set the color to red on black background
    mov es:[92], BYTE PTR ':'      ; Draw ':'
    mov es:[93], BYTE PTR 0Ch      ; Set the color to red on black background
    mov es:[94], BYTE PTR '('      ; Draw '('
    mov es:[95], BYTE PTR 0Ch      ; Set the color to red on black background

    ret         ; Return from the procedure

drawGameOver ENDP

drawLog PROC FAR
    ; Draw the logs on the farm

    mov cx, BYTE PTR 17    ; Number of odd rows
    mov bx, 486            ; Initial position of the first white stripe in row 4
    mov di, bx             ; Set the starting point

drawStripesLoop:
    mov dx, BYTE PTR 5     ; Number of white stripes in each row

drawRowStripesLoop:
    call far ptr drawObstacle      ; Draw a single white stripe
    add di, BYTE PTR 18                 ; Move to the next position for the next stripe
    dec dx                              ; Decrement the stripe counter
    jnz drawRowStripesLoop              ; Continue drawing stripes in the row until done

    add bx, WORD PTR 3C0h  ; Move to the next row with white stripes
    mov di, bx             ; Set the starting point for the next row
    loop drawStripesLoop   ; Repeat for all odd rows

    ret                    ; Return from the procedure

drawLog  ENDP

drawPlayer PROC FAR
    ; Draw the carabao

    push di                             ; Save the current value of di to avoid unexpected results
    mov di, playerPosition                   ; Set di to the player's position
    mov es:[di], BYTE PTR 219           ; Draw the player character
    mov es:[di+1], BYTE PTR 08h         ; Set the color to blue on black
    pop di                              ; Restore the original value of di
    ret                                 ; Return from the procedure

drawPlayer ENDP

movingObstacle PROC far
    ; Move all obstacle

    mov cx, 15              ; Number of red tiles
    MovingAllTiles:
        mov bx, offset obstaclePosition       ; Address of the red tiles' positions
        mov ax, 15                       ; Set ax to 15
        sub ax, cx                       ; Calculate the offset for the current tile
        add bx, ax                       ; Move to the position of the current tile
        add bx, ax                       ; Multiply by 2 (each position is 2 bytes)
        mov di, offset obstacleMovement  ; Address of movement values for red tiles
        add di, ax                       ; Move to the movement value of the current tile
        add di, ax                       ; Multiply by 2 (each movement value is 2 bytes)
        mov dx, [bx]                     ; Get the current position of the tile
        add dx, [di]                     ; Calculate the new position

        ; Check if the new position is within boundaries
        checkLowBoundaries:
            mov si, offset obtacleLowLimits   ; Address of lower boundaries for each tile
            add si, ax                         ; Move to the lower boundary of the current tile
            add si, ax                         ; Multiply by 2 (each boundary value is 2 bytes)
            cmp dx, ds:[si]                    ; Compare the new position with the lower boundary
            jae checkHighBoundaries            ; If above or equal, check higher boundaries
            jmp FailedBoundariesCheck          ; Otherwise, reverse direction

        checkHighBoundaries:
            mov si, offset obstacleHighLimits  ; Address of upper boundaries for each tile
            add si, ax                         ; Move to the upper boundary of the current tile
            add si, ax                         ; Multiply by 2 (each boundary value is 2 bytes)
            cmp dx, ds:[si]                    ; Compare the new position with the upper boundary
            jb PassedBoundariesCheck           ; If below, move the tile
            jmp FailedBoundariesCheck          ; Otherwise, reverse direction

        PassedBoundariesCheck:
            call far ptr moveSingleTile       ; Move the tile
            jmp ContinueMovingAlliles         ; Continue moving other tiles

        FailedBoundariesCheck:
            ; Reverse the direction of movement
            mov ax, 0                          ; New direction = 0 - current movement value
            sub ax, ds:[di]                    ; Calculate the new movement value
            mov ds:[di], ax                    ; Update the movement value

    ContinueMovingAlliles:
        dec cx                                ; Decrement the counter
        jz returnMovingAllTiles               ; If all tiles are moved, return
        jmp MovingAllTiles                    ; Move the next tile

    returnMovingAllTiles:
        ret                                  ; Return from the procedure

movingObstacle ENDP

moveSingleTile PROC far
    ; Move a single red tile

    mov di, [bx]            ; Save the current position of the tile

    ; Draw background color at the current position
    mov es:[di], BYTE PTR 219               ; ASCII character
    mov es:[di+1], BYTE PTR backgroundColor ; Background color
    mov es:[di+2], BYTE PTR 219             ; ASCII character
    mov es:[di+3], BYTE PTR backgroundColor ; Background color
    mov es:[di+4], BYTE PTR 219             ; ASCII character
    mov es:[di+5], BYTE PTR backgroundColor ; Background color
    mov es:[di+6], BYTE PTR 219             ; ASCII character
    mov es:[di+7], BYTE PTR backgroundColor ; Background color

    mov [bx], dx            ; Update the position with the new value
    mov di, [bx]            ; Get the new position of the tile

    ; Draw the red tile at the new position
    call far ptr drawObstacles

    ret         ; Return from the procedure

moveSingleTile ENDP

gameTimer PROC FAR
    ; Get the current time

    mov ah, 2Ch         ; Function to get the system time
    int 21h             ; Call DOS interrupt to get the time

    mov currentDeciSec, dl  ; Save the current hundredths of a second
    mov currentSec, dh      ; Save the current second

    ret        ; Return from the procedure
gameTimer ENDP

collisionPlayer PROC FAR
    ; Check for collision
    mov al, es:[di+1]           ; Get the color of the cell the player is moving to
    cmp al, 0Ch                 ; Check if it's a collision color
    jne NOCOLLISION             ; If not, no collision detected
    mov collisionDetected, 1    ; Set collision detected flag
NOCOLLISION:

    ; Move the player
    mov si, playerPosition           ; Get the current player position
    mov al, 1                   ; Set a flag to compare with
    cmp playerHitLog, 1 ; Check if the player was on a white tile background
    je drawWhiteBackgnd         ; If yes, then draw white background
    jmp drawNormalBackgnd       ; Otherwise, draw the normal background

drawNormalBackgnd:
    ; Draw the player on the normal background
    mov es:[si], BYTE PTR 219    ; ASCII character
    mov es:[si+1], BYTE PTR backgroundColor  ; Background color
    jmp cont

drawWhiteBackgnd:
    ; Draw the player on the white background
    mov es:[si], BYTE PTR 219    ; ASCII character
    mov es:[si+1], BYTE PTR 06h  ; Blue color on white background

cont:
    mov playerHitLog, 0  ; Reset the flag (not on white background anymore)

    ; Check if the new position is on a white background
    mov al, es:[di+1]            ; Get the color of the cell the player is moving to
    cmp al, 06h                  ; Check if it's white
    jne NotAWhite                ; If not, skip setting the flag
    mov playerHitLog, 1  ; Set the flag indicating the player is on a white tile

NotAWhite:
    ; Draw the player
    mov es:[di], BYTE PTR 219     ; ASCII character
    mov es:[di+1], BYTE PTR 01h   ; Blue color on black background
    mov playerPosition, di             ; Save the new player position

    ret       ; Return from the procedure

collisionPlayer ENDP

drawWaterLine PROC FAR
    ; Compare if the water is at the top or bottom

    cmp waterPosition, 0
    jne ItsAtButtom  ; If not, it's at the bottom

ItsAtTop:
    ; Move the yellow line from top to bottom
    mov si, WORD PTR 160     ; Get the old position of the yellow line (first cell)
    mov di, WORD PTR 3840    ; Get the new position of the yellow line (first cell)
    mov waterPosition, 1     ; Set the yellow line at the bottom
    jmp REMOVWDRAWYELLOW     ; Jump to remove and draw the yellow line

ItsAtButtom:
    ; Move the yellow line from bottom to top
    mov si, WORD PTR 3840    ; Get the old position of the yellow line (first cell)
    mov di, WORD PTR 160     ; Get the new position of the yellow line (first cell)
    mov waterPosition, 0     ; Set the yellow line at the top

REMOVWDRAWYELLOW:
    ; Remove the yellow line from its previous position
    mov cx, WORD PTR 80      ; Each row represents 80 cells

RemoveYellow:
    mov es:[si], BYTE PTR 219       ; ASCII character
    mov es:[si+1], BYTE PTR backgroundColor  ; Background color
    add si, 2
    loop RemoveYellow

    ; Draw the yellow line at its new position
    mov cx, WORD PTR 80      ; Each row represents 80 cells

drawYellow:
    mov es:[di], BYTE PTR 219       ; ASCII character
    mov es:[di+1], BYTE PTR 01h     ; Yellow color
    add di, 2
    loop drawYellow

    ret

drawWaterLine ENDP

getObstaclePosition PROC FAR
    ; Initialize di to the start of the first red cell position

    mov di, 480        ; Start of the first red cell position
    mov cx, 15         ; Number of red cells to generate

    ; Get the current time
    push cx
    mov ah, 2Ch        ; Function to get time
    int 21h            ; Interrupt to get time
    pop cx

GetRandomRedDeathCells:
    ; Check if the time is within the range of the screen
    cmp dx, WORD PTR 160   ; Compare the time with the screen boundaries
    jb itsinRowRange       ; If it's within the boundaries, adjust it

itsAboveRange:
    ; Adjust the time if it's above the screen boundaries
    mov dx, ax
    mov bl, BYTE PTR 160
    div bl
    mov ah, 0h
    mov dx, ax

itsinRowRange:
    ; Ensure the row number is even
    test dx, 00000001b     ; Check if the row number is odd
    jz itsEvenContinueItsOK    ; If it's even, it's okay

itsOddMakeitEven:
    ; Make the row number even
    and dx, 11111110b

itsEvenContinueItsOK:
    ; Calculate the position of the red cell and save it

    add di, dx              ; Move to the correct row
    mov bx, 15
    sub bx, cx
    mov ax, bx
    add bx, ax              ; Convert word to byte
    add bx, offset obstaclePosition   ; Get the position of the red cell
    mov ds:[bx], di         ; Save the position of the red cell
    add di, WORD PTR 160    ; Move to the next row
    loop GetRandomRedDeathCells

    ret

getObstaclePosition ENDP

retryGame PROC FAR
    ; Reset the positions of the red tiles to their initial positions

    mov cx, 15                  ; Number of red tiles
    mov di, offset logPosition  ; Start of initial tile positions
    mov si, offset obstaclePosition     ; Start of red tile positions

reInitializeGamePos:
    mov ax, [di]                ; Get initial tile position
    mov [si], ax                ; Reset red tile position
    add di, 2                   ; Move to next initial tile position
    add si, 2                   ; Move to next red tile position
    loop reInitializeGamePos    ; Loop for all tiles

    ; Reset other game variables to their initial values
    mov playerPosition, 3920         ; Initial player position
    mov playerHitLog, 0 ; Player was not on white tile initially
    mov waterPosition, 0h       ; Yellow line position initially at top
    mov MilliSecSpeed, 6        ; Initial millisecond speed
    mov lastFourMultipleSCore, 0; Initial score multiple
    mov gameScore, 0            ; Reset game score
    mov collisionDetected, 0    ; Reset collision detection flag

    ret

retryGame ENDP

;Utilities somewhat
    cls proc; clears the screen
        mov ah, 07h          ; scroll down function
        mov al, 0            ; number of lines to scroll
        mov cx, 0
        mov dx, 9090
        mov bh, 00h          ; clear entire screen
        int 10h
        ret
    cls endp

    str_out proc
        mov ax, 1301h   
        mov bh, 00h   ;page
        int 10h
        ret
    str_out endp

    resp proc
        mov ah, 01h         ;get resp
        int 16h
        mov ah, 00h         ;read resp 
        int 16h
        ret
    resp endp

    invalid_response proc
        call cls
        
        mov ax, 03h
            int 10h
            mov bl, 0Fh ;color

            mov dh, 12   ;row
            mov dl, 30   ;column
            mov cx, strInvalidResponse_length
            lea bp, strInvalidResponse
            call str_out
            ret
    invalid_response endp

END
