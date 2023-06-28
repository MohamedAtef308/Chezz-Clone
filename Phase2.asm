.model huge
.stack 64
.386
.data
    ; 00 wpawn 01 wrock 02 wknight 03 WBishop  04 wqueen 05 Wking
    ; 10 bpawn 11 brock 12 bknight 13 bBishop  14 bqueen 15 bking

    ;----------------------------------------------------------------------------------------------------
    ;                                               Constants
    ;----------------------------------------------------------------------------------------------------

    timeArr         db    '00','01','02','03','04','05','06','07','08'
    temp00          db    '09','10','11','12','13','14','15','16','17'
    temp01          db    '18','19','20','21','22','23','24','25','26'
    temp02          db    '27','28','29','30','31','32','33','34','35'
    temp03          db    '36','37','38','39','40','41','42','43','44'
    temp04          db    '45','46','47','48','49','50','51','52','53'
    temp05          db    '54','55','56','57','58','59','00'

    xaxis           equ   0d
    yaxis           equ   2d
    typ             equ   4d
    time            equ   6d
    arraysize       equ   256d
    blacksize       equ   128d
    stop            equ   6d                                              ;to mark stop highlighting
    continue        equ   5d                                              ;to mark to resume highlighting


    nameMenu        db    "Enter Your Name:$"                             ;for the first screen
    pressEnt        db    "Press Enter to Continue$"

    mainMenu1       db    "To Start Chatting Press F1$"                   ;options for the main menu
    mainMenu2       db    "To Start The Game Press F2$"
    mainMenu3       db    "To Exit The Program Press ESC$"

    chatInv         db    " invited you to chat$"
    gameInv         db    " invited you to play$"
    
    whiteWon        db    "White Won"                                     ;text for the winner
    BlackWon        db    "Black Won"
    ;----------------------------------------------------------------------------------------------------
    ;                                               Users & Temprary Data
    ;----------------------------------------------------------------------------------------------------

    localMode       db    8                                               ;chatting or gaming
    netMode         db    9
    gameStarted     dw    ?

    user1Pos        dw    0,25d,0d                                        ;cx,dx  -> x axis,  y axis
    user1PrevColor  db    01h                                             ;yellow is the initial color of the left top SQR

    
    user2Pos        dw    0,150d,0d                                       ;cx,dx  -> x axis,  y axis
    user2PrevColor  db    07h                                             ;yellow is the initial color of the left top SQR

    
    netCursor       db    0,1                                             ;to mark the position of both chat cursors    dl:dh -> x:y
    meCursor        db    0,0

    xlength         dw    ?                                               ;used for printing
    yheight         dw    ?                                               ;used for printing

    resetPosition   dw    ?,?                                             ;used to reset the position when highlighting

    movingPiece1    dw    ?,?,?                                           ;for user1
    movingColor1    db    ?
    movingOffset1   dw    ?                                               ;stores the offset of the array when user 1 is moving a piece

    movingPiece2    dw    ?,? ,?                                          ;for user2
    movingColor2    db    ?
    movingOffset2   dw    ?                                               ;stores the offset of the array when user 2 is moving a piece

    boardColor      db    ?                                               ;to get the board color when a user moves on a highlighted square

    powerUpTime     dw    ?                                               ;to add a powerup every minute
    powerUp         dw    ?,?                                             ;to store the coordinates of the power up square
    powerOn         db    0

    ;----------------------------------------------------------------------------------------------------
    ;                                               Chatting
    ;----------------------------------------------------------------------------------------------------

    nameCursor      dw    0c1ah
    activePage      db    0


    localName       db    30 dup('$')
    localLength     dw    0
    
    netName         db    30 dup('$')
    netLength       dw    0

    lastGameChatRow db    0d                                              ;to mark the last in game chat row
    lastGameChatCol db    66d

    ;----------------------------------------------------------------------------------------------------
    ;                                               Array of valid Moves
    ;----------------------------------------------------------------------------------------------------
    ;the array takes the form of    -->    cx , dx , highlight color1, highlight color2 , base color

    valid1          dw    84 dup(?)
    valid1Size      dw    0
    isValid1        db    0

    valid2          dw    84 dup(?)
    valid2Size      dw    0
    isValid2        db    0

    colorOffset     dw    ?

    ;----------------------------------------------------------------------------------------------------
    ;                                               Array of Pieces
    ;----------------------------------------------------------------------------------------------------

                    array label word                                      ;label for the pieces array
    ;     Black Team
    bPawn1          dw    0,25d,10d,0d                                    ;Pawns
    bPawn2          dw    26d,25d,10d,0d
    bPawn3          dw    52d,25d,10d,0d
    bPawn4          dw    78d,25d,10d,0d
    bPawn5          dw    104d,25d,10d,0d
    bPawn6          dw    130d,25d,10d,0d
    bPawn7          dw    156d,25d,10d,0d
    bPawn8          dw    182d,25d,10d,0d

    bRook1          dw    0,0d ,11d,0d                                    ;Rooks
    bRook2          dw    182d,0d,11d,0d

    bHorse1         dw    26d,0d,12d,0d                                   ;Horses
    bHorse2         dw    156d,0d,12d,0d

    bBishop1        dw    52d,0d,13d,0d                                   ;Bishops
    bBishop2        dw    130d,0d,13d,0d

    bQueen          dw    78d,0d,14d,0d                                   ;Queen
    bKing           dw    104,0d,15d,0d                                   ;King

    ;     White Team
    wPawn1          dw    00d,150d,00d,0d                                 ;Pawns
    wPawn2          dw    26d,150d,00d,0d
    wPawn3          dw    52d,150d,00d,0d
    wPawn4          dw    78d,150d,00d,0d
    wPawn5          dw    104d,150d,00d,0d
    wPawn6          dw    130d,150d,00d,0d
    wPawn7          dw    156d,150d,00d,0d
    wPawn8          dw    182d,150d,00d,0d

    wRook1          dw    0,175d,01d,0d                                   ;Rooks
    wRook2          dw    182d,175d,01d,0d

    wHorse1         dw    26d,175d,02d,0d                                 ;Horses
    wHorse2         dw    156d,175d,02d,0d

    wBishop1        dw    52d,175d,03d,0d                                 ;Bishops
    wBishop2        dw    130d,175d,03d,0d

    wQueen          dw    78d,175d,04d,0d                                 ;Queen
    wKing           dw    104,175d,05d,0d                                 ;King

    flag            dw    0d
    
    targetOffset1   dw    ?
    targetOffset2   dw    ?
    
    ;----------------------------------------------------------------------------------------------------
    ;                                               Flags
    ;----------------------------------------------------------------------------------------------------

    checkflag       dw    ?
    kingCheck       db    0
    checkingFlag    db    0
    continueFlag    db    1
    overlapFlag     db    0h                                              ;0 no overlap ff overlap


    spaceFlag       db    0d                                              ;0 waiting for first space press ff waiting for second space press
    enterFlag       db    0d                                              ;0 waiting for first enter press ff waiting for second enter press

    highlightFlag   db    5d                                              ;5 means continue highlighting 6 means stop highlighting
    onHighlight     db    0                                               ;To mark when the user is on a highlighted square

    winFlag         db    0
    userFlag        db    0
.code

    ;-------------------------------------------------------------------------------------------------------

main proc    far
                           mov   ax,@data
                           mov   ds,ax
                           mov   es,ax

    ;establishing the connection
                           MOV   DX,3fbh
                           MOV   AL,10000000b
                           OUT   DX,AL

                           MOV   DX,3f8h
                           MOV   AL,0ch
                           OUT   DX,AL

                           MOV   DX,3f9h
                           MOV   AL,00h
                           OUT   DX,AL

                           MOV   DX,3fbh
                           MOV   AL,00000011b
                           OUT   DX,AL

                           call  inputNames                   ;get the user names and store them

    toMainMenu:            
                           call  mainMenu

                           cmp   localMode,01
                           je    endProgram

                           cmp   localMode,3bh
                           jne   gameMode
                           
                           call  Chat

                           jmp   toMainMenu                   ;after exiting chat go to the main menu

    gameMode:              

                           call  printBoard                   ;print the initial board
                           call  clearInGameChat              ;clear the chat area
                           call  printUser1                   ;print the first user
                           call  printUser2                   ;print the second user

                           mov   ah,2ch                       ;will be used to calculate the length of the game
                           int   21h
                           mov   ch,cl
                           mov   cl,dh
                           mov   gameStarted,cx
                           mov   powerUpTime,cx
                          

    keepGoing:             
                           call  printStatusBar
                           call  moveLocal
                           call  moveNet
                           
                           cmp   localMode,3eh                ;F4
                           je    toMainMenu

                           call  isChecked
                           call  printPieces
                           int   21h
                           mov   ch,cl
                           mov   cl,dh
                           mov   dx,powerUpTime
                           add   dx,5d
                           cmp   cx,dx
                           jl    noPowerUp

                           mov   powerUpTime,cx
                           call  addPower

    noPowerUp:             
                          
                           call  checkCooldown
                           call  checkOverlap
                          
                           cmp   winFlag,0
                           je    keepGoing

    ;there's a winner
                           cmp   userFlag,1
                           jne   userReverse

                           cmp   winFlag,1
                           jne   whiteWins

                           mov   di,offset blackWon
                           jmp   gameFinished

    whiteWins:             
                           mov   di,offset whiteWon
                           jmp   gameFinished

    userReverse:           

                           cmp   winFlag,1
                           jne   blackWins

                           mov   di,offset whiteWon
                           jmp   gameFinished

    blackWins:             
                           mov   di,offset blackWon

    gameFinished:          
                           call  printWinner
    ;call  resetGame
    endProgram:            
                           mov   ah,4ch
                           int   21h
                           hlt
                           ret
main endp

    ;-------------------------------------------------------------------------------------------------------

printLines proc    near
                           pusha

                           mov   bx,xlength                   ;get the length of the segement
                           add   bx,cx
    xLoop:                 
                           inc   cx
                           int   10h
                           cmp   cx,bx
                           jne   xLoop

                           popa
                           ret
printLines endp

    ;-------------------------------------------------------------------------------------------------------

printSegment proc    near
                           pusha

                           mov   bx,yheight                   ;get the height of the segement
                           add   bx,dx
                           mov   ah,0ch
    yLoop:                 
                           int   10h
                           call  printLines                   ;print the width
                           inc   dx
                           cmp   dx,bx
                           jne   yLoop

                           popa
                           ret
printSegment endp

    ;-------------------------------------------------------------------------------------------------------
    ;                                                                              Print Square Procedure

printSQR proc    near
                           pusha                              ;to keep the data
        
                           mov   bx,25d
                           mov   yheight,bx
                           mov   bx,25d
                           mov   xlength,bx
                           call  printSegment

                           popa
                           ret
printSQR endp

    ;-------------------------------------------------------------------------------------------------------
    ;                                                                              Print Board at the Start

printBoard proc    near
                           pusha                              ;to keep the data
        
                           mov   ah,0
                           mov   al,13h
                           int   10h                          ;set the video mode to graphics mode
        
                           mov   cx,0                         ;set the x axis with 0
                           mov   dx,0                         ;set the y axis with 0
                           mov   bx,0                         ;set the color toggle with 0
    board:                 
                           cmp   bx,0                         ;check the color toggle to know what color to print
                           je    yellowSQR                    ;if 0 print yellow square
                           jne   redSQR                       ;if 1 print red square
    yellowSQR:                                                ;7h or 0eh
                           mov   al,07h                       ;0eh for yellow and 0ch for red
                           cmp   cx,182d                      ;if it's the last square in the row don't toggle the color
                           je    printS
                           mov   bx,1                         ;toggle color
                           jmp   printS
    redSQR:                
                           mov   al,1h                        ;try 1h or 0ch
                           cmp   cx,182d
                           je    printS
                           mov   bx,0
    printS:                
                           call  PrintSQR
                           add   cx,26d                       ;jump to the next place in the x axis
                           cmp   cx,200d
                           jle   board                        ;keep going if it's not the last square in the row
                           mov   cx,0                         ;reset the x axis when starting a new row
                           add   dx,25d                       ;change the y axis to go to the next row
                           cmp   dx,199d
                           jl    board                        ;if it's not the end of the
        
                           popa
                           ret
printBoard endp

    ;-------------------------------------------------------------------------------------------------------

clearInGameChat proc    near
                           pusha

                           mov   xlength,111d                 ;setting the coordinates
                           mov   cx,208d
                           mov   dx,0
                           mov   yheight,189d

                           mov   al,0                         ;the color
                           call  printSegment

                           mov   lastGameChatRow,0d           ;to the top line
                           mov   lastGameChatCol,66d

                           popa
                           ret
clearInGameChat endp

    ;-----------------------------------------------------------------------------------------------------------

highlight proc    near
                           pusha
                
                           push  bx

                           mov   bl,5d
                           mov   highlightFlag,bl             ;reset the highlight flag
                           
                           pop   bx

                           call  checkArray

                           cmp   bx,1d                        ;if it's user 1 (black)
                           jne   highlightForWhite

                           cmp   targetOffset1,308d           ;if it's empty highlight it blue
                           jne   blackSquareNotEmpty

                           call  setHighlight                 ;to put the board color in valid 1
                           mov   al,09h                       ;blue for user 1 (black)
                           call  printSQR                     ;print user 1 square
                        
                           mov   bx,valid1Size                ;get the array size
                           mov   valid1[bx+xaxis],cx          ;store the x axis
                           mov   valid1[bx+yaxis],dx          ;store the y axis
                           add   bx,6d                        ;increment the size
                           mov   valid1Size,bx

                           jmp   exitHighlight

    blackSquareNotEmpty:   

                           mov   bl,6d
                           mov   highlightFlag,bl             ;to stop highlighting

                           cmp   targetOffset1,128d
                           jl    exitHighlight                ;occupied by the same team so exit
                        
                           mov   bx,1
                           call  setHighlight                 ;to get the board color from valid 2 and put it in valid11
                           mov   al,0Ch
                           call  printSQR                     ;by the other team so highlight red
                        
                           mov   bx,valid1Size                ;get the array size
                           mov   valid1[bx+xaxis],cx          ;store the x axis
                           mov   valid1[bx+yaxis],dx          ;store the y axis
                           add   bx,6d                        ;increment the size
                           mov   valid1Size,bx
                        
                           jmp   exitHighlight                ;then exit
                            
    ;-------------------------------------------------------

    highlightForWhite:     

                           cmp   targetOffset2,308d           ;if it's empty highlight it purple
                           jne   whiteSquareNotEmpty
                      
                           call  setHighlight                 ;to put the board color in valid 2
                           mov   al,0dh                       ;purple for user 2 (white)
                           call  printSQR                     ;print user 2 square
                        
                           mov   bx,valid2Size                ;get the array size
                           mov   valid2[bx+xaxis],cx          ;store the x axis
                           mov   valid2[bx+yaxis],dx          ;store the y axis
                           add   bx,6d                        ;increment the size
                           mov   valid2Size,bx

                           jmp   exitHighlight

    whiteSquareNotEmpty:   

                           mov   bl,6d
                           mov   highlightFlag,bl             ;to stop highlighting

                           cmp   targetOffset2,128d
                           jge   exitHighlight                ;occupied by the same team so exit

                           mov   bx,2
                           call  setHighlight                 ;to get the board color from valid 1 and put it in valid 2
                           mov   al,0Ch
                           call  printSQR                     ;by the other team so highlight red

                           mov   bx,valid2Size                ;get the size of the array
                           mov   valid2[bx+xaxis],cx          ;store the x axis
                           mov   valid2[bx+yaxis],dx          ;store the y axis
                           add   bx,6d                        ;increment the size
                           mov   valid2Size,bx

    exitHighlight:         

                           popa
                           ret
