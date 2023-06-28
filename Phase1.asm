.model small
.stack 64
.386
.data
    ; 00 wpawn 01 wrock 02 wknight 03 WBishop  04 wqueen 05 Wking
    ; 10 bpawn 11 brock 12 bknight 13 bBishop  14 bqueen 15 bking

    ;----------------------------------------------------------------------------------------------------
    ;                                               Constants
    ;----------------------------------------------------------------------------------------------------

    timeArr         db    '00','01','02','03','04','05','06','07','08','09','10','11','12'
    temp00          db    '13','14','15','16','17','18','19','20'                                  ;just to make sure the line isn't too long
    temp01          db    '21','22','23','24','25','26','27','28','29','30','31','32','33'
    temp10          db    '34','35','36','37','38','39','40','41','42','43','44','45','46'
    temp11          db    '47','48','49','50','51','52','53','54','55','56','57','58','59','00'

    xaxis           equ   0d
    yaxis           equ   2d
    typ             equ   4d
    time            equ   6d
    arraysize       equ   256d
    blacksize       equ   128d                                                                     ;to mark to resume highlighting

    mainMenu1       db    "To Start Chatting Press F1$"                                            ;options for the main menu
    mainMenu2       db    "To Start The Game Press F2$"
    mainMenu3       db    "To Exit The Program Press ESC$"
    
    whiteWon        db    "White Won"                                                              ;text for the winner
    BlackWon        db    "Black Won"
    him             db    "Him:$"                                                                  ;text for chatting(not used here)
    me              db    "Me:$"
    ;----------------------------------------------------------------------------------------------------
    ;                                               Users & Temprary Data
    ;----------------------------------------------------------------------------------------------------

    mode            db    ?                                                                        ;chatting or gaming(chat not available here)
    gameStarted     dw    ?                                                                        ;to hold the time when the game started

    user1Pos        dw    0,25d,0d                                                                 ;cx,dx  -> x axis,  y axis
    user1PrevColor  db    01h                                                                      ;yellow is the initial color of the left top SQR
    user1Text       db    50 dup('$')

    
    user2Pos        dw    0,150d,0d                                                                ;cx,dx  -> x axis,  y axis
    user2PrevColor  db    07h                                                                      ;yellow is the initial color of the left top SQR
    user2Text       db    50 dup('$')

    lastGameChatRow db    1d                                                                       ;to mark the last in game chat row
    himCursor       db    0,1                                                                      ;(not used here)to mark the position of both chat cursors    dl:dh -> x:y
    meCursor        db    0,0

    xlength         dw    ?                                                                        ;used for printing
    yheight         dw    ?                                                                        ;used for printing

    resetPosition   dw    ?,?                                                                      ;used to reset the position when highlighting

    movingPiece1    dw    ?,?,?                                                                    ;for user1
    movingColor1    db    ?
    movingOffset1   dw    ?                                                                        ;stores the offset of the array when user 1 is moving a piece

    movingPiece2    dw    ?,? ,?                                                                   ;for user2
    movingColor2    db    ?
    movingOffset2   dw    ?                                                                        ;stores the offset of the array when user 2 is moving a piece

    boardColor      db    ?                                                                        ;to get the board color when a user moves on a highlighted square

    powerUpTime     dw    ?                                                                        ;to add a powerup every minute
    powerUp         dw    ?,?                                                                      ;to store the coordinates of the power up square
    powerOn         db    0                                                                        ;to know if the power up is used or not

    ;----------------------------------------------------------------------------------------------------
    ;                                               Array of valid Moves
    ;----------------------------------------------------------------------------------------------------
    ;the array takes the form of    -->    cx , dx , highlight color1, highlight color2 , base color

    valid1          dw    84 dup(?)                                                                ;to hold the highlighted squares
    valid1Size      dw    0
    isValid1        db    0

    valid2          dw    84 dup(?)
    valid2Size      dw    0
    isValid2        db    0

    ;----------------------------------------------------------------------------------------------------
    ;                                               Array of Pieces
    ;----------------------------------------------------------------------------------------------------

                    array label word                                                               ;label for the pieces array
    ;     Black Team
    bPawn1          dw    0,25d,10d,0d                                                             ;Pawns
    bPawn2          dw    26d,25d,10d,0d
    bPawn3          dw    52d,25d,10d,0d
    bPawn4          dw    78d,25d,10d,0d
    bPawn5          dw    104d,25d,10d,0d
    bPawn6          dw    130d,25d,10d,0d
    bPawn7          dw    156d,25d,10d,0d
    bPawn8          dw    182d,25d,10d,0d

    bRook1          dw    0,0d ,11d,0d                                                             ;Rooks
    bRook2          dw    182d,0d,11d,0d

    bHorse1         dw    26d,0d,12d,0d                                                            ;Horses
    bHorse2         dw    156d,0d,12d,0d

    bBishop1        dw    52d,0d,13d,0d                                                            ;Bishops
    bBishop2        dw    130d,0d,13d,0d

    bQueen          dw    78d,0d,14d,0d                                                            ;Queen
    bKing           dw    104d,0d,15d,0d                                                           ;King

    ;     White Team
    wPawn1          dw    00d,150d,00d,0d                                                          ;Pawns
    wPawn2          dw    26d,150d,00d,0d
    wPawn3          dw    52d,150d,00d,0d
    wPawn4          dw    78d,150d,00d,0d
    wPawn5          dw    104d,150d,00d,0d
    wPawn6          dw    130d,150d,00d,0d
    wPawn7          dw    156d,150d,00d,0d
    wPawn8          dw    182d,150d,00d,0d

    wRook1          dw    0,175d,01d,0d                                                            ;Rooks
    wRook2          dw    182d,175d,01d,0d

    wHorse1         dw    26d,175d,02d,0d                                                          ;Horses
    wHorse2         dw    156d,175d,02d,0d

    wBishop1        dw    52d,175d,03d,0d                                                          ;Bishops
    wBishop2        dw    130d,175d,03d,0d

    wQueen          dw    78d,175d,04d,0d                                                          ;Queen
    wKing           dw    104,175d,05d,0d                                                          ;King

    flag            dw    0d
    
    targetOffset1   dw    ?                                                                        ;holds the offset of the piece that may be killed
    targetOffset2   dw    ?
    
    ;----------------------------------------------------------------------------------------------------
    ;                                               Flags
    ;----------------------------------------------------------------------------------------------------

    checkflag       dw    ?
    kingCheck       db    0                                                                        ;if a king has been checked
    continueFlag    db    1                                                                        ;if a piece is found stop looping through moves

    overlapFlag     db    0h                                                                       ;0 no overlap ff overlap


    spaceFlag       db    0d                                                                       ;0 waiting for first space press ff waiting for second space press
    enterFlag       db    0d                                                                       ;0 waiting for first enter press ff waiting for second enter press

    highlightFlag   db    5d                                                                       ;5 means continue highlighting 6 means stop highlighting
    onHighlight     db    0                                                                        ;To mark when the user is on a highlighted square

    winFlag         db    0                                                                        ;to mark when a user won
    userFlag        db    0                                                                        ;not used here
