*-----------------------------------------------------------
* Program    : Basic Stopwatch
* Written by : J. Senior, 160474257
* Date       : 22/12/2017
*-----------------------------------------------------------

* constants
PM          EQU     12*60*60*100            ; hundredths of a second in half a day

* variables
INTRO       DC.B    'Press any key to start and stop the timer:',0

* program
            ORG     $1000
START:
            LEA     INTRO,A1                ; move message into memory
            MOVE.B  #13,D0                  ; display message
            TRAP    #15

            MOVE    #5,D0                   ; wait for user input
            TRAP    #15

            MOVE    #8,D0                   ; get time in hundredths of a second
            TRAP    #15

            IF.L D1 <HS> #PM THEN.S         ; if after 12PM subtract PM
            SUB.L   #PM,D1
            ENDI

            MOVE.L  D1,D2                   ; save initial time

            BRA     LOOP                    ; go to loop

LOOP        MOVE.W  #$D,D1                  ; carriage return
            MOVE    #6,D0
            TRAP    #15
 
            MOVE    #8,D0                   ; get time in hundredths of a second
            TRAP    #15
            
            IF.L D1 <HS> #PM THEN.S         ; if after 12PM subtract PM
            SUB.L   #PM,D1
            ENDI
            
            SUB.L   D2,D1                   ; subtract start from current
            DIVU    #100,D1                 ; convert to seconds and hundredths
            
            
            MOVE    D1,D7                   ; temp hold to split sec and hundredths
            AND.L   #$0000FFFF,D7           ; remove hundredths
            
            MOVE.L  D7,D3                   ; move seconds to D3
            
            SWAP    D1
            AND.L   #$0000FFFF,D1           ; remove seconds
            MOVE.L  D1,D4                   ; save tenths in D4
            
            DIVU    #60,D3                  ; sec div 60 equ min
            
            MOVE.L  D3,D7                   ; temp hold to split min and sec
            AND.L   #$0000FFFF,D7           ; remove seconds
            MOVE    D7,D5                   ; save minutes in D5
            
            SWAP    D3
            AND.L   #$0000FFFF,D3           ; remove minutes
            
            MOVE.L  D3,D6                   ; save seconds
            
            DIVU    #10,D4                  ; sec div 10 equ tenths
            AND.L   #$0000FFFF,D4           ; save tenths in D4
            
            IF.L D5 <LT> #10 THEN.S         ; if(minutes < 10)
            MOVE.L  #$30,D1                 ; set minute leading zero
            MOVE    #6,D0                   ; display zero
            TRAP    #15
            ENDI
            
            MOVE.L  D5,D1                   ; display minutes
            MOVE    #3,D0
            TRAP    #15
            
            MOVE.B  #$3A,D1                 ; display colon ( : )
            MOVE    #6,D0
            TRAP    #15
            
            IF.L D6 <LT> #10 THEN.S
            MOVE.L  #$30,D1                 ; set second leading zero
            MOVE    #6,D0
            TRAP    #15
            ENDI
            
            MOVE.L  D6,D1                   ; display seconds
            MOVE    #3,D0
            TRAP    #15
            
            MOVE.B  #$2E,D1                 ; display full stop ( . )
            MOVE    #6,D0
            TRAP    #15
            
            MOVE.L  D4,D1                   ; display tenths
            MOVE    #3,D0
            TRAP    #15
            
            MOVE.W  #$D,D1                  ; carriage return
            MOVE    #6,D0
            TRAP    #15
            
            MOVE    #7,D0                   ; check for user input
            TRAP    #15
            
            IF.L D1 <NE> #0 THEN.S          ; if input then exit
            BRA     END
            ENDI
            
            IF.L D5 <GE> #10 THEN.S         ; if(minutes == 10)
            BRA     END                     ; end program
            ENDI
            
            BRA     LOOP
            
END         MOVE.B  #9,D0                   ; end simulation
            TRAP    #15
            END     START                   ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