highlight endp

    ;-----------------------------------------------------------------------------------------------------------

setHighlight proc    near
                           pusha

                           mov   ah,0dh                       ;get the previous color in al
                           int   10h
                           mov   ah,0

                           cmp   bx,1
                           jne   setHighlightWhite

                           cmp   al,0dh                       ;highlighted by the other team
                           je    highlighted1
                           cmp   al,0ah                       ;if it's highlighted by the user
                           je    colorFromUser2
                           cmp   al,6                         ;powerUp
                           je    highlighted1

                           mov   di,valid1Size                ;if it's a board color put it in the base location in the array
                           mov   valid1[di+4],ax
                           jmp   exitSetHighlight

    highlighted1:          

                           mov   di,valid1Size                ;get the size of valid 1
                           call  getBoardColor
                           mov   ah,0
                           mov   al,boardColor
                          
                           mov   valid1[di+4],ax              ;put the board color in it's place
                           jmp   exitSetHighlight

    colorFromUser2:        

                           mov   bh,0
                           mov   bl,user2PrevColor            ;get the bpard color from user 2
                           mov   di,valid1Size                ;get the size of valid 1
                           mov   valid1[di+4],bx              ;put the color in valid 1
                           jmp   exitSetHighlight

    ;--------------------------------------------------------

    setHighlightWhite:     

                           cmp   al,09h                       ;highlighted by the other team
                           je    highlighted2
                           cmp   al,0bh
                           je    colorFromUser1
                           cmp   al,6                         ;powerUp
                           je    highlighted2

                           mov   di,valid2Size                ;if it's a board color put it in the base location in the array
                           mov   valid2[di+4],ax
                           jmp   exitSetHighlight

    highlighted2:          

                           mov   di,valid2Size                ;get the size of valid 2

                           call  getBoardColor                ;get the base color from valid 2 and put it in the base

                           mov   ah,0
                           mov   al,boardColor


                           mov   valid2[di+4],ax              ;put the base color in it's place
                           jmp   exitSetHighlight

    colorFromUser1:        

                           mov   bh,0
                           mov   bl,user1PrevColor
                           mov   di,valid2Size
                           mov   valid2[di+4],bx

    exitSetHighlight:      
                           popa
                           ret
setHighlight endp

    ;-----------------------------------------------------------------------------------------------------------
    ;                                                                              Print User1 Procedure

printUser1 proc    near
                           pusha
                
                           mov   cx,user1Pos[xaxis]
                           mov   dx,user1Pos[yaxis]           ;get the position of user1 before printing
        
                           mov   bx,0                         ;page 0
                           mov   ah,0dh
                           int   10h                          ;read pixel color interrupt

                           cmp   al,0dh
                           je    getColor1                    ;if it's purple
                           cmp   al,09h
                           je    getColor1                    ;if it's lightblue
                           cmp   al,0ch
                           je    getColor1

                           mov   user1PrevColor,al            ;save the previous color of user1
                           jmp   printHim1

    getColor1:             

                           call  getBoardColor                ;get the color from valid 1 or 2 and save it
                           mov   al,boardColor
                           mov   user1PrevColor,al

    printHim1:             

                           mov   al,0bh                       ;blue color for user1
                           call  printSQR                     ;print user1 square
        
                           popa
                           ret
printUser1 endp

    ;-------------------------------------------------------------------------------------------------------

printUser2 proc    near
                           pusha
                
                           mov   cx,user2Pos[xaxis]
                           mov   dx,user2Pos[yaxis]           ;get the position of user1 before printing

                           mov   bx,0                         ;page 0
                           mov   ah,0dh
                           int   10h                          ;read pixel color interrupt
                          
                           cmp   al,0dh
                           je    getColor2                    ;if it's purple
                           cmp   al,09h
                           je    getColor2                    ;if it's lightblue
                           cmp   al,0ch
                           je    getColor2

                           mov   user2PrevColor,al            ;save the previous color of user1
                           jmp   printHim2

    getColor2:             

                           call  getBoardColor                ;if the new
                           mov   al,boardColor
                           mov   user2PrevColor,al

    printHim2:             

                           mov   al,0ah                       ;green color for user2
                           call  printSQR                     ;print user2 square
        
                           popa
                           ret
printUser2 endp

    ;-------------------------------------------------------------------------------------------------------

getBoardColor proc    near
                           pusha

                           mov   ax,cx
                           mov   cl,26d
                           div   cl
                           mov   cx,ax                        ;cx and ax now has cx/26

                           mov   ax,dx
                           mov   dl,25d
                           div   dl                           ;al now has dx/25

                           add   al,cl                        ;add cx/26 + dx/25
                           and   al,1                         ;ah now has the remainder of (cx/26 + dx/25) / 2 (odd or even)

                           cmp   al,1
                           je    oddSQR

                           mov   bl,07h                       ;blue
                           jmp   exitGetBoardColor

    oddSQR:                
                           mov   bl,01h                       ;grey

    exitGetBoardColor:     
                           mov   boardColor,bl
                           mov   bl,1d
                           mov   onHighlight,bl
                           popa
                           ret
getBoardColor endp


    ;-------------------------------------------------------------------------------------------------------
    ;                                                                               Move Users Procedure

moveNet proc    near
                           pusha

                           mov   dx,3fdh
                           in    ax,dx
                           and   al,1
                           jz    exitMoveNet

                           mov   dx,3f8h
                           in    al,dx

                           cmp   al,3eh                       ;F4
                           jne   readNetMove

                           call  resetGame
                           mov   localmode,al                 ;both exit the game
                           mov   netmode,al

                           jmp   exitMoveNet

    readNetMove:           
                           cmp   al,48h                       ;up
                           je    goNetDown
                        
                           cmp   al,4dh                       ;right
                           je    goNetRight
                        
                           cmp   al,50h                       ;down
                           je    goNetUp
                        
                           cmp   al,4bh                       ;left
                           je    goNetLeft

                           cmp   al,28d                       ;enter
                           je    netEntGame

                           call  gameChatRec
                           jmp   exitMoveNet

    goNetUp:               
                           mov   cx,user1Pos[xaxis]
                           mov   dx,user1Pos[yaxis]           ;get the position of user1
                           cmp   dx,0d
                           je    exitMoveNet                  ;can't go up when you're at the top of the board
                           mov   al,user1PrevColor            ;get the previous color of the square of user1
                           call  printSQR
                           sub   dx,25d
                           mov   user1Pos[yaxis],dx           ;set the position of the user with new position
                           call  printUser1                   ;print user 1 with the new position
                           mov   bl,2                         ;used to fix overlap
                           call  fixOverlap
                           cmp   onHighlight,1
                           je    finishNetMove                ;check the highlight Flags and re-Highlight to fix any problem
                           jmp   exitMoveNet

    goNetRight:            
                           mov   cx,user1Pos[xaxis]
                           mov   dx,user1Pos[yaxis]           ;get the position of user1
                           cmp   cx,182d
                           je    exitMoveNet                  ;can't go right when you're at the right border of the board
                           mov   al,user1PrevColor            ;get the previous color of the square of user1
                           call  printSQR
                           add   cx,26d
                           mov   user1Pos[xaxis],cx           ;set the position of the user with new position
                           call  printUser1                   ;print user 1 with the new position
                           mov   bl,2                         ;used to fix overlap
                           call  fixOverlap
                           cmp   onHighlight,1
                           je    finishNetMove                ;check the highlight Flags and re-Highlight to fix any problem
                           jmp   exitMoveNet

    goNetDown:             
                           mov   cx,user1Pos[xaxis]
                           mov   dx,user1Pos[yaxis]           ;get the position of user1
                           cmp   dx,175d
                           je    exitMoveNet                  ;can't go down when you're at the bottom of the board
                           mov   al,user1PrevColor            ;get the previous color of the square of user1
                           call  printSQR
                           add   dx,25d
                           mov   user1Pos[yaxis],dx           ;set the position of the user with new position
                           call  printUser1                   ;print user 1 with the new position
                           mov   bl,2                         ;used to fix overlap
                           call  fixOverlap
                           cmp   onHighlight,1
                           je    finishNetMove                ;check the highlight Flags and re-Highlight to fix any problem
                           jmp   exitMoveNet

    goNetLeft:             
                           mov   cx,user1Pos[xaxis]
                           mov   dx,user1Pos[yaxis]           ;get the position of user1
                           cmp   cx,0d
                           je    exitMoveNet                  ;can't go left when you're at the left border of the board
                           mov   al,user1PrevColor            ;get the previous color of the square of user1
                           call  printSQR
                           sub   cx,26d
                           mov   user1Pos[xaxis],cx           ;set the position of the user with new position
                           call  printUser1                   ;print user 1 with the new position
                           mov   bl,2                         ;used to fix overlap
                           call  fixOverlap
                           cmp   onHighlight,1
                           je    finishNetMove                ;check the highlight Flags and re-Highlight to fix any problem
                           jmp   exitMoveNet

    netEntGame:            
                           mov   bl,spaceFlag
                           cmp   bl,0d                        ;check the flag
                           jne   space2
    
                           mov   cx,user1Pos[xaxis]
                           mov   dx,user1Pos[yaxis]
                           mov   bx,1d
                           call  searchArray

                           mov   bx,movingOffset1
                           cmp   bx,128d                      ;user 1 can't move white pieces
                           jge   exitMoveNet
                           cmp   bx,308d
                           je    exitMoveNet                  ;no piece in that square

                           pusha
                           mov   bx,array[bx+6]               ;get the cooldown of thag piece
                           mov   ah,2ch                       ;get the current time
                           int   21h
                           mov   dl,dh
                           mov   dh,cl                        ;put in dx -> dl = seconds      dh = minutes
                           cmp   dx,bx
                           jge   time1Passed
                           popa                               ;if it's in cooldown pop and clear the buffer
                           jmp   finishNetMove

    time1Passed:           
                           popa

                           mov   bl,0ffh                      ;toggle the flag
                           mov   spaceFlag,bl

    ;------------------------------------------------

                           mov   movingPiece1[xaxis],cx       ;put the position in moving piece 2
                           mov   movingPiece1[yaxis],dx


                           push  ax
                           mov   ax,user1Pos[typ]
                           mov   movingPiece1[typ],ax         ;set the type of the moving piece
                           pop   ax
                           mov   bl,user1PrevColor            ;copy the previous color too
                           mov   movingColor1,bl
                        
    ;---------------------------------------------------

                           jmp   finishNetMove                ;check the highlight Flags and re-Highlight to fix any problem

    ;---------------------------------------------------

    space2:                
                           mov   bx,1
                           call  checkValid
                           call  clearHighlight

                           cmp   isValid1,1
                           jne   notValidMove1

                           call  checkKill1
                           call  printMoving1
                           call  clearMoving1
                          
    notValidMove1:         
                          
                           mov   bx,0
                           mov   valid1Size,bx
                           mov   isValid1,bl

    finishNetMove:         
                           mov   bl,0
                           mov   onHighlight,bl               ;reset the flag
                            
                           cmp   spaceFlag,0ffh               ;if it's not up skip it
                           jne   checkEnterFlagN

                           mov   bx,1
                           call  clearHighlight               ;clear the highlighted squares
                           mov   valid1Size,0

                           cmp   movingOffset1,308d           ;if the user isn't moving a piece don't highlight
                           je    checkEnterFlagN

                           call  highlightMoves
                           call  printBoth

    checkEnterFlagN:       
                           call  printBoth
                           cmp   enterFlag,0ffh
                           jne   exitMoveNet

                           mov   bx,2
                           call  clearHighlight
                           mov   valid2Size,0

                           mov   ah,1
                           int   16h
                           jnz   checkEnterMovingN
                          
                           call  highlightMoves
                           call  printBoth
                           jmp   exitMoveNet

    checkEnterMovingN:     
                           cmp   movingOffset2,308d
                           je    exitMoveNet

                           call  highlightMoves
                           call  printBoth                    ;print both players to fix if there way an overlap

    exitMoveNet:           
                           popa
                           ret
moveNet endp

    ;-------------------------------------------------------------------------------------------------------