.code

    ;-------------------------------------------------------------------------------------------------------

main proc    far
                           mov   ax,@data
                           mov   ds,ax
                           mov   es,ax
    toMainMenu:            

                           call  mainMenu                     ;print the main menu and wait for input
                          
                           cmp   mode,01                      ;ESC
                           je    endProgram

                           cmp   mode,3bh                     ;F1 chat isn't available
                           je    endProgram

    gameMode:              

                           call  printBoard                   ;print the initial board
                           call  clearInGameChat              ;clear the chat area
                           call  printUser1                   ;print the first user
                           call  printUser2                   ;print the second user

                           mov   ah,2ch                       ;will be used to calculate the length of the game
                           int   21h
                           mov   ch,cl
                           mov   cl,dh
                           mov   gameStarted,cx               ;set the game start time
                           mov   powerUpTime,cx               ;set the power up time
                          

    keepGoing:             
                           call  gameTimer                    ;print/update the timer
                           call  printPieces                  ;print all pieces that aren't killed
                           call  printStatusBar               ;print the status bar with the right color

                           int   21h                          ;to know if it's time for power up and update the power up time
                           mov   ch,cl
                           mov   cl,dh
                           mov   dx,powerUpTime
                           add   dx,5d
                           cmp   cx,dx
                           jl    noPowerUp

                           mov   powerUpTime,cx
                           call  addPower

    noPowerUp:             

                           call  moveUsers                    ;move the pieces and users
                           call  isChecked                    ;to know if any king is checked
                           cmp   mode,3eh                     ;if someone pressed F4 go to the main menu
                           je    tomainMenu
                          
                           call  checkOverlap                 ;to check the overlap of both players
                           mov   bl,winFlag                   ;to check if someone won
                           cmp   bl,1
                           jne   whiteWin
    ;black team won
                           mov   di,offset blackWon
                           jmp   gameFinished
                     
    whiteWin:              
                           cmp   bl,2
                           mov   di,offset whiteWon
                           jne   keepGoing

    gameFinished:          
                           call  printWinner
                           mov   ah,0
                           int   16h
                           call  resetGame
                           cmp   ah,3eh                       ;if the players want to go back to the main menu press F4
                           je    toMainMenu
    endProgram:            
                           mov   ah,4ch                       ;to terminate the program
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

