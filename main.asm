;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;----------------------------------------------------------------------------
; Main loop here
;----------------------------------------------------------------------------

; Visto 1 - conversão

; Alunos: Caio Rodrigues Lino Mesquita - 202014842
;		  Juan Carlos Cordir Da Silva - 170147185

NUM    		 .equ    3444        ;Indicar número a ser convertido

		        mov     #NUM, R5    ;R5 = número a ser convertido
		        mov     #RESP, R6   ;R6 = ponteiro para escrever a resposta
				mov     #ALGARISMOS_ROMANOS, R7
		        cmp		#1, R5
		        jl      FIM
		        cmp     #3999, R5
		        jeq		ALG_ROM
		        jhs	    FIM

ALG_ROM:                               ;subrotina alg_rom para adicionar 1000 ao r8 e começar as validações da unidade de milhar
				push R8
				mov  #1000, R8
				cmp  R8, R5
				jl	 CENTENA_LOOP

MILHAR_LOOP:                               ;validações da unidade de milhar

				sub  R8, R5
				mov.b  6(R7), 0(R6)
				inc   R6
				cmp  R8, R5
				jhs  MILHAR_LOOP

CENTENA_LOOP:                            ;subrotina centena_loop para adicionar 900/500/400 ao r8 e começar as validações da centena

				cmp #100, R5
				jl	DEZENA_LOOP
			    mov #900, R8
			    cmp R8, R5
			    jhs CENTENA_900
			    mov #500, R8
			    cmp R8, R5
			    jhs CENTENA_500
			    mov #400, R8
			    cmp R8, R5
			    jhs CENTENA_400
			    jmp CENTENA_300


CENTENA_900:

				sub #900, R5
				mov.b 4(R7), 0(R6)
				inc   R6
				mov.b 6(R7), 0(R6)
				inc   R6
				jmp   DEZENA_LOOP


CENTENA_500:

				sub   #500, R5
				mov.b 5(R7), 0(R6)
				inc   r6
				jmp   CENTENA_300


CENTENA_400:

				sub   #400, R5
				mov.b 4(R7), 0(R6)
				inc   R6
				mov.b 5(R7), 0(R6)
				inc   R6
				jmp   DEZENA_LOOP


CENTENA_300:

				sub    #100, R5
				mov.b  4(R7), 0(R6)
				inc    R6
				cmp    #100, R5
				jhs    CENTENA_300
				NOP

DEZENA_LOOP:                              ;subrotina dezena_loop para adicionar 90/50/40 ao r8 e começar as validações da dezena
				cmp #10, R5
				jl	UNIDADE_LOOP
			    mov #90, R8
			    cmp R8, R5
			    jhs DEZENA_90
			    mov #50, R8
			    cmp R8, R5
			    jhs DEZENA_50
			    mov #40, R8
			    cmp R8, R5
			    jhs DEZENA_40
			    jmp DEZENA_30

DEZENA_90:

				sub #90, R5
				mov.b 2(R7), 0(R6)
				inc   R6
				mov.b 4(R7), 0(R6)
				inc   R6
				jmp   UNIDADE_LOOP


DEZENA_50:

				sub   #50, R5
				mov.b 3(R7), 0(R6)
				inc   r6
				jmp   DEZENA_30


DEZENA_40:

				sub   #40, R5
				mov.b 2(R7), 0(R6)
				inc   R6
				mov.b 3(R7), 0(R6)
				inc   R6
				jmp   UNIDADE_LOOP


DEZENA_30:

				sub    #10, R5
				mov.b  2(R7), 0(R6)
				inc    R6
				cmp    #10, R5
				jhs    DEZENA_30
				NOP


UNIDADE_LOOP:                               ;subrotina unidade_loop para adicionar 9/5/4 ao r8 e começar as validações da unidade
				cmp #1, R5
				jlo	FIM
			    mov #9, R8
			    cmp R8, R5
			    jhs UNIDADE_9
			    mov #5, R8
			    cmp R8, R5
			    jhs UNIDADE_5
			    mov #4, R8
			    cmp R8, R5
			    jhs UNIDADE_4
			    jmp UNIDADE_3


UNIDADE_9:

				sub #9, R5
				mov.b 0(R7), 0(R6)
				inc   R6
				mov.b 2(R7), 0(R6)
				inc   R6
				jmp   FIM


UNIDADE_5:

				sub   #5, R5
				mov.b 1(R7), 0(R6)
				inc   R6
				jmp   UNIDADE_3


UNIDADE_4:

				sub   #4, R5
				mov.b 0(R7), 0(R6)
				inc   R6
				mov.b 1(R7), 0(R6)
				inc   R6
				jmp   FIM


UNIDADE_3:

				sub    #1, R5
				mov.b  0(R7), 0(R6)
				inc    R6
				cmp    #1, R5
				jhs    UNIDADE_3

FIM:
				jmp		$
				NOP


        	   .data
; Local para armazenar a resposta (RESP = 0x2400)
RESP:   	   .byte   "RRRRRRRRRRRRRRRRRR",0

ALGARISMOS_ROMANOS:   .byte "I", "V", "X", "L", "C", "D", "M"



;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