moveLocal proc    near                                        ;333333333333333333
                           pusha

                           mov   ah,1
                           int   16h
                           jz    emptyBuffer

                           cmp   ah,3eh                       ;check for f4
                           jne   didntExit

                           mov   dx,3f8h
                           mov   al,ah
                           out   dx,al

                           call  resetGame
                           mov   localMode,ah
                           mov   netMode,ah

                           jmp   clearBuffer

    didntExit:             
                           cmp   ah,48h                       ;up arrow
                           je    goLocalUp

                           cmp   ah,4dh                       ;right arrow
                           je    goLocalRight

                           cmp   ah,50h                       ;down arrow
                           je    goLocalDown

                           cmp   ah,4bh                       ;left arrow
                           je    goLocalLeft

                           cmp   ah,28d                       ;enter
                           je    ent

                           mov   DX,3f8h
                           OUT   DX,al
                           mov   si,1

                           jmp   clearBuffer
                          
    ;                               ;user 2 (arrows + enter)

    goLocalUp:             
                           mov   dx,3f8h
                           mov   al,ah
                           out   dx,al

                           mov   cx,user2Pos[0]
                           mov   dx,user2Pos[2]               ;get the position of user2
                           cmp   dx,0d
                           je    clearBuffer                  ;can't go up when you're at the top of the board
                           mov   al,user2PrevColor            ;get the previous color of the square of user2
                           call  printSQR
                           sub   dx,25d
                           mov   user2Pos[2],dx               ;set the position of the user with new position
                           call  printUser2                   ;print user 2 with the new position
                           mov   bl,1                         ;used to fix overlap
                           call  fixOverlap
                           cmp   onHighlight,1
                           je    finishMove                   ;check the highlight Flags and re-Highlight to fix any problem
                           jmp   clearBuffer

    goLocalRight:          
                           mov   dx,3f8h
                           mov   al,ah
                           out   dx,al

                           mov   cx,user2Pos[0]
                           mov   dx,user2Pos[2]               ;get the position of user2
                           cmp   cx,182d
                           je    clearBuffer                  ;can't go right when you're at the right border of the board
                           mov   al,user2PrevColor            ;get the previous color of the square of user2
                           call  printSQR
                           add   cx,26d
                           mov   user2Pos[0],cx               ;set the position of the user with new position
                           call  printUser2                   ;print user 2 with the new position
                           mov   bl,1                         ;used to fix overlap
                           call  fixOverlap
                           cmp   onHighlight,1
                           je    finishMove                   ;check the highlight Flags and re-Highlight to fix any problem
                           jmp   clearBuffer

    goLocalDown:           
                           mov   dx,3f8h
                           mov   al,ah
                           out   dx,al

                           mov   cx,user2Pos[0]
                           mov   dx,user2Pos[2]               ;get the position of user2
                           cmp   dx,175d
                           je    clearBuffer                  ;can't go down when you're at the bottom of the board
                           mov   al,user2PrevColor            ;get the previous color of the square of user2
                           call  printSQR
                           add   dx,25d
                           mov   user2Pos[2],dx               ;set the position of the user with new position
                           call  printUser2                   ;print user 2 with the new position
                           mov   bl,1                         ;used to fix overlap
                           call  fixOverlap
                           cmp   onHighlight,1
                           je    finishMove                   ;check the highlight Flags and re-Highlight to fix any problem
                           jmp   clearBuffer

    goLocalLeft:           
                           mov   dx,3f8h
                           mov   al,ah
                           out   dx,al

                           mov   cx,user2Pos[0]
                           mov   dx,user2Pos[2]               ;get the position of user2
                           cmp   cx,0d
                           je    clearBuffer                  ;can't go left when you're at the left border of the board
                           mov   al,user2PrevColor            ;get the previous color of the square of user2
                           call  printSQR
                           sub   cx,26d
                           mov   user2Pos[0],cx               ;set the position of the user with new position
                           call  printUser2                   ;print user 2 with the new position
                           mov   bl,1                         ;used to fix overlap
                           call  fixOverlap
                           cmp   onHighlight,1
                           je    finishMove                   ;check the highlight Flags and re-Highlight to fix any problem
                           jmp   clearBuffer

    ent:                   
                           mov   dx,3f8h
                           mov   al,ah
                           out   dx,al
                          
                           mov   bl,enterFlag
                           cmp   bl,0d                        ;check the flag
                           jne   ent2

                           mov   cx,user2Pos[0]
                           mov   dx,user2Pos[2]
                           mov   bx,2d
                           call  searchArray

                           mov   bx,movingOffset2
                           cmp   bx,128d                      ;user 2 can't move black pieces
                           jl    clearBuffer
                           cmp   bx,308d
                           je    clearBuffer                  ;no piece in that square

                           pusha
                           mov   bx,array[bx+6]               ;get the cooldown of thag piece
                           mov   ah,2ch                       ;get the current time
                           int   21h
                           mov   dl,dh
                           mov   dh,cl                        ;put in dx -> dl = seconds      dh = minutes
                           cmp   dx,bx
                           jge   time2Passed
                           popa                               ;if it's in cooldown pop and clear the buffer
                           jmp   clearBuffer

    time2Passed:           
                           popa
                           mov   bl,0ffh                      ;toggle the flag
                           mov   enterFlag,bl

                           mov   movingPiece2[xaxis],cx       ;put the position in moving piece 2
                           mov   movingPiece2[yaxis],dx

                           push  ax
                           mov   ax,user2Pos[typ]
                           mov   movingPiece2[typ],ax
                           pop   ax
                           mov   bl,user2PrevColor            ;copy the previous color too
                           mov   movingColor2,bl

                           mov   bx,2
                           jmp   finishMove                   ;check the highlight Flags and re-Highlight to fix any problem
                
    ent2:                  
                           mov   bx,2
                           call  checkValid                   ;check if it's a valid move
                           call  clearHighlight               ;anyway clear the highlight
                        
                           cmp   isValid2,1                   ;if not valid jump
                           jne   notValidMove2

                           call  checkKill2                   ;check if there's a kill
                           call  printMoving2                 ;set the moved piece position
                           call  clearMoving2                 ;clear the previous square

    notValidMove2:         
                          
                           mov   bx,0
                           mov   valid2Size,bx                ;reset the size and the validity flag
                           mov   isValid2,bl
                          
    finishMove:            

                           mov   bl,0
                           mov   onHighlight,bl               ;reset the flag
                            
                           cmp   spaceFlag,0ffh               ;if it's not up skip it
                           jne   checkEnterFlag

                           mov   bx,1
                           call  clearHighlight               ;clear the highlighted squares
                           mov   valid1Size,0

                           cmp   movingOffset1,308d           ;if the user isn't moving a piece don't highlight
                           je    checkEnterFlag

                           call  highlightMoves
                           call  printBoth

    checkEnterFlag:        
                           call  printBoth
                           cmp   enterFlag,0ffh
                           jne   clearBuffer

                           mov   bx,2
                           call  clearHighlight
                           mov   valid2Size,0

                           mov   ah,1
                           int   16h
                           jnz   checkEnterMoving
                          
                           call  highlightMoves
                           call  printBoth
                           jmp   clearBuffer

    checkEnterMoving:      
                           cmp   movingOffset2,308d
                           je    clearBuffer

                           call  highlightMoves
                           call  printBoth                    ;print both players to fix if there way an overlap

    clearBuffer:           
                           mov   ah,00h
                           int   16h                          ;clear the buffer

    emptyBuffer:           
                           popa
                           ret
moveLocal endp

    ;-------------------------------------------------------------------------------------------------------

printMoving1 proc    near
                           pusha

                           mov   cx,user1Pos[0]
                           mov   dx,user1Pos[2]
                           mov   bx,movingOffset1
                           mov   array[bx+0],cx
                           mov   array[bx+2],dx

                           push  cx
                           push  dx
                          
                           mov   ah,2ch
                           int   21h
                           mov   dl,dh
                           mov   dh,cl
                           mov   ax,dx
                          
                           pop   dx
                           pop   cx

                           cmp   cx,powerUp[xaxis]
                           jne   normalCoolDown1
                           cmp   dx,powerUp[yaxis]
                           jne   normalCoolDown1
                           cmp   powerOn,1
                           jne   normalCoolDown1

                           add   ax,2d
                           mov   powerOn,ah
                           jmp   exitPrintMoving1

    normalCoolDown1:       
                           add   ax,3d
    exitPrintMoving1:      
                           mov   array[bx+6],ax

                           popa
                           ret
printMoving1 endp

    ;-------------------------------------------------------------------------------------------------------

clearMoving1 proc    near
                           pusha

                           mov   al,movingColor1
                           mov   cx,movingPiece1[0]
                           mov   dx,movingPiece1[2]
                           call  printSQR

                           popa
                           ret
clearMoving1 endp

    ;-------------------------------------------------------------------------------------------------------

printMoving2 proc    near
                           pusha

                           mov   cx,user2Pos[0]
                           mov   dx,user2Pos[2]
                           mov   bx,movingOffset2
                           mov   array[bx+0],cx
                           mov   array[bx+2],dx
    
                           push  cx
                           push  dx
                          
                           mov   ah,2ch
                           int   21h
                           mov   dl,dh
                           mov   dh,cl
                           mov   ax,dx
                          
                           pop   dx
                           pop   cx

                           cmp   cx,powerUp[xaxis]
                           jne   normalCoolDown2
                           cmp   dx,powerUp[yaxis]
                           jne   normalCoolDown2
                           cmp   powerOn,1d
                           jne   normalCoolDown2

                           add   ax,2d
                           mov   powerOn,ah
                           jmp   exitPrintMoving2

    normalCoolDown2:       
                           add   ax,3d
    exitPrintMoving2:      
                           mov   array[bx+6],ax

                           popa
                           ret
printMoving2 endp

    ;-------------------------------------------------------------------------------------------------------

clearMoving2 proc    near
                           pusha

                           mov   al,movingColor2
                           mov   cx,movingPiece2[0]
                           mov   dx,movingPiece2[2]
                           call  printSQR
                           popa
                           ret
clearMoving2 endp

    ;-------------------------------------------------------------------------------------------------------

printBoth proc near                                           ;to avoid printing a square over a user
                           pusha

                           mov   bl,user1PrevColor
                           call  printUser1
                           mov   user1PrevColor,bl

                           mov   bl,user2PrevColor
                           call  printUser2
                           mov   user2PrevColor,bl
                           popa
                           ret
printBoth endp

    ;-------------------------------------------------------------------------------------------------------

checkOverlap proc    near
                           pusha

                           mov   ax,user1Pos[0]
                           mov   bx,user1Pos[2]
                           mov   cx,user2Pos[0]
                           mov   dx,user2Pos[2]

                           cmp   ax,cx
                           jne   exitOverlap
                           cmp   dx,bx
                           jne   exitOverlap

                           mov   bl,0ffh
                           mov   overlapFlag,bl
                           mov   bh,user1PrevColor
                           cmp   bh,0ah                       ;if user 1 is on user 2
                           jne   switch
                           mov   bh,user2PrevColor
                           mov   user1PrevColor,bh
                           jmp   exitOverlap

    switch:                
                           mov   user2PrevColor,bh

    exitOverlap:           
                           popa
                           ret
checkOverlap endp

    ;-------------------------------------------------------------------------------------------------------

fixOverlap proc    near
                           pusha
                           mov   bh,overlapFlag
                           cmp   bh,0d                        ;no overlap happened
                           je    exitOverlapFix

                           cmp   bl,1                         ;need to print user 1
                           jne   fixOtherUser

                           call  printUser1                   ;print user 1
                           jmp   exitOverlapFix

    fixOtherUser:          
                           call  printUser2                   ;print user 2
    exitOverlapFix:        
                           mov   bh,0
                           mov   overlapFlag,bh
                           popa
                           ret
fixOverlap endp

    ;-------------------------------------------------------------------------------------------------------

checkKill1 proc    near
                           pusha

                           mov   cx,user1Pos[0]               ;get the position of user1
                           mov   dx,user1Pos[2]

                           mov   bx,1                         ;needed for check array
                           call  checkArray
                           mov   bx,targetOffset1
                      
                           cmp   targetOffset1,128d
                           jl    exitKill1                    ;if it's the same team don't kill
                           cmp   bx,308d
                           je    exitKill1                    ;if it's empty don't kill

                           cmp   bx,movingOffset2             ;if the position is occupied by the other team and it's moving kill it and remove it from movingOffset
                           jne   kill1
                           mov   cx,308d
                           mov   movingOffset2,cx
                    
    kill1:                 

                           mov   cx,123d                      ;to mark he's killed
                           mov   array[bx],cx
                          
    exitKill1:             
                           popa
                           ret
checkKill1 endp

    ;-------------------------------------------------------------------------------------------------------

checkKill2 proc    near
                           pusha

                           mov   cx,user2Pos[0]
                           mov   dx,user2Pos[2]

                           mov   bx,2
                           call  checkArray
                           mov   bx,targetOffset2
                      
                           cmp   targetOffset2,128d
                           jge   noKill2                      ;if it's empty don't kill
                           cmp   bx,308d
                           je    kill2

                           cmp   bx,movingOffset1
                           jne   kill2
                           mov   cx,308d
                           mov   movingOffset1,cx
                    
    kill2:                 

                           mov   cx,123d                      ;to mark he's killed
                           mov   array[bx],cx

    noKill2:               
                           popa
                           ret
checkKill2 endp

    ;-------------------------------------------------------------------------------------------------------

checkCooldown proc    near
                           pusha

                           mov   di,0                         ;8888

                           mov   ah,2ch                       ;will be used to calculate the length of the game
                           int   21h
                           mov   ch,cl
                           mov   cl,dh

                           mov   bx,cx                        ;bx has the current time

                           sub   di,8

    cooldownLoop:          
                           add   di,8
                          
                           cmp   di,arraysize
                           jge   coolLoopEnd

                           cmp   array[di+xaxis],123d
                           je    cooldownLoop
                          
                           mov   cx,array[di+6]               ;get the time of the piece
                           cmp   bx,cx
                           jge   clearCool

                           mov   cx,array[di+xaxis]
                           mov   dx,array[di+yaxis]
                           call  printCooldown

                           jmp   cooldownLoop

    clearCool:             
                           mov   cx,array[di+xaxis]
                           mov   dx,array[di+yaxis]

                           call  clearCooldown
                           jmp   cooldownLoop
    coolLoopEnd:           
                           popa
                           ret
checkCooldown endp

    ;-------------------------------------------------------------------------------------------------------

printCooldown proc    near
                           pusha

                           add   cx,3d
                           add   dx,22d

                           mov   xlength,20d
                           mov   yheight,3d
                           mov   al,0eh
                           call  printSegment

                           popa
                           ret
printCooldown endp

    ;-------------------------------------------------------------------------------------------------------

clearCooldown proc    near
                           pusha

                           call  getBoardColor
                           mov   al,boardColor

                           add   cx,3d
                           add   dx,22d

                           mov   xlength,20d
                           mov   yheight,3d

                           call  printSegment

                           popa
                           ret
clearCooldown endp

    ;-------------------------------------------------------------------------------------------------------

printPawn proc    near
                           pusha

                           add   cx,10d
                           add   dx,7d
                           mov   bx,6d
                           mov   xlength,bx
                           mov   bx,2d
                           mov   yheight,bx
                           call  printSegment

                           sub   cx,1d
                           add   dx,2d
                           mov   bx,8d
                           mov   xlength,bx
                           mov   bx,2d
                           mov   yheight,bx
                           call  printSegment

                           add   cx,1d
                           add   dx,2d
                           mov   bx,6d
                           mov   xlength,bx
                           mov   bx,5d
                           mov   yheight,bx
                           call  printSegment

                           sub   cx,2d
                           add   dx,5d
                           mov   bx,10d
                           mov   xlength,bx
                           mov   bx,3d
                           mov   yheight,bx
                           call  printSegment

                           sub   cx,3d
                           add   dx,3d
                           mov   bx,16d
                           mov   xlength,bx
                           mov   bx,3d
                           mov   yheight,bx
                           call  printSegment

                           popa
                           ret
printPawn endp

    ;-------------------------------------------------------------------------------------------------------

printRook proc    near
                           pusha

                           add   cx,4d
                           add   dx,3d
                           mov   bx,2d
                           mov   xlength,bx
                           mov   bx,2d
                           mov   yheight,bx
                           call  printSegment

                           add   cx,4d
                           call  printSegment

                           add   cx,4d
                           call  printSegment

                           add   cx,4d
                           call  printSegment

                           add   cx,4d
                           call  printSegment

                           sub   cx,16d
                           add   dx,2d
                           mov   bx,18d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,2d
                           add   dx,2d
                           mov   bx,14d
                           mov   xlength,bx
                           mov   bx,8d
                           mov   yheight,bx
                           call  printSegment

                           sub   cx,2d
                           add   dx,8d
                           mov   bx,18d
                           mov   xlength,bx
                           mov   bx,3d
                           mov   yheight,bx
                           call  printSegment

                           sub   cx,1d
                           add   dx,3d
                           mov   bx,20d
                           mov   xlength,bx
                           mov   bx,4d
                           mov   yheight,bx
                           call  printSegment

                           popa
                           ret
printRook endp

    ;-------------------------------------------------------------------------------------------------------