printBoard proc    near                                       ;note: colors were changed
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

                           mov   lastGameChatRow,1d           ;to the top line

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

moveUsers proc    near
                           pusha
        
                           mov   ah,1
                           int   16h
                           jz    emptyBuffer                  ;buffer is empty

                           cmp   ah,3eh
                           jne   continueGame

                           call  resetGame
                           mov   mode,3eh
                           je    clearbuffer

    continueGame:          
        
                           cmp   al,77h                       ;w
                           je    go1Up
        
                           cmp   al,64h                       ;d
                           je    go1Right
        
                           cmp   al,73h                       ;s
                           je    go1Down
        
                           cmp   al,61h                       ;a
                           je    go1Left

                           cmp   al,32d
                           je    space

    ;                user2

                           cmp   ah,48h                       ;up arrow
                           je    go2Up

                           cmp   ah,4dh                       ;right arrow
                           je    go2Right

                           cmp   ah,50h                       ;down arrow
                           je    go2Down

                           cmp   ah,4bh                       ;left arrow
                           je    go2Left

                           cmp   ah,28d                       ;enter
                           je    ent

                           cmp   al,'c'
                           jne   checkWrite

                           call  readTxt
                           jmp   emptyBuffer

    checkWrite:            
                           cmp   al,'r'
                           jne   clearBuffer

                           call  writeTxt

                           jmp   clearBuffer
    
    ;user 2 (w a s d + space)
    
    go1Up:                 
                           mov   cx,user1Pos[xaxis]
                           mov   dx,user1Pos[yaxis]           ;get the position of user1
                           cmp   dx,0d
                           je    clearBuffer                  ;can't go up when you're at the top of the board
                           mov   al,user1PrevColor            ;get the previous color of the square of user1
                           call  printSQR
                           sub   dx,25d
                           mov   user1Pos[yaxis],dx           ;set the position of the user with new position
                           call  printUser1                   ;print user 1 with the new position
                           mov   bl,2                         ;used to fix overlap
                           call  fixOverlap
                           cmp   onHighlight,1
                           je    finishMove                   ;check the highlight Flags and re-Highlight to fix any problem
                           jmp   clearBuffer

    go1Right:              
                          
                           mov   cx,user1Pos[xaxis]
                           mov   dx,user1Pos[yaxis]           ;get the position of user1
                           cmp   cx,182d
                           je    clearBuffer                  ;can't go right when you're at the right border of the board
                           mov   al,user1PrevColor            ;get the previous color of the square of user1
                           call  printSQR
                           add   cx,26d
                           mov   user1Pos[xaxis],cx           ;set the position of the user with new position
                           call  printUser1                   ;print user 1 with the new position
                           mov   bl,2                         ;used to fix overlap
                           call  fixOverlap
                           cmp   onHighlight,1
                           je    finishMove                   ;check the highlight Flags and re-Highlight to fix any problem
                           jmp   clearBuffer

    go1Down:               
                          
                           mov   cx,user1Pos[xaxis]
                           mov   dx,user1Pos[yaxis]           ;get the position of user1
                           cmp   dx,175d
                           je    clearBuffer                  ;can't go down when you're at the bottom of the board
                           mov   al,user1PrevColor            ;get the previous color of the square of user1
                           call  printSQR
                           add   dx,25d
                           mov   user1Pos[yaxis],dx           ;set the position of the user with new position
                           call  printUser1                   ;print user 1 with the new position
                           mov   bl,2                         ;used to fix overlap
                           call  fixOverlap
                           cmp   onHighlight,1
                           je    finishMove                   ;check the highlight Flags and re-Highlight to fix any problem
                           jmp   clearBuffer

    go1Left:               
                          
                           mov   cx,user1Pos[xaxis]
                           mov   dx,user1Pos[yaxis]           ;get the position of user1
                           cmp   cx,0d
                           je    clearBuffer                  ;can't go left when you're at the left border of the board
                           mov   al,user1PrevColor            ;get the previous color of the square of user1
                           call  printSQR
                           sub   cx,26d
                           mov   user1Pos[xaxis],cx           ;set the position of the user with new position
                           call  printUser1                   ;print user 1 with the new position
                           mov   bl,2                         ;used to fix overlap
                           call  fixOverlap
                           cmp   onHighlight,1
                           je    finishMove                   ;check the highlight Flags and re-Highlight to fix any problem
                           jmp   clearBuffer

    space:                 
                           mov   bl,spaceFlag
                           cmp   bl,0d                        ;check the flag
                           jne   space2
    
                           mov   cx,user1Pos[xaxis]
                           mov   dx,user1Pos[yaxis]
                           mov   bx,1d
                           call  searchArray

                           mov   bx,movingOffset1
                           cmp   bx,128d                      ;user 1 can't move white pieces
                           jge   clearBuffer
                           cmp   bx,308d
                           je    clearBuffer                  ;no piece in that square

                           pusha
                           mov   bx,array[bx+6]               ;get the cooldown of thag piece
                           mov   ah,2ch                       ;get the current time
                           int   21h
                           mov   dl,dh
                           mov   dh,cl                        ;put in dx -> dl = seconds      dh = minutes
                           cmp   dx,bx
                           jge   time1Passed
                           popa                               ;if it's in cooldown pop and clear the buffer
                           jmp   clearBuffer

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

                           jmp   finishMove                   ;check the highlight Flags and re-Highlight to fix any problem

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

                           jmp   finishMove                   ;check the highlight Flags and re-Highlight to fix any problem

    ;                               ;user 2 (arrows + enter)

    go2Up:                 
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

    go2Right:              
                          
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

    go2Down:               
                          
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

    go2Left:               

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
moveUsers endp

    ;-------------------------------------------------------------------------------------------------------

