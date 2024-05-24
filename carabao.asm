.MODEL large
.STACK 64
.DATA
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

.code
MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX

    ; Store video memory address in the extra segment
    MOV AX, 0B800h
    MOV ES, AX

    JMP InitializeGame

RetryGameSelected:      ; Executed when the "retry game" option is selected
    CALL FAR PTR retryGame

InitializeGame:         ; Draws the initial game scene
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

MAIN    ENDP

initialGameScreen PROC FAR
    ; Set black background for the entire screen
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
    ; Draw a square in four cells starting from the address in DI
    ; Each cell consists of two bytes: one for the ASCII character and one for the color

    mov es:[di], BYTE PTR 178   ; Draw a solid block
    mov es:[di+1], BYTE PTR 0h  ; Set the color to black

    mov es:[di+2], BYTE PTR 178 ; Draw a solid block
    mov es:[di+3], BYTE PTR 0h  ; Set the color to black

    mov es:[di+4], BYTE PTR 178 ; Draw a solid block
    mov es:[di+5], BYTE PTR 0h  ; Set the color to black

    mov es:[di+6], BYTE PTR 178 ; Draw a solid block
    mov es:[di+7], BYTE PTR 0h  ; Set the color to black

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

END MAIN