printPieces proc    near
                           pusha
                           cmp   userFlag,1
                           jne   reverseColor
                           mov   al,0fh                       ;White Team
                           jmp   startPieces

    reverseColor:          

                           mov   al,00h

    startPieces:           

                           mov   cx,wPawn1[xaxis]             ;pawns
                           cmp   cx,123d
                           je    wP1Killed
                           mov   dx,wPawn1[yaxis]
                           call  printPawn
    wP1Killed:             

                           mov   cx,wPawn2[xaxis]
                           cmp   cx,123d
                           je    wP2Killed
                           mov   dx,wPawn2[yaxis]
                           call  printPawn
    wP2Killed:             

                           mov   cx,wPawn3[xaxis]
                           cmp   cx,123d
                           je    wP3Killed
                           mov   dx,wPawn3[yaxis]
                           call  printPawn
    wP3Killed:             

                           mov   cx,wPawn4[xaxis]
                           cmp   cx,123d
                           je    wP4Killed
                           mov   dx,wPawn4[yaxis]
                           call  printPawn
    wP4Killed:             

                           mov   cx,wPawn5[xaxis]
                           cmp   cx,123d
                           je    wP5Killed
                           mov   dx,wPawn5[yaxis]
                           call  printPawn
    wP5Killed:             

                           mov   cx,wPawn6[xaxis]
                           cmp   cx,123d
                           je    wP6Killed
                           mov   dx,wPawn6[yaxis]
                           call  printPawn
    wP6Killed:             

                           mov   cx,wPawn7[xaxis]
                           cmp   cx,123d
                           je    wP7Killed
                           mov   dx,wPawn7[yaxis]
                           call  printPawn
    wP7Killed:             

                           mov   cx,wPawn8[xaxis]
                           cmp   cx,123d
                           je    wP8Killed
                           mov   dx,wPawn8[yaxis]
                           call  printPawn                    ;Last Pawn
    wP8Killed:             


                           mov   cx,wRook1[xaxis]             ;Rooks
                           cmp   cx,123d
                           je    wRook1Killed
                           mov   dx,wRook1[yaxis]
                           call  PrintRook
    wRook1Killed:          

                           mov   cx,wRook2[xaxis]
                           cmp   cx,123d
                           je    wRook2Killed
                           mov   dx,wRook2[yaxis]
                           call  printRook
    wRook2Killed:          

                           mov   cx,wHorse1[xaxis]            ;Horses
                           cmp   cx,123d
                           je    wHorse1Killed
                           mov   dx,wHorse1[yaxis]
                           call  printHorse
    wHorse1Killed:         

                           mov   cx,wHorse2[xaxis]
                           cmp   cx,123d
                           je    wHorse2Killed
                           mov   dx,wHorse2[yaxis]
                           call  printHorse
    wHorse2Killed:         

                           mov   cx,wBishop1[xaxis]           ;Bishops
                           cmp   cx,123d
                           je    wBishop1Killed
                           mov   dx,wBishop1[yaxis]
                           call  printBishop
    wBishop1Killed:        

                           mov   cx,wBishop2[xaxis]
                           cmp   cx,123d
                           je    wBishop2Killed
                           mov   dx,wBishop2[yaxis]
                           call  printBishop
    wBishop2Killed:        

                           mov   cx,wQueen[xaxis]             ;Queen
                           cmp   cx,123d
                           je    wQueenKilled
                           mov   dx,wQueen[yaxis]
                           call  printQueen
    wQueenKilled:          

                           mov   cx,wKing[xaxis]              ;King
                           cmp   cx,123d
                           je    wKingKilled
                           mov   dx,wKing[yaxis]
                           call  printKing
                           jmp   printBlackTeam
    wKingKilled:           
                           mov   cl,1d                        ;black (1) team won
                           mov   winFlag,cl

    printBlackTeam:        

                           not   al                           ;Black Team
                           and   al,00001111b
                     
                           mov   cx,bPawn1[xaxis]             ;Pawns
                           cmp   cx,123d
                           je    bPawn1Killed
                           mov   dx,bPawn1[yaxis]
                           call  printPawn
    bPawn1Killed:          

                           mov   cx,bPawn2[xaxis]
                           cmp   cx,123d
                           je    bPawn2Killed
                           mov   dx,bPawn2[yaxis]
                           call  printPawn
    bPawn2Killed:          

                           mov   cx,bPawn3[xaxis]
                           cmp   cx,123d
                           je    bPawn3Killed
                           mov   dx,bPawn3[yaxis]
                           call  printPawn
    bPawn3Killed:          

                           mov   cx,bPawn4[xaxis]
                           cmp   cx,123d
                           je    bPawn4Killed
                           mov   dx,bPawn4[yaxis]
                           call  printPawn
    bPawn4Killed:          

                           mov   cx,bPawn5[xaxis]
                           cmp   cx,123d
                           je    bPawn5Killed
                           mov   dx,bPawn5[yaxis]
                           call  printPawn
    bPawn5Killed:          

                           mov   cx,bPawn6[xaxis]
                           cmp   cx,123d
                           je    bPawn6Killed
                           mov   dx,bPawn6[yaxis]
                           call  printPawn
    bPawn6Killed:          

                           mov   cx,bPawn7[xaxis]
                           cmp   cx,123d
                           je    bPawn7Killed
                           mov   dx,bPawn7[yaxis]
                           call  printPawn
    bPawn7Killed:          

                           mov   cx,bPawn8[xaxis]
                           cmp   cx,123d
                           je    bPawn8Killed
                           mov   dx,bPawn8[yaxis]
                           call  printPawn                    ;Last Pawn
    bPawn8Killed:          

                           mov   cx,bRook1[xaxis]             ;Rooks
                           cmp   cx,123d
                           je    bRook1Killed
                           mov   dx,bRook1[yaxis]
                           call  PrintRook
    bRook1Killed:          

                           mov   cx,bRook2[xaxis]
                           cmp   cx,123d
                           je    bRook2Killed
                           mov   dx,bRook2[yaxis]
                           call  printRook
    bRook2Killed:          

                           mov   cx,bHorse1[xaxis]            ;Horses
                           cmp   cx,123d
                           je    bHorse1Killed
                           mov   dx,bHorse1[yaxis]
                           call  printHorse
    bHorse1Killed:         

                           mov   cx,bHorse2[xaxis]
                           cmp   cx,123d
                           je    bHorse2Killed
                           mov   dx,bHorse2[yaxis]
                           call  printHorse
    bHorse2Killed:         

                           mov   cx,bBishop1[xaxis]           ;Bishops
                           cmp   cx,123d
                           je    bBishop1Killed
                           mov   dx,bBishop1[yaxis]
                           call  printBishop
    bBishop1Killed:        

                           mov   cx,bBishop2[xaxis]
                           cmp   cx,123d
                           je    bBishop2Killed
                           mov   dx,bBishop2[yaxis]
                           call  printBishop
    bBishop2Killed:        

                           mov   cx,bQueen[xaxis]             ;Queen
                           cmp   cx,123d
                           je    bQueenKilled
                           mov   dx,bQueen[yaxis]
                           call  printQueen
    bQueenKilled:          

                           mov   cx,bKing[xaxis]              ;King
                           cmp   cx,123d
                           je    bKingKilled
                           mov   dx,bKing[yaxis]
                           call  printKing
                           jmp   printPiecesEnd
    bKingKilled:           
                           mov   cl,2d                        ;white team (2) won
                           mov   winFlag,cl
   
    printPiecesEnd:        
                           popa
                           ret
printPieces endp

    ;-------------------------------------------------------------------------------------------------------

printHorse proc    near
                           pusha

                           add   cx,5d
                           add   dx,1d
                           mov   bx,12d
                           mov   xlength,bx
                           mov   bx,2d
                           mov   yheight,bx
                           call  printSegment

                           sub   cx,1d
                           add   dx,2d
                           mov   bx,14d
                           mov   xlength,bx
                           call  printSegment

                           sub   cx,1d
                           add   dx,2d
                           mov   bx,16d
                           mov   xlength,bx
                           call  printSegment

                           sub   cx,1d
                           add   dx,2d
                           mov   bx,18d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,1d
                           add   dx,2d
                           mov   bx,8d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,12d                       ;seperation
                           mov   bx,7d
                           mov   xlength,bx
                           call  printSegment
                                            
                           sub   cx,11d                       ;nose
                           add   dx,2d
                           mov   bx,10d
                           mov   xlength,bx
                           mov   bx,4d
                           mov   yheight,bx
                           call  printSegment

                           add   cx,14d                       ;seperation
                           mov   bx,5d
                           mov   xlength,bx
                           mov   bx,2
                           mov   yheight,bx
                           call  printSegment

                           sub   cx,12d
                           add   dx,4d
                           mov   bx,14d
                           mov   xlength,bx
                           mov   bx,4d
                           mov   yheight,bx
                           call  printSegment

                           sub   cx,2d
                           add   dx,2d
                           mov   bx,18d
                           mov   xlength,bx
                           mov   bx,2d
                           mov   yheight,bx
                           call  printSegment

                           sub   cx,1d
                           add   dx,2d
                           mov   bx,20d
                           mov   xlength,bx
                           mov   bx,3d
                           mov   yheight,bx
                           call  printSegment

                           popa
                           ret
printHorse endp

    ;-------------------------------------------------------------------------------------------------------

printBishop proc    near
                           pusha

                           add   cx,12d
                           add   dx,1d
                           mov   bx,2d
                           mov   xlength,bx
                           mov   bx,1d
                           mov   yheight,bx
                           call  printSegment

                           sub   cx,1d
                           add   dx,1d
                           mov   bx,4d
                           mov   xlength,bx
                           call  printSegment

                           sub   cx,1d
                           add   dx,1d
                           mov   bx,6d
                           mov   xlength,bx
                           call  printSegment

                           sub   cx,1d
                           add   dx,1d
                           mov   bx,6d                        ;crack start
                           mov   xlength,bx
                           call  printSegment

                           sub   cx,1d
                           add   dx,1d
                           mov   bx,6d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,9d                        ;crack
                           mov   bx,1d
                           mov   xlength,bx
                           call  printSegment

                           sub   cx,10d
                           add   dx,1d
                           mov   bx,6d
                           mov   xlength,bx
                           mov   bx,2
                           mov   yheight,bx
                           call  printSegment

                           add   cx,9d                        ;crack
                           mov   bx,3d
                           mov   xlength,bx
                           call  printSegment

                           sub   cx,10d
                           add   dx,2d
                           mov   bx,6d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,9d                        ;crack
                           mov   bx,5d
                           mov   xlength,bx
                           call  printSegment

                           sub   cx,10d
                           add   dx,2d
                           mov   bx,16d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,1d                        ;big to waist
                           add   dx,2d
                           mov   bx,14d
                           mov   xlength,bx
                           mov   bx,2d
                           mov   yheight,bx
                           call  printSegment

                           add   cx,1d
                           add   dx,2d
                           mov   bx,12d
                           mov   xlength,bx
                           mov   bx,2d
                           mov   yheight,bx
                           call  printSegment

                           add   cx,3d                        ;tower
                           add   dx,2d
                           mov   bx,6d
                           mov   xlength,bx
                           mov   bx,3d
                           mov   yheight,bx
                           call  printSegment

                           sub   cx,7d                        ;base
                           add   dx,3d
                           mov   bx,20d
                           mov   xlength,bx
                           mov   bx,3d
                           mov   yheight,bx
                           call  printSegment

                           popa
                           ret
printBishop endp

    ;-------------------------------------------------------------------------------------------------------

printKing proc    near
                           pusha

                           add   cx,3d                        ;left
                           add   dx,3d
                           mov   bx,1d
                           mov   xlength,bx
                           mov   bx,1d
                           mov   yheight,bx
                           call  printSegment

                           add   cx,5d                        ;middle left
                           call  printSegment

                           add   cx,9d                        ;middle right
                           call  printSegment

                           add   cx,5d                        ;right
                           call  printSegment

                           sub   cx,19d                       ;left
                           add   dx,1d
                           mov   bx,2d
                           mov   xlength,bx
                           call  printSegment

                           mov   bx,3d
                           mov   xlength,bx
                           add   cx,4d                        ;middle left
                           call  printSegment

                           add   cx,9d                        ;middle right
                           call  printSegment

                           mov   bx,2d
                           mov   xlength,bx

                           add   cx,5d                        ;right
                           call  printSegment

                           sub   cx,18d                       ;left
                           add   dx,1d
                           mov   bx,8d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,12d                       ;right
                           call  printSegment

                           sub   cx,12d                       ;left
                           add   dx,1d
                           mov   bx,9d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,11d                       ;right
                           call  printSegment

                           sub   cx,11d                       ;heart
                           add   dx,1d
                           mov   bx,20d
                           mov   xlength,bx
                           mov   bx,5d
                           mov   yheight,bx
                           call  printSegment

                           add   cx,1d
                           add   dx,5d
                           mov   bx,18d
                           mov   xlength,bx
                           mov   bx,1d
                           mov   yheight,bx
                           call  printSegment

                           add   cx,1d
                           add   dx,1d
                           mov   bx,16d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,1d
                           add   dx,1d
                           mov   bx,14d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,1d
                           add   dx,1d
                           mov   bx,12d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,1d
                           add   dx,1d
                           mov   bx,10d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,1d                        ;base to heart
                           add   dx,1d
                           mov   bx,8d
                           mov   xlength,bx
                           mov   bx,2d
                           mov   yheight,bx
                           call  printSegment

                           sub   cx,6d                        ;base
                           add   dx,2d
                           mov   bx,20d
                           mov   xlength,bx
                           mov   bx,3d
                           mov   yheight,bx
                           call  printSegment

                           popa
                           ret
printKing endp

    ;-------------------------------------------------------------------------------------------------------

printQueen proc    near
                           pusha

                           add   cx,3d                        ;left
                           add   dx,3d
                           mov   bx,1d
                           mov   xlength,bx
                           mov   bx,1d
                           mov   yheight,bx
                           call  printSegment

                           add   cx,19d                       ;right
                           call  printSegment

                           sub   cx,19d                       ;left
                           add   dx,1d
                           mov   bx,2d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,18d                       ;right
                           call  printSegment

                           sub   cx,18d                       ;left
                           add   dx,1d
                           mov   bx,3d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,17d                       ;right
                           call  printSegment

                           sub   cx,17d                       ;left
                           add   dx,1d
                           mov   bx,4d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,16d                       ;right
                           call  printSegment

                           sub   cx,16d                       ;left
                           add   dx,1d
                           mov   bx,5d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,15d                       ;right
                           call  printSegment

                           sub   cx,15d                       ;left
                           add   dx,1d
                           mov   bx,6d
                           mov   xlength,bx
                           mov   bx,2d
                           mov   yheight,bx
                           call  printSegment

                           add   cx,14d                       ;right
                           call  printSegment


                           sub   cx,5d                        ;middle
                           mov   bx,2d
                           mov   xlength,bx
                           mov   bx,1d
                           mov   yheight,bx
                           call  printSegment

                           sub   cx,1d
                           add   dx,1d
                           mov   bx,4d
                           mov   xlength,bx
                           call  printSegment

                           sub   cx,8d                        ;waist
                           add   dx,1d
                           mov   bx,20d
                           mov   xlength,bx
                           mov   bx,2d
                           mov   yheight,bx
                           call  printSegment

                           add   cx,1d
                           add   dx,2d
                           mov   bx,18d
                           mov   xlength,bx
                           mov   bx,1d
                           mov   yheight,bx
                           call  printSegment

                           add   cx,1d
                           add   dx,1d
                           mov   bx,16d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,1d
                           add   dx,1d
                           mov   bx,14d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,1d
                           add   dx,1d
                           mov   bx,12d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,1d
                           add   dx,1d
                           mov   bx,10d
                           mov   xlength,bx
                           call  printSegment

                           add   cx,1d                        ;base to waist
                           add   dx,1d
                           mov   bx,8d
                           mov   xlength,bx
                           mov   bx,2d
                           mov   yheight,bx
                           call  printSegment

                           sub   cx,6d                        ;base
                           add   dx,2d
                           mov   bx,20d
                           mov   xlength,bx
                           mov   bx,3d
                           mov   yheight,bx
                           call  printSegment

                           popa
                           ret
printQueen endp

    ;-------------------------------------------------------------------------------------------------------

rookMoves proc    near
                           pusha
                 
    rookDownLoop:          
                  
                           cmp   dx,175d
                           je    rookUp

                           add   dx,25d
                           call  highlight

                           cmp   highlightFlag,6d
                           jne   rookDownLoop

    rookUp:                
                           mov   dx,resetPosition[yaxis]      ;reset the y-axis
    
    rookUpLoop:            
                           cmp   dx,0d                        ;if it's the first row then don't do anything
                           je    rookRight

                           sub   dx,25d                       ;check the upper square
                           call  highlight                    ;highlight it
                           
                           cmp   highlightFlag,6d
                           jne   rookUpLoop

    rookRight:             

                           mov   dx,resetPosition[yaxis]      ;reset the y axis

    rookRightLoop:         
                           cmp   cx,182d                      ;if it's the first row then don't do anything
                           je    rookLeft
                           
                           add   cx,26d                       ;check the upper square
                           call  highlight
                           
                           cmp   highlightFlag,6d
                           jne   rookRightLoop

    rookLeft:              
                           mov   cx,resetPosition[xaxis]
    rookLeftLoop:          
                           cmp   cx,0d                        ;if it's the first row then don't do anything
                           je    exitRook

                           sub   cx,26d                       ;check the upper square
                           call  highlight

                           cmp   highlightFlag,6d
                           jne   rookLeftLoop
    exitRook:              
                     
                           popa
                           ret