printMoving1 proc    near
                           pusha

                           mov   cx,user1Pos[0]
                           mov   dx,user1Pos[2]
                           mov   bx,movingOffset1
                           mov   array[bx+0],cx               ;update the current moving piece
                           mov   array[bx+2],dx

                           push  cx
                           push  dx
                          
                           mov   ah,2ch                       ;get the current time
                           int   21h
                           mov   dl,dh
                           mov   dh,cl
                           mov   ax,dx                        ;save it in ax
                          
                           pop   dx
                           pop   cx

                           cmp   cx,powerUp[xaxis]            ;check if it's the square with power up
                           jne   normalCoolDown1
                           cmp   dx,powerUp[yaxis]
                           jne   normalCoolDown1
                           cmp   powerOn,1                    ;check if the power up is still available
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

                           mov   al,movingColor1              ;clearing the previous location of the piece
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
                           mov   al,0fh                       ;White Team

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

                           mov   al,0                         ;Black Team
                     
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

    ;-------------------------------------------------------------------------------------------------------

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

    ;-------------------------------------------------------------------------------------------------------

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

    ;-------------------------------------------------------------------------------------------------------

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

    ;-------------------------------------------------------------------------------------------------------

highlightMoves proc    near
                           pusha
     
                           cmp   bx,1d
                           jne   highlightWhiteTeam

                           mov   cx,movingPiece1[xaxis]
                           mov   dx,movingPiece1[yaxis]

                           mov   resetPosition[xaxis],cx      ;to return to this position in each loop
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

                           mov   ah,00h                       ;trying to generate a random number
                           int   1ah

                           add   dh,dl
                           mov   ch,0
                           mov   cl,dh
                           mov   dh,0

                           mov   al,cl
                           mov   bl,7d                        ;to limit the x axis to be only from 0 to 7
                           div   bl
                           mov   al,ah
                           mov   bl,26d                       ;take the remainder and multiplie by 26 to get the coordinates
                           mul   bl
                           mov   cl,al

                           mov   al,dl
                           mov   bl,4d                        ;to limit it to be from 0 to 3
                           div   bl
                           mov   al,ah
                           mov   bl,25d
                           mul   bl
                           mov   dl,al
                           add   dl,50d                       ;to keep it in the area between the 2 teams

                           add   cx,12d                       ;to move to a pixel that's colored if there's a piece in the square
                           add   dx,21d

                           mov   ah,0dh
                           int   10h

                           cmp   al,0h                        ;if the square already has a piece in it
                           je    randomizeAgain
                           cmp   al,0fh
                           je    randomizeAgain

                           sub   cx,12d                       ;go back to the coordinates
                           sub   dx,21d
                           push  cx
                           push  dx

                           mov   cx,powerUp[0]                ;saving the coordinates
                           mov   dx,powerUp[2]

                           call  getBoardColor
                           mov   al,boardColor
                           call  printSQR
                           call  printBoth

                           mov   cx,user1Pos[xaxis]           ;reseting the previous color of both users correctly so it's not the power up color
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

                           mov   powerUp[0],cx                ;setting the power up to be on and printing it
                           mov   powerUp[2],dx
                           mov   ch,1
                           mov   powerOn,ch

                           call  printPowerUp

                           mov   ah,2ch                       ;updating the time of the power up
                           int   21h
                           mov   ch,cl
                           mov   cl,dh
                           mov   powerUpTime,cx

                           cmp   spaceFlag,0ffh               ;if it's not up skip it
                           jne   checkEnterFlagP

                           mov   bx,1                         ;to avoid overlaping with higlighted squares
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

