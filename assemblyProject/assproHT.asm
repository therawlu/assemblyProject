.MODEL SMALL
.DATA

    ENTMSG1             DB 'HELLO TO OUR SITE, HESITANT', 0Dh, 0Ah , '$'
    ENTMSG2             DB 'PRESS ANY KEY TO CONTINUE' , 0Dh, 0Ah ,'$'
    ENDMSG              DB  0Dh, 0Ah ,'I hope we helped you make the best choice', '$'
    MSG1                DB 'first choice: ' ,'$'
    MSG2                DB 'second choice: ' ,'$'
    MSG3                DB 'third choice: ' ,'$'
    MSG4                DB 'forth choice: ' ,'$'
    BUFFER1             DB 255                                              ;to store the first string
    LEN1                DW 0                                                ;length of the first string
    BUFFER2             DB 255                                              ;to store the second string
    LEN2                DW 0                                                ;length of the second string
    BUFFER3             DB 255                                              ;to store the third string
    LEN3                DW 0                                                ;length of the third string
    BUFFER4             DB 255                                              ;to store the forth string
    LEN4                DW 0                                                ;length of the forth string
    RandomGeneratedFlag DB 0                                                ;flag to indicate if random number has been generated (0 = no, 1 = yes)
    
.CODE
    
    MAIN PROC
    
    .STARTUP
    
        ;displaying the entry msgs
        MOV AH, 09h
        LEA DX, ENTMSG1
        INT 21H
        
        MOV AH, 09h
        LEA DX, ENTMSG2
        INT 21H
        
        ;wait for any key press
        mov ah, 08h
        int 21h
        
        CALL CLEAR_SCREEN
        
        ;display msg for the first string
        MOV AH, 09H
        LEA DX, MSG1
        INT 21H
        
        ;read the first string
        MOV AH, 0AH
        LEA DX, BUFFER1
        INT 21H
        
        ;compute the length of the first string
        MOV SI, OFFSET BUFFER1 + 1
        MOV AL, [SI]
        MOV LEN1,AX
        
        CALL CLEAR_SCREEN
        
        ;display msg for the second string
        MOV AH, 09H
        LEA DX, MSG2
        INT 21H
        
        ;read the second string
        MOV AH, 0AH
        LEA DX, BUFFER2
        INT 21H
        
        ;compute the length of the second string
        MOV SI, OFFSET BUFFER2 + 1
        MOV AL, [SI]
        MOV LEN2,AX
        
        CALL CLEAR_SCREEN
        
        ;display msg for the third string
        MOV AH, 09H
        LEA DX, MSG3
        INT 21H
        
        ;read the third string
        MOV AH, 0AH
        LEA DX, BUFFER3
        INT 21H
        
        ;compute the length of the third string
        MOV SI, OFFSET BUFFER3 + 1
        MOV AL, [SI]
        MOV LEN3,AX
        
        CALL CLEAR_SCREEN
        
        ;display msg for the forth string
        MOV AH, 09H
        LEA DX, MSG4
        INT 21H
        
        ;read the forth string
        MOV AH, 0AH
        LEA DX, BUFFER4
        INT 21H
        
        ;compute the length of the forth string
        MOV SI, OFFSET BUFFER4 + 1
        MOV AL, [SI]
        MOV LEN4,AX
        
        CALL CLEAR_SCREEN

    RANDSTART PROC
        MOV AH, 00h                                                  ; interrupts to get system time        
        INT 1AH                                                      ; CX:DX now hold number of clock ticks since midnight      

        mov  ax, dx
        xor  dx, dx
        mov  cx, 4    
        div  cx                                                      ; here dx contains the remainder of the division - from 0 to 9

        add  dl, '1'                                                 ; to ascii from '1' to '4'
        mov ah, 2h                                                   ; call interrupt to display a value in DL
        int 21h    

        ; Set a flag indicating that the random number has been generated
        mov byte ptr [RandomGeneratedFlag], 1

        ; Skip the loop and proceed to exit
        jmp EXIT
    RANDSTART ENDP

        
        ;exit
        EXIT:
        MOV AH, 09h
        LEA DX, ENDMSG
        INT 21H
        
        MOV AH,4CH
        INT 21H
        
    .EXIT
    MAIN ENDP
    
    ;clear screen
    CLEAR_SCREEN PROC
        ; Clear the screen
        mov ah, 06h
        mov al, 0
        mov bh, 07h                                                         ; Display attribute (text color)
        mov cx, 0                                                           ; Upper left corner
        mov dh, 24                                                          ; Lower right corner (number of rows - 1)
        mov dl, 79                                                          ; Lower right corner (number of columns - 1)
        int 10h
        RET
    CLEAR_SCREEN ENDP
END MAIN