rookMoves endp

    ;-------------------------------------------------------------------------------------------------------

horseMoves proc     near
                           pusha
                            
                           add   dx,50d                       ;down down right
                           add   cx,26d
                           cmp   cx,200d                      ;if it's in the right column skip
                           jge   _2downLeft
                           cmp   dx,200d                      ;or in the bottom row
                           jge   _2downLeft

                           call  highlight



    _2downLeft:            
                           sub   cx,52d                       ;down down left
                           cmp   cx,0d
                           jl    _2leftDown
                           cmp   cx,200d
                           jge   _2leftDown
                           cmp   dx,200d
                           jge   _2leftDown
                           
                           call  highlight

    _2leftDown:            
                           
                           sub   dx,25d                       ;left left down
                           sub   cx,26d
                           cmp   cx,0d
                           jl    _2rightDown
                           cmp   cx,200d
                           jge   _2rightDown
                           cmp   dx,200d
                           jge   _2rightDown
                           cmp   dx,0d
                           jl    _2rightDown
                           
                           call  highlight

    _2rightDown:           
    
                           add   cx,104d                      ;right right up
                           cmp   cx,0d
                           jb    _2rightUp
                           cmp   cx,200d
                           jae   _2rightUp
                           cmp   dx,200d
                           jae   _2rightUp
                           cmp   dx,0d
                           jb    _2rightUp
                           
                           call  highlight
    
    _2rightUp:             
    
                           sub   dx,50d                       ;right right up
                           cmp   cx,0d
                           jb    _2leftUp
                           cmp   cx,200d
                           jae   _2leftUp
                           cmp   dx,200d
                           jae   _2leftUp
                           cmp   dx,0d
                           jb    _2leftUp
                           
                           call  highlight

    _2leftUp:              
    
                           sub   cx,104d                      ;left left up
                           cmp   cx,0d
                           jb    _2upLeft
                           cmp   cx,200d
                           ja    _2upLeft
                           cmp   dx,200d
                           jae   _2upLeft
                           cmp   dx,0d
                           jb    _2upLeft
                           
                           call  highlight

    _2upLeft:              
    
                           add   cx,26d                       ;up up left
                           sub   dx,25d
                           cmp   cx,0d
                           jb    _2upRight
                           cmp   cx,200d
                           jae   _2upRight
                           cmp   dx,200d
                           jae   _2upRight
                           cmp   dx,0d
                           jb    _2upRight
                           
                           call  highlight

    _2upRight:             
                           
                           add   cx,52d                       ;up up right
                           cmp   cx,0d
                           jb    exitHorse
                           cmp   cx,200d
                           jae   exitHorse
                           cmp   dx,200d
                           jae   exitHorse
                           cmp   dx,0d
                           jb    exitHorse
                           
                           call  highlight

    exitHorse:             

                           popa
                           ret
horseMoves endp

    ;-------------------------------------------------------------------------------------------------------

bishopMoves proc    near
                           pusha

    downRight:             
                    
                           cmp   dx,175d                      ;if it's the bottom row
                           je    downRightEnd
                           cmp   cx,182d                      ;if it's the right most column
                           je    downRightEnd

                           add   cx,26d                       ;move it right down
                           add   dx,25d
                        
                           call  highlight
                           cmp   highlightFlag,6d
                           jne   downRight

    downRightEnd:          

                           mov   cx,resetPosition[xaxis]      ;reset the position
                           mov   dx,resetPosition[yaxis]
    
    downLeft:              
   
                           cmp   cx,0d                        ;if it's the left most column
                           je    downLeftEnd
                           cmp   dx,175d                      ;if it's the bottom row
                           je    downLeftEnd
                        
                           sub   cx,26d                       ;move it
                           add   dx,25d

                           call  highlight
                           cmp   highlightFlag,6d
                           jne   downLeft

    downLeftEnd:           

                           mov   cx,resetPosition[xaxis]      ;reset the position
                           mov   dx,resetPosition[yaxis]
                        
    upLeft:                
                    
                           cmp   dx,0d                        ;if it's the top row
                           je    upLeftEnd
                           cmp   cx,0d                        ;if it's the left most column
                           je    upLeftEnd
                        
                           sub   cx,26d                       ;move it
                           sub   dx,25d

                           call  highlight
                           cmp   highlightFlag,6d
                           jne   upLeft

    upLeftEnd:             

                           mov   cx,resetPosition[xaxis]      ;reset the position
                           mov   dx,resetPosition[yaxis]

    upRight:               
   
                           cmp   cx,182d                      ;if it's the right most column
                           je    exitBishop
                           cmp   dx,0d                        ;if it's the top row
                           je    exitBishop
                        
                           add   cx,26d                       ;move it
                           sub   dx,25d
                           
                           call  highlight
                           cmp   highlightFlag,6d
                           jne   upRight
                            
    exitBishop:            

                           popa
                           ret
bishopMoves endp

    ;-------------------------------------------------------------------------------------------------------

kingMoves proc    near
                           pusha

                           sub   cx,26d
                           sub   dx,25d
                           mov   si,0

    kingChecks:            
    
                           cmp   cx,0d                        ;check left most column
                           jb    nextSQR
                           cmp   cx ,182d                     ;check right most column
                           ja    nextSQR
                           cmp   dx,0d                        ;check top row
                           jb    nextSQR
                           cmp   dx ,175d                     ;check bottom row
                           ja    nextSQR
                           
                           call  highlight
    
    nextSQR:               
    
                           add   cx,26d
                           cmp   si,2
                           jne   secondRow                    ;check the next row
                           add   dx,25d
                           sub   cx,78d

    secondRow:             
    
                           cmp   si,5
                           jne   thirdRow                     ;check the next row
                           add   dx,25d
                           sub   cx,78d
    
    thirdRow:              
    
                           cmp   si,8
                           jne   incrementSI
                           add   dx,25d
                           sub   cx,104d
    
    incrementSI:           
    
                           inc   si
                           cmp   si,8d
                           jbe   kingChecks                   ;loop again

                           popa
                           ret
kingMoves endp

    ;-------------------------------------------------------------------------------------------------------

blackPawnMoves proc    near
                           pusha

                           cmp   dx,175d                      ;if it's the bottom row exit
                           je    exitBlackPawnMoves

                           add   dx,25d                       ;highlight the square below

                           call  checkArray
                           cmp   targetOffset1,308d
                           jne   highlightBlackPawnRed

                           call  Highlight                    ;only if it can move to this position

                           cmp   resetPosition[yaxis],25d
                           jne   highlightBlackPawnRed
                        
                           add   dx,25d                       ;if it's the first move check the next square too
                          
                           call  checkArray
                           cmp   targetOffset1,308d
                           jne   highlightBlackPawnRed

                           call  highlight                    ;only if it can move to this position

    highlightBlackPawnRed: 
    
                           mov   dx,resetPosition[yaxis]      ;reset the y axis
                           add   dx,25d                       ;go back to the square below

                           cmp   cx,0                         ;check if it's the left most column if true then skip
                           je    noLeftBlackPawn

                           sub   cx,26d                       ;check left square and highlight it red if valid

                           call  checkArray
                           cmp   targetOffset1,308d
                           je    noLeftBlackPawn
                           cmp   targetOffset1,128d
                           jl    noLeftBlackPawn

                           call  highlight                    ;only if it can attack this position

    noLeftBlackPawn:       

                           mov   cx,resetPosition[xaxis]      ;reset the x axis
                           cmp   cx,182d                      ;if it's the right most column exit
                           je    exitBlackPawnMoves

                           add   cx,26d                       ;check the right square and higlight it ready if valid
                          
                           call  checkArray
                           cmp   targetOffset1,308d
                           je    exitBlackPawnMoves
                           cmp   targetOffset1,128d
                           jl    exitBlackPawnMoves

                           call  highlight                    ;only if it can attack this position

    exitBlackPawnMoves:    
                           popa
                           ret
blackPawnMoves endp

    ;-------------------------------------------------------------------------------------------------------

whitePawnMoves proc    near
                           pusha

                           cmp   dx,0d                        ;if it's the top row exit
                           je    exitWhitePawnMoves

                           sub   dx,25d                       ;highlight the square above

                           call  checkArray
                           cmp   targetOffset2,308d
                           jne   highlightWhitePawnRed

                           call  Highlight                    ;only if it can move to this position

                           cmp   resetPosition[yaxis],150d
                           jne   highlightWhitePawnRed
                        
                           sub   dx,25d                       ;if it's the first move check the next square too
                          
                           call  checkArray
                           cmp   targetOffset2,308d
                           jne   highlightWhitePawnRed

                           call  highlight                    ;only if it can move to this position

    highlightWhitePawnRed: 
    
                           mov   dx,resetPosition[yaxis]      ;reset the y axis
                           sub   dx,25d                       ;go back to the square below

                           cmp   cx,0                         ;check if it's the left most column if true then skip
                           je    noLeftWhitePawn

                           sub   cx,26d                       ;check left square and highlight it red if valid

                           call  checkArray
                           cmp   targetOffset2,128d
                           jge   noLeftWhitePawn

                           call  highlight                    ;only if it can attack this position

    noLeftWhitePawn:       

                           mov   cx,resetPosition[xaxis]      ;reset the x axis
                           cmp   cx,182d                      ;if it's the right most column exit
                           je    exitWhitePawnMoves

                           add   cx,26d                       ;check the right square and higlight it ready if valid
                          
                           call  checkArray
                           cmp   targetOffset2,128d
                           jge   exitWhitePawnMoves

                           call  highlight                    ;only if it can attack this position

    exitWhitePawnMoves:    
                           popa
                           ret
whitePawnMoves endp

    ;-------------------------------------------------------------------------------------------------------

searchArray proc    near                                      ;put bx = 1 if black (1) is calling
                           pusha
                           push  bx                           ;as it has which user is calling
                           mov   di,0d                        ;the searching position need to be put in cx , dx before calling

    search:                
                           mov   ax,array[di+xaxis]
                           mov   bx,array[di+yaxis]

                           cmp   cx,ax                        ;check the x axis
                           jne   notFound
                           cmp   dx,bx                        ;check the y axis
                           je    found

    notFound:              
                           add   di,8                         ;to go to the next element of the array      size of a single element
                           cmp   di,arraysize                 ;if the end of the array reached             8*32
                           jle   search

                           mov   di,308d                      ;to mark that it's not found

    found:                 
                
                           pop   bx                           ;to get the user
                           cmp   bx,1d                        ;set the array off set of the proper user with the value to use it later
                           jne   offsetuser2
                   
                           mov   movingOffset1,di
                           push  bx
                           mov   bx,array[di+typ]
                           mov   user1Pos+typ,bx
                           mov   movingPiece1+typ,bx
                           pop   bx
                           popa
                           ret
    offsetuser2:           
                           mov   movingOffset2,di
                           push  bx
                           mov   bx,array[di+typ]
                           mov   user2Pos+typ,bx
                           pop   bx
                           mov   flag,1d
                           popa
                           ret
searchArray endp

    ;-------------------------------------------------------------------------------------------------------

checkArray proc    near                                       ;put bx = 1 if black (1) is calling
                           pusha
                           push  bx                           ;as it has which user is calling
                           mov   di,0d                        ;the searching position need to be put in cx , dx before calling

    searchCheck:           
                           mov   ax,array[di+xaxis]
                           mov   bx,array[di+yaxis]

                           cmp   cx,ax                        ;check the x axis
                           jne   notFoundCheck
                           cmp   dx,bx                        ;check the y axis
                           je    foundCheck

    notFoundCheck:         
                           add   di,8                         ;to go to the next element of the array      size of a single element
                           cmp   di,arraysize                 ;if the end of the array reached             8*32
                           jle   searchCheck

                           mov   di,308d                      ;to mark that it's not found

    foundCheck:            

                           mov   checkflag,1d
                           pop   bx                           ;to get the user
                           cmp   bx,1d                        ;set the array off set of the proper user with the value to use it later
                           jne   offsetuser2Check
                   
                           mov   targetOffset1,di

                           popa
                           ret
    offsetuser2Check:      
                           mov   targetOffset2,di

                           popa
                           ret
checkArray endp
    
    ;-------------------------------------------------------------------------------------------------------

clearHighlight proc    near
                           pusha

                           mov   di,0                         ;reset the counter
                           cmp   bx,1
                           jne   clearHighlight2


    keepClearing1:         
                           cmp   di,valid1Size
                           je    exitClear

                           mov   cx,valid1[di+xaxis]          ;get x axis
                           mov   dx,valid1[di+yaxis]          ;get y axis
                           mov   ax,valid1[di+4]              ;get the color
                           call  printSQR

                           add   di,6                         ;go to the next element
                           jmp   keepClearing1                ;loop again


    clearHighlight2:       

                           cmp   di,valid2Size
                           je    exitClear

                           mov   cx,valid2[di+xaxis]          ;get x axis
                           mov   dx,valid2[di+yaxis]          ;get y axis
                           mov   ax,valid2[di+4]              ;get the color
                          
                           call  printSQR
                          
                           add   di,6                         ;go to the next element
                           jmp   clearHighlight2              ;loop again

    exitClear:             
                           call  printPowerUp
                           popa
                           ret
clearHighlight endp

    ;-------------------------------------------------------------------------------------------------------

highlightMoves proc    near
                           pusha
     
                           cmp   bx,1d
                           jne   highlightWhiteTeam

                           mov   cx,movingPiece1[xaxis]
                           mov   dx,movingPiece1[yaxis]

                           mov   resetPosition[xaxis],cx
                           mov   resetPosition[yaxis],dx

    ;---------------------------------------------------        Pawn      --------------------------------
                           cmp   movingPiece1[typ],10d
                           jne   blackRook

                           call  blackPawnMoves
                           jmp   exitMoves

    ;---------------------------------------------------        Rook      --------------------------------

    blackRook:             
                           cmp   movingPiece1[typ],11d        ;check if it's a rook
                           jne   blackKnight                  ;if not go to the horse case
                      
                           call  rookMoves
                           jmp   exitMoves

    ;---------------------------------------------------        Knight      --------------------------------

    blackKnight:           
    
                           cmp   movingPiece1[typ],12d        ;check if it's a knight
                           jne   blackBishop                  ;if not go to the bishop case
                           
                           call  horseMoves
                           jmp   exitMoves

    ;---------------------------------------------------        Bishop      --------------------------------

    blackBishop:           
                           
                           cmp   movingPiece1[typ],13d        ;if it's a bishop
                           jne   blackKing                    ;if not go to the king case
                                                 
                           call  bishopMoves
                           jmp   exitMoves

    ;---------------------------------------------------        King      --------------------------------

    blackKing:             
    
                           cmp   movingPiece1[typ],15d        ;if it's a king
                           jne   blackQueen                   ;if not go to the queen case
                           
                           call  kingMoves
                           jmp   exitMoves

    ;---------------------------------------------------        Queen      --------------------------------

    blackQueen:            
                           cmp   movingPiece1[typ],14d        ;check if it's a queen

                           call  rookMoves                    ;combine bishop and rook moves
                           call  bishopMoves
                           jmp   exitMoves

    
    ;-----------------------------------------------------WHITE TEAM -----------------------------------------------------

    highlightWhiteTeam:    

                           mov   cx,movingPiece2[xaxis]
                           mov   dx,movingPiece2[yaxis]

                           mov   resetPosition[xaxis],cx
                           mov   resetPosition[yaxis],dx

    ;---------------------------------------------------        Pawn      --------------------------------

                           cmp   movingPiece2[typ],0d
                           jne   whiteRook

                           call  whitePawnMoves
                           jmp   exitMoves
    ;---------------------------------------------------        Rook      --------------------------------

    whiteRook:             

                           cmp   movingPiece2[typ],1d         ;check if it's a rook
                           jne   whiteKnight                  ;if not go to the horse case
                      
                           call  rookMoves
                           jmp   exitMoves

    ;---------------------------------------------------        Knight      --------------------------------

    whiteKnight:           
    
                           cmp   movingPiece2[typ],2d         ;check if it's a knight
                           jne   whiteBishop                  ;if not go to the bishop case
                           
                           call  horseMoves
                           jmp   exitMoves

    ;---------------------------------------------------        Bishop      --------------------------------

    whiteBishop:           
                           
                           cmp   movingPiece2[typ],3d         ;if it's a bishop
                           jne   whiteKing                    ;if not go to the king case
                                                 
                           call  bishopMoves
                           jmp   exitMoves

    ;---------------------------------------------------        King      --------------------------------

    whiteKing:             
    
                           cmp   movingPiece2[typ],5d         ;if it's a king
                           jne   whiteQueen                   ;if not go to the queen case
                           
                           call  kingMoves
                           jmp   exitMoves

    ;---------------------------------------------------        Queen      --------------------------------

    whiteQueen:            
                           cmp   movingPiece2[typ],4d         ;check if it's a queen

                           call  rookMoves                    ;combine bishop and rook moves
                           call  bishopMoves

    exitMoves:             
                           popa
                           ret