readTxt proc    near
                           pusha

                           mov   ah,00h                       ;clear buffer
                           int   16h
                           mov   di,0

    newChar:               

                           mov   ah,0
                           int   16h

                           cmp   al,0dh                       ;enter
                           je    exitRead
                          
                           mov   user1Text[di],al
                           inc   di
                           jmp   newChar

    exitRead:              

                           popa
                           ret
readTxt endp

    ;-------------------------------------------------------------------------------------------------------

writeTxt proc near
                           pusha

                           mov   di,0
                           mov   dh,lastGameChatRow
                           dec   dh                           ;to set the row of the last chat
    
    newLine:               
    
                           mov   dl,66d

                           inc   dh
                           cmp   dh,23d
                           jge   bottomChatline

    writeNewChar:          
                          
                           mov   ah,2
                           int   10h
                          
                           mov   al,user1Text[di]
                           cmp   al,'$'
                           je    exitWrite

                           mov   bl,0fh
                           mov   ah,0eh
                           int   10h

                           mov   al,'$'
                           mov   user1Text[di],al
                           inc   di
                           inc   dl
                           cmp   dl,80d                       ;enter
                           je    newLine
                           jmp   writeNewChar

    bottomChatline:        
                           mov   lastGameChatRow,1d           ;reset the last row
                           call  clearInGameChat              ;clear the previous chat
                          
                           mov   cx,50d
                           mov   di,0

    resetGameChatArray:    
                           mov   user1Text[di],'$'            ;clear the full array if there was anything left
                           inc   di
                           loop  resetGameChatArray

                           jmp   exitWriteReset
    
    exitWrite:             
                           inc   dh
                           mov   lastGameChatRow,dh
    exitWriteReset:        
                           popa
                           ret