highlightMoves endp

    ;-------------------------------------------------------------------------------------------------------

checkValid proc    near
                           pusha

                           cmp   bx,1
                           jne   checkValid2

                           mov   si,valid1Size                ;set the current position of the user & the counter
                           mov   bx,0
                           mov   cx,user1Pos[xaxis]
                           mov   dx,user1Pos[yaxis]
                           mov   isValid1,bl                  ;reset the flag
                           mov   spaceFlag,bl                 ;reset the space flag

    valid1Loop:            
                           cmp   bx,si                        ;if the counter reaches the end exit
                           je    exitValid

                           cmp   cx,valid1[bx+xaxis]          ;check the x axis
                           jne   nextValid1
                           cmp   dx,valid1[bx+yaxis]          ;check the y axis
                           jne   nextValid1
                        
                           mov   bx,1                         ;if they match set the flag with 1
                           mov   isValid1,bl
                           jmp   exitValid

    nextValid1:            
                           add   bx,6d
                           jmp   valid1Loop

    checkValid2:           

                           mov   si,valid2Size                ;set the current position of the user & the counter
                           mov   bx,0
                           mov   cx,user2Pos[xaxis]
                           mov   dx,user2Pos[yaxis]
                           mov   isValid2,bl                  ;reset the flag
                           mov   enterFlag,bl                 ;reset the enter flag

    valid2Loop:            
                           cmp   bx,si
                           je    exitValid                    ;if the counter reaches the end then exit

                           cmp   cx,valid2[bx+xaxis]          ;check the x axis
                           jne   nextValid2
                           cmp   dx,valid2[bx+yaxis]          ;check the y axis
                           jne   nextValid2
                        
                           mov   bx,1                         ;if they match set the flag with 1
                           mov   isValid2,bl
                           jmp   exitValid
                        
    nextValid2:            
                           add   bx,6d
                           jmp   valid2Loop

    exitValid:             
                           popa
                           ret
checkValid endp

    ;-------------------------------------------------------------------------------------------------------

addPower proc    near
                           pusha

    randomizeAgain:        

                           mov   ah,00h                       ;may need more randomness
                           int   1ah

                           add   dh,dl
                           mov   ch,0
                           mov   cl,dh
                           mov   dh,0

                           mov   al,cl
                           mov   bl,7d
                           div   bl
                           mov   al,ah
                           mov   bl,26d
                           mul   bl
                           mov   cl,al

                           mov   al,dl
                           mov   bl,4d
                           div   bl
                           mov   al,ah
                           mov   bl,25d
                           mul   bl
                           mov   dl,al
                           add   dl,50d

                           add   cx,12d
                           add   dx,21d

                           mov   ah,0dh
                           int   10h

                           cmp   al,0h
                           je    randomizeAgain
                           cmp   al,0fh
                           je    randomizeAgain

                           sub   cx,12d
                           sub   dx,21d
                           push  cx
                           push  dx

                           mov   cx,powerUp[0]
                           mov   dx,powerUp[2]

                           call  getBoardColor
                           mov   al,boardColor
                           call  printSQR
                           call  printBoth

                           mov   cx,user1Pos[xaxis]
                           mov   dx,user1Pos[yaxis]

                           call  getBoardColor
                           mov   al,boardColor
                           mov   user1PrevColor,al

                           mov   cx,user2Pos[xaxis]
                           mov   dx,user2Pos[yaxis]

                           call  getBoardColor
                           mov   al,boardColor
                           mov   user2PrevColor,al

                           pop   dx
                           pop   cx

                           mov   powerUp[0],cx
                           mov   powerUp[2],dx
                           mov   ch,1
                           mov   powerOn,ch

                           call  printPowerUp

                           mov   ah,2ch
                           int   21h
                           mov   ch,cl
                           mov   cl,dh
                           mov   powerUpTime,cx

                           cmp   spaceFlag,0ffh               ;if it's not up skip it
                           jne   checkEnterFlagP

                           mov   bx,1
                           call  clearHighlight               ;clear the highlighted squares
                           mov   valid1Size,0

                           cmp   movingOffset1,308d           ;if the user isn't moving a piece don't highlight
                           je    checkEnterFlagP

                           call  highlightMoves
                           call  printBoth

    checkEnterFlagP:       

                           cmp   enterFlag,0ffh
                           jne   exitAddPower

                           mov   bx,2
                           call  clearHighlight
                           mov   valid2Size,0

                           cmp   movingOffset2,308d
                           je    exitAddPower

                           call  highlightMoves
                           call  printBoth                    ;print both players to fix if there way an overlap

    exitAddPower:          
                           popa
                           ret
addPower endp

    ;-------------------------------------------------------------------------------------------------------

printPowerUp proc    near
                           pusha

                           cmp   powerOn,1
                           jne   exitPrintPowerUp

                           mov   al,6
                           mov   cx,powerUp[0]
                           mov   dx,powerUp[2]
                           call  printSQR

    exitPrintPowerUp:      
                           popa
                           ret
printPowerUp endp

    ;-------------------------------------------------------------------------------------------------------

printStatusBar proc    near
                           pusha

                           mov   cx,208d
                           mov   dx,190d
                           mov   bx,10d
                           mov   yheight,bx
                           mov   bx,111d
                           mov   xlength,bx

                           cmp   kingCheck,1
                           jne   noCheck
                           mov   al,4h                        ;red if there's a check
                           jmp   exitPrintStatusBar
    noCheck:               
                           mov   al,30h                       ;print normal status bar
    exitPrintStatusBar:    
                           call  printSegment
                           popa
                           ret
printStatusBar endp

    ;-------------------------------------------------------------------------------------------------------

printWinner proc    near
                           pusha

                           add   si,di
                           add   si,9d
                           mov   dl,69d
                           mov   dh,24d

    contPrinting:          

                           cmp   si,di
                           je    exitPrintWinner

                           mov   ah,02h
                           int   10h

                           mov   al,ds:[di]
                           mov   bl,0fh
                           mov   ah,0eh
                           int   10h
                           inc   di
                           inc   dl
                           jmp   contPrinting

    exitPrintWinner:       
                           popa
                           ret
printWinner endp

    ;-------------------------------------------------------------------------------------------------------

gameChatRec proc near
                           pusha

                           cmp   al,96d                       ;96 to start a new line
                           jne   normalGameChat

                           mov   lastGameChatCol,66d
                           inc   lastGameChatRow

                           jmp   exitWrite
                          
    normalGameChat:        
                           cmp   lastGameChatRow,23d
                           jl    noGameChatClear

                           mov   lastGameChatRow,0d           ;reset the last row
                           call  clearInGameChat              ;clear the previous chat

    noGameChatClear:       
                           mov   dh,lastGameChatRow
                           mov   dl,lastGameChatCol

                           cmp   dl,80d
                           jne   newLine

                           mov   lastGameChatCol,66d
                           inc   lastGameChatRow
                           jmp   normalGameChat

    newLine:               
                           mov   ah,2
                           int   10h
                          
                           mov   dl,66d
                           mov   dh,1d

                           mov   bl,0fh
                           mov   ah,0eh
                           int   10h

                           inc   lastGameChatCol
    
    exitWrite:             
                           popa
                           ret
gameChatRec endp

    ;-------------------------------------------------------------------------------------------------------

resetGame proc    near
                           pusha

                           mov   user1Pos,0
                           mov   user1Pos[2],25
                           mov   user1PrevColor,01h           ;yellow is the initial color of the left top SQR
    
                           mov   bx,0
                           mov   cx,50d
    resetLoop1:            
    
                           inc   bx
                           loop  resetLoop1
    
                           mov   user2Pos,0
                           mov   user2Pos[2],150d
                           mov   user2PrevColor,07h           ;yellow is the initial color of the left top SQR
    
                           mov   cx,50d
    resetLoop2:            
    
                           inc   bx
                           loop  resetLoop2

                           mov   valid1Size,0
                           mov   isValid1,0

                           mov   valid2Size,0
                           mov   isValid2,0

                           mov   colorOffset,0

                           mov   checkflag,0

                           mov   overlapFlag,0h               ;0 no overlap ff overlap


                           mov   spaceFlag,0d                 ;0 waiting for first space press ff waiting for second space press
                           mov   enterFlag,0d                 ;0 waiting for first enter press ff waiting for second enter press

                           mov   highlightFlag,5d             ;5 means continue highlighting 6 means stop highlighting
                           mov   onHighlight,0                ;To mark when the user is on a highlighted square

                           mov   winFlag,0


                           mov   bPawn1,0
                           mov   bPawn1[2],25d
                           mov   bPawn1[4],10d
                           mov   bPawn1[6],0d
    
                           mov   bPawn2,26d
                           mov   bPawn2[2],25d
                           mov   bPawn2[4],10d
                           mov   bPawn2[6],0d
    

                           mov   bPawn3,52d
                           mov   bPawn3[2],25d
                           mov   bPawn3[4],10d
                           mov   bPawn3[6],0d

                           mov   bPawn4,78d
                           mov   bPawn4[2],25d
                           mov   bPawn4[4],10d
                           mov   bPawn4[6],0d

                           mov   bPawn5,104d
                           mov   bPawn5[2],25d
                           mov   bPawn5[4],10d
                           mov   bPawn5[6],0d


                           mov   bPawn6,130d
                           mov   bPawn6[2],25d
                           mov   bPawn6[4],10d
                           mov   bPawn6[6],0d

                           mov   bPawn7,156d
                           mov   bPawn7[2],25d
                           mov   bPawn7[4],10d
                           mov   bPawn7[6],0d


                           mov   bPawn8,182d
                           mov   bPawn8[2],25d
                           mov   bPawn8[4],10d
                           mov   bPawn8[6],0d

                           mov   bRook1,0d
                           mov   bRook1[2],0d
                           mov   bRook1[4],11d
                           mov   bRook1[6],0d


                           mov   bRook1,0d
                           mov   bRook1[2],0d
                           mov   bRook1[4],11d
                           mov   bRook1[6],0d

                           mov   bRook2,182d
                           mov   bRook2[2],0d
                           mov   bRook2[4],11d
                           mov   bRook2[6],0d

                           mov   bHorse1,26d
                           mov   bHorse1[2],0d
                           mov   bHorse1[4],12d
                           mov   bHorse1[6],0d

                           mov   bHorse2,156d
                           mov   bHorse2[2],0d
                           mov   bHorse2[4],12d
                           mov   bHorse2[6],0d


                           mov   bBishop1,52d
                           mov   bBishop1[2],0d
                           mov   bBishop1[4],13d
                           mov   bBishop1[6],0d

                           mov   bBishop2,130d
                           mov   bBishop2[2],0d
                           mov   bBishop2[4],13d
                           mov   bBishop2[6],0d

                           mov   bQueen,78d
                           mov   bQueen[2],0d
                           mov   bQueen[4],14d
                           mov   bQueen[6],0d

                           mov   bKing,104d
                           mov   bKing[2],0d
                           mov   bKing[4],15d
                           mov   bKing[6],0d

                           mov   wPawn1,0
                           mov   wPawn1[2],150d
                           mov   wPawn1[4],00d
                           mov   wPawn1[6],0d
    
                           mov   wPawn2,26d
                           mov   wPawn2[2],150d
                           mov   wPawn2[4],00d
                           mov   wPawn2[6],0d
    

                           mov   wPawn3,52d
                           mov   wPawn3[2],150d
                           mov   wPawn3[4],00d
                           mov   wPawn3[6],0d

                           mov   wPawn4,78d
                           mov   wPawn4[2],150d
                           mov   wPawn4[4],00d
                           mov   wPawn4[6],0d

                           mov   wPawn5,104d
                           mov   wPawn5[2],150d
                           mov   wPawn5[4],00d
                           mov   wPawn5[6],0d


                           mov   wPawn6,130d
                           mov   wPawn6[2],150d
                           mov   wPawn6[4],00d
                           mov   wPawn6[6],0d

                           mov   wPawn7,156d
                           mov   wPawn7[2],150d
                           mov   wPawn7[4],00d
                           mov   wPawn7[6],0d


                           mov   wPawn8,182d
                           mov   wPawn8[2],150d
                           mov   wPawn8[4],00d
                           mov   wPawn8[6],0d

                           mov   wRook1,0d
                           mov   wRook1[2],0d
                           mov   wRook1[4],01d
                           mov   wRook1[6],0d


                           mov   wRook1,0d
                           mov   wRook1[2],175d
                           mov   wRook1[4],01d
                           mov   wRook1[6],0d

                           mov   wRook2,182d
                           mov   wRook2[2],175d
                           mov   wRook2[4],01d
                           mov   wRook2[6],0d

                           mov   wHorse1,26d
                           mov   wHorse1[2],175d
                           mov   wHorse1[4],02d
                           mov   wHorse1[6],0d

                           mov   wHorse2,156d
                           mov   wHorse2[2],175d
                           mov   wHorse2[4],02d
                           mov   wHorse2[6],0d


                           mov   wBishop1,52d
                           mov   wBishop1[2],175d
                           mov   wBishop1[4],03d
                           mov   wBishop1[6],0d

                           mov   wBishop2,130d
                           mov   wBishop2[2],175d
                           mov   wBishop2[4],03d
                           mov   wBishop2[6],0d

                           mov   wQueen,78d
                           mov   wQueen[2],175d
                           mov   wQueen[4],04d
                           mov   wQueen[6],0d

                           mov   wKing,104d
                           mov   wKing[2],175d
                           mov   wKing[4],05d
                           mov   wKing[6],0d

                           mov   flag,0d
    
                           mov   targetOffset1,0
                           mov   targetOffset2,0

                           mov   lastGameChatRow,0d
                           mov   lastGameChatCol,66d
                           
                           mov   movingPiece1,0
                           mov   movingPiece1[2],0
                           mov   movingColor1,0
                           mov   movingOffset1,0

                           mov   movingPiece2,0
                           mov   movingPiece2[2],0
                           mov   movingColor2,0
                           mov   movingOffset2,0

                           mov   powerUpTime,0
                           mov   powerUp,0
                           mov   powerUp[2],0
                           mov   powerOn,0
                          
                           popa
                           ret
resetGame endp

    ;-------------------------------------------------------------------------------------------------------