writeTxt endp

    ;-------------------------------------------------------------------------------------------------------

resetGame proc    near
                           pusha

                           mov   user1Pos,0
                           mov   user1Pos[2],25
                           mov   user1PrevColor,01h           ;yellow is the initial color of the left top SQR
    
                           mov   bx,0
                           mov   cx,50d
    resetLoop1:            
    
                           mov   user1Text[bx],'$'
                           inc   bx
                           loop  resetLoop1
    
                           mov   user2Pos,0
                           mov   user2Pos[2],150d
                           mov   user2PrevColor,07h           ;yellow is the initial color of the left top SQR
    
                           mov   cx,50d
    resetLoop2:            
    
                           mov   user2Text[bx],'$'
                           inc   bx
                           loop  resetLoop2

                           mov   valid1Size,0
                           mov   isValid1,0

                           mov   valid2Size,0
                           mov   isValid2,0

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

                           mov   lastGameChatRow,1d

                           mov   movingPiece1,0
                           mov   movingPiece1[2],0
                           mov   movingColor1,0
                           mov   movingOffset1,0

                           mov   movingPiece2,0
                           mov   movingPiece2[2],0
                           mov   movingColor2,0
                           mov   movingOffset2,0

                           mov   gameStarted,0
                           mov   powerUp,0
                           mov   powerUp[2],0
                           mov   powerOn,0
                          
                           call  printBoard
                           call  printPieces
                           call  clearInGameChat

                           popa
                           ret
resetGame endp

    ;-------------------------------------------------------------------------------------------------------

mainMenu proc    near
                           pusha

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

                           mov   dh,24d                       ;move cursor
                           mov   dl,26d
                           mov   ah,2
                           int   10h

    notValidInput:         
    
                           mov   ah,0                         ;read chatacter
                           int   16h

                           cmp   ah,01h                       ;esc
                           je    validInput

                           cmp   ah,3bh                       ;f1
                           je    validInput

                           cmp   ah,3ch                       ;f2
                           jne   notValidInput

    validInput:            

                           mov   mode,ah

                           popa
                           ret
mainMenu endp

    ;-------------------------------------------------------------------------------------------------------

gameTimer proc    near                                        ;5555
                           pusha

                           mov   ah,2ch                       ;get current time
                           int   21h

                           mov   ch,cl                        ;cx = > min:sec
                           mov   cl,dh
                           sub   cx,gameStarted
                           cmp   cl,0
                           jge   trueTime
                           neg   cl
                           mov   al,cl
                           mov   cl,60d
                           sub   cl,al

    trueTime:              

                           mov   dl,71d
                           mov   dh,0
                           mov   ah,2
                           int   10h

                           mov   al,2
                           mul   ch                           ;to access the array
                           mov   ah,0
                           mov   di,ax

                           mov   bl,0fh
                           mov   al,timeArr[di]
                           mov   ah,0eh
                           int   10h

                           mov   ah,2
                           inc   dl                           ;move cursor
                           int   10h

                           inc   di
                           mov   al,timeArr[di]
                           mov   ah,0eh                       ;print it
                           int   10h

                           mov   ah,2
                           inc   dl                           ;move cursor
                           int   10h

                           mov   al,':'
                           mov   ah,0eh                       ;print it
                           int   10h

                           inc   dl
                           mov   ah,2                         ;move the cursor
                           int   10h

                           mov   al,2
                           mul   cl                           ;to access the array
                           mov   ah,0
                           mov   di,ax

                           mov   al,timeArr[di]
                           mov   ah,0eh
                           int   10h

                           mov   ah,2
                           inc   dl                           ;move cursor
                           int   10h

                           inc   di
                           mov   al,timeArr[di]
                           mov   ah,0eh                       ;print it
                           int   10h

                           mov   ah,2
                           inc   dl                           ;move cursor
                           int   10h
                              
                           popa
                           ret
gameTimer endp

end  main