mainMenu proc    near
                           pusha

                           mov   localMode,8
                           mov   netMode,9

                           mov   ah,0
                           mov   al,13h
                           int   10h

                           mov   ah,0
                           mov   al,3
                           int   10h                          ;to clear the screen

                           mov   dh,10d
                           mov   dl,26d
                           mov   ah,2
                           int   10h

                           LEA   dx,mainMenu1                 ;chat option
                           mov   ah,9
                           int   21h

                           mov   dh,12d                       ;move cursor
                           mov   dl,26d
                           mov   ah,2
                           int   10h

                           LEA   dx,mainMenu2                 ;game option
                           mov   ah,9
                           int   21h

                           mov   dh,14d                       ;move cursor
                           mov   dl,26d
                           mov   ah,2
                           int   10h

                           LEA   dx,mainMenu3                 ;exit program
                           mov   ah,9
                           int   21h

                           mov   dh,0d                        ;move cursor
                           mov   dl,0d
                           mov   ah,2
                           int   10h

    ;reading input from users

    readNetMode:           
                           mov   ah,localMode
                           cmp   ah,netMode
                           je    modeChosen
                          
                           mov   dx,3fdh
                           in    al,dx
                           and   al,1
                           jz    readLocalMode

                           mov   dx,3f8h
                           in    al,dx

                           mov   netMode,al                   ;store the mode
                           cmp   al,localMode                 ;if both modes are the same exit
                           je    modeChosen

                           cmp   netMode,01h
                           jne   netF1

                           mov   localMode,01                 ;both users exit
                           mov   netMode,01
                           jmp   modeChosen

    netF1:                 
                           cmp   netMode,3bh                  ;recieved a F1
                           jne   netF2

                           mov   dh,0
                           mov   dl,0
                           mov   ah,2
                           int   10h                          ;set cursor position
            
                           mov   ah,9
                           mov   dx,offset netName
                           int   21h

                           mov   dx,offset chatInv            ;print invitation
                           int   21h

                           jmp   readLocalMode

    netF2:                 
                           cmp   netMode,3ch
                           jne   readLocalMode

                           mov   dh,0
                           mov   dl,0
                           mov   ah,2
                           int   10h                          ;set cursor position
            
                           mov   ah,9
                           mov   dx,offset netName
                           int   21h

                           mov   dx,offset gameInv            ;print invitation
                           int   21h

    readLocalMode:         
                           mov   ah,1                         ;check if the local user pressed a button
                           int   16h
                           jz    readNetMode

                           mov   ah,0
                           int   16h

                           cmp   ah,01h                       ;esc
                           je    validInput

                           cmp   ah,3bh                       ;f1
                           je    validInput

                           cmp   ah,3ch                       ;f2
                           jne   readNetMode

    validInput:            
                           mov   al,ah
                           mov   localMode,al                 ;store the mode

                           mov   dx,3f8h
                           out   dx,al                        ;send the mode to the other user

                           cmp   al,01                        ;if esc exit the mainmenu after sending the mode
                           je    modeChosen

                           jmp   readNetMode

    modeChosen:            
                           popa
                           ret
mainMenu endp

    ;-------------------------------------------------------------------------------------------------------

printMe proc    near
                           pusha

                           LEA   dx,localName
                           mov   ah,9
                           int   21h

                           mov   ah,2
                           mov   dl,':'
                           int   21h

                           mov   ax,localLength
                           mov   meCursor,al                  ;to make the printing of text start after "Me: "

                           popa
                           ret
printMe endp

    ;-------------------------------------------------------------------------------------------------------

printHim proc    near
                           pusha

                           LEA   dx,netName
                           mov   ah,9
                           int   21h

                           mov   ah,2
                           mov   dl,':'
                           int   21h

                           mov   dx,netLength
                           mov   netCursor,dl                 ;to make the printing of text start after "You: "

                           popa
                           ret
printHim endp

    ;-------------------------------------------------------------------------------------------------------

Chat proc    near
                           pusha

                           mov   ah,0                         ;to clear the screen
                           mov   al,13h
                           int   10h
                           mov   al,3h
                           int   10h

    chatLoop:              

                           cmp   meCursor[1],24d
                           jne   checknetScroll

                           mov   meCursor[1],0
                           mov   meCursor,0
                           mov   netCursor[1],1
                           mov   netCursor,0

                           call  ScrollDown

                           jmp   normalChat

    checknetScroll:        
                           cmp   netCursor[1],24d
                           jne   normalChat

                           mov   meCursor[1],0
                           mov   meCursor,0
                           mov   netCursor[1],1
                           mov   netCursor,0

                           call  ScrollDown

                           jmp   normalChat
    
    normalChat:            
                           mov   ah,1
                           int   16h                          ;to check if the me pressed a key
                           jz    checkNet                     ;the user didn't press

                           cmp   ah,3eh                       ;F4 to exit chating
                           jne   localChatNoExit

                           mov   dx,3f8h
                           mov   al,3eh
                           out   dx,al

                           mov   localMode,3eh
                           mov   netMode,3eh
                           jmp   exitChat

    localChatNoExit:       
                           cmp   ah,50h
                           jne   checkScrollUp

                           call  ScrollDown
                           mov   ah,0
                           int   16h

                           mov   dx,3f8h                      ;make the other user scroll too
                           mov   al,ah
                           out   dx,al
                          
                           jmp   checkNet

    checkScrollUp:         
                           cmp   ah,48h
                           jne   noScrolling

                           call  ScrollUp
                           mov   ah,0
                           int   16h

                           mov   dx,3f8h                      ;make the other user scroll too
                           mov   al,ah
                           out   dx,al

                           jmp   checkNet

    noScrolling:           
                           mov   dl,meCursor                  ;setting me cursor position
                           mov   dh,meCursor[1]
                           mov   bh,activePage
                           mov   ah,2
                           int   10h
                          
                           cmp   dl,0                         ;if me cursor is at the start of the line
                           jne   dontPrintMe
                          
                           call  printMe
    dontPrintMe:           

                           mov   ah,0                         ;clear buffer
                           int   16h

                           mov   dx,3f8h                      ;send the key pressed to him to handle it
                           out   dx,al

                           cmp   al,13d                       ;if enter start a new line
                           je    meEnterPressed
                           cmp   al,8d
                           je    meBackspacePressed           ;if me pressed backspace handle it

                           mov   dl,meCursor                  ;getting me cursor position
                           mov   dh,meCursor[1]
                           mov   bh,activePage
                           mov   ah,2
                           int   10h
                          
                           inc   dl
                           mov   meCursor,dl                  ;incrementing the x of me cursor to prepare for the next letter

                          
                           mov   dl,al                        ;display me character
                           mov   ah,2
                           int   21h

                           jmp   checkNet
    meEnterPressed:        
                           mov   ax,localLength
                           cmp   meCursor,al                  ;if the line is empty don't go to a new line
                           je    checkNet
                          
                           mov   meCursor,0                   ;reset the x axis of me cursor
                           mov   dh,meCursor[1]               ;go down 2 lines for me row

                           inc   dh
                           cmp   dh,netCursor[1]              ;if the net user is writing in the next line skip it
                           jg    meLineEmpty

                           mov   dh,netCursor[1]
                           inc   dh

    meLineEmpty:           
                           mov   meCursor[1],dh
                        
                           jmp   checkNet

    meBackspacePressed:    
                           mov   ax,localLength
                           cmp   meCursor,al                  ;if it's at the start of the line do nothing
                           je    checkNet

                           mov   dl,meCursor
                           mov   dh,meCursor[1]               ;get the position of the cursor

                           dec   dl                           ;move back once
                           mov   ah,2
                           mov   bh,activePage
                           int   10h                          ;set the cursor position

                           mov   meCursor,dl                  ;save the cursor position
                           mov   dl,' '
                           mov   bh,activePage
                           mov   ah,2
                           int   21h

    checkNet:              

                           mov   DX,3fdh                      ;check if you pressed a key and the data is ready
                           IN    AL,DX
                           AND   al,1
                           jz    chatLoop                     ;if not loop again

                           mov   dx,3f8h
                           IN    al,dx                        ;if you pressed a key put it in al
                           cmp   al,3eh                       ;if you exited me exits too
                           jne   netChatNoExit

                           mov   localMode,3eh
                           mov   netMode,3eh
                           jmp   exitChat

    netChatNoExit:         
                           cmp   al,50h
                           jne   netScrollUp

                           call  ScrollDown
                           jmp   chatLoop

    netScrollUp:           
                           cmp   al,48h
                           jne   normalNetChat
                          
                           call  ScrollUp
                           jmp   chatLoop
                          
    normalNetChat:         
                           mov   dl,netCursor                 ;setting me cursor position
                           mov   dh,netCursor[1]
                           mov   ah,2
                           mov   bh,activePage
                           int   10h

                           cmp   dl,0                         ;if me cursor is at the start of the line
                           jne   dontPrintHim
                          
                           call  printHim
    dontPrintHim:          

                           cmp   al,13d                       ;if enter start a new line
                           je    himEnterPressed
                           cmp   al,8d
                           je    himBackspacePressed          ;if me pressed backspace handle it

                           mov   dl,netCursor                 ;setting me cursor position
                           mov   dh,netCursor[1]
                           mov   bh,activePage
                           mov   ah,2
                           int   10h
                          
                           inc   dl
                           mov   netCursor,dl                 ;incrementing the x of me cursor to prepare for the next letter

                          
                           mov   dl,al                        ;display me character
                           mov   ah,2
                           int   21h

                           jmp   chatLoop
    himEnterPressed:       
                           mov   ax,netLength
                           cmp   netCursor,al                 ;if the line is empty don't go to a new line
                           je    chatLoop
                          
                           mov   netCursor,0                  ;reset the x axis of me cursor
                           mov   dh,netCursor[1]              ;go down 2 lines for me row
                          
                           inc   dh
                           cmp   dh,meCursor[1]
                           jg    netLineEmpty
                          
                           mov   dh,meCursor[1]
                           inc   dh

    netLineEmpty:          
                           mov   netCursor[1],dh
                        
                           jmp   chatLoop

    himBackspacePressed:   
                           mov   ax,netLength
                           cmp   netCursor,al                 ;if it's at the start of the line do nothing
                           je    chatLoop

                           mov   dl,netCursor
                           mov   dh,netCursor[1]              ;get the position of the cursor

                           dec   dl                           ;move back once
                           mov   ah,2
                           mov   bh,activePage
                           int   10h                          ;set the cursor position

                           mov   netCursor,dl                 ;save the cursor position
                           mov   dl,' '                       ;clear the last character
                           mov   ah,2
                           mov   bh,activePage
                           int   21h

                           jmp   chatLoop

    exitChat:              
                           popa
                           ret
Chat endp

    ;-------------------------------------------------------------------------------------------------------

ScrollDown proc    near
                           pusha

                           mov   ah,05h
                           cmp   activePage,7
                           je    downScrollEnd

                           inc   activePage
                           mov   al,activePage
                           int   10h

    downScrollEnd:         
                           popa
                           ret
ScrollDown endp

    ;-------------------------------------------------------------------------------------------------------

ScrollUp proc    near
                           pusha

                           mov   ah,05h
                           cmp   activePage,0
                           je    upScrollEnd

                           dec   activePage
                           mov   al,activePage
                           int   10h

    upScrollEnd:           
                           popa
                           ret
ScrollUp endp

    ;-------------------------------------------------------------------------------------------------------

inputNames proc    near
                           pusha

                           mov   ah,0                         ;to clear the screen
                           mov   al,13h
                           int   10h
                           mov   al,3h
                           int   10h

                           mov   dh,10d                       ;to move the cursor
                           mov   dl,26d
                           mov   ah,2
                           int   10h
     
                           LEA   dx,nameMenu                  ;print "enter you name"
                           mov   ah,9
                           int   21h

                           mov   dh,15d                       ;to move the cursor
                           mov   dl,26d
                           mov   ah,2
                           int   10h

                           LEA   dx,pressEnt                  ;print "press enter to continue"
                           mov   ah,9
                           int   21h

                           mov   si,0                         ;flag for the local name
                           mov   di,0                         ;flag for the net name

    readRecieve:           
                           cmp   si,1
                           je    recieveName
                          
                           mov   ah,1
                           int   16h
                           jz    recieveName                  ;if the local user didn't type check the otherr user

                           mov   bx,localLength               ;first get the last length of the name
                           mov   ah,0                         ;read the character
                           int   16h
                          
                           cmp   al,13d                       ;if enter stop reading
                           je    localEnt

                           mov   dx,3f8h
                           OUT   dx,al                        ;send the character

                           mov   dx,nameCursor                ;get the cursor position
                           mov   ah,2
                           int   10h
                           push  dx

                           mov   ah,2
                           mov   dl,al                        ;display the character
                           int   21h
                          
                           pop   dx
                           inc   dl
                           mov   nameCursor,dx                ;update the cursor position

                           mov   localName[bx],al             ;store the character
                           inc   bx
                           mov   localLength,bx               ;increment the length

                           jmp   recieveName

    localEnt:              
                           cmp   localLength,0
                           je    recieveName
                          
                           inc   si                           ;local user finished his name
                           mov   dx,3f8h
                           OUT   dx,al                        ;send enter

                           cmp   di,1
                           je    secondUser
    recieveName:           
                           cmp   di,1
                           je    readRecieve
                           mov   dx,3fdh
                           IN    AL,dx                        ;read the line status
                           AND   al,1                         ;bit masking to get the data ready flag
                           jz    readRecieve

                           mov   dx,3f8h
                           in    al,dx                        ;recieve the character

                           cmp   al,13d
                           je    netEnt

                           mov   bx,netLength
                           mov   netName[bx],al
                           inc   bx
                           mov   netLength,bx
                           jmp   readRecieve

    netEnt:                
                           inc   di

                           cmp   si,1
                           je    firstUser

                           jmp   readRecieve

    firstUser:             
                           mov   userFlag,1
                           jmp   namesFinished
    secondUser:            
                           mov   userFlag,2

    namesFinished:         

                           mov   bx,netLength
                           mov   netName[bx],'$'
                           add   netLength,2

                           mov   bx,localLength
                           mov   localName[bx],'$'
                           add   localLength,2

                           popa
                           ret
inputNames endp




isChecked proc    near
                           pusha                              ;loops throught hte pieces and checks every piece

                           mov   kingCheck,0                  ;reset the check flag

                           mov   bl,1                         ;for black team
                           mov   di,0

    pawnCheckLoopBlack:    
                           mov   cx,bPawn1[di+xaxis]          ;black pawns

                           cmp   cx,123d
                           je    pawnBlackKilled
                           mov   resetPosition[xaxis],cx
                           mov   dx,bPawn1[di+yaxis]
                           call  kingAttackedBlackPawn
                           cmp   kingCheck,1
                           je    exitIsChecked

    
    pawnBlackKilled:       
                           add   di,8
                           cmp   di,64d
                           jle   pawnCheckLoopBlack

                           mov   cx,bRook1[xaxis]             ;black rook 1
                           cmp   cx,123d
                           je    br1killed
                           mov   resetPosition[xaxis],cx
                           mov   dx,bRook1[yaxis]
                           mov   resetPosition[yaxis],dx
                           call  kingAttackedRook
                           cmp   kingCheck,1
                           je    exitIsChecked
    br1killed:             
    

                           mov   cx,bRook2[xaxis]             ;black rook 2

                           cmp   cx,123d
                           je    br2killed
                           mov   resetPosition[xaxis],cx
                           mov   dx,bRook2[yaxis]
                           mov   resetPosition[yaxis],dx
                           call  kingAttackedRook
                           cmp   kingCheck,1
                           je    exitIsChecked
    br2killed:             
    

                           mov   cx,bBishop1[xaxis]           ;black bishop 1
                           cmp   cx,123d
                           je    bb1killed
                           mov   resetPosition[xaxis],cx
                           mov   dx,bBishop1[yaxis]
                           mov   resetPosition[yaxis],dx
                           call  kingAttackedBishop
                           cmp   kingCheck,1
                           je    exitIsChecked
    bb1killed:             
    

                           mov   cx,bBishop2[xaxis]           ;black bishop 2
                           cmp   cx,123d
                           je    bb2killed
                           mov   resetPosition[xaxis],cx
                           mov   dx,bBishop2[yaxis]
                           mov   resetPosition[yaxis],dx
                           call  kingAttackedBishop
                           cmp   kingCheck,1
                           je    exitIsChecked
    bb2killed:             
    

                           mov   cx,bHorse1[xaxis]            ;black horse 1
                           cmp   cx,123d
                           je    bh1killed
                           mov   resetPosition[xaxis],cx
                           mov   dx,bHorse1[yaxis]
                           mov   resetPosition[yaxis],dx
                           call  kingAttackedHorse
                           cmp   kingCheck,1
                           je    exitIsChecked
    bh1killed:             
    

                           mov   cx,bHorse2[xaxis]            ;black horse 2
                           cmp   cx,123d
                           je    bh2killed
                           mov   resetPosition[xaxis],cx
                           mov   dx,bHorse2[yaxis]
                           mov   resetPosition[yaxis],dx
                           call  kingAttackedHorse
                           cmp   kingCheck,1
                           je    exitIsChecked
    bh2killed:             
    

                           mov   cx,bQueen[xaxis]             ;black queen
                           cmp   cx,123d
                           je    bqkilled
                           mov   resetPosition[xaxis],cx
                           mov   dx,bQueen[yaxis]
                           mov   resetPosition[yaxis],dx
                           call  kingAttackedBishop
                           call  kingAttackedRook
                           cmp   kingCheck,1
                           je    exitIsChecked
    bqkilled:              
    


    ;                                           White Team

                           mov   bl,2
                           mov   di,0

    pawnCheckLoopWhite:    
                           mov   cx,wPawn1[di+xaxis]          ;white pawns
                           cmp   cx,123d
                           je    pawnWhiteKilled
                           mov   resetPosition[xaxis],cx
                           mov   dx,wPawn1[di+yaxis]
                           call  kingAttackedWhitePawn
                           cmp   kingCheck,1
                           je    exitIsChecked

    
    pawnWhiteKilled:       
                           add   di,8
                           cmp   di,64d
                           jle   pawnCheckLoopWhite

                           mov   cx,wRook1[xaxis]             ;white rook 1
                           cmp   cx,123d
                           je    wr1killed
                           mov   resetPosition[xaxis],cx
                           mov   dx,wRook1[yaxis]
                           mov   resetPosition[yaxis],dx
                           call  kingAttackedRook
                           cmp   kingCheck,1
                           je    exitIsChecked
    wr1killed:             
    

                           mov   cx,wRook2[xaxis]             ;white rook 2
                           cmp   cx,123d
                           je    wr2killed
                           mov   resetPosition[xaxis],cx
                           mov   dx,wRook2[yaxis]
                           mov   resetPosition[yaxis],dx
                           call  kingAttackedRook
                           je    exitIsChecked
    wr2killed:             
    

                           mov   cx,wBishop1[xaxis]           ;white bishop 1
                           cmp   cx,123d
                           je    wb1killed
                           mov   resetPosition[xaxis],cx
                           mov   dx,wBishop1[yaxis]
                           mov   resetPosition[yaxis],dx
                           call  kingAttackedBishop
                           cmp   kingCheck,1
                           je    exitIsChecked
    wb1killed:             
    

                           mov   cx,wBishop2[xaxis]           ;white bishop 2
                           cmp   cx,123d
                           je    wb2killed
                           mov   resetPosition[xaxis],cx
                           mov   dx,wBishop2[yaxis]
                           mov   resetPosition[yaxis],dx
                           call  kingAttackedBishop
                           cmp   kingCheck,1
                           je    exitIsChecked
    wb2killed:             
    

                           mov   cx,wHorse1[xaxis]            ;white horse 1
                           cmp   cx,123d
                           je    wh1killed
                           mov   resetPosition[xaxis],cx
                           mov   dx,wHorse1[yaxis]
                           mov   resetPosition[yaxis],dx
                           call  kingAttackedHorse
                           cmp   kingCheck,1
                           je    exitIsChecked
    wh1killed:             
    

                           mov   cx,wHorse2[xaxis]            ;white horse 2
                           cmp   cx,123d
                           je    wh2killed
                           mov   resetPosition[xaxis],cx
                           mov   dx,wHorse2[yaxis]
                           mov   resetPosition[yaxis],dx
                           call  kingAttackedHorse
                           cmp   kingCheck,1
                           je    exitIsChecked
    wh2killed:             
    

                           mov   cx,wQueen[xaxis]             ;white queen
                           cmp   cx,123d
                           je    exitIsChecked
                           mov   resetPosition[xaxis],cx
                           mov   dx,wQueen[yaxis]
                           mov   resetPosition[yaxis],dx
                           call  kingAttackedBishop
                           call  kingAttackedRook
                           cmp   kingCheck,1

    

    exitIsChecked:         
                           popa
                           ret
isChecked endp

    ;-------------------------------------------------------------------------------------------------------

kingIsAttacked proc    near
                           pusha
                           mov   continueFlag,1               ;reset the flag

                           call  checkArray
                          
                           cmp   bl,1
                           jne   whiteTeamAttack
                          
                           cmp   targetOffset1,308d           ;empty square
                           je    exitKingIsAttacked
                          
                           mov   continueFlag,0               ;stop looping (a piece is found)

                           cmp   targetOffset1,248d           ;if the square has the white king
                           jne   exitKingIsAttacked

                           mov   kingCheck,1d                 ;set the flag
                           jmp   exitKingIsAttacked
    whiteTeamAttack:       

                           cmp   targetOffset2,308d           ;empty square
                           je    exitKingIsAttacked
                          
                           mov   continueFlag,0               ;stop looping (a piece is found)

                           cmp   targetOffset2,120d           ;if the square has the black king
                           jne   exitKingIsAttacked

                           mov   kingCheck,1d                 ;set the flag

    exitKingIsAttacked:    
                           popa
                           ret
kingIsAttacked endp

kingAttackedRook proc    near
                           pusha                              ;loops through the rook moves and checks if it threatens the king

    rookDownLoopKing:      
                  
                           cmp   dx,175d
                           je    rookUpKing

                           add   dx,25d

                           call  kingIsAttacked
                           cmp   kingCheck,1d
                           je    exitRookKing

                           cmp   continueFlag,1
                           je    rookDownLoopKing

    rookUpKing:            
                          
                           mov   dx,resetPosition[yaxis]      ;reset the y-axis
    rookUpLoopKing:        
                           cmp   dx,0d                        ;if it's the first row then don't do anything
                           je    rookRightKing

                           sub   dx,25d                       ;check the upper square

                           call  kingIsAttacked
                           cmp   kingCheck,1d
                           je    exitRookKing

                           cmp   continueFlag,1
                           je    rookUpLoopKing

    rookRightKing:         

                           mov   dx,resetPosition[yaxis]      ;reset the y axis
    rookRightLoopKing:     
                           cmp   cx,182d                      ;if it's the first row then don't do anything
                           je    rookLeftKing
                           
                           add   cx,26d                       ;check the upper square

                           call  kingIsAttacked
                           cmp   kingCheck,1d
                           je    exitRookKing

                           cmp   continueFlag,1
                           je    rookRightLoopKing

    rookLeftKing:          
                           mov   cx,resetPosition[xaxis]

    rookLeftLoopKing:      
                           cmp   cx,0d                        ;if it's the first row then don't do anything
                           je    exitRookKing

                           sub   cx,26d                       ;check the upper square

                           call  kingIsAttacked
                           cmp   kingCheck,1d
                           je    exitRookKing

                           cmp   continueFlag,1
                           je    rookLeftLoopKing
    
    exitRookKing:          
                           popa
                           ret
kingAttackedRook endp

kingAttackedBishop proc    near
                           pusha

    downRightKing:         
                    
                           cmp   dx,175d                      ;if it's the bottom row
                           je    downRightEndKing
                           cmp   cx,182d                      ;if it's the right most column
                           je    downRightEndKing

                           add   cx,26d                       ;move it right down
                           add   dx,25d
                        
                           call  kingIsAttacked
                           cmp   kingCheck,1d
                           je    exitBishopKing

                           cmp   continueFlag,1d
                           je    downRightKing

    downRightEndKing:      

                           mov   cx,resetPosition[xaxis]      ;reset the position
                           mov   dx,resetPosition[yaxis]
    
    downLeftKing:          
   
                           cmp   cx,0d                        ;if it's the left most column
                           je    downLeftEndKing
                           cmp   dx,175d                      ;if it's the bottom row
                           je    downLeftEndKing
                        
                           sub   cx,26d                       ;move it
                           add   dx,25d

                           call  kingIsAttacked
                           cmp   kingCheck,1d
                           je    exitBishopKing

                           cmp   continueFlag,1d
                           je    downLeftKing

    downLeftEndKing:       

                           mov   cx,resetPosition[xaxis]      ;reset the position
                           mov   dx,resetPosition[yaxis]
                        
    upLeftKing:            
                    
                           cmp   dx,0d                        ;if it's the top row
                           je    upLeftEndKing
                           cmp   cx,0d                        ;if it's the left most column
                           je    upLeftEndKing
                        
                           sub   cx,26d                       ;move it
                           sub   dx,25d

                           call  kingIsAttacked
                           cmp   kingCheck,1d
                           je    exitBishopKing

                           cmp   continueFlag,1d
                           je    upLeftKing

    upLeftEndKing:         

                           mov   cx,resetPosition[xaxis]      ;reset the position
                           mov   dx,resetPosition[yaxis]

    upRightKing:           
   
                           cmp   cx,182d                      ;if it's the right most column
                           je    exitBishopKing
                           cmp   dx,0d                        ;if it's the top row
                           je    exitBishopKing
                        
                           add   cx,26d                       ;move it
                           sub   dx,25d
                           
                           call  kingIsAttacked
                           cmp   kingCheck,1d
                           je    exitBishopKing

                           cmp   continueFlag,1d
                           je    upRightKing
                            
    exitBishopKing:        

                           popa
                           ret
kingAttackedBishop endp

kingAttackedHorse proc    near
                           pusha

                           add   dx,50d                       ;down down right
                           add   cx,26d
                           cmp   cx,200d                      ;if it's in the right column skip
                           jge   _2downLeftKing
                           cmp   dx,200d                      ;or in the bottom row
                           jge   _2downLeftKing

                           call  kingIsAttacked
                           cmp   kingCheck,1d
                           je    exitHorseKing

    _2downLeftKing:        
                           sub   cx,52d                       ;down down left
                           cmp   cx,0d
                           jl    _2leftDownKing
                           cmp   cx,200d
                           jge   _2leftDownKing
                           cmp   dx,200d
                           jge   _2leftDownKing
                           
                           call  kingIsAttacked
                           cmp   kingCheck,1d
                           je    exitHorseKing

    _2leftDownKing:        
                           
                           sub   dx,25d                       ;left left down
                           sub   cx,26d
                           cmp   cx,0d
                           jl    _2rightDownKing
                           cmp   cx,200d
                           jge   _2rightDownKing
                           cmp   dx,200d
                           jge   _2rightDownKing
                           cmp   dx,0d
                           jl    _2rightDownKing
                           
                           call  kingIsAttacked
                           cmp   kingCheck,1d
                           je    exitHorseKing

    _2rightDownKing:       
    
                           add   cx,104d                      ;right right up
                           cmp   cx,0d
                           jb    _2rightUpKing
                           cmp   cx,200d
                           jae   _2rightUpKing
                           cmp   dx,200d
                           jae   _2rightUpKing
                           cmp   dx,0d
                           jb    _2rightUpKing
                           
                           call  kingIsAttacked
                           cmp   kingCheck,1d
                           je    exitHorseKing
    
    _2rightUpKing:         
    
                           sub   dx,50d                       ;right right up
                           cmp   cx,0d
                           jb    _2leftUpKing
                           cmp   cx,200d
                           jae   _2leftUpKing
                           cmp   dx,200d
                           jae   _2leftUpKing
                           cmp   dx,0d
                           jb    _2leftUpKing
                           
                           call  kingIsAttacked
                           cmp   kingCheck,1d
                           je    exitHorseKing

    _2leftUpKing:          
    
                           sub   cx,104d                      ;left left up
                           cmp   cx,0d
                           jb    _2upLeftKing
                           cmp   cx,200d
                           ja    _2upLeftKing
                           cmp   dx,200d
                           jae   _2upLeftKing
                           cmp   dx,0d
                           jb    _2upLeftKing
                           
                           call  kingIsAttacked
                           cmp   kingCheck,1d
                           je    exitHorseKing

    _2upLeftKing:          
    
                           add   cx,26d                       ;up up left
                           sub   dx,25d
                           cmp   cx,0d
                           jb    _2upRightKing
                           cmp   cx,200d
                           jae   _2upRightKing
                           cmp   dx,200d
                           jae   _2upRightKing
                           cmp   dx,0d
                           jb    _2upRightKing
                           
                           call  kingIsAttacked
                           cmp   kingCheck,1d
                           je    exitHorseKing

    _2upRightKing:         
                           
                           add   cx,52d                       ;up up right
                           cmp   cx,0d
                           jb    exitHorseKing
                           cmp   cx,200d
                           jae   exitHorseKing
                           cmp   dx,200d
                           jae   exitHorseKing
                           cmp   dx,0d
                           jb    exitHorseKing
                           
                           call  kingIsAttacked
                          
    exitHorseKing:         
                           popa
                           ret
kingAttackedHorse endp

    ;-------------------------------------------------------------------------------------------------------

kingAttackedBlackPawn proc    near
                           pusha

                           cmp   dx,175d                      ;if it's the bottom row exit
                           je    exitBlackPawnMovesKing

                           add   dx,25d
                          
                           cmp   cx,0                         ;check if it's the left most column if true then skip
                           je    noLeftBlackPawnKing

                           sub   cx,26d                       ;check left square and highlight it red if valid
                           call  kingIsAttacked
                           cmp   kingCheck,1d
                           je    exitBlackPawnMovesKing

    noLeftBlackPawnKing:   

                           mov   cx,resetPosition[xaxis]      ;reset the x axis
                           cmp   cx,182d                      ;if it's the right most column exit
                           je    exitBlackPawnMovesKing

                           add   cx,26d
                           call  kingIsAttacked
                           cmp   kingCheck,1d

    exitBlackPawnMovesKing:
                           popa
                           ret
kingAttackedBlackPawn endp

    ;-------------------------------------------------------------------------------------------------------

kingAttackedWhitePawn proc    near
                           pusha

                           cmp   dx,0d                        ;if it's the top row exit
                           je    exitWhitePawnMovesKing

                           sub   dx,25d
                          
                           cmp   cx,0                         ;check if it's the left most column if true then skip
                           je    noLeftWhitePawnKing

                           sub   cx,26d                       ;check left square and highlight it red if valid
                           call  kingIsAttacked
                           cmp   kingCheck,1d
                           je    exitWhitePawnMovesKing

    noLeftWhitePawnKing:   

                           mov   cx,resetPosition[xaxis]      ;reset the x axis
                           cmp   cx,182d                      ;if it's the right most column exit
                           je    exitWhitePawnMovesKing

                           add   cx,26d
                           call  kingIsAttacked
                           cmp   kingCheck,1d

    exitWhitePawnMovesKing:
                           popa
                           ret
kingAttackedWhitePawn endp
end  main